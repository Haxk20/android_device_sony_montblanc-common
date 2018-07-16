LOCAL_PATH := $(call my-dir)
INITSONY := $(PRODUCT_OUT)/utilities/init_sony
MKELF := $(LOCAL_PATH)/boot/mkelf.py

MKELF_ARGS :=
BOARD_KERNEL_NAME := $(strip $(BOARD_KERNEL_NAME))
ifdef BOARD_KERNEL_NAME
   MKELF_ARGS += -n $(BOARD_KERNEL_NAME)
endif

uncompressed_ramdisk := $(PRODUCT_OUT)/ramdisk.cpio
$(uncompressed_ramdisk): $(INSTALLED_RAMDISK_TARGET)
	zcat $< > $@




recovery_uncompressed_ramdisk := $(PRODUCT_OUT)/ramdisk-recovery.cpio
recovery_uncompressed_device_ramdisk := $(PRODUCT_OUT)/ramdisk-recovery-device.cpio
$(recovery_uncompressed_device_ramdisk): $(MKBOOTFS) \
		$(ADBD) \
		$(INTERNAL_RECOVERYIMAGE_FILES) \
		$(recovery_initrc) $(recovery_sepolicy) $(recovery_kernel) \
		$(INSTALLED_2NDBOOTLOADER_TARGET) \
		$(recovery_build_prop) $(recovery_resource_deps) $(recovery_root_deps) \
		$(recovery_fstab) \
		$(RECOVERY_INSTALL_OTA_KEYS) \
		$(INTERNAL_BOOTIMAGE_FILES)
	$(call build-recoveryramdisk)
	@echo "----- Making uncompressed recovery ramdisk ------"
	$(hide) cp $(PRODUCT_OUT)/root/logo.rle $(TARGET_RECOVERY_ROOT_OUT)/
	$(hide) $(MKBOOTFS) $(TARGET_RECOVERY_ROOT_OUT) > $@
	$(hide) rm -f $(recovery_uncompressed_ramdisk)
	$(hide) cp $(recovery_uncompressed_device_ramdisk) $(recovery_uncompressed_ramdisk)

recovery_ramdisk := $(PRODUCT_OUT)/ramdisk-recovery.img
$(recovery_ramdisk): $(MINIGZIP) \
		$(recovery_uncompressed_device_ramdisk)
	@echo "----- Making compressed recovery ramdisk ------"
	$(hide) $(MINIGZIP) < $(recovery_uncompressed_ramdisk) > $@

INSTALLED_BOOTIMAGE_TARGET := $(PRODUCT_OUT)/boot.img
$(INSTALLED_BOOTIMAGE_TARGET): $(PRODUCT_OUT)/kernel \
		$(uncompressed_ramdisk) \
		$(recovery_uncompressed_device_ramdisk) \
		$(INSTALLED_RAMDISK_TARGET) \
		$(INITSONY) \
		$(PRODUCT_OUT)/utilities/toybox \
		$(PRODUCT_OUT)/utilities/keycheck \
		$(MKBOOTIMG) $(MINIGZIP) \
		$(INTERNAL_BOOTIMAGE_FILES)
	@echo "----- Making boot image ------"

	$(hide) rm -rf $(PRODUCT_OUT)/combinedroot
	$(hide) cp -a $(PRODUCT_OUT)/root $(PRODUCT_OUT)/combinedroot
	$(hide) mkdir -p $(PRODUCT_OUT)/combinedroot/sbin

	$(hide) mv $(PRODUCT_OUT)/root/logo.rle $(PRODUCT_OUT)/combinedroot/logo.rle
	$(hide) cp $(recovery_uncompressed_ramdisk) $(PRODUCT_OUT)/combinedroot/sbin/
	$(hide) cp $(PRODUCT_OUT)/utilities/keycheck $(PRODUCT_OUT)/combinedroot/sbin/
	$(hide) cp $(PRODUCT_OUT)/utilities/toybox $(PRODUCT_OUT)/combinedroot/sbin/toybox_init

	$(hide) cp $(INITSONY) $(PRODUCT_OUT)/combinedroot/sbin/init_sony
	$(hide) chmod 755 $(PRODUCT_OUT)/combinedroot/sbin/init_sony
	$(hide) mv $(PRODUCT_OUT)/combinedroot/init $(PRODUCT_OUT)/combinedroot/init.real
	$(hide) ln -s sbin/init_sony $(PRODUCT_OUT)/combinedroot/init

	$(hide) $(MKBOOTFS) $(PRODUCT_OUT)/combinedroot > $(PRODUCT_OUT)/combinedroot.cpio
	$(hide) cat $(PRODUCT_OUT)/combinedroot.cpio | gzip > $(PRODUCT_OUT)/combinedroot.fs
	$(hide) python $(MKELF) $(MKELF_ARGS) -o $(PRODUCT_OUT)/kernel.elf $(PRODUCT_OUT)/kernel@$(BOARD_KERNEL_ADDRESS) $(PRODUCT_OUT)/combinedroot.fs@$(BOARD_RAMDISK_ADDRESS),ramdisk $(LOCAL_PATH)/../$(TARGET_DEVICE)/config/cmdline@cmdline

	$(hide) dd if=$(PRODUCT_OUT)/kernel.elf of=$(PRODUCT_OUT)/kernel.elf.bak bs=1 count=44
	$(hide) printf "\x04" >$(PRODUCT_OUT)/04
	$(hide) cat $(PRODUCT_OUT)/kernel.elf.bak $(PRODUCT_OUT)/04 > $(PRODUCT_OUT)/kernel.elf.bak2
	$(hide) rm -rf $(PRODUCT_OUT)/kernel.elf.bak
	$(hide) dd if=$(PRODUCT_OUT)/kernel.elf of=$(PRODUCT_OUT)/kernel.elf.bak bs=1 skip=45 count=99
	$(hide) cat $(PRODUCT_OUT)/kernel.elf.bak2 $(PRODUCT_OUT)/kernel.elf.bak > $(PRODUCT_OUT)/kernel.elf.bak3
	$(hide) rm -rf $(PRODUCT_OUT)/kernel.elf.bak $(PRODUCT_OUT)/kernel.elf.bak2
	$(hide) cat $(PRODUCT_OUT)/kernel.elf.bak3 $(LOCAL_PATH)/../$(TARGET_DEVICE)/prebuilt/elf.3 > $(PRODUCT_OUT)/kernel.elf.bak
	$(hide) rm -rf $(PRODUCT_OUT)/kernel.elf.bak3
	$(hide) dd if=$(PRODUCT_OUT)/kernel.elf of=$(PRODUCT_OUT)/kernel.elf.bak2 bs=16 skip=79
	$(hide) cat $(PRODUCT_OUT)/kernel.elf.bak $(PRODUCT_OUT)/kernel.elf.bak2 > $(PRODUCT_OUT)/kernel.elf.bak3
	$(hide) rm -rf $(PRODUCT_OUT)/kernel.elf.bak $(PRODUCT_OUT)/kernel.elf.bak2 $(PRODUCT_OUT)/kernel.elf $(PRODUCT_OUT)/04
	$(hide) mv $(PRODUCT_OUT)/kernel.elf.bak3 $(PRODUCT_OUT)/boot.img
	$(call pretty,"Made boot image: $@")

INSTALLED_RECOVERYIMAGE_TARGET := $(PRODUCT_OUT)/recovery.img
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
		$(recovery_ramdisk) \
		$(recovery_kernel)
	@echo "----- Making recovery image ------"
	$(hide) python $(MKELF) -o $(PRODUCT_OUT)/recovery.elf $(PRODUCT_OUT)/kernel@$(BOARD_KERNEL_ADDRESS) $(PRODUCT_OUT)/ramdisk-recovery.img@$(BOARD_RAMDISK_ADDRESS),ramdisk $(LOCAL_PATH)/../$(TARGET_DEVICE)/config/cmdline@cmdline

	$(hide) dd if=$(PRODUCT_OUT)/recovery.elf of=$(PRODUCT_OUT)/recovery.elf.bak bs=1 count=44
	$(hide) printf "\x04" >$(PRODUCT_OUT)/_04
	$(hide) cat $(PRODUCT_OUT)/recovery.elf.bak $(PRODUCT_OUT)/_04 > $(PRODUCT_OUT)/recovery.elf.bak2
	$(hide) rm -rf $(PRODUCT_OUT)/recovery.elf.bak
	$(hide) dd if=$(PRODUCT_OUT)/recovery.elf of=$(PRODUCT_OUT)/recovery.elf.bak bs=1 skip=45 count=99
	$(hide) cat $(PRODUCT_OUT)/recovery.elf.bak2 $(PRODUCT_OUT)/recovery.elf.bak > $(PRODUCT_OUT)/recovery.elf.bak3
	$(hide) rm -rf $(PRODUCT_OUT)/recovery.elf.bak $(PRODUCT_OUT)/recovery.elf.bak2
	$(hide) cat $(PRODUCT_OUT)/recovery.elf.bak3 $(LOCAL_PATH)/../$(TARGET_DEVICE)/prebuilt/elf.3 > $(PRODUCT_OUT)/recovery.elf.bak
	$(hide) rm -rf $(PRODUCT_OUT)/recovery.elf.bak3
	$(hide) dd if=$(PRODUCT_OUT)/recovery.elf of=$(PRODUCT_OUT)/recovery.elf.bak2 bs=16 skip=79
	$(hide) cat $(PRODUCT_OUT)/recovery.elf.bak $(PRODUCT_OUT)/recovery.elf.bak2 > $(PRODUCT_OUT)/recovery.elf.bak3
	$(hide) rm -rf $(PRODUCT_OUT)/recovery.elf.bak $(PRODUCT_OUT)/recovery.elf.bak2 $(PRODUCT_OUT)/recovery.elf $(PRODUCT_OUT)/_04
	$(hide) mv $(PRODUCT_OUT)/recovery.elf.bak3 $(PRODUCT_OUT)/recovery.img
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE))
	$(call pretty,"Made recovery image: $@")
