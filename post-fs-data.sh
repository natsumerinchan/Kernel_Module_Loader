#!/system/bin/sh
MODDIR=${0%/*}
MODULE_DIR=$MODDIR/kernel_module

[ -f "$MODDIR/insmod_old.log" ] && rm "$MODDIR/insmod_old.log"
[ -f "$MODDIR/insmod.log" ] && mv "$MODDIR/insmod.log" "$MODDIR/insmod_old.log"

for module_path in $MODULE_DIR/*.ko; do
    [ -f "$module_path" ] || continue
    
    # 获取文件名用于日志显示
    module_name=$(basename "$module_path")
    
    # 加载模块，并实时记录日志
    echo "Loading $module_name ..." | tee -a "$MODDIR/insmod.log"
    insmod "$module_path" 2>&1 | tee -a "$MODDIR/insmod.log"
    
    # 检查加载是否成功
    if [ $? -eq 0 ]; then
        echo "Success: $module_name" | tee -a "$MODDIR/insmod.log"
    else
        echo "FAILED: $module_name (see dmesg for details)" | tee -a "$MODDIR/insmod.log"
    fi
done
