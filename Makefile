#arm-none-eabi-gcc -c -mcpu=arm926ej-s -g test.c -o test.o
#arm-none-eabi-as -mcpu=arm926ej-s -g startup.s -o startup.o
#arm-none-eabi-ld -T test.ld test.o startup.o -o test.elf
#arm-none-eabi-objcopy -O binary test.elf test.bin

PROJ_NAME = test

ARM = arm-none-eabi
CC = $(ARM)-gcc
AS = $(ARM)-as
AR = $(ARM)-ar
LD = $(ARM)-ld
OBJ_COPY = $(ARM)-objcopy
SIZE = $(ARM)-size
DUMP = $(ARM)-objdump


SRC_DIR = src
INC_DIR = inc 
USR_DIR = usr

PATH_TO_LIB = Libs/Libraries
CMSIS_INC_DIR = $(PATH_TO_LIB)/CMSIS/Include
LIB_PERIPH_STM = $(PATH_TO_LIB)/STM32F4xx_StdPeriph_Driver/inc
LIB_STM = $(PATH_TO_LIB)/CMSIS/Device/ST/STM32F4xx/Include
UTILS = $(PATH_TO_LIB)/CMSIS/Utilities/STM32F429I-Discovery
UTILS_C = $(PATH_TO_LIB)/CMSIS/Utilities/Common

BUILD_DIR = build

SRC = main.c system_stm32f4xx.c stm32f4xx_gpio.c stm32f4xx_rcc.c stm32f4xx_it.c stm324x9i_eval.c stm32f4xx_adc.c
VPATH += src ./Libs/Libraries/STM32F4xx_StdPeriph_Driver/src
SRC += $(SRC_DIR)/startup_stm32f429_439xx.s
LINKER = $(USR_DIR)/stm32f429zi_flash.ld

CPU = cortex-m4
ARCH = thumb
SPECS = nosys.specs

TARGET = $(PROJ_NAME).elf
CFLAGS = -T $(LINKER) -nostdlib -Wl,--gc-sections -Wl,-Map="$@.map" 
CFLAGS += -mcpu=$(CPU) -m$(ARCH) -march=armv7e-m -mtune=cortex-m4 -mlittle-endian --specs=$(SPECS) -Wall  -ffreestanding
CFLAGS += -I $(INC_DIR) \
					-I $(CMSIS_INC_DIR) \
					-I $(LIB_PERIPH_STM) \
					-I $(LIB_STM)
CFLAGS += -I $(UTILS)
CFLAGS += -I $(UTILS_C)
CFLAGS += -DSTM32F429_439xx
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -DUSE_STM324x9I_EVAL

OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRC))

.PHONY: all

all: $(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRC)
	@echo "Building $@"
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJ_COPY) -O binary $@ $(PROJ_NAME).bin
	$(SIZE) $@

.PHONY: clean flash

clean: 
	rm -rf $(BUILD_DIR)/* $(TARGET) $(PROJ_NAME).bin $(PROJ_NAME).hex  $(PROJ_NAME).map

flash: $(PROJ_NAME).bin
	st-flash write $< 0x8000000


