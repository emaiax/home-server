## home-server

To install:

```
wget -qO - https://raw.githubusercontent.com/emaiax/home-server/main/install.sh | bash -
```

It's recommended that you generate a new SSH Key for accessing your home-server, then you can copy the new key using the example below.

```
ssh-copy-id -i /path/to/new/key.pub user@homeserver.local
```