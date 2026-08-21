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

