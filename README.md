# Welcome to truzztport 👋
![Version](https://img.shields.io/badge/version-0.0.1-blue.svg?cacheSeconds=2592000)
[![Documentation Status](https://readthedocs.org/projects/truzztport/badge/?version=latest)](https://truzztport.readthedocs.io/en/latest/?badge=latest)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache2.0-yellow.svg)](/LICENSE)

> Fully configurable dataspace setup

### 🏠 [Homepage](truzztport.com)

### ✨ [Demo](demo.truzztport.com)

## Configure
Create a file named ```.env```, in the project root, using the file ```template.env``` as template, and change it for your needs. 
For a localhost deployment set ```TRUZZTPORT_ENV_SLUG=local``` and ```TRUZZTPORT_BASE_DOMAIN=<YOUR_LOCAL_IP>```

## Install

```sh
bash scripts/truzzport.sh init
```

## Usage

Run ```bash scripts/truzzport.sh add [ENV_NAME]``` to add a new environment and run bash ```scripts/truzzport.sh start [ENV_NAME]``` to start an environment

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check [issues page](https://github.com/truzzt/truzztport/issues). You can also take a look at the [contributing guide](/CONTRIBUTING.md).

## Show your support

Give a ⭐️ if this project helped you!


## 📝 License

Copyright © 2023 [truzzt GmbH](https://truzzt.com).

This project is [Apache 2.0](/LICENSE) licensed.

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_