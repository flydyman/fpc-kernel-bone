#!/bin/sh
TMPISO=iso
TMPBOOT=${TMPISO}/boot
TMPGRUB=${TMPBOOT}/grub
TMPCFG=${TMPGRUB}/grub.cfg
 
mkdir $TMPISO
mkdir $TMPBOOT
mkdir $TMPGRUB
cp kernel.obj $TMPBOOT/kernel.obj
echo 'set timeout=0'                  > $TMPCFG
echo 'set default =0'                >> $TMPCFG
echo ''                              >> $TMPCFG
echo 'menuentry "Pascal bare" {'     >> $TMPCFG
echo '  multiboot /boot/kernel.obj'  >> $TMPCFG
echo '  boot'                        >> $TMPCFG
echo '}'                             >> $TMPCFG
grub-mkrescue --output=pascal-kernel.iso iso
rm -rf $TMPISO
