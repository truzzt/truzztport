#!/bin/sh

if [ ! $# -ge 1 ] || [ ! $# -le 3 ]; then
    echo "Usage: $0 NAME (SECURITY_PROFILE) (CERTFILE)"
    exit 1
fi

CLIENT_NAME=$1

python3 ca/pki.py cert create --subCA dataspaceSubCa --common-name $1 --algo rsa --bits 2048 --hash sha256 --country-name DE --organization-name test --unit-name test --server --client --san-name $1 --san-ip 127.0.0.1

CLIENT_SECURITY_PROFILE=$2
[ -z "$CLIENT_SECURITY_PROFILE" ] && CLIENT_SECURITY_PROFILE="idsc:BASE_SECURITY_PROFILE"

CLIENT_CERT="data/cert/$CLIENT_NAME.crt"
if [ -n "$3" ]; then
    [ ! -f "$3" ] && (echo "Cert not found"; exit 1)
    cert_format="DER"
    openssl x509 -noout -in "$3" 2>/dev/null && cert_format="PEM"
    openssl x509 -inform "$cert_format" -in "$3" -text > "$CLIENT_CERT"
else
    openssl pkcs12 -export -in "$CLIENT_CERT" -inkey "data/cert/${CLIENT_NAME}.key" -out "data/cert/${CLIENT_NAME}.p12"  -password pass:password
fi


SKI="$(openssl x509 -in "data/cert/${CLIENT_NAME}.crt" -noout -text | grep -A1 "Subject Key Identifier" | tail -n 1 | tr -d ' ')"
AKI="$(openssl x509 -in "data/cert/${CLIENT_NAME}.crt" -noout -text | grep -A1 "Authority Key Identifier" | tail -n 1 | tr -d ' ')"
#SUB='keyid'
CLIENT_ID="$SKI:$AKI"

#contains() {
    #string="$AKI"
    #substring="$SUB"
    #if test "${string#*$substring}" != "$string"
    #then
        #CLIENT_ID="$SKI:$AKI"    # $substring is in $string
    #else
        #CLIENT_ID="$SKI:keyid:$AKI"    # $substring is not in $string
    #fi
#}

#contains "$AKI" "$SUB"

CLIENT_CERT_SHA="$(openssl x509 -in "data/cert/${CLIENT_NAME}.crt" -noout -sha256 -fingerprint | tr '[:upper:]' '[:lower:]' | tr -d : | sed 's/.*=//')"

cat >> data/daps/clients.yml <<EOF
- client_id: $CLIENT_ID
  client_name: $CLIENT_NAME
  grant_types: client_credentials
  token_endpoint_auth_method: private_key_jwt
  scope: idsc:IDS_CONNECTOR_ATTRIBUTES_ALL
  attributes:
  - key: idsc
    value: IDS_CONNECTOR_ATTRIBUTES_ALL
  - key: securityProfile
    value: $CLIENT_SECURITY_PROFILE
  - key: referringConnector
    value: http://${CLIENT_NAME}
  - key: "@type"
    value: ids:DatPayload
  - key: "@context"
    value: https://w3id.org/idsa/contexts/context.jsonld
  - key: transportCertsSha256
    value: $CLIENT_CERT_SHA
EOF

cp "$CLIENT_CERT" "data/daps/clients/${CLIENT_ID}.cert"

