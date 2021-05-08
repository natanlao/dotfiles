TF2 configuration, generated with [cfg.tf](https://cfg.tf) using Rhapsody's DX9
config ([RhapsodySL/perfconfig](https://github.com/RhapsodySL/perfconfig)).

Use launch options:

    -dxlevel 95 -fullscreen -w 1920 -h 1080 -novid

This can't be stowed, I think because TF2 doesn't like symlinks. So:

    cd apps/
    rm -rf ~/.steam/steam/steamapps/common/Team\ Fortress\ 2/tf/cfg
    cp -R cfg ~/.steam/steam/steamapps/common/Team\ Fortress\ 2/tf
