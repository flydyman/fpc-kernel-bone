{
/////////////////////////////////////////////////////////
//                                                     //
//               Freepascal barebone OS                //
//                      kernel.pas                     //
//                                                     //
/////////////////////////////////////////////////////////
//
//      By:             De Deyn Kim <kimdedeyn@skynet.be>
//      License:        Public domain
//
}
 
unit kernel;
 
interface
 
uses
        multiboot,
        console;
 
procedure kmain(mbinfo: Pmultiboot_info_t; mbmagic: DWORD); stdcall;
 
implementation
 
procedure kmain(mbinfo: Pmultiboot_info_t; mbmagic: DWORD); stdcall; [public, alias: 'kmain'];
begin
        kclearscreen();
        kwritestr('Freepascal barebone OS booted!');
        xpos := 0;
        ypos += 1;
 
        if (mbmagic <> MULTIBOOT_BOOTLOADER_MAGIC) then
        begin
                kwritestr('Halting system, a multiboot-compliant boot loader needed!');
                asm
                        cli
                        hlt
                end;
        end
        else
        begin
                kwritestr('Booted by a multiboot-compliant boot loader!');
                xpos := 0;
                ypos += 2;
                kwritestr('Multiboot information:');
                xpos := 0;
                ypos += 2;
                kwritestr('                       Lower memory  = ');
                kwriteint(mbinfo^.mem_lower);
                kwritestr('KB');
                xpos := 0;
                ypos += 1;
                kwritestr('                       Higher memory = ');
                kwriteint(mbinfo^.mem_upper);
                kwritestr('KB');
                xpos := 0;
                ypos += 1;
                kwritestr('                       Total memory  = ');
                kwriteint(((mbinfo^.mem_upper + 1000) div 1024) +1);
                kwritestr('MB');
        end;
 
        //asm
        //        @loop:
        //        jmp @loop
        //end;
end;
 
end.
end.
