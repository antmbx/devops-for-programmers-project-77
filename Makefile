# Makefile
 
ansible-ex:
	ansible-galaxy install -r requirements.yml
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini -kK -t prep --ask-vault-pass

yc-reconf:
	ansible-vault  decrypt terraform/secret.backend.tfvars.enc --vault-password-file key.secret --output terraform/secret.backend.tfvars
	terraform -chdir=terraform init -backend-config=secret.backend.tfvars -reconfigure
	rm -f terraform/secret.backend.tfvars


tf-create:
	ssh-keygen -m PEM -t rsa -b 4096 -f id_rsa -N ''
	ansible-vault  decrypt terraform/var.secret.auto.tf.enc --vault-password-file key.secret --output terraform/var.secret.auto.tf
	terraform -chdir=terraform apply 
	rm -f terraform/var.secret.auto.tf
	sleep 120
	resolvectl flush-caches
	ansible-galaxy install -r ansible/requirements.yml
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini -kK -t prep --vault-password-file key.secret



tf-destroy:
	ansible-vault  decrypt terraform/var.secret.auto.tf.enc --vault-password-file key.secret --output terraform/var.secret.auto.tf
	terraform -chdir=terraform destroy
	rm -f terraform/var.secret.auto.tf


### Работа с инфраструктурой

cp-tmpl2vars:# cp-tmpl2vars-backend cp-tmpl2vars-main
	mkdir -p terraform/secret_vars
	cp terraform/tmpl/secret.backend.tmpl terraform/secret_vars/secret.backend.tfvars
	cp terraform/tmpl/var.secret.auto.tmpl terraform/secret_vars/var.secret.auto.tf

### Работа с vars
# Шифруем переменные в каталоге terraform/secret_vars и удаляем исходные файлы
ansible-enc: ansible-enc-backend ansible-enc-main

ansible-enc-backend:
	ansible-vault  encrypt terraform/secret_vars/secret.backend.tfvars --vault-password-file key.secret --output terraform/secret.backend.tfvars.enc
	rm -f terraform/secret_vars/secret.backend.tfvars


ansible-enc-main:
	ansible-vault  encrypt terraform/secret_vars/var.secret.auto.tf --vault-password-file key.secret --output terraform/var.secret.auto.tf.enc
	rm -f terraform/secret_vars/var.secret.auto.tf


# Восстанавливаем переменные в каталоге terraform/secret_vars для редактирования и дальнейшего шифрования
ansible-restore-var: ansible-restore-var-backend ansible-restore-var-main

ansible-restore-var-backend:
	mkdir -p terraform/secret_vars
	ansible-vault  decrypt terraform/secret.backend.tfvars.enc --vault-password-file key.secret --output terraform/secret_vars/secret.backend.tfvars

ansible-restore-var-main:
	mkdir -p terraform/secret_vars	
	ansible-vault  decrypt terraform/var.secret.auto.tf.enc  --vault-password-file key.secret --output terraform/secret_vars/var.secret.auto.tf



ansible-new-api:
	chmod +x ansible/scripts/set_new_api.sh
	./ansible/scripts/set_new_api.sh	
	ansible-vault encrypt ansible/group_vars/webservers/vault.yml --vault-password-file key.secret
	

ansible-restart-dd:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini -kK -t restart-datadog --vault-password-file key.secret



ansible-new-upmon: ansible-upmon-token  ansible-upmon-reload

ansible-upmon-token:
	chmod +x ansible/scripts/set_new_upmon.sh
	./ansible/scripts/set_new_upmon.sh	
	ansible-vault encrypt ansible/group_vars/lbservers/vault.yml --vault-password-file key.secret

ansible-upmon-reload:
		ansible-playbook ansible/playbook.yml -i ansible/inventory.ini -kK -t upmon --vault-password-file key.secret


ansible-restart:
		ansible-playbook ansible/playbook.yml -i ansible/inventory.ini -kK -t restart --vault-password-file key.secret		