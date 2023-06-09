#!/system/bin/sh
MODDIR=${0%/*}
MODULE_DIR=$MODDIR/kernel_module
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 3
done

module_list=$(ls $MODULE_DIR | grep .ko)
test -e $MODDIR/insmod_old.log || rm $MODDIR/insmod_old.log
test -e $MODDIR/insmod.log || mv $MODDIR/insmod.log $MODDIR/insmod_old.log
for module_name in $module_list
do
  insmod $MODULE_DIR/$module_name 2>&1 | tee -a $MODDIR/insmod.log
done
