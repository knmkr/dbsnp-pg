# contrib/deploy

- Deployment scripts for hosting `dbsnp-pg-min` on PostgreSQL server.


## Requirements

- `VirtualBox` & `Vagrant`
- `Ansible`


## Getting Started

1\. Install `VirtualBox` & `Vagrant`.

2\. Install `Ansible`.

3\. Build the VM and deploy the `dbsnp-pg-min` PostgreSQL server.

```
$ vagrant up
```


## Notes

- For production use, replace `Vagrant` to actual servers.
- Define servers in `playbook/hosts`, and run `Ansible` playbooks against remote servers:

```
$ ansible-playbook playbook/site.yml -i playbook/hosts --ask-become-pass
```

- Or clone repo and install ansible on remote servers, and run playbooks against localhost:

```
[user@remote-server]$ # install ansible
[user@remote-server]$ # clone dbsnp-pg-min
[user@remote-server]$ # cd dbsnp-pg-min/contrib/deploy
[user@remote-server]$ ansible-playbook playbook/site.local.yml -i playbook/hosts.local --ask-become-pass
```

See details in `Vagrantfile` and `playbook`.
