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
ui_print "- Check Kernel Configs..."
config_list="
    CONFIG_MODULES
    CONFIG_KPROBES
    CONFIG_HAVE_KPROBES
    CONFIG_KPROBE_EVENTS
"
for config_name in $config_list
do
  (zcat /proc/config.gz | grep "$config_name=y") || abort "! Your Kernel has not enabled $config_name !"
done