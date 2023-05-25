#
# Copyright (C) 2666680 Ontario Inc.
#
# SPDX-License-Identifier: GPL-2.0+
#
NAME := GVM User Suite
VERSION := 0.1.0.0

RM_MAJOR ?= 525
RM_MINOR ?= 85
RM_PATCH ?= 07

SDK := sdks/nv$(RM_MAJOR)

# Recursive wildcard function
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

BUILD := build

EXT_SRC := $(call rwildcard,extern/src,*.c)
LIB_SRC := $(call rwildcard,src/lib,*.c) $(call rwildcard,src/lib,*.cpp)
RMAPI_SRC := $(call rwildcard,sdks/nvalloc)
LIB_OBJ := $(LIB_SRC:src/lib/%=$(BUILD)/lib/%.o) $(EXT_SRC:extern/src/%=$(BUILD)/extern/%.o)

EXE_SRC := $(call rwildcard,src/exe,*.cpp)
BINARIES := $(EXE_SRC:src/exe/%.cpp=%)

TEST_SRC := $(call rwildcard,tests,*.cpp)
TEST_BIN := $(TEST_SRC:tests/%.cpp=test-%)

ifndef VERBOSE
.SILENT:
endif

ASM := gcc
CC := gcc
CXX := g++
LD := g++

DEFS := -DRM_VERSION="\"$(RM_MAJOR).$(RM_MINOR).$(RM_PATCH)\""
NVFLAGS := -I $(SDK)/nvidia/inc -I $(SDK)/nvalloc/common/inc -I $(SDK)/nvalloc/unix/include -I $(SDK)/nvml/ -DNVTYPES_USE_STDINT=1
GENFLAGS := -c -g -Og -I inc -I extern/inc -Wall -Wextra -Wno-missing-field-initializers $(DEFS)

ASMFLAGS := $(GENFLAGS)
CFLAGS := $(GENFLAGS) $(NVFLAGS) -std=gnu99
CXXFLAGS := $(GENFLAGS) $(NVFLAGS)
LDFLAGS := -rdynamic -ldl -lnvidia-ml

all: lib
	$(MAKE) execs
	$(info Made all executables)

lib: $(LIB_OBJ)
	$(info Made $(NAME) (lib) version: $(VERSION))

tests: lib $(TEST_BIN)
	$(info Made all tests)

execs: $(BINARIES)

docs:
	doxygen

clean:
	rm -rf build bin docs
	$(info Made clean)

$(BUILD)/extern/%.c.o: extern/src/%.c
	$(info [CC] compiling $?)
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $? -o $@

$(BUILD)/lib/%.S.o: src/lib/%.S
	$(info [ASM] assembling $?)
	mkdir -p $(@D)
	$(ASM) $(ASMFLAGS) $? -o $@

$(BUILD)/lib/%.c.o: src/lib/%.c
	$(info [CC] compiling $?)
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $? -o $@

$(BUILD)/lib/%.cpp.o: src/lib/%.cpp
	$(info [CXX] compiling $?)
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $? -o $@

$(BUILD)/exe/%.c.o: src/exe/%.c
	$(info [CC] compiling $?)
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $? -o $@

$(BUILD)/exe/%.cpp.o: src/exe/%.cpp
	$(info [CXX] compiling $?)
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $? -o $@

$(BUILD)/tests/%.cpp.o: tests/%.cpp
	$(info [CXX] compiling $?)
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $? -o $@

test-%: $(BUILD)/tests/%.cpp.o
	$(info [LD] Linking $@)
	mkdir -p bin
	$(LD) $(LIB_OBJ) $^ $(LDFLAGS) -o bin/$@

%: $(BUILD)/exe/%.cpp.o
	$(info [LD] Linking $@)
	mkdir -p bin
	$(LD) $(LIB_OBJ) $^ $(LDFLAGS) -o bin/$@
