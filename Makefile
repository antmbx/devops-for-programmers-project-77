# Makefile

ansible-prep: ansible-new-api ansible-ex 
	
yc-state-prep:
	yc storage bucket create --name yc-hxlt-state --max-size 10000000
	yc ydb database create terraform-state-lock --serverless
	echo "folder id: "
	read folderid
	echo "serviceAccount: "
	read serviceAccount
	yc resource-manager folder add-access-binding "${folderid}" --role ydb.editor --subject serviceAccount:"${serviceAccount}"
	ansible-vault  decrypt terraform/secret.backend.tfvars.enc --vault-password-file key.secret --output terraform/secret.backend.tfvars
	terraform init -backend-config=secret.backend.tfvars -reconfigure
	rm -f terraform/secret.backend.tfvars

tf-create:
	ansible-vault  decrypt terraform/var.secret.auto.tf.enc --vault-password-file key.secret --output terraform/var.secret.auto.tf
	terraform -chdir=terraform apply 
	rm -f terraform/var.secret.auto.tf

tf-destroy:
	ansible-vault  decrypt terraform/var.secret.auto.tf.enc --vault-password-file key.secret --output terraform/var.secret.auto.tf
	terraform -chdir=terraform destroy
	rm -f terraform/var.secret.auto.tf


### Работа с инфраструктурой

cp-tmpl2vars: cp-tmpl2vars-backend cp-tmpl2vars-main

cp-tmpl2vars-backend:
	cp terraform/tmpl/secret.backend.tmpl terraform/secret_vars/secret.backend.tfvars
	@echo "\n\n>> Next fill out the template file terraform/secret_vars/secret.backend.tfvars"
	@echo ">> After that, encrypt the file terraform/secret_vars/terraform/secret_vars/var.secret.auto.tf (keyFile key.secret): make ansible-enc-backend \n" 

cp-tmpl2vars-main:
	cp terraform/tmpl/var.secret.auto.tmpl terraform/secret_vars/var.secret.auto.tf
	@echo ">> Next fill out the template file terraform/secret_vars/terraform/secret_vars/var.secret.auto.tf" 
	@echo ">> After that, encrypt the file terraform/secret_vars/terraform/secret_vars/var.secret.auto.tf (keyFile key.secret): make ansible-enc-main \n" 


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
	ansible-vault  decrypt terraform/secret.backend.tfvars.enc --vault-password-file key.secret --output terraform/secret_vars/secret.backend.tfvars

ansible-restore-var-main:	
	ansible-vault  decrypt terraform/var.secret.auto.tf.enc  --vault-password-file key.secret --output terraform/secret_vars/var.secret.auto.tf