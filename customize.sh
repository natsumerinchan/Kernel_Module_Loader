SKIPUNZIP=0
MODULES_ARCH=arm64

# Check Device Platform
if [ "$ARCH" != "$MODULES_ARCH" ]; then
    abort "! Unsupport platform: $ARCH"
else
    ui_print "- Device platform: $ARCH"
fi

ui_print "- API Level: $API"

# Check Kernel Version
kernel_version=$(uname -r | awk -F '-' '{print $1}')
case "$kernel_version" in
5.4.*) supported=true ;;
4.19.*) supported=true ;;
*) supported=false ;;
esac

if [ ! $supported ]; then
    abort "! Unsupport Kernel Version: $kernel_version"
else
    ui_print "- Kernel Version: $kernel_version"
fi

# Check Kernel Configs
config_dependencylist="
    CONFIG_MODULES
    CONFIG_KPROBES
    CONFIG_HAVE_KPROBES
    CONFIG_KPROBE_EVENTS
"

config_blocklist="
    CONFIG_LTO
    CONFIG_THINLTO
"

check_dependencylist() {
    ui_print "- Checking Dependencylist Kernel Configs..."
    for config_name in $config_dependencylist
    do
        if [ ! $(zcat /proc/config.gz | grep "$config_name=y") ]; then
            abort "! Your Kernel has not enabled $config_name !"
        else
            ui_print "- $config_name=y"
        fi
    done       
}

check_blocklist() {
    ui_print "- Checking Blocklist Kernel Configs..."
    for config_name in $config_blocklist
    do
        if [ $(zcat /proc/config.gz | grep "$config_name=y") ]; then
            abort "! Your Kernel has not disabled $config_name !"
        else
            ui_print "- $config_name has been disabled."
        fi
    done       
}

check_dependencylist
# check_blocklist