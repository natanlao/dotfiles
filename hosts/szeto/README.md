`szeto` is a Raspberry Pi 3B+ that hosts my home network services.

# Bootstrapping NixOS

I followed [this tutorial][tutorial] to generate an image of NixOS on my PC to
write to the Raspberry Pi SD card. NixOS could just be rebuilt on the Pi itself,
but this step is useful for convenience.

The process goes something like this:

```
git clone git@github.com:Robertof/nixos-docker-sd-image-builder.git
cd nixos-docker-sd-image-builder
mv config/rpi3 config/host
mv config/host/hardware-config.nix config/host/hardware-configuration.nix  # if it doesn't exist, otherwise we can use the real config -- easier than rewriting configuration.nix
cp /etc/nixos/hosts/szeto/configuration.nix config/host/
cp /etc/nixos/configuration.nix config/sd-image.nix
# set DISABLE_ZFS_IN_INSTALLER=y in :/docker/docker-compose.yml
./run.sh
```

Then, to clean up:

```
./run.sh down --rmi all -v
```

  [tutorial]: https://gist.github.com/chrisanthropic/2e6d3645f20da8fd4c1f122113f89c06

