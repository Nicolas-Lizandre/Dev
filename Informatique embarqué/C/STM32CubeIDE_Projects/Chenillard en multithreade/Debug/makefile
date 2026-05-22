################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Drivers/STM32L4xx_HAL_Driver/Src/subdir.mk
-include Core/Startup/subdir.mk
-include Core/Src/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

OPTIONAL_TOOL_DEPS := \
$(wildcard ../makefile.defs) \
$(wildcard ../makefile.init) \
$(wildcard ../makefile.targets) \


BUILD_ARTIFACT_NAME := MC - TP3 - Chenillard en multithreade
BUILD_ARTIFACT_EXTENSION := elf
BUILD_ARTIFACT_PREFIX :=
BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.elf \

MAP_FILES += \
MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.map \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.list \


# All Target
all: main-build

# Main-build Target
main-build: MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.elf secondary-outputs

# Tool invocations
MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.elf MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.map: $(OBJS) $(USER_OBJS) C:\Users\nicol\OneDrive\Bureau\ENSEA\MC\ -\ TP3\ -\ Chenillard\ en\ multithreade\STM32L476RGTX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-gcc -o "MC - TP3 - Chenillard en multithreade.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m4 -T"C:\Users\nicol\OneDrive\Bureau\ENSEA\MC - TP3 - Chenillard en multithreade\STM32L476RGTX_FLASH.ld" --specs=nosys.specs -Wl,-Map="MC - TP3 - Chenillard en multithreade.map" -Wl,--gc-sections -static --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "MC - TP3 - Chenillard en multithreade.list"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.elf MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.list MC\ -\ TP3\ -\ Chenillard\ en\ multithreade.map MC\\ -\\ TP3\\ -\\ Chenillard\\ en\\ multithreade.elf default.size.stdout
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST)

fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

.PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

-include ../makefile.targets
