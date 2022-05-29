+++
title = "Install NixOS on a Contabo-VPS"
description = "to install NixOS on a Contabo-VPS workarounds are required explained here."
tags = [
  "nixos",
  "contabo",
]
date = 2020-09-06T12:05:50Z
author = "Felix Bühler"
+++

this little guide describes how to bootstrap nix to install nixos on a contabo-vps server:

create `/nix` and used tempfs, because otherwise the disk is full quickly

```bash
mkdir /nix
mount -t tmpfs tmpfs /nix -o size=5g
```

create nix-build users

```bash
groupadd nixbld
for n in $(seq 1 10); do useradd -c "Nix build user $n" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(command -v nologin)" "nixbld$n"; done
```

change password of xuser (so we can use sudo later) and switch to it

```bash
passwd xuser
su xuser
cd
```

install `nix`

```bash
bash <(curl -L https://nixos.org/nix/install)
. $HOME/.nix-profile/etc/profile.d/nix.sh
sudo nix-channel --add https://nixos.org/channels/nixos-21.11 nixpkgs
```

setup `nixpkgs`

```bash
sudo -E nix-env -iE "_: with import <nixpkgs/nixos> { configuration = {}; }; with config.system.build; [ nixos-generate-config nixos-install nixos-enter manual.manpages ]"
```

Now partition the disks the way you want them and mount them to `/mnt`

```bash
mount /dev/sda1 /mnt
```

nextup generate config

```bash
nixos-generate-config --root /mnt
```

make sure these lines are included in your config:

```bash
{ config, lib, pkgs, ... }:

{
  boot.initrd = {
    availableKernelModules = [
      "virtio_pci"  # disk
      "virtio_scsi" # disk
    ];
    kernelModules = [
      "dm-snapshot"
    ];
  };
}
```

install NixOS

```bash
nixos-install
```

then exit `xuser` and reboot

```bash
exit
reboot
```

after rebooting make sure the nix-channels are up-to-date

```bash
nix-channel --add https://nixos.org/channels/nixos-21.11 nixos
nixos-rebuild switch --upgrade
```
