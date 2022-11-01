## home-server

To install:

```
wget -qO - https://raw.githubusercontent.com/emaiax/home-server/main/install.sh | bash -
```

It's recommended that you generate a new SSH Key for accessing your home-server, then you can copy the new key using the example below.

```
ssh-copy-id -i /path/to/new/key.pub user@homeserver.local
```

Now you just need to setup your SSH config to use the identity file so you won't be prompted for a password next time. I have something like this:

```
Host homeserver
  HostName 192.168.1.123
  User pirate
  IdentityFile ~/.ssh/homeserver

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

#### Setup

This configuration relies on having both the SUDO and VAULT password files stored locally so you don't have to type it on every run.

```
echo "your vault password" > .vault_password
echo "your become password" > .become_password

To run all the tasks, you can run the following statement:

```
ansible-playbook setup.yml
```

To only deploy the docker services, you can use the tags `deploy-services` as:

```
ansible-playbook setup.yml --tags "deploy-services"
```

If you want to deploy the services and use custom config files, you can use both tags `deploy-services, deploy-local-config` as:

```
ansible-playbook setup.yml --tags "deploy-services, deploy-local-config"
```