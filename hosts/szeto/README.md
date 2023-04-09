`szeto` is a Raspberry Pi 3B+ that hosts my home network services.

# Bootstrapping NixOS

I followed [this tutorial][tutorial] to generate an image of NixOS on my PC to
write to the Raspberry Pi SD card. NixOS could just be rebuilt on the Pi itself,
but that's slow, so this is useful for quick iteration.

The process goes something like this:

```
git clone git@github.com:Robertof/nixos-docker-sd-image-builder.git
cd nixos-docker-sd-image-builder
mv config/rpi3 config/host
mv /etc/nixos/hosts/szeto/*.nix config/host/
cp /etc/nixos/configuration.nix config/sd-image.nix
./run.sh
# dd the image on to the usb
./cleanup.sh
```

Optionally, configure SSH agent forwarding:

```
$ cat ~/.ssh/config
Host szeto
    ForwardAgent yes
```

Once the host boots:

1. Clone this repository into `/etc/nixos` and configure `/etc/nixos/host`

2. Rebuild for good measure

  [tutorial]: https://gist.github.com/chrisanthropic/2e6d3645f20da8fd4c1f122113f89c06

