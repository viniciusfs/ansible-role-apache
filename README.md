# Ansible role: Apache

[![Build Status](https://travis-ci.org/viniciusfs/ansible-role-apache.svg?branch=master)](https://travis-ci.org/viniciusfs/ansible-role-apache)

Installs and configures Apache Server in CentOS/RHEL systems.


## Role Variables

* `apache_`:
    - Description: Enable service at boot time
    - Values: `True | False`
    - Default: `True`


## Example Playbook

    - hosts: servers
      roles:
        - { role: viniciusfs.apache }


## License

MIT


## Author Information

* Vinícius Figueiredo <viniciusfs@gmail.com>
