export LD_SHIM_LIBS := \
	/system/lib/libicuuc.so|libicuuc_51.so \
	/system/lib/hw/camera.montblanc.so|libcamera_symbols.so \
	suntrold|libmd5_symbols.so:/system/lib/libril.so|libril_symbols.so
