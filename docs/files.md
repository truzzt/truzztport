# Files

## General
the **data/** directory will hold all files. It is created by running the ```init``` command.
```
data/
├── ca
│   ├── TRUZZTPORT_DOMAIN.crt
│   ├── TRUZZTPORT_DOMAIN.key
│   └── TRUZZTPORT_DOMAIN.serial
├── cert
└── subca
```

## DAPS
DAPS [docs](https://github.com/International-Data-Spaces-Association/omejdn-daps)
```
data/demo/daps
├── config
│   ├── clients.yml
│   ├── omejdn-plugins.yml
│   ├── omejdn.yml
│   ├── scope_description.yml
│   ├── scope_mapping.yml
│   ├── users.yml
│   └── webfinger.yml
└── keys
    ├── clients
    │   ├── 7A:37:CD:FF:B4:DF:C6:53:83:8F:DC:2D:CB:4B:35:77:99:87:51:49:keyid:EC:8B:20:90:00:5C:C5:21:91:B5:0F:B0:BB:22:93:8B:41:DB:43:2A.cert
    │   ├── 7E:50:C5:AA:F5:9F:4A:F4:C3:92:47:F5:DD:4E:6B:8B:E4:34:5A:76:keyid:EC:8B:20:90:00:5C:C5:21:91:B5:0F:B0:BB:22:93:8B:41:DB:43:2A.cert
    │   └── A5:2C:B2:74:C1:A4:4E:47:42:C2:7A:5F:3C:13:29:2A:84:39:8F:B4:keyid:EC:8B:20:90:00:5C:C5:21:91:B5:0F:B0:BB:22:93:8B:41:DB:43:2A.cert
    └── omejdn
        └── omejdn.key
```

## Broker
Broker [docs](https://github.com/truzzt/ids-basecamp-broker)
```
data/demo/broker
├── daps.crt
├── keystore.jks
└── vault.properties
```

## Clearinghouse
Clearinghouse [docs](https://github.com/truzzt/ids-basecamp-clearinghouse)
```
data/demo/clearing
├── Rocket-document.toml
├── Rocket-keyring.toml
├── Rocket-logging.toml
├── allow-all-flow.pl
├── clearing-house-routes.xml
├── daps.der
├── keys
└── keystore.p12
```

## Connector
Connector [docs](https://github.com/truzzt/test-connector)
```
data/demo/connector
├── keystore.jks
└── vault.properties
```