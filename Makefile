# Freepascal BareboneOS 
# Makefile 
# 			2019
# by:		furaidi <iluatitok@gmail.com>
# License:	Public domain

OUTDIR = out
NASMPARAMS = -f elf32 -o $(OUTDIR)/stub.o
LDPARAMS = -melf_i386 --gc-sections -s -Tlinker.script -o kernel.obj
FPCPARAMS = -Pi386 -Tlinux
TMPISO = iso
TMPBOOT = $(TMPISO)/boot
TMPGRUB = $(TMPBOOT)/grub
TMPCFG  = $(TMPGRUB)/grub.cfg
 
objects = $(OUTDIR)/stub.o $(OUTDIR)/kernel.o $(OUTDIR)/multiboot.o $(OUTDIR)/console.o $(OUTDIR)/system.o

 
_FPC:
	echo 'Compile kernel'
	fpc $(FPCPARAMS) kernel.pas
	if [ ! -d "$(OUTDIR)" ]; then mkdir $(OUTDIR); fi;
	mv *.o $(OUTDIR)
	rm *.ppu

_NASM:
	echo 'Compile stub'
	nasm $(NASMPARAMS) stub.asm
 
_LD:
	echo 'Link them together'
	ld $(LDPARAMS) $(objects)
 
all: _FPC _NASM _LD

 
install:
	mkdir $(TMPISO)
	mkdir $(TMPBOOT)
	mkdir $(TMPGRUB)
	cp $(OUTDIR)/kernel.obj $(TMPBOOT)/kernel.obj
	echo 'set timeout=0'     		 > $(TMPCFG)
	echo 'set default =0'		        >> $(TMPCFG)
	echo ''                      		>> $(TMPCFG)
	echo 'menuentry "Pascal Bare" {'	>> $(TMPCFG)
	echo '  multiboot /boot/kernel.obj'  	>> $(TMPCFG)
	echo '  boot'              		>> $(TMPCFG)
	echo '}'                      		>> $(TMPCFG)
	grub-mkrescue --output=pascal-kernel.iso $(TMPISO)
	rm -rf $(TMPISO)

run:
	qemu-system-i386 -kernel kernel.obj

runcd:
	qemu-system-i386 pascal-kernel.iso
 
clean:
	rm -rf $(TMPISO)
	rm -f *.o
	rm -f *.ppu
