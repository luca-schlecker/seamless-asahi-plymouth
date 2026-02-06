
# Install the theme with the given logo
install IMAGE:
    #!/usr/bin/env sh
    if [[ "{{IMAGE}}" == "https://"* ]]; then
        curl -L "{{IMAGE}}" -o ./src/logo.png
    else
        cp {{IMAGE}} ./src/logo.png
    fi
    sudo cp -R ./src /usr/share/plymouth/themes/seamless-asahi
    sudo plymouth-set-default-theme -R seamless-asahi
