program TY_COMPILER;

uses strUtils,Classes,sysUtils,crt;

TYPE
TOKENS = (NUMBER,EOL,KEYWORD,PLS{+},MNS{-},MUL{*},DIVV{/},PWR{^},ROOT{^/},opnparenthes{(},clsparenthes{)},opnbrace(*{*),clsbrace(*}*),arrsizopn{[},arrsizcls{]},nnot{~},annd{&},nand{~&},orr{|},xorr{#},nor{~|},nxor{~|},eql{=},shftl{<<}shftr{>>},iseql{==,<,>
,typ{:},dlr(*$*),att{@},modu{%},iff{?},els{!},chr{'},str{"},dot{.});
token = record
        tok : TOKENS;
        val : string;
end;
state = record//for what was in the line befor
        tok : TOKENS;
        string_of_what_was : string;
end;

var
        tokline : array of token;
        ty_file : TextFile;
        pas_file : TextFile;
        paspath : ansistring;
        line : string;
        linesArray : array of string;
        i : longword;

const
         path = 'C:/Turbo-Yiddish-lexer/thing.ty' ;
        //namee = 'thing.txt';
        apostophe = Chr($27);
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
        lq = UnicodeChar(#$fb2e);
        lw = UnicodeChar(#$fb2f);
        lcx = UnicodeChar(#$fb4c);
        lfx = UnicodeChar(#$fb4d);
        lpxx = UnicodeChar(#$fb4e);


        heb_alph : array [0..31] of widechar = (lt,lc,ld,ls,lv,lu,lz,lj,ly,lh,ll,lf,lk,lo,ln,li,lb,lx,lg,lpx,lp,lmx,lm,le,lr,la,lyx,lq,lw,lcx,lfx,lpxx);
        heb_alph_name : array [0..31] of string = ('lt','lc','ld','ls','lv','lu','lz','lj','ly','lh','ll','lf','lk','lo','ln','li','lb','lx','lg','lpx','lp','lmx','lm','le','lr','la','lyx','lq','lw','lcx','lfx','lpxx');
        hb_length = 32;


function notin(const ich : widechar;const arr : array of widechar): boolean;
var e : widechar;
begin
   notin := true;
   for e in arr do
        if e = ich then
                begin notin := false; break; end;
end;

function notin(const ich : char;const arr : string): boolean;
var e : widechar;
begin
   notin := true;
   for e in arr do
        if e = ich then
                begin notin := false; break; end;
end;



Function replace(const wdstr : widestring):string;
        var j,i,e : integer; t : ansistring;
        begin
                t := '';
                j := length(wdstr);

                for i := 1 to j do begin

                                for e:=0 to hb_length-1 do
                                         if wdstr[i] = heb_alph[e] then
                                                //appendstr(replace,replace+heb_alph_name[t]);
                                                t := t+heb_alph_name[e];

                                if  notin(widechar(wdstr[i]),heb_alph)  then
                                                //appendstr(replace,ansistring(wdstr[i]));
                                                t := t+ansistring(wdstr[i]) ;
                                end;
                                Replace := t;

 end;

function change_filetype(const org_path,new_path : ansistring): ansistring;
var i : integer;
begin
	change_filetype := org_path;
	for i := length(change_filetype)-1 to 0 do
		if not (change_filetype[i] = '.') then
			change_filetype[i] := char('')
		else
			break;
	change_filetype := change_filetype + new_path;
end;



procedure lexer(const line : string; Args : array of string;output : array of token);
var i,j,l : integer;    lin : string; g : char;first_line : Boolean;previous_line : state ;

begin
j := 0;
first_line := true;
lin := line;

END;




begin

     Assign(ty_file,path);
     reset(ty_file);
     assign(pas_file,change_filetype(path,'PAS'));
     rewrite(pas_file);
     While not EOF(ty_file) do
       Begin
           readln(ty_file,line);
           line := replace(line);
           lexer(line,linesArray,tokline);

       End;
     if length(linesArray) <> 0 then
     for i:=0 to length(linesArray) do begin
         write(' ',tokline[i].tok,' ',tokline[i].val,' ');
     end;
     close(ty_file);
     readkey;

 end.
