# Installation

## Requirements
- Python3
- PyOpenSSL
- OpenSSL
- Docker
- Keytool

## Environment Setup
Create a **.env** file with the following variables:

**General**

```TRUZZTPORT_NAME=```
The name of the project.

```TRUZZTPORT_ENV_SLUG=```
Short name of the environment. Is used to create the subCA and build the component.domains.

```TRUZZTPORT_DOMAIN=```
The domain for the CA. It Is used to create the subCA und build the component domains.


**CA settings**

```TRUZZTPORT_CA_ORGANIZATION_NAME=```
Your company's legally registered name (e.g., YourCompany, Inc.).

```TRUZZTPORT_CA_COUNTRY_NAME=```
The two-letter country code where your company is legally located.

```TRUZZTPORT_CA_UNIT_NAME=```
The name of your department within the organization.


**Credentials**

```TRUZZTPORT_ADMIN_USERNAME=```
```TRUZZTPORT_ADMIN_PASSWORD=```


**DAPS Settings**

```TRUZZTPORT_DAPS_SUBDOMAIN=```
The sub domain prefix for the daps. (e.g., daps)

```TRUZZTPORT_DAPS_PORT=```
The port for the DAPS.


**BROKER Settings**

```TRUZZTPORT_BROKER_SUBDOMAIN=```
The sub domain prefix for the broker. (e.g., broker)

```TRUZZTPORT_BROKER_IDS_PORT=```
The port for the ids entpoint of the broker.

```TRUZZTPORT_BROKER_MANAGEMENT_PORT=```
The port for the management entpoint of the broker.

```TRUZZTPORT_BROKER_DATA_PORT=```
The port for the data entpoint of the broker.

```TRUZZTPORT_BROKER_API_PORT=```
The port for the api entpoint of the broker.

```TRUZZTPORT_BROKER_IDS_PREFIX=```
The path of the ids endpoint. (e.g., /api/v1/ids)

```TRUZZTPORT_BROKER_MANAGEMENT_PREFIX=/api/v1/management```
The path of the management endpoint. (e.g., /api/v1/management)

```TRUZZTPORT_BROKER_DATA_PREFIX=/api/v1/data```
The path of the data endpoint. (e.g., /api/v1/data)

```TRUZZTPORT_BROKER_API_PREFIX=/api```
The path of the api endpoint. (e.g., /api)


**POSGRESQL Settings**

```TRUZZTPORT_POSTGRES_PORT=```
The port for the postgres database.


**CLEARING Settings**

```TRUZZTPORT_CLEARING_SUBDOMAIN=```
The sub domain prefix for the clearinghouse. (e.g., clearing)

```TRUZZTPORT_CLEARING_PORT=13006```
The port for the ids entpoint of the broker.


**CONNECTOR Settings**

```TRUZZTPORT_CONNECTOR_SUBDOMAIN=```
The sub domain prefix for the connector. (e.g., connector)
```TRUZZTPORT_CONNECTOR_IDS_PORT=```
The port for the ids entpoint of the connector.

```TRUZZTPORT_CONNECTOR_MANAGEMENT_PORT=```
The port for the management entpoint of the connector.

```TRUZZTPORT_CONNECTOR_DATA_PORT=```
The port for the data entpoint of the connector.

```TRUZZTPORT_CONNECTOR_API_PORT=```
The port for the api entpoint of the connector.

```TRUZZTPORT_CONNECTOR_IDS_PREFIX=```
The path of the ids endpoint. (e.g., /api/v1/ids)

```TRUZZTPORT_CONNECTOR_MANAGEMENT_PREFIX=/api/v1/management```
The path of the management endpoint. (e.g., /api/v1/management)

```TRUZZTPORT_CONNECTOR_DATA_PREFIX=/api/v1/data```
The path of the data endpoint. (e.g., /api/v1/data)

```TRUZZTPORT_CONNECTOR_API_PREFIX=/api```
The path of the api endpoint. (e.g., /api)
