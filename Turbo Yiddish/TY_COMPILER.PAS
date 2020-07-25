program TY_COMPILER;

uses Sysutils,crt;

var
        fille : TextFile;
        line : widestring;
        fil : widestring;

const
         path = 'C:\Program Files (x86)\Turbo Yiddish\thing.txt' ;
        //namee = 'thing.txt';

        lt = UnicodeChar(#$05d0);
        lc = UnicodeChar(#$05d1);
        ld = UnicodeChar(#$05d3);
        ls = UnicodeChar(#$05d4);
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
        heb_alph_name : array [0..31] of string = ('lt`','lc`','ld`','ls`','lv`','lu`','lz`','lj`','ly`','lh`','ll`','lf`','lk`','lo`','ln`','li`','lb`','lx`','lg`','lpx`','lp`','lmx`','lm`','le`','lr`','la`','lyx`','lq`','lw`','lcx`','lfx`','lpxx`');
        hb_length = 32;


function inn(const ich : widechar;const arr : array of widechar): boolean;
var e : widechar;
begin
   inn := false;
   for e in arr do
        if e = ich then
                begin inn := true; break; end;
end;


procedure reverse(wdstr : widestring);
        var i,j : integer;  strwd : widestring;
        begin
                j := length(wdstr);
                setlength(strwd, j);
                for i := 1 to j do
                        strwd[i] := wdstr[j-i+1];
        end;


function replace(wdstr : widestring):ansistring;
        var j,i : integer; t : integer;
        begin

                j := length(wdstr);

                for i := 1 to j do
                                for t:=0 to hb_length-1 do
                                        begin
                                         if wdstr[i] = heb_alph[t] then
                                                appendstr(replace,replace+heb_alph_name[t]); end;
                                if  not inn(widechar(wdstr[i]),heb_alph)  then
                                                appendstr(replace,ansistring(wdstr[i]));


 end;
//function comp(wdstr : widestring) : string;


begin

     Assign(fille,path);
     reset(fille);
     readln(fille, line);
     writeln(replace(line));
     close(fille);
     readkey;

 end.
