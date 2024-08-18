> 1) похоже что не хватает нескольких объектов terraform, в условиях задания:

>> 1.1) Создайте Alert в DataDog используя Terraform.

**Без изменений**

>> 1.2) Добавьте в Terraform домен и запись, которая будет указывать на созданный балансировщик нагрузки

**Выполнено для своего кастомного балансировщика (балансировщик + реверспрокси со своим TLS сертификатом)**

>> 1.3) Балансировщик нагрузки, принимающий запросы по HTTPS

**Свой, кастомный балансировщик + реверспрокси + HTTPS
**

> 2) Предлагаю перенести в файл proviver.tf https://github.com/antmbx/devops-for-programmers-project-77/blob/47def5166c30318bff7ff4fbfe07b39af406ca1b/terraform/main.tf#L12-L15

**Готово**


> 3) Желательно избегать неявной зависимости, предлагаю перенести в Ansible (ближе к приложению) https://github.com/antmbx/devops-for-programmers-project-77/blob/47def5166c30318bff7ff4fbfe07b39af406ca1b/terraform/main.tf#L55-L60


**Сделал генерацию файла секретов для Ansible в provisioner "local-exec" на базе переменных и ресурсов Terraform**

> 4) После пункта 1 предлагаю убрать nginx https://github.com/antmbx/devops-for-programmers-project-77/blob/47def5166c30318bff7ff4fbfe07b39af406ca1b/ansible/playbook.yml#L132-L196

**оставил свой кастомный балансировщик**