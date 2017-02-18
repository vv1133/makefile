# Makefile for C/C++ GNU/linux Program   
# Make Target:   
# ------------   
# The Makefile provides the following targets to make:   
#   $ make           build elf and lib
#   $ make elf       compile and link elf
#   $ make lib       compile and create libraries files(.a)
#   $ make clean     clean objects and the executable file 
#   $ make help      get the usage of the makefile
#   
#===========================================================================   

ARCH=pc

ifeq ($(ARCH), pc)
CC            = gcc
AR            = ar
else ifeq ($(ARCH), arm)
CC            = arm-linux-gcc
AR            = arm-linux-ar
endif

################################ config ################################ 
OUT_DIR = ./output

# lib
ARFLAGS = -rcs
LIB_INCLUDE_DIR =  . ./src ./include
LIB_CFLAGS = -DFUN -g -O2
TARGET_LIB = libfun.a

# elf
LIB_DIR = ./src
LD_LIBS  = -lfun
LD_FLAGS = -g -O2
ELF_INCLUDE_DIR =  . ./include
ELF_CFLAGS = -DTEST -g -O2
TARGET_ELF = test.elf

LIB_COBJS = src/fun.o
ELF_COBJS = test.o
########################################################################

RM = rm -f

TARGET = $(TARGET_LIB) $(TARGET_ELF)
LIB_INCLUDE_CMPL_DIR =$(addprefix -I , $(LIB_INCLUDE_DIR))
LIB_CFLAGS += $(LIB_INCLUDE_CMPL_DIR)
ELF_INCLUDE_CMPL_DIR =$(addprefix -I , $(ELF_INCLUDE_DIR))
ELF_CFLAGS += $(ELF_INCLUDE_CMPL_DIR)
LD_FLAGS = $(LD_LIBS) $(LD_INCLUDE_DIR)
LD_INCLUDE_DIR   =$(addprefix -L , $(LIB_DIR) $(OUT_DIR))

LIB_DEPS = $(subst .o,.d,$(LIB_COBJS))
ELF_DEPS = $(subst .o,.d,$(ELF_COBJS))

# Rules for generating the executable.   
#-------------------------------------   
.PHONY : all clean
all: $(TARGET)
	@echo $(TARGET)

elf: $(TARGET_ELF)
	@echo
	@-ls -l $(OUT_DIR)/* | awk '{ print $$9 ":\t" $$5 }'

lib: $(TARGET_LIB)
	@echo
	@-ls -l $(OUT_DIR)/* | awk '{ print $$9 ":\t" $$5 }'

$(TARGET_ELF): $(ELF_COBJS)
	@echo "[Generate elf...]"
	$(CC) -o $@ $^ $(LD_FLAGS) 
	@mv $@ $(OUT_DIR)/

$(TARGET_LIB): $(LIB_COBJS)
	@echo "[Generate lib...]"
	@$(AR) $(ARFLAGS) $@ $^
	@mv $@ $(OUT_DIR)/


ifeq ($(MAKECMDGOALS),clean)
NOTINCLUDE=true
endif
ifeq ($(MAKECMDGOALS),help)
NOTINCLUDE=true
endif
ifneq ($(NOTINCLUDE),true)
-include $(LIB_DEPS) $(ELF_DEPS)
endif

$(LIB_DEPS):%.d:%.c
	@echo [dep $@]
	@$(CC) $(LIB_CFLAGS) -M $< > $@.$$$$;\
	sed 's,\(.*\)\.o[ :]*,$(shell dirname $@)/\1.o $@ : ,g' <$@.$$$$ > $@;\
	$(RM) $@.$$$$

$(ELF_DEPS):%.d:%.c
	@echo [dep $@]
	@$(CC) $(ELF_CFLAGS) -M $< > $@.$$$$;\
	sed 's,\(.*\)\.o[ :]*,$(shell dirname $@)/\1.o $@ : ,g' <$@.$$$$ > $@;\
	$(RM) $@.$$$$

$(LIB_COBJS):%.o:%.c
	@echo [$(CC) compiling $@]
	$(CC) $(LIB_CFLAGS) -c $< -o $@

$(ELF_COBJS):%.o:%.c
	@echo [$(CC) compiling $@]
	$(CC) $(ELF_CFLAGS) -c $< -o $@

clean:   
	@-$(RM) $(LIB_DEPS) $(ELF_DEPS) $(LIB_COBJS) $(ELF_COBJS) $(OUT_DIR)/$(TARGET_ELF) $(OUT_DIR)/$(TARGET_LIB)
	@echo "[clean done]"
  
# Show help.   
help:
	@echo 'Generic Makefile for C/C++ Programs (GNU/linux makefile) version 0.1'  
	@echo 'Copyright (C) 2017'  
	@echo   
	@echo 'Usage: make [TARGET]'  
	@echo 'TARGETS:'  
	@echo '  elf       compile and create elf files(.elf)'
	@echo '  lib       compile and create all libraries files(.a)'
	@echo '  clean     clean all objects and the executable file.'  
	@echo '  help      print this message.'  
	@echo   
	@echo 'Report bugs to <zhengdi05@gmail.com>.'  

