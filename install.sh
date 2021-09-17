#!/bin/bash

# Display ascii art with base64 because I am cool
echo "ICAgICAgICAgICAgXyAgICAgICAgICAgICAgICAgXyAgIF8gICAgICAgICAgICAgICAgICAgICBfICAgICAgICAgICBfICAgICAgICAgICBfIF8gICAKICAgICAgICAgICB8IHwgICAgICAgICAgICAgICB8IHwgfCB8ICAgICAgICAgICAgICAgICAgIHwgfCAgICAgICAgIHwgfCAgICAgICAgIHwgfCB8ICAKICBfIF9fIF9fXyB8IHxfXyAgXyBfXyBfX19fX198IHxffCB8X18gIF8gICBfIF8gX18gICBfX3wgfCBfX18gXyBfX3wgfF9fICAgX19fIHwgfCB8XyAKIHwgJ18gYCBfIFx8ICdfIFx8ICdfIFxfX19fX198IF9ffCAnXyBcfCB8IHwgfCAnXyBcIC8gX2AgfC8gXyBcICdfX3wgJ18gXCAvIF8gXHwgfCBfX3wKIHwgfCB8IHwgfCB8IHxfKSB8IHxfKSB8ICAgICB8IHxffCB8IHwgfCB8X3wgfCB8IHwgfCAoX3wgfCAgX18vIHwgIHwgfF8pIHwgKF8pIHwgfCB8XyAKIHxffCB8X3wgfF98Xy5fXy98IC5fXy8gICAgICAgXF9ffF98IHxffFxfXyxffF98IHxffFxfXyxffFxfX198X3wgIHxfLl9fLyBcX19fL3xffFxfX3wKICAgICAgICAgICAgICAgICB8IHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICB8X3wgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAK" | base64 --decode
echo "Welcome to the installation script of https://github.com/MattSays/mbp-thunderbolt"

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
    echo "WARNING: Not running as root. Using sudo for installation operations"
fi


$SUDO cp -r ./initcpio/* /etc/initcpio/
echo "Initcpio files copied to config directory successfully."

MKINITCPIO = "/etc/mkinitcpio.conf"

grep "pcie-rescan" $MKINITCPIO > /dev/null

if (( $? != 0 )); then
    echo "Adding pcie-rescan hook..."
    sed -i '/HOOKS="base udev/ s/udev/udev pcie-rescan/' $MKINITCPIO
fi

grep "pcie-rescan" $MKINITCPIO > /dev/null

if (( $? != 0 )); then
    echo "ERROR: Couldn't add pcie-rescan hook to your hooks."
    echo "Please add hook 'pcie-rescan' before immediately after 'udev' hook by editing /etc/mkinitcpio.conf and search for HOOKS"
    echo "Save changes by executing 'mkinitcpio -P'"
    exit 1
fi

echo "Updating new changes..."
$SUDO mkinitcpio -P > /dev/null

if (( $? != 0 )); then
    echo "ERROR: Couldn't build new kernel images. exec 'mkinitcpio -P' for more info"
    exit 1
fi

echo "SUCCESS! Installation completed without any errors. YAY!"
