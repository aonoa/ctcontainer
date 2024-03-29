set -lx prefix [ctcontainer]
set -lx ctcontainer_root /opt/ctcontainer
set -lx ctcontainer_share $HOME/ctcontainer_share
set -lx ctcontainer_log_level info
set -lx ctcontainer_backend chroot
set -lx ctcontainer_safety_level 1
set -lx ctcontainer_auto_umount 1
if test -d /etc/centerlinux/conf.d/
else
    sudo mkdir -p /etc/centerlinux/conf.d/
end
if test -e /etc/centerlinux/conf.d/ctcontainer.conf
    set ctcontainer_root (sed -n '/ctcontainer_root=/'p /etc/centerlinux/conf.d/ctcontainer.conf | sed 's/ctcontainer_root=//g')
    set ctcontainer_share (sed -n '/ctcontainer_share=/'p /etc/centerlinux/conf.d/ctcontainer.conf | sed 's/ctcontainer_share=//g')
    set ctcontainer_log_level (sed -n '/log_level=/'p /etc/centerlinux/conf.d/ctcontainer.conf | sed 's/log_level=//g')
    set ctcontainer_backend (sed -n '/backend=/'p /etc/centerlinux/conf.d/ctcontainer.conf | sed 's/backend=//g')
    set ctcontainer_safety_level (sed -n '/safety_level=/'p /etc/centerlinux/conf.d/ctcontainer.conf | sed 's/safety_level=//g')
    set ctcontainer_auto_umount (sed -n '/auto_umount=/'p /etc/centerlinux/conf.d/ctcontainer.conf | sed 's/auto_umount=//g')
else
    ctconfig_init
end
if test -d $ctcontainer_root
else
    set_color red
    logger 4 "root.ctcontainer not found,try to create it under root"
    set_color normal
    sudo mkdir -p $ctcontainer_root
end
argparse -i -n $prefix ctlog_level= ctauto_umount= ctsafety_level= ctbackend= -- $argv
if set -q _flag_ctlog_level
    set ctcontainer_log_level $_flag_ctlog_level
end
if set -q _flag_ctauto_umount
    set ctcontainer_auto_umount $_flag_ctauto_umount
end
if set -q _flag_ctsafety_level
    set ctcontainer_safety_level $_flag_ctsafety_level
end
if set -q _flag_ctbackend
    set ctcontainer_backend $_flag_ctbackend
end
if [ "$ctcontainer_log_level" = debug ]
    logger 2 "set root.ctcontainer -> $ctcontainer_root"
    logger 2 "set share.ctcontainer -> $ctcontainer_share"
    logger 2 "set log_level.ctcontainer -> $ctcontainer_log_level"
    logger 2 "set backend.ctcontainer -> $ctcontainer_backend"
    logger 2 "set safety_level.ctcontainer -> $ctcontainer_safety_level"
    logger 2 "set auto_umount.ctcontainer -> $ctcontainer_auto_umount"
end
switch $argv[1]
    case purge
        purge $argv[2..-1]
    case init
        init $argv[2] $argv[3]
    case run
        run $argv[2] $argv[3..-1]
    case list
        list
    case v version
        set_color yellow
        echo "FrostFlower@build8"
        set_color normal
    case install
        install ctcontainer
    case uninstall
        uninstall ctcontainer
    case h help '*'
        help_echo
end
