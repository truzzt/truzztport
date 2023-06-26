# IDS BaseCamp Demo Instructions

1. Get all the required images (just to make sure, we have access on all the registries)
  - EDC: `docker pull registry.orbiter.de/truzzt/federated-catalog:latest`
  - FederatedCatalog: `registry.orbiter.de/orbiter/mds-edc:dev`
2. Init the local setup by running ./scripts/init.sh
  - IP is `127.0.0.1`
3. Run docker compose up: `docker compose -f docker/docker-compose.yml --env-file config/.env --profile test up`
4. Run this command to show no crawled assets yet: `curl -v http://localhost:13004/federatedcatalog -H 'authorization: ApiKeyDefaultValue' -H 'content-type: application/json' -H 'accept: application/json' -d '{"criteria":[]}'`
5. Run this script to add a ContractOffer:
  - `curl -X POST -H "Content-Type: application/json" -H "Authorization: ApiKeyDefaultValue" -d @./demo/asset.json "http://localhost:13104/api/v1/management/assets"`
  - `curl -X POST -H "Content-Type: application/json" -H "Authorization: ApiKeyDefaultValue" -d @./demo/policydefinition.json "http://localhost:13104/api/v1/management/policydefinitions"`
  - `curl -X POST -H "Content-Type: application/json" -H "Authorization: ApiKeyDefaultValue" -d @./demo/contractoffer.json "http://localhost:13104/api/v1/management/contractdefinitions"`
6. Wait 10s (for the crawler to get the offers) and then run 4. again.
