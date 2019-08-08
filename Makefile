# Freepascal BareboneOS 
# Makefile 
# 			2019
# by:		furaidi <iluatitok@gmail.com>
# License:	Public domain
 
NASMPARAMS = -f elf32 -o stub.o
LDPARAMS = -A elf-i386 --gc-sections -s -Tlinker.script -o kernel.obj
TMPISO = iso
TMPBOOT = $(TMPISO)/boot
TMPGRUB = $(TMPBOOT)/grub
TMPCFG  = $(TMPGRUB)/grub.cfg
 
objects = stub.o kernel.o multiboot.o console.o system.o
 
_FPC:
	# Compile kernel
	fpc $(FPCPARAMS) kernel.pas 
 
_NASM:
	# Compile stub
	nasm $(NASMPARAMS) stub.asm
 
_LD:
	# Link them together
	ld $(LDPARAMS) $(objects)
 
all: _FPC _NASM _LD
 
install:
	mkdir $(TMPISO)
	mkdir $(TMPBOOT)
	mkdir $(TMPGRUB)
	cp kernel.obj $(TMPBOOT)/kernel.obj
	echo 'set timeout=0'     		 > $(TMPCFG)
	echo 'set default =0'		        >> $(TMPCFG)
	echo ''                      		>> $(TMPCFG)
	echo 'menuentry "Pascal Bare" {'	>> $(TMPCFG)
	echo '  multiboot /boot/kernel.obj'  	>> $(TMPCFG)
	echo '  boot'              		>> $(TMPCFG)
	echo '}'                      		>> $(TMPCFG)
	grub-mkrescue --output=pascal-kernel.iso $(TMPISO)
	rm -rf $(TMPISO)
 
clean:
	rm -rf $(TMPISO)
	rm -f *.o
	rm -f *.ppu
