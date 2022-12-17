# home-server

<h1 align="center">
 <img width="480" src="https://blog.codinghorror.com/content/images/uploads/2012/10/6a0120a85dcdae970b017c327d5a4e970b-800wi.jpg">
</h1>

![]()
**Hardware:** [Beelink GTR5 R9, AMD Ryzen 9 5900HX](https://pt.aliexpress.com/item/32753185927.html)

**Compatibility:**

| Distro | Version | Arch       | Compatibility |
|--------|:-------:| :----------:|:----------------:|
| Ubuntu | 22.04.1 LTS (Jammy Jellyfish) | x86_64 | ✅ |

## Install

```shell
wget -qO - https://raw.githubusercontent.com/emaiax/home-server/main/install.sh | bash -
```

It's recommended that you generate a new SSH Key for accessing your home-server, then you can copy the new key using the example below.

```shell
ssh-copy-id -i /path/to/new/key.pub user@homeserver.local
```

Now you just need to setup your SSH config to use the identity file so you won't be prompted for a password next time. I have something like this:

```ssh-config
Host homeserver
  HostName 192.168.1.123
  User pirate
  IdentityFile ~/.ssh/homeserver

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

## Setup

This configuration relies on having both the `sudo` and `vault` password files stored locally so you don't have to type it on every run.

```shell
echo "your vault password" > .vault_password
echo "your become password" > .become_password
```

It's also recommended to change the permissions of these password files as they are plain texts, so no one else has access to those passwords

```shell
chmod 700 .vault_password .become_password
```

To run all the tasks, you can run the following statement:

```shell
ansible-playbook setup.yml
```

To only deploy the docker services, you can use the tags `deploy-services` as:

```shell
ansible-playbook setup.yml --tags "deploy-services"
```

If you want to deploy the services and use custom config files, you can use both tags `deploy-services, deploy-local-config` as:

```shell
ansible-playbook setup.yml --tags "deploy-services, deploy-local-config"
```
