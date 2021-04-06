#!/bin/bash

LATEST_ZIP="https://github.com/r-kuhr/c9util/archive/main.zip"
TMP_ZIP="/tmp/c9util.zip"
INSTALL_PATH="/home/ec2-user/.c9u"
BASH_PROFILE="/home/ec2-user/.bash_profile"
EXPORT_STATEMENT="export PATH=\$PATH:$INSTALL_PATH/bin"

prompt_user() {
    echo
    echo "Press RETURN or SPACE to continue or any other key to abort"
    read -r -s -n 1 key
    if [[ ! $key = "" ]]; then
        echo "** CANCELED **"
        exit 1
    fi
}

uninstall() {
    read -r -p \
        "Remove existing version at $INSTALL_PATH? existing? [y/N] " \
        answer
    if [[ ! ${answer,,} =~ ^(yes|y)$ ]]; then
        echo "** CANCELED **"
        exit 1
    fi

    rm -rf $INSTALL_PATH
}

if_install_do_we_remove() {
    if [[ ! -d "$INSTALL_PATH" ]]; then
        return
    fi
    uninstall
}

install() {
    wget -q -O $TMP_ZIP $LATEST_ZIP
    unzip -q $TMP_ZIP -d /tmp
    rm $TMP_ZIP
    mv /tmp/c9util-main $INSTALL_PATH
    chmod +x $INSTALL_PATH/bin/*
}

add_export() {
    if [[ "$(cat $BASH_PROFILE)" == *"$EXPORT_STATEMENT"* ]]; then
        return
    fi
    echo $EXPORT_STATEMENT >> $BASH_PROFILE
}
prompt_user

if_install_do_we_remove

install

add_export

echo "installation complete"
echo ""
echo "you will need to source your profile or open a new terminal for the utilities to be in our path"