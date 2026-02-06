<h1><p align="center">Seamless Asahi Plymouth Theme</p></h1>

<p float="left">
  <img src="https://raw.githubusercontent.com/luca-schlecker/seamless-asahi-plymouth/refs/heads/main/assets/nixos.png" alt="Screenshot using the NixOS icon" width="49%" />
  <img src="https://raw.githubusercontent.com/luca-schlecker/seamless-asahi-plymouth/refs/heads/main/assets/asahi.png" alt="Screenshot using the Asahi icon" width="49%" />
</p>

The theme is designed to mimick the astethics of the MacOS boot screen
including a smooth transitions between _u-boot_ and _plymouth_. The used logo is
interchangeable to allow for easy adaptation to custom u-boot logos.

> [!NOTE]
> I was only able to test this on my MacBook Pro M2 14". It could be that other
> devices do not have a smooth transition due to different displays.

## Installation

This theme is available as a NixOS flake, but can also be installed manually.

To ensure correct operation, plymouth must not be scaled. Do this by
adding `DeviceScale=1` to the plymouth config.

### NixOS

Add the flake to your inputs and make the following configuration:

```nix
boot.plymouth = {
  enable = true;
  theme = "seamless-asahi";
  themePackages = [ inputs.seamless-asahi-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  extraConfig = ''
    DeviceScale=1
  '';
};
```

The [NixOS logo](https://github.com/NixOS/nixos-artwork/blob/master/logo/nix-snowflake-colours.svg)
is used by default, but it can be overridden like this:
```nix
inputs.seamless-asahi-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
  logo = "<path to logo>";
}
```

### Manual

Before installation, a logo must be chosen. Copy it to `./src/logo.png`.
On most distributions the theme can then be installed by copying it to
`/usr/share/plymouth/theme/`.

### Justfile

There is a _justfile_ automating the manual process.

Execute the following command with a valid _path_ or _URL_ to a _png_ file instead of the `<image>`:
```bash
just install <image>
```

Execute the respective command to install the theme using a common logo:
- Asahi: `just install "https://raw.githubusercontent.com/AsahiLinux/artwork/refs/heads/main/logos/png_512/AsahiLinux_logomark.png"`
- Fedora: `just install "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Fedora_icon_%282021%29.svg/960px-Fedora_icon_%282021%29.svg.png"`
