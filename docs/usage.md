# Usage

## init
```bash truzztport.sh init```
Creates the directory structure **data/** and CA.

## add
```bash truzztport.sh add <ENV_SLUG>```
Adds an environment with the name ENV_SLUG.

### Special Environment
**local**
If the ENV_SLUG ist set to **local** the truzztport provides a different behaviour in order to provide a setup to run on localhost.

## start
```bash truzztport.sh start <ENV_SLUG>```
Starts a given environment by name.

## stop
```bash truzztport.sh stop <ENV_SLUG>```
Stops a given environment by name.