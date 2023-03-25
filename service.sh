#!/system/bin/sh
MODDIR=${0%/*}
MODULE_DIR=$MODDIR/kernel_module
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 3
done

module_list=$(ls $MODULE_DIR)
for module_name in $module_list
do
  insmod $MODULE_DIR/$module_name
done