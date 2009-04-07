url --url=$tree
#if $getVar('system_name', '') != ''
authconfig  --enableshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
#if $getVar('rhts_server', '') != ''
# Use text mode install
text
#end if
$getVar('mode', '')

# Firewall configuration
#if $getVar('rhts_server', '') != ''
firewall --disabled
#end if
#if $getVar('rhts_server', '') == ''
firewall --enabled --port=22:tcp
#end if

#if $getVar('rhts_server', '') != ''
# Don't Run the Setup Agent on first boot
firstboot --disable
#end if

# System keyboard
keyboard $getVar('keyboard', 'us')
# System language
lang $getVar('lang','en_US.UTF-8')
langsupport --default $getVar('lang', 'en_US.UTF-8') $getVar('lang','en_US.UTF-8')
$yum_repo_stanza
reboot
#Root password
rootpw --iscrypted \$1\$mF86/UHC\$WvcIcX2t6crBz2onWxyac.
# SELinux configuration
selinux --$getVar('selinux', 'enforcing')

#if $getVar('rhts_server','') != ''
# Do not configure the X Window System for RHTS
skipx
#end if

# System timezone
timezone  $getVar('timezone', 'America/New_York')
# Install OS instead of upgrade
install
#if not $getVar('arch', '').startswith('s390')
network --bootproto=dhcp
#end if

$SNIPPET("rhts_partitions")

%packages --resolvedeps --ignoremissing
#if $getVar('rhts_server','') == ''
@ office
@ dialup
@ sound-and-video
@ editors
@ admin-tools
@ printing
@ base-x
@ gnome-desktop
@ graphics
@ games
@ text-internet
@ graphical-internet
@ compat-arch-support
e2fsprogs
lvm2
#end if
$SNIPPET("rhts_packages")

#end if
%pre
$SNIPPET("rhts_pre")

%post
$SNIPPET("rhts_post")