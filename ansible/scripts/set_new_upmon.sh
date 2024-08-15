#!/bin/bash
echo "INPUT TOKEN UPMON"
read upmon
echo "upmontoken: ${upmon}" > ansible/group_vars/lbservers/vault.yml
