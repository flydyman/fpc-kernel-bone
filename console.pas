{
/////////////////////////////////////////////////////////
//                                                     //
//               Freepascal barebone OS                //
//                       console.pas                   //
//                                                     //
/////////////////////////////////////////////////////////
//
//      By:             De Deyn Kim <kimdedeyn@skynet.be>
//      License:        Public domain
//
}
 
unit console;
 
interface
 
var
        xpos: Integer = 0;
        ypos: Integer = 0;
 
procedure kclearscreen();
procedure kwritechr(c: Char);
procedure kwritestr(s: PChar);
procedure kwriteint(i: Integer);
procedure kwritedword(i: DWORD);
 
implementation
 
var
        vidmem: PChar = PChar($b8000);
 
procedure kclearscreen(); [public, alias: 'kclearscreen'];
var
        i: Integer;
begin
        for i := 0 to 3999 do
                vidmem[i] := #0;
end;
 
procedure kwritechr(c: Char); [public, alias: 'kwritechr'];
var
        offset: Integer;
begin
        if (ypos > 24) then
                ypos := 0;
 
        if (xpos > 79) then
                xpos := 0;
 
        offset := (xpos shl 1) + (ypos * 160);
        vidmem[offset] := c;
        offset += 1;
        vidmem[offset] := #7;
        offset += 1;
 
        xpos := (offset mod 160);
        ypos := (offset - xpos) div 160;
        xpos := xpos shr 1;
end;
 
procedure kwritestr(s: PChar); [public, alias: 'kwritestr'];
var
        offset, i: Integer;
begin
        if (ypos > 24) then
                ypos := 0;
 
        if (xpos > 79) then
                xpos := 0;
 
        offset := (xpos shl 1) + (ypos * 160);
        i := 0;
 
        while (s[i] <> Char($0)) do
        begin
                vidmem[offset] := s[i];
                offset += 1;
                vidmem[offset] := #7;
                offset += 1;
                i += 1;
        end;
 
        xpos := (offset mod 160);
        ypos := (offset - xpos) div 160;
        xpos := xpos shr 1;
end;
 
procedure kwriteint(i: Integer); [public, alias: 'kwriteint'];
var
        buffer: array [0..11] of Char;
        str: PChar;
        digit: DWORD;
        minus: Boolean;
begin
        str := @buffer[11];
        str^ := #0;
 
        if (i < 0) then
        begin
                digit := -i;
                minus := True;
        end
        else
        begin
                digit := i;
                minus := False;
        end;
 
        repeat
                Dec(str);
                str^ := Char((digit mod 10) + Byte('0'));
                digit := digit div 10;
        until (digit = 0);
 
        if (minus) then
        begin
                Dec(str);
                str^ := '-';
        end;
 
        kwritestr(str);
end;
 
procedure kwritedword(i: DWORD); [public, alias: 'kwritedword'];
var
        buffer: array [0..11] of Char;
        str: PChar;
        digit: DWORD;
begin
        for digit := 0 to 10 do
                buffer[digit] := '0';
 
        str := @buffer[11];
        str^ := #0;
 
        digit := i;
        repeat
                Dec(str);
                str^ := Char((digit mod 10) + Byte('0'));
                digit := digit div 10;
        until (digit = 0);
 
        kwritestr(str);
end;
 
end.
