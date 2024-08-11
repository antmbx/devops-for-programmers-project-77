### Hexlet tests and linter status:
[![Actions Status](https://github.com/antmbx/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/antmbx/devops-for-programmers-project-77/actions)

[![UPMON](https://www.upmon.com/badge/49fff047-2b66-4a11-8eb9-3d41d3/2-chJkvO.svg)](https://hexlet.azxs.ru/)



# Описание проекта
> 1. Load balancer + reverse proxy (nginx)
> 2. Веб-сервер 1
> 3. Веб-сервер 2
> 4. Managed кластер PGSQL
> 


**path to Example:** https://hexlet.azxs.ru/


### Установка зависимостей

```
make ansible-ex
```

## Создание инфры

Состояние инфры хранится в бакете облака. Для этого необходимо предварительно подготовить облако к хранению tfstate согласно документации.


Инфраструктура создается с помощью Terraform (рабочий каталог [terraform](https://github.com/antmbx/devops-for-programmers-project-77/tree/main/terraform))

### Подготовка секретов и переменных

#### Ключи для TLS веб-сайта
Разместите ключи в каталоге /ansible/keys
- сертификат с именем файла cert.crt
- ключ с именем файла key.key

#### Переменные
Создайте файл /*key.secret* с ключом для шифрования секретов.


Шаблоны терраформ-файлов находятся в каталоге [/terraform/tmpl](https://github.com/antmbx/devops-for-programmers-project-77/tree/main/terraform/tmpl).

ОНИ не подлежат изменению, т.к. являются шаблонами.

Подготовленные для шифрования файлы секретов и переменных должны находится в каталоге *terraform/secret_vars*

Для подготовки каталога *terraform/secret_vars* используется команда
```bash
make cp-tmpl2vars
```

*terraform/secret_vars/secret.backend* - переменные для бекенда терраформ - endpoint для хранения состояния


*terraform/secret_vars/var.secret.auto.tf* - переменные для разворачивания инфры

После заполнения секретов и переменных производится их шифрование:

```bash
make ansible-enc
```
ВНИМАНИЕ! После шифрования файлы с переменные из каталога *terraform/secret_vars* удаляются

Расшифровать и восстановить для последующего редактирования в каталоге *terraform/secret_vars* можно командой: 
```bash
make ansible-restore-var
```


### Инфраструктура

Создание инфрастуктуры. Развернуть все компоненты инфры, установить зависимости, развернуть проектные системы
```bash
make tf-create
```

Уничтожить инфраструктуру
```bash
make tf-destroy
```


#### DataDog
Задать токен API DD
```bash
make ansible-new-api
```

Рестарт DD для применения настрок
```bash
make ansible-restart-dd
```

#### UPMON

Задать токен UPMON (https://upmon.net/[ТОКЕН])
```bash
make ansible-new-upmon
```

Рестарт cron после изменений настроек CRON
```bash
make ansible-upmon-reload
```