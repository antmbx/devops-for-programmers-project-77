#!/bin/bash
echo "INPUT PASSWORD DB"
read pwd
echo "REDMINE_DB_PASSWORD: '${pwd}'" > group_vars/all/vault.yml
