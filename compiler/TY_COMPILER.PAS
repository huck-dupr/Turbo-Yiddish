program TY_COMPILER;

uses strUtils,Classes,sysUtils,crt,math;

TYPE
TOKENS = (NUMBER,EOL,KEYWORD,PLS{+},MNS{-},MUL{*},DIVV{/},PWR{^},ROOT{^/},opnprnth{(},clsprnth{)},opnbrace(*{*),clsbrace(*}*),arrsizopn{[},arrsizcls{]},nnot{~},annd{&},nand{~&},orr{|}{,xorr{^}},nor{~|},nxor{~^},eql{=},shftl{<<},shftr{>>},iseql{==},
nteql{<>,><},bgr{>},smlr{<},bgeq{=>,>=},smleq{<=,=<},typ{:},dlr(*$*),att{@},modu{%},iff{?},els{!},chr{'the thing'},str{"the thing"},dot{.},spctab{ ,        },bkslsh{\},none{},swch{#},codechar{for string formating});
token = record
        tok : TOKENS;
        val : widestring;
end;
tokray = array of token;

var
        tokline : array of token;
        isChar : boolean;
        isString : boolean;
        isBkslsh : boolean;
        isComment : boolean;
        strdel : boolean;
        isLComment : boolean;
        first : boolean;
        ty_file : TextFile;
        pas_file : TextFile;
        paspath : ansistring;
        line : widestring;
        a :longword;
        Args : array of widestring;
        i : longword;
        output : tokray ;
const
         path = 'C:\Turbo-Yiddish-master\thing.ty' ;
        //namee = 'thing.txt';
        apostrophe = Char($27);
        quotes = Char($22);
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


procedure lexer(line : widestring);
var i,l,f,s : integer;    lin,strthng : widestring; g,eoa : widechar;previous_line : token ;

begin
lin := UTF8Decode(line);

if notin(unicodechar(';'),lin) then begin
        a:=a+1;
        //writeln(a);
        setlength(Args,a+1);
        args[a] := lin;
        exit;
end;


if a <> 0 then begin lin := args[0]+' '+lin;
        for i := 0 to a do lin := args[i]+' '+lin;  end;

a:=0;
setlength(Args,0);
isComment := isLComment;
for i:=1 to length(lin) do begin
        if (previous_line.val ='*') and (previous_line.tok = none) then previous_line.val :='';
        f := length(output);
        setlength(output,f+2);
        g := lin[i];
        case g of

                '0'..'9':if not isComment then begin  if first then begin
                                previous_line.tok := number; previous_line.val := g; first := false;
                        end
                        else if (previous_line.tok = keyword) or (previous_line.tok = number) then
                                previous_line.val :=previous_line.val+g
                        else begin

                                output[f] := previous_line;
                                previous_line.tok := number;
                                previous_line.val := g;

                        end;

                end;
                ';':if not isComment then begin  if first then begin
                                previous_line.tok := EOL; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok := EOL;
                                previous_line.val := g;
                        end;

                end;
                '+':if not isComment then begin  if first then begin
                                previous_line.tok := Pls; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok := Pls;
                                previous_line.val := g;
                        end;

                end;
                '#':if not isComment then begin  if first then begin
                                previous_line.tok := swch; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok := swch;
                                previous_line.val := g;
                        end;

                end;
                '-':if not isComment then begin  if first then begin
                                output[f] := previous_line;previous_line.tok := Mns; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok := Mns;
                                previous_line.val := g;
                        end;

                end;
                '*':begin
                        if not isComment then
                                if first then begin
                                        previous_line.tok := Mul; previous_line.val := g; first := false;
                                end
                                else if previous_line.tok = divv then begin
                                        previous_line.tok := none;
                                        previous_line.val := '/*';
                                        isLComment := true;
                                        isComment := true;
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok := Mul;
                                        previous_line.val := g;
                                end
                        else  begin
                                previous_line.tok := none;
                                previous_line.val := '*';
                        end;

                end;
                '\':begin
                        if not isComment  then  begin
                                if  (previous_line.tok = Bkslsh) and isBkslsh and (isString or isChar) then begin
                                        isBkslsh := false;
                                        output[f] := previous_line;
                                        previous_line.tok := str;
                                        previous_line.val := '\';
                                        writeln('tehc');
                                end
                                else if (isString or isChar) and not isBkslsh then begin
                                        isBkslsh := true; writeln('stonks');
                                end
                                else if (isString or isChar) and isBkslsh then begin
                                        isBkslsh := false;   writeln('heyyeyeyiyyii');
                                        output[f] := previous_line;
                                        previous_line.tok := bkslsh;
                                        previous_line.val := '';
                                        s := f;
                                        strthng := Reversestring(previous_line.val);
                                        while (output[s].tok <> bkslsh) do begin
                                                strthng := strthng+Reversestring(output[s].val);
                                                output[s].val :=''; output[s].tok :=none;
                                                strdel := false;
                                                s := s-1;
                                        end;
                                        strthng := Reversestring(strthng);
                                        previous_line.tok := codechar;
                                        previous_line.val := strthng;
                                        output[f] := previous_line;
                                        previous_line.tok := bkslsh;
                                        previous_line.val := '';
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok := Bkslsh;
                                        previous_line.val := g;
                                end;
                        end
                        else if (previous_line.tok = none)and((previous_line.val = '\')or (previous_line.val = '*')) then begin
                                previous_line.val :='';isComment:=false;isLComment := false;  end
                        else  begin
                                previous_line.val :='\'; previous_line.tok :=none;   end;

                end;
                '/':if not isComment then begin if previous_line.tok = pwr then begin
                                        output[f-1].tok := Root;
                                        output[f-1].val := '^/';
                                        previous_line.tok := none;
                                        previous_line.val := '';

                        end
                        else if previous_line.tok = Divv then begin
                                        isComment := true;
                                        previous_line.tok := none;
                                        previous_line.val := '';
                        end
                        else
                                if first then begin
                                        previous_line.tok := Divv; previous_line.val := g; first := false;
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok := Divv;
                                        previous_line.val := g;
                                end;

                end;
                '^':if not isComment then begin if previous_line.tok=nnot then begin
                        output[f-1].tok := nxor;
                        output[f-1].val := '~^';
                        previous_line.tok := none;
                        previous_line.val := '';

                end
                else
                                if first then begin
                                        previous_line.tok := pwr; previous_line.val := g; first := false;
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok :=pwr;
                                        previous_line.val := g;
                                        end;


                end;
                '{':if not isComment then begin  if first then begin
                                previous_line.tok := opnbrace; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok := opnbrace;
                                previous_line.val := g;
                        end;

                end;
                '}':if not isComment then begin  if first then begin
                                previous_line.tok := clsbrace; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok := clsbrace;
                                previous_line.val := g;
                        end;

                end;

                '[':if not isComment then begin  if first then begin
                                previous_line.tok := arrsizopn; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=arrsizopn;
                                previous_line.val := g;
                        end;

                end;
                ']':if not isComment then begin  if first then begin
                                previous_line.tok := arrsizcls; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=arrsizcls;
                                previous_line.val := g;
                        end;

                end;
                '(':if not isComment then begin  if first then begin
                                previous_line.tok := opnprnth; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=opnprnth;
                                previous_line.val := g;
                        end;

                end;
                ')':if not isComment then begin  if first then begin
                                previous_line.tok := clsprnth; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=clsprnth;
                                previous_line.val := g;
                        end;

                end;
                '~':if not isComment then begin  if first then begin
                                previous_line.tok := nnot; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=nnot;
                                previous_line.val := g;
                        end;

                end;
                '&':if not isComment then begin if (previous_line.tok=nnot) then begin
                        output[f-1].tok := nand;
                        output[f-1].val := '~&';
                        previous_line.tok := none;
                        previous_line.val := '';

                end
                else
                                if first then begin
                                        previous_line.tok := annd; previous_line.val := g; first := false;
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok :=annd;
                                        previous_line.val := g;
                                        end;


                end;

                '|':begin if not isComment then if previous_line.tok=nnot then begin
                        output[f-1].tok := nor;
                        output[f-1].val := '~|';
                        previous_line.tok := none;
                        previous_line.val := '';

                end
                else  if not isComment then
                                if first then begin
                                        previous_line.tok := orr; previous_line.val := g; first := false;
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok :=orr;
                                        previous_line.val := g;
                                        end;


                end;

                '=': if not isComment then begin if  previous_line.tok=eql then begin
                        output[f-1].tok := iseql;
                        output[f-1].val := '>>';
                        previous_line.tok := iseql;
                        previous_line.val := '';

                end
                else  if (previous_line.tok=bgr) then begin
                        output[f-1].tok := bgeq;
                        output[f-1].val := '>=';
                        previous_line.tok := bgeq;
                        previous_line.val := '';

                end
                else  if (previous_line.tok=smlr) then begin
                        output[f-1].tok := smleq;
                        output[f-1].val := '>=';
                        previous_line.tok := smleq;
                        previous_line.val := '';

                end
                else
                                if first then begin
                                        previous_line.tok := eql; previous_line.val := g; first := false;
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok :=eql;
                                        previous_line.val := g;
                                end;


                end;
                '>':if not isComment then begin if (previous_line.tok=bgr) then begin
                        output[f-1].tok := shftr;
                        output[f-1].val := '>>';
                        previous_line.tok := none;
                        previous_line.val := '';

                end
                else  if (previous_line.tok=smlr) then begin
                        output[f-1].tok := nteql;
                        output[f-1].val := '<>';
                        previous_line.tok := nteql;
                        previous_line.val := '';

                end
                else  if (previous_line.tok=bgr) then begin
                        output[f-1].tok := bgeq;
                        output[f-1].val := '=>';
                        previous_line.tok := bgeq;
                        previous_line.val := '';

                end
                else
                                if first then begin
                                        previous_line.tok := bgr; previous_line.val := g; first := false;
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok :=bgr;
                                        previous_line.val := g;
                                        end;


                end;
                '<': if not isComment then begin if previous_line.tok=smlr then begin
                        output[f-1].tok := shftl;
                        output[f-1].val := '>>';
                        previous_line.tok := none;
                        previous_line.val := '';

                end
                else if previous_line.tok=bgr then begin
                        output[f-1].tok := nteql;
                        output[f-1].val := '><';
                        previous_line.tok := nteql;
                        previous_line.val := '';

                end
                else if previous_line.tok=eql then begin
                        output[f-1].tok := smleq;
                        output[f-1].val := '=<';
                        previous_line.tok := smleq;
                        previous_line.val := '';

                end
                else
                                if first then begin
                                        previous_line.tok := smlr; previous_line.val := g; first := false;
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok :=smlr;
                                        previous_line.val := g;
                                        end;


                end;
                ':': if not isComment then begin  if first then begin
                                previous_line.tok := typ; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=typ;
                                previous_line.val := g;
                        end;

                end;
                '$': if not isComment then begin  if first then begin
                                previous_line.tok := dlr; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=dlr;
                                previous_line.val := g;
                        end;

                end;
                '@': if not isComment then begin  if first then begin
                                previous_line.tok := att; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=att;
                                previous_line.val := g;
                        end;

                end;
                '%': if not isComment then begin  if first then begin
                                previous_line.tok := modu; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=modu;
                                previous_line.val := g;
                        end;

                end;
                '?': if not isComment then begin  if first then begin
                                previous_line.tok := iff; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=iff;
                                previous_line.val := g;
                        end;

                end;
                '!': if not isComment then begin  if first then begin
                                previous_line.tok := els; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=els;
                                previous_line.val := g;
                        end;

                end;

                apostrophe: if not isComment then begin
                        if (isBkslsh and (previous_line.tok=Bkslsh)) or isString then begin
                                output[f] := previous_line;
                                previous_line.val:=apostrophe; //writeln('hey');
                                previous_line.tok:=Chr;
                                isBkslsh := false;                                         end
                        else if isChar and (previous_line.tok= none)and(previous_line.val= g) then begin
                                output[f] := previous_line;  //the parser will deal with empty Chars
                                previous_line.tok := Chr; writeln('hey');
                                isChar := false;

                                previous_line.val := ''; end
                        {else if isChar and isBkslsh then begin
                                previous_line.val := apostrophe;
                                isBkslsh := false;
                        end  }
                        else begin
                                isChar := not isChar;
                                if first then begin
                                        first := false;
                                        previous_line.tok := none;
                                        previous_line.val := g;
                                end
                                else begin
                                        if not isChar then begin
                                                previous_line.tok := chr;
                                                output[f] := previous_line;
                                                previous_line.tok := none;
                                                previous_line.val := g;
                                        end
                                        else begin
                                                previous_line.val :=g;
                                                previous_line.tok := none;
                                        end;
                                end;
                        end;
                end;
                quotes: if not isComment then begin
                    if ((previous_line.tok=bkslsh) and isBkslsh) or isChar then begin
                        output[f] := previous_line;
                        previous_line.val:= g;
                        previous_line.tok:= str;
                        end
                    else begin
                        isString:=not isString;
                        if first then begin
                                 first := false;
                                 previous_line.tok := none;
                                 previous_line.val := quotes;
                        end
                        else begin
                                if not isString then begin   s := f;
                                        strthng := Reversestring(previous_line.val);
                                        while (output[s].tok <> none) and (output[s].val<>quotes) do begin
                                                //if pos(widechar(#$007f),output[s].val)<>0 then strdel := true;
                                                strthng := strthng+Reversestring(output[s].val);
                                                output[s].val :='';output[s].tok :=none;
                                                strdel := false;
                                                s := s-1;
                                        end;
                                        strthng := Reversestring(strthng);
                                        previous_line.tok := str;
                                        previous_line.val := strthng;
                                        output[f] := previous_line;
                                        strthng:= '';
                                        previous_line.tok := none;
                                        previous_line.val := quotes;
                                end
                                else begin
                                        output[f] := previous_line;
                                        previous_line.tok := none;
                                        previous_line.val := quotes;
                                end;
                        end;
                    end;
                end;
                '.': if not isComment then begin  if first then begin
                                previous_line.tok := dot; previous_line.val := g; first := false;
                        end
                        else begin
                                output[f] := previous_line;
                                previous_line.tok :=dot;
                                previous_line.val := g;
                        end;

                end;
                ' ',tab: if not isComment then  if not(previous_line.tok = spctab) then begin

                        if not first then output[f] := previous_line;
                        previous_line.tok := spctab;
                        previous_line.val := g;
                end;

                else if not isComment then begin
                        if first then begin
                                previous_line.tok := keyword; previous_line.val := g; first := false;
                        end
                        else if (previous_line.tok = Bkslsh) and isBkslsh and ((g=lb) or (g=lc)) then begin
                                if g=lb then begin
                                        isBkslsh := false;
                                        output[f] := previous_line;
                                        previous_line.tok := str;
                                        previous_line.val := sLineBreak;
                                end
                                else if previous_line.tok <> Bkslsh then begin
                                        isBkslsh := false;
                                        delete(previous_line.val, length(previous_line.val)-1,1);
                                end
                                else begin
                                        isBkslsh := false;
                                        output[f] := previous_line;
                                        previous_line.tok := spctab;
                                        previous_line.val := widechar(#$007f);
                                end
                        end
                        else if (previous_line.tok = keyword) then begin
                                previous_line.val :=previous_line.val+g
                        end
                        else begin

                                output[f] := previous_line;
                                previous_line.tok := keyword;
                                previous_line.val := g;
                        end;
                end;

       End;
ENd;
isComment := isLComment;
output[f+1] := previous_line;
first := true;


l := 0;
for i:=0 to length(output)-1 do
        if output[i].val <> '' then begin
                setlength(tokline,l+1);
                tokline[l] := output[i];
                l := l+1;
                end;
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
           lexer(line);
       End;

     for i:=0 to length(tokline)-1 do
        writeln(pas_file,tokline[i].val,' ',tokline[i].tok);

     close(ty_file);
     close(pas_file);
     readkey;
end.
