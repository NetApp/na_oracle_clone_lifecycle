#/usr/bin/sh

cd /home/admin/na_oracle_clone_lifecycle
/home/admin/.local/bin/ansible-playbook -i hosts clone_1_refresh.yml -u admin -e @vars/vars.yml >> logs/clone_1_refresh_`date +"%Y-%m%d-%H%M%S"`.log 2>&1
