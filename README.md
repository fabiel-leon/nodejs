Ansible Node.js Site Role
=========================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-Node-Site-Role.svg?branch=master)](https://travis-ci.org/bbatsche/Ansible-Node-Site-Role)  [![Ansible Galaxy](https://img.shields.io/ansible/role/7466.svg)](https://galaxy.ansible.com/bbatsche/Node)

This role will install NVM and use that to setup a given version of Node.js. It will create an Nginx site running that node executable through Phusion Passenger.

Requirements
------------

Installing NVM requires that Git already be installed on your server. But come on, you already did that, right?

This role takes advantage of Linux filesystem ACLs and a group called "web-admin" for granting access to particular directories. You can either configure those steps manually or install the [`bbatsche.Base`](https://galaxy.ansible.com/bbatsche/Base/) role.

Role Variables
--------------

- `domain` &mdash; Site domain to be created.
- `nvm_version` &mdash; Version of NVM to be installed. Default is "v0.30.2".
- `node_version` &mdash; Version of Node.js to be installed. Default is "v5.5.0".
- `copy_appjs` &mdash; Whether to copy a stub app.js file to the site, useful for testing. Default is no.
- `http_root` &mdash; Directory all site directories will be created under. Default is "/srv/http".
- `nvm_root` &mdash; Directory to install NVM and its support files. Default is "/usr/local/nvm"

Dependencies
------------

This role depends on bbatsche.Nginx. You must install that role first using:

```bash
ansible-galaxy install bbatsche.Nginx
```

Example Playbook
----------------

```yml
- hosts: servers
  roles:
     - { role: bbatsche.Node, domain: my-node-site.dev }
```

License
-------

MIT

Testing
-------

Included with this role is a set of specs for testing each task individually or as a whole. To run these tests you will first need to have [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed. The spec files are written using [Serverspec](http://serverspec.org/) so you will need Ruby and [Bundler](http://bundler.io/).

To run the full suite of specs:

```bash
$ gem install bundler
$ bundle install
$ rake
```

The spec suite will target both Ubuntu Trusty Tahr (14.04) and Xenial Xerus (16.04).

To see the available rake tasks (and specs):

```bash
$ rake -T
```

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency is tested independently via integration testing.
