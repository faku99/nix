# Network

## Wireless

```
$ sudo systemctl start wpa_supplicant.service
$ wpa_cli
> add_network
0
> set_network 0 ssid "SSID"
OK
> set_network 0 psk "PASSWORD"
OK
> enable_network 0
OK
```

# Disk formatting

```
$ sudo -i
# FLAKE_URL="github:faku99/nixos#hostname"
# nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --flake $FLAKE_URL --mode destroy,format,mount
# nixos-install --flake $FLAKE_URL --no-root-passwd
```

# Raspberry 5

1. Extract [RPi5_UEFI_Release_v0.3.zip](https://github.com/worproject/rpi5-uefi/releases/download/v0.3/RPi5_UEFI_Release_v0.3.zip) to the first partition (FAT32) of the microSD card
2. Reboot
3. In BIOS settings, under *Device Manager* > *Raspberry Pi Configuration* > *ACPI / Device Tree*, set *System Table Mode* to *Device Tree*
4. Save and reset