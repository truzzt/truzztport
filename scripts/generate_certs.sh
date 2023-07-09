#! /bin/sh

# Check if only one argument is passed
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "Usage: $0 <number_of_connectors>"
    exit 1
fi

PASSWORD="password"

# create required directories
mkdir -p data/cert config

# Iterate over the number of connectors
for ((i=1;i<=$1;i++)); do
    # Create directory for each connector
    mkdir -p docker/resources/vault/connector-$i

    # Assigning the connector name
    connector_name="connector-"$i

    # Creating the connector certificate
    ./scripts/create_client.sh $connector_name

    # Extracting the SKI:AKI and private key from the certificate
    TEMP_FILE="$(mktemp)"
    CRT_FILE=data/cert/connector-$i.crt 
    EDC_P12=data/cert/connector-$i.p12
    EDC_DEST_STORE=docker/resources/vault/connector-$i/keystore.jks

    # Extracting the SKI:AKI and private key from the certificate
    openssl x509 -in "$CRT_FILE" -text > "$TEMP_FILE"
    SKI="$(grep -A1 "Subject Key Identifier"  "$TEMP_FILE" | tail -n 1 | tr -d ' ')"
    AKI="$(grep -A1 "Authority Key Identifier"  "$TEMP_FILE" | tail -n 1 | tr -d ' ')"
    echo "TEST_EDC_${i}_SKI_AKI=$SKI:$AKI" >> config/.env

    # Extracting the private key from the certificate
    keytool -importkeystore -srckeystore "$EDC_P12" -srcstoretype pkcs12 -destkeystore "$EDC_DEST_STORE" -deststoretype jks -deststorepass "$PASSWORD" -srcstorepass "$PASSWORD" -noprompt 2>/dev/null

    # Cleanup
    rm -f $TEMP_FILE
done