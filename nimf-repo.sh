#!/bin/bash
# Copyright HamoniKR Team. All rights reserved.
# Script to install the HamoniKR repo onto a Debian or Ubuntu system.
#
# wget -qO- https://update.hamonikr.org/add-update-repo.apt | sudo -E bash -
#   or
# curl -sL https://update.hamonikr.org/add-update-repo.apt | sudo -E bash -

export DEBIAN_FRONTEND=noninteractive

print_status() {
    echo
    echo "## $1"
    echo
}

if test -t 1; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

print_bold() {
    title="$1"
    text="$2"

    echo
    echo "${red}================================================================================${normal}"
    echo "${red}================================================================================${normal}"
    echo
    echo -e "  ${bold}${yellow}${title}${normal}"
    echo
    echo -en "  ${text}"
    echo
    echo "${red}================================================================================${normal}"
    echo "${red}================================================================================${normal}"
}

bail() {
    echo 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

setup() {

    print_status "Installing the HamoniKR APT..."

    if $(uname -m | grep -Eq ^armv6); then
        print_status "You appear to be running on ARMv6 hardware. Unfortunately this is not currently supported by the HamoniKR OS."
        exit 1
    fi

    PRE_INSTALL_PKGS=""
    [ ! -e /usr/lib/apt/methods/https ] && PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} apt-transport-https"
    [ ! -x /usr/bin/lsb_release ] && PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} lsb-release"
    [ ! -x /usr/bin/gpg ] && PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} gnupg"
    if [ "X${PRE_INSTALL_PKGS}" != "X" ]; then
        print_status "Installing packages required for setup:${PRE_INSTALL_PKGS}..."
        exec_cmd "apt-get install -y${PRE_INSTALL_PKGS} > /dev/null 2>&1"
    fi

    DistributorID=$(lsb_release -i -s)
    RELEASE=$(lsb_release -d -s)
    CODENAME=$(lsb_release -c -s)

    check_alt_hamonikr() {
        if [ "X${RELEASE}" == "X${2}" ]; then
            echo
            echo "## You seem to be using ${1} version ${RELEASE}."
            echo "## This maps to ${3} \"${4}\"... Adjusting for you..."
            DISTRO="${4}"
        fi
    }

    if [ "X${DistributorID}" != "XHamoniKR" ]; then
        print_status "Detected ${DistributorID}"
    else
        check_alt_hamonikr "HamoniKR" "me" "HamoniKR" "me"
        check_alt_hamonikr "HamoniKR" "sun" "HamoniKR" "sun"
        check_alt_hamonikr "HamoniKR" "jin" "HamoniKR" "jin"
        check_alt_hamonikr "HamoniKR" "hanla" "HamoniKR" "hanla"
        check_alt_hamonikr "HamoniKR" "taebaek" "HamoniKR" "taebaek"        
    fi

    # Remove previous HamoniKR APT
    if [[ -f "/etc/apt/sources.list.d/hamonikr.list" ]]; then
        exec_cmd "rm -f /etc/apt/sources.list.d/hamonikr.list"
        print_status 'Removing Previous HamoniKR APT - hamonikr.list'
    fi

    if [[ -f "/etc/apt/sources.list.d/hamonikr-pkg.list" ]]; then
        exec_cmd "rm -f /etc/apt/sources.list.d/hamonikr-pkg.list"
        print_status 'Removing Previous HamoniKR APT - hamonikr-pkg.list'
    fi

    if [[ -f "/etc/apt/sources.list.d/hamonikr-app.list" ]]; then
        exec_cmd "rm -f /etc/apt/sources.list.d/hamonikr-app.list"
        print_status 'Removing Previous HamoniKR APT - hamonikr-app.list'
    fi

    # INSTALL APT KEY AND REPO LIST
    print_status 'Adding the HamoniKR Applications APT...'

    # Register apt repository
    eval $(apt-config shell APT_SOURCE_PARTS Dir::Etc::sourceparts/d)
    HAMONIKR_SOURCE_PART=${APT_SOURCE_PARTS}hamonikr.list

    eval $(apt-config shell APT_TRUSTED_PARTS Dir::Etc::trustedparts/d)
    HAMONIKR_TRUSTED_PART=${APT_TRUSTED_PARTS}hamonikr.gpg

    # Install repository source list
    WRITE_SOURCE=0
    if [ ! -f $HAMONIKR_SOURCE_PART ] ; then
        # Write source list if it does not exist
        WRITE_SOURCE=1
    elif grep -Eq "https:\/\/update\.hamonikr\.org" $HAMONIKR_SOURCE_PART; then
        # Migrate from old repository
        WRITE_SOURCE=1
    elif grep -q "# disabled on upgrade to" $HAMONIKR_SOURCE_PART; then
        # Write source list if it was disabled by OS upgrade
        WRITE_SOURCE=1
    fi

    # dpkg --print-architecture = arm64
    if $(uname -m | grep -Eq ^aarch64); then
        # adjust with codename
        if [ "X${CODENAME}" == "Xbionic" ] ||  [ "X${CODENAME}" == "Xbuster" ] ; then
            echo "deb [arch=arm64] http://pkg.hamonikr.org/ ${CODENAME} main" > /etc/apt/sources.list.d/hamonikr.list
            echo "#deb-src [arch=arm64] http://pkg.hamonikr.org/ ${CODENAME} main" >> /etc/apt/sources.list.d/hamonikr.list
        elif [ "X${CODENAME}" == "Xfocal" ] ||  [ "X${CODENAME}" == "Xbullseye" ] ; then
            echo "deb [arch=arm64] http://repo.hamonikr.org/ jetson main" > /etc/apt/sources.list.d/hamonikr.list
            echo "#deb-src [arch=amd64] deb [arch=arm64] http://repo.hamonikr.org/ jetson main" >> /etc/apt/sources.list.d/hamonikr.list
        elif [ "X${CODENAME}" == "Xjammy" ] ||  [ "X${CODENAME}" == "Xbookworm" ] || [ "X${CODENAME}" == "Xorion-belt" ] ; then
            echo "deb [arch=arm64] http://repo.hamonikr.org/ kumkang main extra" > /etc/apt/sources.list.d/hamonikr.list
            echo "#deb [arch=arm64] http://repo.hamonikr.org/ kumkang main extra" >> /etc/apt/sources.list.d/hamonikr.list
        elif [ "X${CODENAME}" == "Xnoble" ]
            echo "deb [arch=arm64] http://pkg.hamonikr.org/ bionic main" > /etc/apt/sources.list.d/hamonikr.list
            echo "#deb-src [arch=arm64] http://pkg.hamonikr.org/ bionic main" >>/etc/apt/sources.list.d/hamonikr.list
        fi
    else
    # amd64
        if [ "$WRITE_SOURCE" -eq "1" ]; then
            echo "### THIS FILE IS AUTOMATICALLY CONFIGURED ###" > $HAMONIKR_SOURCE_PART
            echo "deb [arch=amd64] https://update.hamonikr.org taebaek main" >> $HAMONIKR_SOURCE_PART
            echo "#deb-src [arch=amd64] https://update.hamonikr.org taebaek main" >> $HAMONIKR_SOURCE_PART
        fi

        # for debian bullseye and LDME 5
        if [ "X${CODENAME}" == "Xelsie" ] ||  [ "X${CODENAME}" == "Xbullseye" ] ; then
            echo "deb [arch=amd64] https://pkg.hamonikr.org bullseye main" > /etc/apt/sources.list.d/hamonikr-pkg.list
            echo "#deb-src [arch=amd64] https://pkg.hamonikr.org bullseye main" >> /etc/apt/sources.list.d/hamonikr-pkg.list
        # for debian bookworm, ubuntu jammy, sparky 7.3
        elif [ "X${CODENAME}" == "Xjammy" ] ||  [ "X${CODENAME}" == "Xbookworm" ] || [ "X${CODENAME}" == "Xorion-belt" ] ; then
            echo "deb [arch=amd64] http://repo.hamonikr.org/ jammy main extra" > /etc/apt/sources.list.d/hamonikr.list
            echo "#deb [arch=amd64] http://repo.hamonikr.org/ jammy main extra" >> /etc/apt/sources.list.d/hamonikr.list        
        fi
    fi

    # Sourced from https://repo.hamonikr.org/hamonikr-pkg.key
    if [ ! -f $HAMONIKR_TRUSTED_PART ]; then
        KEY="-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=jMj1
-----END PGP PUBLIC KEY BLOCK-----"
    
    echo "$KEY" | gpg --dearmor > $HAMONIKR_TRUSTED_PART   

    fi

    print_status 'Running `apt-get update` for you...'
    exec_cmd 'apt-get update'

    case $LANG in
        ko*)
            print_bold """\`${bold}�섎え�덉뭅 ���μ냼�� 理쒖떊 �⑦궎吏� 紐⑸줉�� 媛��몄솕�듬땲��.${normal}\`
    ## �ъ슜 以� 沅곴툑�� �먯� �꾨옒 �ъ씠�몃� 諛⑸Ц�섏꽭��. :
    https://hamonikr.org
"""
            ;;
        *)
            print_bold """\`${bold}Updated HamoniKR Repo.${normal}\`
    ## If you have any questions, please visit the link below :
    https://hamonikr.org
"""
            ;;
    esac

}

## Defer setup until we have the complete script
setup