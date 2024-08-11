#!/bin/bash
echo "INPUT API KEY DataDog"
read apikey
echo "datadog_api_key: ${apikey}" > ansible/group_vars/webservers/vault.yml
