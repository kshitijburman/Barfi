#	compiler params
# use -g to genrate debug symbol
CC = gcc
CF = -Wall -O  -fstrength-reduce -fomit-frame-pointer -fno-stack-protector -finline-functions -nostdinc -fno-builtin -m32  -I./src/include -c

#linker params
LNK = ld
LNKF = -m elf_i386 -s 

#mkisofs
MK = mkisofs
MKF = -no-emul-boot -boot-load-size 4 -boot-info-table -N -J -r -c _$$ -hide-joliet _$$ -hide _$$ 


C_SOURCES = $(shell find src -type f -iname '*.c')
C_OBJECTS = $(foreach x,$(basename $(C_SOURCES)),$(x).o)

ASM_SOURCES = $(shell find src -type f -iname '*.asm')
ASM_OBJECTS = $(foreach x,$(basename $(ASM_SOURCES)),$(x).o)

all: cleanall runiso

MyOS.iso: kernel.bin 
	$(MK) -o MyOS.iso -b isolinux/isolinux.bin $(MKF) ./bin
	

kernel.bin: $(C_OBJECTS) $(ASM_OBJECTS)
	$(LNK) $(LNKF) -Tlinker.ld -o bin/kernel.bin  $(C_OBJECTS) $(ASM_OBJECTS)
	
%.o:%.c
	$(CC) $(CF) -o $@  $<
	
%.o:%.asm
	nasm -felf $< -o $@
	
cleanall:
	rm -f $(C_OBJECTS) $(ASM_OBJECTS)  bin/kernel.bin
	rm -f MyOS.iso

cleanobj:
	rm -f $(C_OBJECTS) $(ASM_OBJECTS)

runkernel: kernel.bin
	qemu-system-i386 -m 16 -kernel bin/kernel.bin
	
runmonitor:MyOS.iso
	qemu-system-i386 -m 20 -monitor stdio   --cdrom $<
runiso: MyOS.iso
	# use -S -gdb tcp::1234 for debug it will wait for connection
	qemu-system-i386 -m 20   --cdrom $<
	#bochs -f ./bochs/bochsrc
