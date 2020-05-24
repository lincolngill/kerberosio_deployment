# kerberosio_deployment
Ansible repo to install and setup Raspberry pi(s) as Kerberos.io security cameras.

Tested on Ubuntu as ansible control host.

## Shortcut script for running ansible commands

Modify as required.

```bash
./doit.sh <step> [<limit> [<playbook> [<tags>]]]
```

## Prepare a new Raspian image for ansible

1) Modify `group_vars/pies/vars.yml` to suit your WiFi and Pi setup requirements.
2) Modify `hosts` to suit your inventory of pi cameras.
3) Update the ansible `VAULT_ID` in the `doit.sh` script.
4) Generate a WiFi psk value from the WiFi passphrase.
```bash
$ wpa_passphrase <ssid>
```
5) Create a vault file.
```bash
$ ./doit.sh 0
vault_wifi_ssid: <ssid>
vault_wifi_psk: <psk>
vault_wifi_passphrase: (leave blank)

# Created via
# $ mkpasswd -m sha-512 <secure_password>
vault_pi_password_hash: "<password_hash_value>"
``` 
6) Inject config into the Raspian image. Refer: [newpi role README.md](roles/newpi/README.md)
```bash
$ ./doit.sh 1
```
7) Check prepared image is working as expected. E.g:
```bash
$ ./doit.sh 2 cam1pi.local
```

## Setup pi as kerberos.io camera

Refer: [picamera role README.md](roles/picamera/README.md)

8) Install kerberos.io machinery and web
```bash
$ ./doit.sh 3 cam1pi.local
```

## Re-run part of the setup

The playbooks and tasks are idempotent, so will only change what is required when re-run multiple times.

Each tasks file in the `pi` and `picamera` roles have associated tags. Refer to the `roles/<role>/tasks/main.yml` files.

Include *tags* in the ansible commands to run part of the setup. E.g to run just the tasks to enable the pi camera:
```bash
$ ./doit.sh 3 cam1pi.local picameras configcamera
```