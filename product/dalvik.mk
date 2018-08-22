
# Dalvik properties
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=192m \
    dalvik.vm.heapsize=256m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=8m \
    dalvik.vm.image-dex2oat-filter=quicken \
    dalvik.vm.dex2oat-filter=quicken \
    pm.dexopt.first-boot=quicken \
    pm.dexopt.boot=verify \
    pm.dexopt.install=verify \
    pm.dexopt.bg-dexopt=quicken \
    pm.dexopt.ab-ota=quicken \
    pm.dexopt.inactive=verify \
    pm.dexopt.shared=quicken
