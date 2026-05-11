include scripts/utils.mk

SDKPATH ?= ../er-301

# Determine PROFILE if it's not provided...
# testing | release | debug
PROFILE ?= testing

TOOLCHAIN_FILE ?=
ifneq ($(strip $(TOOLCHAIN_FILE)),)
include $(SDKPATH)/$(TOOLCHAIN_FILE)
endif

# Determine ARCH if it's not provided...
# linux | darwin | am335x
ifndef ARCH
  ifneq ($(BUILDROOT),)
    ARCH = linux
  else
    SYSTEM_NAME := $(shell uname -s)
    ifeq ($(SYSTEM_NAME),Linux)
      ARCH = linux
    else ifeq ($(SYSTEM_NAME),Darwin)
      ARCH = darwin
    else
      $(error Unsupported system $(SYSTEM_NAME))
    endif
  endif
endif


ifeq ($(ARCH),am335x)
  TI_INSTALL_DIR := /root/ti
  include $(SDKPATH)/scripts/am335x.mk
endif

ifeq ($(ARCH),linux)
  CROSS_COMPILE ?= auto
  LINUX_CROSS_CPUFLAGS ?= -mcpu=cortex-a17 -mfloat-abi=hard -mfpu=neon-vfpv4

  ifeq ($(CROSS_COMPILE),auto)
  ifneq ($(BUILDROOT),)
  CROSS_COMPILE := 1
  else
  CROSS_COMPILE := 0
  endif
  endif

  include $(SDKPATH)/scripts/linux.mk
endif

ifeq ($(ARCH),darwin)
  include $(SDKPATH)/scripts/darwin.mk
endif
