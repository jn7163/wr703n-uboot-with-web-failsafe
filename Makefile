
export BUILD_TOPDIR=$(PWD)
MAKECMD=make ARCH=mips CROSS_COMPILE=mips-openwrt-linux-uclibc-
export PATH:=$(BUILD_TOPDIR)/toolchain/OpenWrt-Toolchain-ar71xx-for-mips_r2-gcc-4.6-linaro_uClibc-0.9.33/toolchain-mips_r2_gcc-4.6-linaro_uClibc-0.9.33/bin/:$(PATH)
export STAGING_DIR=$(BUILD_TOPDIR)/tmp
export FLASH_SIZE=4
export COMPRESSED_UBOOT=1
export MAX_UBOOT_SIZE=130048 #size 0x1fc00


all: decompress_toolchain uboot
	@echo tuboot.bin size: `wc -c < $(BUILD_TOPDIR)/bin/tuboot.bin`
	@if [ "`wc -c < $(BUILD_TOPDIR)/bin/tuboot.bin`" -gt "$(MAX_UBOOT_SIZE)" ]; then \
			echo "####################ERROR####################" \
            echo "tuboot.bin image size more than $(MAX_UBOOT_SIZE)"; \
    fi;


decompress_toolchain:
	make -C $(BUILD_TOPDIR)/toolchain/


uboot:
	cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) tl-wr703n_config
	cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) ENDIANNESS=-EB V=1 all
	cp $(BUILD_TOPDIR)/u-boot/tuboot.bin $(BUILD_TOPDIR)/bin


clean:
	cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) clean
	rm -f $(BUILD_TOPDIR)/bin/*
	

clean_all:
	cd $(BUILD_TOPDIR)/u-boot/ && $(MAKECMD) distclean
	rm -f $(BUILD_TOPDIR)/bin/*
	make -C $(BUILD_TOPDIR)/toolchain/ clean

