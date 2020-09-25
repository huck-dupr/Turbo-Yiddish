program TY_COMPILER;

uses strUtils,Classes,sysUtils,crt,math;

TYPE
TOKENS = (NUMBER,EOL,KEYWORD,PLS{+},MNS{-},MUL{*},DIVV{/},PWR{^},ROOT{^/},opnparenthes{(},clsparenthes{)},opnbrace(*{*),clsbrace(*}*),arrsizopn{[},arrsizcls{]},nnot{~},annd{&},nand{~&},orr{|},xorr{#},nor{~|},nxor{~#},eql{=},shftl{<<},shftr{>>},iseql{==},
nteql{<>,><},bgr{>},smlr{<},bgeq{=>,>=},smleq{<=,=<},typ{:},dlr(*$*),att{@},modu{%},iff{?},els{!},chr{'},str{"},dot{.},spctab{ ,        });
token = record
        tok : TOKENS;
        val : widestring;
end;


var
        tokline : array of token;
        first : boolean;
        ty_file : TextFile;
        pas_file : TextFile;
        paspath : ansistring;
        line : widestring;
        a :longword;
        linesArray : array of widestring;
        i : longword;

const
         path = 'C:\Turbo-Yiddish-newlexer\thing.ty' ;
        //namee = 'thing.txt';
        apostophe = Char($27);
        tab = Char($09);
        lt = UnicodeChar(#$05d0);
        lc = UnicodeChar(#$05d1);
        ld = UnicodeChar(#$05d2);
        ls = UnicodeChar(#$05d3);
        lv = UnicodeChar(#$05d4);
        lu = UnicodeChar(#$05d5);
        lz = UnicodeChar(#$05d6);
        lj = UnicodeChar(#$05d7);
        ly = UnicodeChar(#$05d8);
        lh = UnicodeChar(#$05d9);
        ll = UnicodeChar(#$05da);
        lf = UnicodeChar(#$05db);
        lk = UnicodeChar(#$05dc);
        lo = UnicodeChar(#$05dd);
        ln = UnicodeChar(#$05de);
        li = UnicodeChar(#$05df);
        lb = UnicodeChar(#$05e0);
        lx = UnicodeChar(#$05e1);
        lg = UnicodeChar(#$05e2);
        lpx = UnicodeChar(#$05e3);
        lp = UnicodeChar(#$05e4);
        lmx = UnicodeChar(#$05e5);
        lm = UnicodeChar(#$05e6);
        le = UnicodeChar(#$05e7);
        lr = UnicodeChar(#$05e8);
        la = UnicodeChar(#$05e9);
        lyx = UnicodeChar(#$05ea);



        heb_alph : array [0..26] of widechar = (lt,lc,ld,ls,lv,lu,lz,lj,ly,lh,ll,lf,lk,lo,ln,li,lb,lx,lg,lpx,lp,lmx,lm,le,lr,la,lyx);
        heb_alph_name : array [0..26] of string = ('t`','c`','d`','s`','v`','u`','z`','j`','y`','h`','l`','f`','k`','o`','n`','i`','b`','x`','g`','px`','p`','mx`','m`','e`','r`','a`','yx`');
        hb_length = 27;


function notin(const ich : widechar;const arr : array of widechar): boolean;
var e : widechar;
begin
   notin := true;
   for e in arr do
        if e = ich then
                begin notin := false; break; end;
end;

function notin(const ich : widechar;const arr : widestring): boolean;
var e : widechar;
begin
   notin := true;
   for e in arr do
        if e = ich then
                begin notin := false; break; end;
end;




function change_filetype(const org_path,new_path : string): string;
var i,j : integer;lin:string;g:char;
begin
        change_filetype := '';
        for i := 0 to length(org_path) do
		if change_filetype[i] = '.' then  break
                else if i = 0 then  change_filetype :=  org_path[i]
                else change_filetype := change_filetype + org_path[i];
         change_filetype := copy(change_filetype,2,length(change_filetype)) + new_path;

end;



procedure lexer(line : widestring; Args : array of widestring;output : array of token);  //can tokenize, problem with output
var i,l : integer;    lin : widestring; g : widechar;previous_line : token ;

begin
lin := UTF8Decode(line);
if a <> 0 then
        for i := 0 to a do lin := lin+args[i];

if notin(unicodechar(';'),lin) then begin
        a := a +1;
        args[a] := lin;
        exit;
end;
for i:=1 to length(lin) do begin

        g := lin[i];
        case g of
                '0'..'9':begin write('number '); if first then begin
                                previous_line.tok := number; previous_line.val := g; first := false;
                        end
                        else if (previous_line.tok = keyword) or (previous_line.tok = number) then
                                previous_line.val :=previous_line.val+g
                        else begin
                                //output[i] := previous_line;
                                previous_line.tok := number;
                                previous_line.val := g;
                        end;

                end;

                ' ',tab: if not(previous_line.tok = spctab) then begin write('spctab ');
                        //if not first then output[i] := previous_line;
                        previous_line.tok := spctab;
                        previous_line.val := g;
                end;

                else begin write('keyword '); if first then begin
                                previous_line.tok := keyword; previous_line.val := g; first := false;
                        end
                        else if (previous_line.tok = keyword) then
                                previous_line.val :=previous_line.val+g
                        else begin
                                //output[i] := previous_line;
                                previous_line.tok := keyword;
                                previous_line.val := g;
                        end;
                end;
       End;  writeln(previous_line.val,previous_line.tok);
ENd;
END;



begin

     Assign(ty_file,path);
     reset(ty_file);
     assign(pas_file,change_filetype(path,'PAS'));
     rewrite(pas_file);
     a := 0;
     first := true;
     While not EOF(ty_file) do
       Begin
           readln(ty_file,line);
           lexer(line,linesArray,tokline);

       End;
     {if length(tokline) = 1 then}
     {else  for i:=1 to length(tokline) do
        writeln(pas_file,tokline[i].val+' ');}

     close(ty_file);
     close(pas_file);
     readkey;

 end.
