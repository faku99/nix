# Import personal GPG key

```bash
rbw get "PGP lucas@elisei.ch" | sudo gpg --import -
```

# Add a new host

```bash
nix-shell -p ssh-to-age --run 'ssh-keyscan $HOST | ssh-to-age'
```

Then add a new entry in `.sops.yaml`.