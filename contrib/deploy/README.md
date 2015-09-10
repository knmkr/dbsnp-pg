# contrib/deploy

- Deployment scripts for `dbsnp-pg-min` on PostgreSQL server.


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

- For production use, replace `Vagrant` to actual servers, and run `Ansible` playbooks directly.


See details in `Vagrantfile` and `playbook`.
