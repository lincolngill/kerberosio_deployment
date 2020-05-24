#!/usr/bin/env bash
STEP=${1:-1}
LIMIT="${2}"
PLAY="${3:-picameras}"
TAGS="${4}"
AOPT=""
if [ -n "$LIMIT" ]; then
    AOPT="-l ${LIMIT}"
fi
if [ -n "$TAGS" ]; then
    AOPT="$AOPT --tags ${TAGS}"
fi
cd $(dirname $0)

fn_run () {
    set -x; $1; set +x
}

case $STEP in
    0) fn_run "ansible-vault edit --vault-id gills@~/ansible-vpw group_vars/pies/vault.yml" ;;
    # mount USB SD card locally
    1) fn_run "ansible-playbook prepimage.yml -i hosts ${AOPT} --vault-id gills@~/ansible-vpw" ;;
    2) fn_run "ansible ${LIMIT} -i hosts -a whoami --vault-id gills@~/ansible-vpw" ;;
    # Run playbook with vault
    3) fn_run "ansible-playbook ${PLAY}.yml -i hosts ${AOPT} --vault-id gills@~/ansible-vpw" ;;
    # Run playbook without vault
    4) fn_run "ansible-playbook ${PLAY}.yml -i hosts ${AOPT}" ;;
    5) fn_run "ansible-galaxy init roles/newrole" ;;
    # List facts
    6) fn_run "ansible -i hosts -m setup --vault-id gills@~/ansible-vpw $LIMIT" ;;
    *) echo "Usage: doit.sh [<step>] [<ansible_limit>]" >&2; exit 1 ;;
esac