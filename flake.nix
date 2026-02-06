{
  description = "A seamless plymouth theme for Asahi";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { pkgs, ... }:
        {
          packages.default = pkgs.callPackage (
            {
              stdenvNoCC,
              nixos-icons,
              logo ? "${nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png",
            }:
            stdenvNoCC.mkDerivation {
              pname = "seamless-asahi-plymouth-theme";
              version = "1.0.0";
              src = ./src;
              installPhase = ''
                TARGET=$out/share/plymouth/themes/seamless-asahi
                mkdir -p $TARGET
                cp ./* $TARGET/
                cp ${logo} $TARGET/logo.png
                chmod +x $TARGET/seamless-asahi.plymouth
                substituteInPlace $TARGET/seamless-asahi.plymouth --replace '@TARGET_DIR@' "$TARGET"
              '';
            }
          ) { };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              just
              plymouth
              (pkgs.writeShellScriptBin "plymouth-preview" ''
                if [ ! "$( id -u )" -eq 0 ]; then
                  echo "must be run as sudo"
                  exit
                fi

                DURATION=''${1:-5}

                plymouthd
                plymouth --show-splash

                for ((I=0; I<"$DURATION"; I++)); do
                  plymouth --update="step $I"
                  sleep 1
                done

                plymouth quit
              '')
            ];
          };

          formatter = pkgs.nixfmt-tree;
        };
    };
}
