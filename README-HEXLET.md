> 1) похоже что не хватает нескольких объектов terraform, в условиях задания:

>> 1.1) Создайте Alert в DataDog используя Terraform.

>> 1.2) Добавьте в Terraform домен и запись, которая будет указывать на созданный балансировщик нагрузки


>> 1.3) Балансировщик нагрузки, принимающий запросы по HTTPS

Балансирощик, принимающий запросы по HTTPS есть


"Все задачи выполняются через Terraform. Руками только проверка результата."

> 2) Предлагаю перенести в файл proviver.tf https://github.com/antmbx/devops-for-programmers-project-77/blob/47def5166c30318bff7ff4fbfe07b39af406ca1b/terraform/main.tf#L12-L15

> 3) Желательно избегать неявной зависимости, предлагаю перенести в Ansible (ближе к приложению) https://github.com/antmbx/devops-for-programmers-project-77/blob/47def5166c30318bff7ff4fbfe07b39af406ca1b/terraform/main.tf#L55-L60

> 4) После пункта 1 предлагаю убрать nginx https://github.com/antmbx/devops-for-programmers-project-77/blob/47def5166c30318bff7ff4fbfe07b39af406ca1b/ansible/playbook.yml#L132-L196

