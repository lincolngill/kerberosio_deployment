Seup Raspberry Pi as kerberos.io camera
=========

Refer: https://doc.kerberos.io/opensource/installation-advanced#raspbian

* Enable camera
* Install kerberos.io machinery software
* Install kerberos.io web software
* Create job to auto remove old images

Requirements
------------

1. Raspian image prepared via *prepimage.yml* playbook. Or Pi setup for ansible ssh access

Role Variables
--------------

| Variable                    | Required | Default                      | Comments                                    |
|-----------------------------|----------|------------------------------|---------------------------------------------|
| picamera_kerberosio_version | no       | 2.8.0                        | Kerberos.io release version                 |
| picamera_mach_baseurl       | no       | Refer defaults/main.yml      | Kerberos.io download base URL               |
| picamera_mach_pkg           | no       | Refer defaults/main.yml      | Kerberos.io download machinery package dict |
| picamera_mach_libdir        | no       | /usr/lib/arm-linux-gnueabihf | Encoding lib install location               |
| picamera_mach_libs          | no       | Refer defaults/main.yml      | Encoding lib file names dict of lists       |
| picamera_web_baseurl        | no       | Refer defaults/main.yml      | Kerberos.io download web tarball URL        |

`picamera_mach_pkg` is a dictionary of package names. Key=pi_type, value=machinery_pkgname.

`picamera_mach_libs` is a dictionary of encoding library names (list). Key=pi_type, value=list_of_libnames.


Internal Variables
------------------

| Variable                 | Value      | Comments                                 |
|--------------------------|------------|------------------------------------------|
| picamera_enable_camera   | True       | Desired state of pi camera               |
| ansible_env.HOME         | From facts | Location of downloaded machinery package |

Dependencies
------------

Role dependencies:
* pi

Example Playbook
----------------

Need to gather facts (for installkmach.yml tasks).

#### *picamera.yml*
```yaml
#
# Playbook setup kerberos.io Pi security camera
#
- name: Pi security camera setup
  hosts: picameras
  gather_facts: yes
  become: yes

  tasks:
    # picamera role depends on pi role
    - import_role:
        name: picamera
```
```bash
ansible-playbook -i hosts --vault-id <label>@<source> picameras.yml --tags <distupgrade|setpw|...> -l <hostlimit>
```