unit functionsFM;

//20180703 Added GetRunningAplications

interface

uses system.classes, strutils, system.Types, system.SysUtils, system.Math,
     System.NetEncoding, System.UIConsts, IdURI,FMX.Dialogs,IOUtils,System.UITypes,
     {$IFDEF MSWINDOWS}
    winapi.windows,Winapi.ShellAPI, Winapi.TlHelp32,
    {$ENDIF MSWINDOWS}
    {$IFDEF ANDROID}
  FMX.Helpers.Android, Androidapi.JNI.GraphicsContentViewText, FMX.Platform,
  Androidapi.JNI.Net, Androidapi.JNI.JavaTypes,Androidapi.Helpers,
{$ELSE}
{$IFDEF IOS}
  iOSapi.Foundation, FMX.Helpers.iOS ,
{$ENDIF IOS}
{$ENDIF ANDROID}
     IdIPWatch;

type TDigitSet = set of '0'..'9';

const REALSIS_ENCRYPT='AABCBBCD';

function sBreakApart(BaseString, BreakString: string; StringList:TStringList):TStringList;
procedure sBreakinValues(OriginalString,SeparatorString: string; var a,b,c,d,e,f,g,h,i,j,k: string);
procedure sBreakinValues_abcd(OriginalString,SeparatorString: string; var a,b,c,d: string);
function GetStrInsidePlicas( str: string): string;
function GetStrBeforeChar( str,beforestr: string): string;
function GetStrAfterChar( str,afterstr: string): string;
function RealsisEncryptDecrypt(str: string): string;
function LastPos(substr, s:string): integer;
function GetValidInt(str: string; default: integer): integer;
function IsStrANumber(NumStr : string) : boolean;
function isValidFloat(str: string):boolean;
//Removes plicas to use in SQL
function GetValidSQLWord(value: string): string;   overload;
function GetValidSQLWord(value: string; maxchars:integer): string; overload;
function GetCharCount(str: string; chr: char): integer;
function GetInsideParentesis( str: string): string;
function GetInsideParentesis2( str: string): string;
function GetInsideParentesis_as_is( str: string): string;
function GetInsideChavetas2( str: string): string;
procedure GetListInsideAspas( str: string; lista:Tstringlist);
function GetInsideAspas( str: string): string;
function GetFirstChar(str: string; ignorechar: char): char;
function GetFirstCommand(str: string):string;
function GetSecondCommand(str: string):string;
function getinsidetag(str: string):string;
procedure getinsidexmltag(str: string; lista:Tstringlist);
function ExtractFloat(str: string):double;
function color2num(color: string): integer;
function Encode64(value: string): string;
function Decode64(value: string): string;
function GetFunctionName( str: string): string;
function LocalIp: string;
 {$IFDEF MSWINDOWS}
function GetHDDSerial(drive:string): string;
 {$ENDIF MSWINDOWS}
function RemoveEscapeChars(phrase: string):string;
//Removes plicas to use in SQL
procedure NameApelido(fullname: string; var name,middle,apelido: string);
function ChartoBool(boolchar: string):boolean;
function ChartoBoolatPos(boolchar: string; pos: integer):boolean;
function GetinsideAB(str, A, B: string): string;
 {$IFDEF MSWINDOWS}
procedure GetRunningAplications(Applist: TStringlist);
{$ENDIF}
// URLEncode is performed on the URL
// so you need to format it   protocol://path
function OpenURL(const URL: string; const DisplayError: Boolean = False): Boolean;
function GetValidBool(str: string): boolean;
procedure LogWrite(logfile: string; phrase: string);
//Algumas traduções
function GetMonthPT(mes: integer; Short: boolean):string;
function GetWeekdayPT(weekday: integer; Short: boolean):string;
function FastPos(search,wholestring: string):integer;
function GetValidAlphaColor(value: string):TAlphaColor;
function BooltoString(boolvalue: boolean): string; //Devolver '1' ou '0' em string
//Agora relacionado com a nossa API DXK
function DKXStringtoList(DKXString: string; Linhas: TStrings): integer;
function DKXLinetoWords(DXKLine: string; Words: TStrings): integer;
function GetOSLangID: String;

implementation

function FastPos(search,wholestring: string):integer;
var i,j,slen,wlen,equals:integer;
begin
    slen:=length(search);
    wlen:=length(wholestring);
    result:=0; //Default
    for i := 1 to wlen do
     begin
      if wholestring[i]=search[1] then
       begin
        equals:=1;
        for j := 2 to slen do
         if (i+j-1)<=wlen then
          if wholestring[i+j-1]=search[j] then equals:=equals+1;
        if equals=slen then
         begin
          result:=i;
          break;
         end;
       end;

     end;

end;

//Nova versão com suporte widestring
function sBreakApart(BaseString, BreakString: string; StringList: TStringList):TStringList;
var EndOfCurrentString: integer;
    TempStr: string;
begin
     StringList.Clear;
     repeat
       EndOfCurrentString := Pos(BreakString, BaseString);
       if EndOfCurrentString = 0 then
         StringList.add(BaseString)
       else
         //StringList.add(Copy(BaseString,1,EndOfCurrentString - 1));
         StringList.add(Copy(BaseString,1,EndOfCurrentString - 1));
       BaseString:= Copy(BaseString,EndOfCurrentString +
                    length(BreakString),length(BaseString) -
                    EndOfCurrentString);
     until EndOfCurrentString = 0;
     result:=StringList;
end;

//Divide em partes e retorna nas variáveis as separações obtidas
procedure sBreakinValues(OriginalString,SeparatorString: string; var a,b,c,d,e,f,g,h,i,j,k: string);
var StringList: TStringList;
begin
    StringList:=TStringList.Create;
    sbreakapart( OriginalString,SeparatorString,StringList);
    if StringList.Count>0 then a:=StringList[0];
    if StringList.Count>1 then b:=StringList[1];
    if StringList.Count>2 then c:=StringList[2];
    if StringList.Count>3 then d:=StringList[3];
    if StringList.Count>4 then e:=StringList[4];
    if StringList.Count>5 then f:=StringList[5];
    if StringList.Count>6 then g:=StringList[6];
    if StringList.Count>7 then h:=StringList[7];
    if StringList.Count>8 then i:=StringList[8];
    if StringList.Count>9 then j:=StringList[9];
    if StringList.Count>10 then k:=StringList[10];
    StringList.Free;
end;

procedure sBreakinValues_abcd(OriginalString,SeparatorString: string; var a,b,c,d: string);
var StringList: TStringList;
begin
    StringList:=TStringList.Create;
    sbreakapart( OriginalString,SeparatorString,StringList);
    if StringList.Count>0 then a:=StringList[0];
    if StringList.Count>1 then b:=StringList[1];
    if StringList.Count>2 then c:=StringList[2];
    if StringList.Count>3 then d:=StringList[3];
    StringList.Free;
end;

//function sBreakApart(BaseString, BreakString: string; StringList: TStringList):TStringList;
//var EndOfCurrentString: byte;
//    TempStr: string;
//begin
//     StringList.Clear;
//     repeat
//       EndOfCurrentString := FastPos(BreakString, BaseString);
//       if EndOfCurrentString = 0 then
//         StringList.add(BaseString)
//       else
//         //StringList.add(Copy(BaseString,1,EndOfCurrentString - 1));
//         StringList.add(Copy(BaseString,1,EndOfCurrentString - 1));
//       BaseString:= Copy(BaseString,EndOfCurrentString +
//                    length(BreakString),length(BaseString) -
//                    EndOfCurrentString);
//     until EndOfCurrentString = 0;
//     result:=StringList;
//end;

function GetStrInsidePlicas( str: string): string;
var i, j: integer;
begin
    i:=pos('''',str);
    j:=lastpos('''',str);
    result:=MidStr(str,i+1,j-i-1);
end;

function GetStrBeforeChar( str,beforestr: string): string;
var i: integer;
begin
    if pos(beforestr,str)>0 then
     begin
      i:=pos(beforestr,str)-1;
      result:=LeftStr(str,i);
     end
    else
     result:='';
end;

function GetStrAfterChar( str,afterstr: string): string;
var i: integer;
begin
    if pos(afterstr,str)>0 then
     begin
      i:=length(str)-pos(afterstr,str)+1;
      result:=RightStr(str,i-length(afterstr));
     end
    else
     result:='';
end;

function RealsisEncryptDecrypt(str: string): string;
var w,i: integer;
    key, res: string;
begin
        w:=length(str);
        //Agora vai construir uma chave de encryptacao
        //fazendo a mesma crescer até ter o tamanho certo
        key:=REALSIS_ENCRYPT;
        while length(key)<w do
         key:=key+REALSIS_ENCRYPT;
        key:=copy(key,1,w);
        //Agora faz a encryptacao
        res:=str;
        for i:=1 to w do
         begin
          res[i]:=chr(ord(res[i]) xor (ord(key[i])-65));
         end;
        result:=res;
end;

function LastPos(substr, s:string): integer;
var ss: string;
begin
        substr:=reverseString(substr);
        s:=reverseString(s);
        result:=length(s)-pos(substr,s)+1;
end;

function GetValidInt(str: string; default: integer): integer;
begin
    if IsStrANumber(str) then result:=strtoint(str) else result:=default;
end;

function IsStrANumber(NumStr : string) : boolean;
var i: integer;
    isok: boolean;
begin
    isOk:=True;
    if length(NumStr)<1 then isok:=False;
    {$IFDEF ANDROID}
    //for i:=0 to length(NumStr)-1 do
    for i:=1 to length(NumStr) do //Já foi corrigido no delphi
    {$ELSE}
    for i:=1 to length(NumStr) do
    {$ENDIF}
     begin
      if not (NumStr[i] in ['0'..'9','.',',','-']) then isok:=False;
     end;

    result:=isOk;
end;

function isValidFloat(str: string):boolean;
var s: string;
    validdigits: TDigitSet;
    commacount,i: integer;
    erro: boolean;
begin
    validdigits:= ['0','1','2','3','4','5','6','7','8','9'];
    commacount:=0;
    erro:=false;
    str:=trim(str);

    if length(str)>0 then
     for i := 1 to length(str) do
      begin
       if not ((str[i] in validdigits)or (str[i]='.')or(str[i]=',')) then
        begin erro:=true; break; end;
       if (str[i]='.')or(str[i]=',') then commacount:=commacount+1;
       if commacount>1 then break;
      end
     else
      erro:=true;

     if (erro=false) and (commacount<=1)  then
      result:=true
     else
      result:=False;

end;

function GetValidSQLWord(value: string): string;
begin
  result:=stringreplace(value,
               '''','''''',[rfReplaceAll]);
end;

function GetValidSQLWord(value: string; maxchars:integer): string;
var s: string;
    c: integer;
begin
  s:=MidStr(stringreplace(value,
               '''','''''',[rfReplaceAll]),1,maxchars);
  //O corte abrupto pode originar de novo número impar de plicas
  c:=GetCharCount(s,'''');
  if odd(c) then
   s:=MidStr(s,1,maxchars-1);

  result:=s;
end;

function GetCharCount(str: string; chr: char): integer;
var i: integer;
begin
      i:=0;
      while pos(chr,str)>0 do
         begin
          inc(i);
          str[pos(chr, str)]:=' ';
         end;
      result:=i;
end;

function GetInsideParentesis( str: string): string;
var a: integer;
    b, c: integer;
    s: string;
begin
    s:='';
    b:=pos('(',str);
    c:=pos(')',str);
    if (c>b) and (b*c>0) then
    for a:=b+1 to c-1 do
     begin
      s:=s+str[a];
     end;
    result:=uppercase(s);
end;

// Entre o primeiro e o último  (  )
function GetInsideParentesis2( str: string): string;
var a: integer;
    b, c: integer;
    s: string;
begin
    s:='';
    b:=pos('(',str);
    c:=lastpos(')',str);
    if (c>b) and (b*c>0) then
    for a:=b+1 to c-1 do
     begin
      s:=s+str[a];
     end;
    result:=uppercase(s);
end;

function GetInsideParentesis_as_is( str: string): string;
var a: integer;
    b, c: integer;
    s: string;
begin
    s:='';
    b:=pos('(',str);
    c:=pos(')',str);
    if (c>b) and (b*c>0) then
    for a:=b+1 to c-1 do
     begin
      s:=s+str[a];
     end;
    result:=s;
end;

// Entre o primeiro e o último
function GetInsideChavetas2( str: string): string;
var a: integer;
    b, c: integer;
    s: string;
begin
    s:='';
    b:=pos('{',str);
    c:=lastpos('}',str);
    if (c>b) and (b*c>0) then
    for a:=b+1 to c-1 do
     begin
      s:=s+str[a];
     end;
    result:=s;
end;

procedure GetListInsideAspas( str: string; lista:Tstringlist);
var a: integer;
    active: boolean;
    s: string;
begin

        active:=false;
        for a:=1 to length(str) do
         begin

            if active then
              begin
               if str[a]='"' then begin lista.Add(s); active:=false; end;
               if str[a]<>'"' then s:=s+str[a];
              end
            else
              begin
               if str[a]='"' then begin active:=true; s:=''; end;
              end;


         end;

end;

function GetInsideAspas( str: string): string;
var i, j: integer;
begin
    i:=pos('"',str);
    j:=lastpos('"',str);
    result:=MidStr(str,i+1,j-i-1);
end;

//Vai buscar o primeiro caractere da string ignorando por exemplo os espaços
function GetFirstChar(str: string; ignorechar: char): char;
var i,len: integer;
    found: boolean;
begin
    len:=length(str);
    result:=chr(0);
    if len=0 then exit;


    found:=false;
    i:=1;

    repeat
     if str[i]<>ignorechar then
      begin
        found:=true;
        result:=str[i];
      end;
     i:=i+1;
    until found or (i>(len-1));
end;

//Vai buscar a primeira palavra depois dos espaços(ou tab #9), em maiúsculas
function GetFirstCommand(str: string):string;
var i,len: integer;
    found, inside: boolean;
    command: string;
begin
    i:=1;
    len:=length(str);
    result:='';

    if len=0 then exit;


    found:=false;
    inside:=false;
    command:='';
    repeat
     if (str[i]<>' ') and (str[i]<>#9) then begin found:=true; inside:=true; end;
     if found then
      if str[i]=' ' then inside:=false;
     if found and inside then command:=command+str[i];

     i:=i+1;
    until (found and not inside) or (i>(len));

    if found then result:=uppercase(command);
end;

//Vai buscar a segunda palavra depois dos espaços e depois da primeira, em maiúsculas
function GetSecondCommand(str: string):string;
var command: string;
begin
   command:=GetFirstCommand(str);
   str:=stringreplace(str,command,'',[rfIgnoreCase]);
   result:=GetFirstCommand(str);
end;

//Vai buscar o que está dentro de <ABC/DEF/GHIK> --->  ABC/DEF/GHIK
function getinsidetag(str: string):string;
var a,b: integer;
    s: string;
begin
  a:=pos('<',str);
  b:=pos('>',str);
  s:=midstr(str,a+1,b-a-1);
  result:=s;
end;

//Vai buscar uma coisa do género <ABC/DEF/GHIK>
procedure getinsidexmltag(str: string; lista:Tstringlist);
var a,b: integer;
    s: string;
begin

  a:=pos('<',str);
  b:=pos('>',str);
  s:=midstr(str,a+1,b-a-1);
  sbreakapart(s,'/',lista);

end;

function ExtractFloat(str: string):double;
var i,a: integer;
    r,d,dcount: integer;
    tot: integer;
    comma: boolean;
    validdigits: TDigitSet;
begin
validdigits:= ['0','1','2','3','4','5','6','7','8','9'];

        a:=1;
        r:=0;
        d:=0;
        dcount:=0;
        comma:=False;
        str:=trim(str);
        if length(str)>0 then
        while ((str[a] in validdigits)or (str[a]='.')or(str[a]=',')) do
         begin
          if ((str[a]=',')or(str[a]='.')) then begin
                                    if comma then break;
                                    comma:=True;
                                   end
          else begin
                if not comma then
                 r:=r*10+strtoint(str[a])
                else begin
                      d:=d*10+strtoint(str[a]);
                      inc(dcount);
                     end;
               end;
          inc(a);
          if a>length(str) then break;
         end;

        result:=r+d/power(10,dcount);

end;

function color2num(color: string): integer;
begin
  result:=$000000; //Black
  color:=uppercase(color);
  if color='BLACK' then result:=$000000;
  if color='WHITE' then result:=$FFFFFF;
  if color='BLUE' then result:=$0000FF;
  if color='RED' then result:=$FF0000;
  if color='GREEN' then result:=$00FF00;
  if color='YELLOW' then result:=$FFFF00;
  if color='PINK' then result:=$FF38CD;
  if color='GRAY' then result:=$A0A0A0;
  if color='CYAN' then result:=$00FFEE;
  if color='ORANGE' then result:=$FFAE00;
  if color='PURPLE' then result:=$9000FF;

  if pos('$',color)>0 then result:=StringToAlphaColor (color);



end;

function Encode64(value: string): string;
begin
  result:=TNetEncoding.Base64.Encode(value);
end;

function Decode64(value: string): string;
begin
  result:=TNetEncoding.Base64.Decode(value);
end;

function GetFunctionName( str: string): string;
var a,b: integer;
    s: string;
begin
    s:='';
    if pos('(',str)>0 then
    if length(str)>0 then
     begin
      b:=pos('(',str);
      dec(b);
      while((str[b]=' ') and (b>0) ) do dec(b);
      while((str[b]<>' ') and (b>0) ) do begin s:=str[b]+s; dec(b); end;
     end;
    result:=uppercase(s);
end;

function LocalIp: string;
var IPW: TIdIPWatch;
begin
  Result := '127.0.0.1';
  IpW := TIdIPWatch.Create(nil);
  try
    if IpW.LocalIP <> '' then
      Result := IpW.LocalIP;
  finally
    FreeAndNil(IPW); //No novo mobile compiler
  end;
end;

 {$IFDEF MSWINDOWS}
function GetHDDSerial(drive:string): string;
var
  VolumeName,
  FileSystemName     : array [0..MAX_PATH-1] of Char;
  VolumeSerialNo,  MaxComponentLength , FileSystemFlags : DWord;
begin
  GetVolumeInformation(pchar(drive+':\'),VolumeName,MAX_PATH,@VolumeSerialNo,
                       MaxComponentLength,FileSystemFlags,
                       FileSystemName,MAX_PATH);
  result:=IntToHex(VolumeSerialNo,8);


end;
 {$ENDIF MSWINDOWS}

 function RemoveEscapeChars(phrase: string):string;
 var i: integer;
     res: string;
 begin
     res:='';
     for i := 1 to length(phrase) do
       begin
         if ord(phrase[i])>=32 then
          res:=res+phrase[i];
       end;
     result:=res;
 end;



//Vai dividir o nome completo em nome, meio e apelido
procedure NameApelido(fullname: string; var name,middle,apelido: string);
var lista: TStringList;
    i: integer;
begin
    name:='';
    middle:='';
    apelido:='';
    lista:=TStringlist.Create;
    sbreakapart(fullname,' ',lista);
    if lista.Count>=1 then name:=lista[0];
    if lista.Count>=2 then apelido:=lista[lista.Count-1];
    if lista.Count>=3 then name:=name+' '+lista[1];
    if lista.Count>=4 then middle:=lista[2];
    if lista.Count>=5 then
     for i := 3 to lista.Count-2 do
      begin
       middle:=middle+' '+lista[i];
      end;
    FreeAndNil(lista); //No novo mobile compiler
end;

//Converte 0 ou 1 em boolean
function ChartoBool(boolchar: string):boolean;
begin
   result:=false;
   if length(boolchar)>0 then
    begin
     if boolchar[1]='0' then result:=false;
     if boolchar[1]='1' then result:=true;
    end;
end;

//Converte 0 ou 1 em boolean a partir de uma string 01101....
//pos=1 é o primeiro elemento da string
function ChartoBoolatPos(boolchar: string; pos: integer):boolean;
begin
   result:=false;
   if length(boolchar)>=(pos) then
    begin
     if boolchar[pos]='1' then result:=true;
    end;
end;

//The sames as above but returns only the first
function GetinsideAB(str, A, B: string): string;
var i, j: integer;
begin
    i:=pos(A,str);
    j:=lastpos(B,str);
    result:=MidStr(str,i+length(A),j-i-length(B)-length(A)+1);
end;

 {$IFDEF MSWINDOWS}
procedure GetRunningAplications(Applist: TStringlist);
var
  PE: TProcessEntry32;
  Snap: THandle;
  fName: String;
begin
  pe.dwsize:=sizeof(PE);
  Snap:= CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap <> 0 then
  begin
    if Process32First(Snap, PE) then
    begin
      fName := String(PE.szExeFile);
      Applist.Add(fName);
      while Process32Next(Snap, PE) do
      begin
        fName := String(PE.szExeFile);
        Applist.Add(fName);
      end;
    end;
    CloseHandle(Snap);
  end;
end;
{$ENDIF}

function OpenURL(const URL: string; const DisplayError: Boolean = False): Boolean;
{$IFDEF ANDROID}
var
  Intent: JIntent;
begin
// There may be an issue with the geo: prefix and URLEncode.
// will need to research
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
    TJnet_Uri.JavaClass.parse(StringToJString(TIdURI.URLEncode(URL))));
  try
    SharedActivity.startActivity(Intent);
    exit(true);
  except
    on e: Exception do
    begin
      if DisplayError then ShowMessage('Error: ' + e.Message);
      exit(false);
    end;
  end;
end;
{$ELSE}
{$IFDEF IOS}
var
  NSU: NSUrl;
begin
  // iOS doesn't like spaces, so URL encode is important.
  NSU := StrToNSUrl(TIdURI.URLEncode(URL));
  if SharedApplication.canOpenURL(NSU) then
    exit(SharedApplication.openUrl(NSU))
  else
  begin
    if DisplayError then
      ShowMessage('Error: Opening "' + URL + '" not supported.');
    exit(false);
  end;
end;
{$ELSE}
begin
  raise Exception.Create('Not supported!');
end;
{$ENDIF IOS}
{$ENDIF ANDROID}

function GetValidBool(str: string): boolean;
begin
   if (uppercase(str)='S')
   or (uppercase(str)='SIM')
   or (uppercase(str)='Y')
   or (uppercase(str)='YES')
   or (uppercase(str)='T')
   or (uppercase(str)='TRUE')
   or (uppercase(str)='1')
   then  result:=true
   else result:=False;

end;

procedure LogWrite(logfile: string; phrase: string);
begin
// if not fileexists(logfile) then
//   TFile.CreateText(logfile);
//   TFile.AppendAllText(logfile, phrase);
   TFile.AppendAllText(logfile, phrase,TEncoding.ANSI) ;
end;

function GetMonthPT(mes: integer; Short: boolean):string;
begin
  if short then
  case mes of
   1: result:='Jan';
   2: result:='Fev';
   3: result:='Mar';
   4: result:='Abr';
   5: result:='Mai';
   6: result:='Jun';
   7: result:='Jul';
   8: result:='Ago';
   9: result:='Set';
   10: result:='Out';
   11: result:='Nov';
   12: result:='Dez';
  end
  else
  case mes of
   1: result:='Janeiro';
   2: result:='Fevereiro';
   3: result:='Março';
   4: result:='Abril';
   5: result:='Maio';
   6: result:='Junho';
   7: result:='Julho';
   8: result:='Agosto';
   9: result:='Setembro';
   10: result:='Outubro';
   11: result:='Novembro';
   12: result:='Dezembro';
  end;
end;

//Monday=1
function GetWeekdayPT(weekday: integer; Short: boolean):string;
begin
  if short then
   case weekday of
    0: result:='Dom';
    1: result:='Seg';
    2: result:='Ter';
    3: result:='Qua';
    4: result:='Qui';
    5: result:='Sex';
    6: result:='Sáb';
    7: result:='Dom';
   end
  else
  case weekday of
    0: result:='Domingo';
    1: result:='Segunda';
    2: result:='Terça';
    3: result:='Quarta';
    4: result:='Quinta';
    5: result:='Sexta';
    6: result:='Sábado';
    7: result:='Domingo';
   end
end;

function GetValidAlphaColor(value: string):TAlphaColor;
var x : word;
    k : integer;
begin
  value:=uppercase(value);
  if pos('$',value)=1 then
   begin
    Val(value, x, k);
    result:=x;
   end
  else if pos('RED',value)>0 then result:=$FFFF0000
  else if pos('GREEN',value)>0 then result:=$FF00FF00
  else if pos('BLUE',value)>0 then result:=$FF0000FF
  else if pos('WHITE',value)>0 then result:=$FFFFFFFF
  else if pos('BLACK',value)>0 then result:=$FF000000
  else if pos('YELLOW',value)>0 then result:=$FFFFFF00
  else if pos('CYAN',value)>0 then result:=$FF00FFFF
  else if pos('GRAY',value)>0 then result:=$FF808080
  else if pos('LIGHTGRAY',value)>0 then result:=$FFCCCCCC
  else if pos('ORANGE',value)>0 then result:=$FFFF5900
  else if pos('PURPLE',value)>0 then result:=$FF66097B
  else if pos('PINK',value)>0 then result:=$FFFF00C7
  else result:=$FFFFFFFF;


end;

function BooltoString(boolvalue: boolean): string;
begin
  if boolvalue then result:='1' else result:='0';

end;

// <!B>FIELD1<!>FIELD2<!>FIELD3<!E>
// <!B>Field1Value<!>Field2Value<!>Field3Value<!E>
// <!B>Field1Value<!>Field2Value<!>Field3Value<!E>
// .....
//Converte para linhas e devolve número de linhas
function DKXStringtoList(DKXString: string; Linhas: TStrings): integer;
var a,b,howmany,offset: integer;
    found:boolean;
begin
   howmany:=0;
   offset:=1;
   found:=true;
   while found do
    begin
     a:=pos('<!B>',DKXString,offset);
     b:=pos('<!E>',DKXString,offset+1);
     if (b>a) and (a>0) then
      begin
       Linhas.Add(MidStr(DKXstring,a+4,b-a-4));
       offset:=b+1;
       found:=true;
       howmany:=howmany+1;
      end
     else found:=false;


    end;
    result:=howmany;
end;


// Field1Value<!>Field2Value<!>Field3Value
//Converte para palavras e devolve número de palavras
function DKXLinetoWords(DXKLine: string; Words: TStrings): integer;
var a,b,howmany,offset: integer;
    found:boolean;
begin
    howmany:=0;
   offset:=1;
   found:=true;
   while found do
    begin
     a:=pos('<!>',DXKLine,offset);
     if (a>2) then
      begin
       Words.Add(MidStr(DXKLine,1,a-1));
       offset:=a+1;
       found:=true;
       howmany:=howmany+1;
      end
     else
      begin
       found:=false;
       Words.Add(MidStr(DXKLine,offset+2,length(DXKLine)));
       howmany:=howmany+1;
      end;
    end;
    result:=howmany;
end;

function GetOSLangID: String;
{$IFDEF MACOS} var
  Languages: NSArray;
begin
  Languages := TNSLocale.OCClass.preferredLanguages;
  Result := TNSString.Wrap(Languages.objectAtIndex(0)).UTF8String;
  {$ENDIF}
  {$IFDEF ANDROID} var
    LocServ: IFMXLocaleService;
  begin
    if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService,
      IInterface(LocServ)) then
      Result := LocServ.GetCurrentLangID; {$ENDIF}
  {$IFDEF MSWINDOWS} var
      buffer: MarshaledString;
      UserLCID: LCID;
      BufLen: Integer;
    begin // defaults
      UserLCID := GetUserDefaultLCID;
      BufLen := GetLocaleInfo(UserLCID, LOCALE_SISO639LANGNAME, nil, 0);
      buffer := StrAlloc(BufLen);
      if GetLocaleInfo(UserLCID, LOCALE_SISO639LANGNAME, buffer, BufLen) <> 0
      then
        Result := buffer
      else
        Result := 'en';
      StrDispose(buffer);
    {$ENDIF}
  end; { code }

end.
