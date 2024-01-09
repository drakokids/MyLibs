unit functions;

//****** FUNCTION UNIT
// 14-12-2014 - Changes to work with Lazarus
// 08-12-2013 - Updated to XE5
// 04-08-2012 - Merge Functions from other units
// 04-08-2012 - string2color also accepts hexadecimal color rgb

interface

{$IFDEF DCC}
uses classes,vcl.grids,windows,SysUtils,vcl.Dialogs, vcl.forms, vcl.FileCtrl,ShellAPI,
StrUtils, math,registry,ShlOBJ,vcl.Graphics,Winsock,vcl.Controls,DateUtils, system.IOUtils,
Vcl.Imaging.jpeg,vcl.ExtCtrls,IdBaseComponent,  IdComponent, IdTCPConnection, IdTCPClient,
 IdHTTP, TLHelp32, IdFTP,IdGlobal,URLMon ;
{$ENDIF}
{$IFDEF FPC}
{$mode delphi}
uses classes,grids,windows,SysUtils,Dialogs, forms, FileCtrl,ShellAPI,
     StrUtils, math,registry,ShlOBJ,Graphics,Winsock,Controls,DateUtils,
     ExtCtrls;
{$ENDIF}

type TDigitSet = set of '0'..'9';

type TWinVersion = (wvUnknown, wvWin95, wvWin98, wvWin98SE, wvWinNT, wvWinME,
                    wvWin2000, wvWinXP, wvWinVista, wvWinSeven, wvWinEight) ;

type
TByteArray=array[0..0] of byte;
PByteArray=^TByteArray;

const REALSIS_ENCRYPT='AABCBBCD';
const
 HexOfNum: array[0..15] of char=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

var DEBUGMODE: boolean=true;
    LOGFILENAME: string='';
    LOGLINESCOUNT: integer=0;//Conta o nº de linhas que vai escrevendo
    LastDebugTime: TDateTime;

function GetHDDSerial(drive:string): string;
function sBreakApart(BaseString, BreakString: string; StringList:
                       TStringList):TStringList;
function sBreakSpecial(BaseString, BreakString: string; StringList:
                       TStringList):TStringList;
procedure LoadLista(Lines: TStrings; DivideChar: char; Grelha: TStringGrid);

function WinExecAndWait32(FileName:String; Visibility : integer):integer;
function ExecApp(AppName, Params: string): Boolean;
function ExecAppWait(AppName, Params: string): Boolean;
{$IFDEF DCC} function ExecAppWaitHidden(AppName, Params: string): Boolean; {$ENDIF}
procedure GetRunningAplications(Applist: TStringlist);
function AppisRunning(appname: string):boolean;
function KillTask(ExeFileName: string): Integer;
function RunAsAdmin(hWnd: hWnd; filename: string; Parameters: string; Visible: Boolean = true): Boolean;
function IsAppRespondigNT(wnd: HWND): Boolean;

procedure LogWrite(s: string);
procedure LogWriteCustom(customlogfilename,s: string);
procedure DebugWrite( s: string);
procedure TestLogFile;
procedure PLog( s: string);
function ApagaFile( filename: string): boolean;
function CopiaFile( filename, tofilename: string): boolean;
function removefileext(FileName:String): string;
function IsStrANumber(NumStr : string) : bool;
function GetFirstFree(var F: array of boolean; max: integer): integer;
function GetFirstFree1(var F: array of boolean; max: integer): integer;
function ExtractNumber(str: string):integer;
function isValidFloat(str: string):boolean;
function ExtractFloat(str: string):double;
function IncrementNumber(var str: string): string;
function GetValidInt(str: string; default: integer): integer;
function GetValidInt64(str: string; default: integer): int64;
function GetValidBool(str: string): boolean;
function str2ascii( str: string): string;
function strreplaceignoreinside( str, replace, by, ignoreinside: string): string;
procedure GetAllinsideAB(str, A, B: string; StringList:TStringList);
function LastPos(substr, s:string): integer;
function GetinsideAB(str, A, B: string): string;
function StrRemoveFirst( str: string; n: integer): string;
function GetFunctionName( str: string): string;
function GetInsideParentesis( str: string): string;
function GetInsideParentesisRetos( str: string): string;
function GetInsideParentesis2( str: string): string;
function GetInsideChavetas2( str: string): string;
procedure GetListInsideAspas( str: string; lista:Tstringlist);
function GetInsideAspas( str: string): string;
function GetCharCount(str: string; chr: char): integer;
function GetStrInsidePlicas( str: string): string;
function GetStrBeforeChar( str,beforestr: string): string;
function GetStrAfterChar( str,afterstr: string): string;
function GetStrAfterLastChar( str,afterstr: string): string;
function RealsisEncryptDecrypt(str: string): string;
function isdigit(ch : AnsiChar) : Boolean;
function islower(ch : AnsiChar) : Boolean;
function isupper(ch : AnsiChar) : boolean;
procedure GetAllFiles(resultlist:TStrings; dir,filter: string);
procedure GetAllFileValues(resultlist,displaylist: TStrings;dir,filter: string;
                           usekey: boolean;key: string);
procedure EmptyDir(dir: string);
function StrOccurences(part,original: string): integer;
function mysqldouble(n: double): string;
function Push(var Lista: Tstringlist; str: string):integer;
procedure Pop(Lista: Tstringlist; var str: string);
procedure Fifo(Lista: Tstringlist; var str: string);
{$IFDEF DCC}   function DelphiIsRunning: boolean;    {$ENDIF}
function GetRegistryValue(key,variable: string): string;
procedure WriteRegistryValue(key,variable, value: string);
function DGetTempFileName (const Folder, Prefix : string) : string;
function GetNetUser : Ansistring;
procedure AddtoDocMenu(fName: string);
function extractUnixFilename(unixfilename: string):string;
function PosR(substr, str: string): integer;
function Color2String(cor: TColor): string;
function string2color(value: string): TColor;
function BrushStyle2String(value: TBrushStyle): string;
function String2BrushStyle(value: string): TBrushStyle;
function float2money(value: double; decimals: integer;symbol: string): string;
function Date2YYYYMMDD(data: TDateTime): string;
function DiaMesAno2Date(data: string): TDateTime;
function AnoMesDia2Date(data: string): TDateTime;
procedure SplitPostalCode(completepostalcode: string; var number,city: string);
function RemoveSpaces(str: string): string;
function GetIPFromHost(var HostName, IPaddr, WSAErr: string): Boolean;

procedure EnableAllControls(AParent: TWinControl; const AEnabled: Boolean);
function ListToComas(lista: TStrings): string;
function ListToAny(lista: TStrings; anyseparator: string): string;
function CreateValidFilename(originalName: string): string;
function CRC16str(InString: String): string;
function CRC16Anviz(data: string): string;
procedure Delay(MSec: Cardinal);
function Get_File_Size2(sFileToExamine: string): integer;
//Conta quantos vezes a palavra aWord no texto ATExt
function CountWords(aText, aWord: string): integer;
function GetTempDirectory: String;
function GetSpecialDirectory(alias: string): string;
//Creates a valid name without strange chars from the sugested one
function CreateValidVarName(sugestedname: string): string;

function FormatByteSize(const bytes: Longint): string;
function FormatByteSize64(const bytes: int64): string;
function FileSize(fileName : wideString) : Int64;
{$IFDEF DCC} function MemoryUsed: cardinal;  {$ENDIF}
function GetTotalMemory: int64;
function GetFreeMemory: int64;

function GetFirstChar(str: string; ignorechar: char): char;
function GetFirstCommand(str: string):string;
function GetSecondCommand(str: string):string;
function getinsidetag(str: string):string;
procedure getinsidexmltag(str: string; lista:Tstringlist);
function color2num(color: string): integer;
function color2RGBHex(color: integer): string;

{$IFDEF DCC}
procedure DownloadJPG(url:string;Bitmap: TBitmap);
function DownloadFile(url:string):UTF8String;
function DownloadToFile(url,Filename:string):boolean;
function NewDownloadFile(SourceFile, DestFile: string): Boolean;
{$ENDIF}

//Removes plicas to use in SQL
function GetValidSQLWord(value: string): string;   overload;
function GetValidSQLWord(value: string; maxchars:integer): string; overload;


function GetTotalWithoutVat(Quantity,ItemUnitPriceEuros,DiscountEuros: extended):extended;
function GetTotalWithVat(Quantity,ItemUnitPriceEuros,DiscountEuros,Vat: extended):extended;
function GetTotalofVat(Quantity,ItemUnitPriceEuros,DiscountEuros,Vat: extended):extended;
function GetDiscounPercentage(TotalAmmount,DiscountEuros: extended): extended;

//Date and Time Utils
function DiadaSemana(data: TDateTime): string;
function Mes(data: TDateTime): string;
function Mes_3(data: TDateTime): string;
function MinutesBetweenDate(start,stop: TDateTime) : int64;
function SecondsBetweenDate(start,stop: TDateTime) : int64;
function FirstDayofMonth(Date: TDateTime): TDateTime;
function LastDayofMonth(Date: TDateTime): TDateTime;
function Time2StrHM(time: TTime): string; // ->HH:MM
function StrHM2Time(Strtime: string): TTime;  // HH:MM->
function AddMinutes(time: TTime; minutes: integer): TTime;
function MinutesInside(strTime1,strTime2: string): integer; //HH:MM -> minutes
function Minutes2StrHM(minutes: integer): string; // ->HH:NN
function Minutes2StrHour(minutes: integer): string; // ->8.2
function MinutesOfTime(time: TDateTime): integer; //ex: 03:16 -> 3*60 + 16

//Wide functions
function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
function StringToWideString(const s: AnsiString; codePage: Word): WideString;

function NumOfHex(c: Char): integer;
function encodedata(const BinData; size: integer): string;
function decodedata(const s: string): string;
procedure WriteWideStringToStream(aString: widestring; aStream: tstream);
procedure ReadWideStringFromStream(var aString: widestring; aStream: tStream);
procedure WriteWideString(const ws: WideString; stream: TStream);
function ReadWideString(stream: TStream): WideString;

procedure NameApelido(fullname: string; var name,middle,apelido: string);
function GetWinVersion: TWinVersion;
function winVersiontoString(  WinVersion: TWinVersion ): string;
function RemoveEscapeChars(phrase: string):string;
{$IFDEF DCC} function GetFolderDialog(parent: TFOrm;TheTitle,defaultFolder,language: string): string;   {$ENDIF}
{$IFDEF DCC}  function StrMaxLen(const S: string; MaxLen: integer): string; {$ENDIF}

function removeLeadingZeros(const Value: string): string;
function GetIndexStartingWith(Lista: TStrings; StartText: string):integer;

procedure SortTStrings(Strings:TStrings);
function BestFit(const AInput: AnsiString): AnsiString;

function ChartoBool(boolchar: string):boolean; // '1'/'0' 'V'/'F'  'Y'/'N' to True/False
function InttoBool(boolnumber: integer): Boolean;  // 1/0 to True/False
function BooltoInt(boolvalue: boolean): integer;  //Devolve 0 ou 1
function BooltoChar(boolvalue: boolean): string; //Devolve '0' ou '1'
function HasInternet: Boolean;
function TestURL(testurl: string): Boolean;
function GetIntegerSign(signednumber: integer):string;
function InvertColor(const Color: TColor): TColor;
function FtpUploadFile( HostName: String; UserName: String; Password: String;
                             UploadFileName: String; ToHostDir : String ):boolean;
function GetCommaSeparatedFromList(lista: TStrings): string;
function Version2Number(version: string): integer;
function GetFilesinDir(DirList : TStrings; Path: String):boolean;
procedure HideTaskBar;
procedure ShowTaskbar;


implementation

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
  //Memo1.Lines.Add('VName = '+VolumeName);
  //Memo1.Lines.Add('SerialNo = $'+IntToHex(VolumeSerialNo,8));
  //Memo1.Lines.Add('CompLen = '+IntToStr(MaxComponentLength));
  //Memo1.Lines.Add('Flags = $'+IntToHex(FileSystemFlags,4));
  //Memo1.Lines.Add('FSName = '+FileSystemName);

end;

function sBreakApart(BaseString, BreakString: string; StringList:
                       TStringList):TStringList;
var
   EndOfCurrentString: byte;
   TempStr: string;
begin
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

//Igual ao anterior mas não devolve valor na lista se este não existir
function sBreakSpecial(BaseString, BreakString: string; StringList:
                       TStringList):TStringList;
var
   EndOfCurrentString: byte;
   TempStr: string;
begin
     repeat
       EndOfCurrentString := Pos(BreakString, BaseString);
       if EndOfCurrentString = 0 then
         StringList.add(BaseString)
       else
        if (EndOfCurrentString - 1)>0 then
         StringList.add(Copy(BaseString,1,EndOfCurrentString - 1));
       BaseString:= Copy(BaseString,EndOfCurrentString +
                    length(BreakString),length(BaseString) -
                    EndOfCurrentString);
     until EndOfCurrentString = 0;
     result:=StringList;
end;

procedure LoadLista(Lines: TStrings; DivideChar: char; Grelha: TStringGrid);
var lista: TStringList;
     stemp: string;
     a,b: integer;
begin
               for a:=0 to lines.count do
                begin
                 lista:=TStringList.Create;
                 stemp:=Lines.Strings[a];
                 Lista:=sBreakApart(stemp,DivideChar,Lista);
                 //Caso necessário aumenta a grid
                 if (a+1)>Grelha.RowCount then
                     Grelha.RowCount:=Grelha.RowCount+1;
                 if (Lista.Count) > Grelha.ColCount then
                    Grelha.ColCount:=Grelha.ColCount+1;
                 for b:=0 to Lista.Count-1 do
                  begin
                    Grelha.Rows[a+1].strings[b]:=Lista.Strings[b];
                  end;//for b
                FreeAndNil(Lista);
               end;//for a

end;

 function WinExecAndWait32(FileName:String; Visibility : integer):integer;
  var
    zAppName:array[0..512] of char;
    zCurDir:array[0..255] of char;
    WorkDir:String;
    StartupInfo:TStartupInfo;
    ProcessInfo:TProcessInformation;
    Directory, Executavel: string;
    temp : dword;

  begin
    Directory:=extractfiledir(fILENAME);
    Executavel:=extractfilename(FileName);
    SetCurrentDir(dIRECTORY);
    StrPCopy(zAppName,Executavel);
    //GetDir(0,WorkDir);
    StrPCopy(zCurDir,Directory);
    FillChar(StartupInfo,Sizeof(StartupInfo),#0);
    StartupInfo.cb := Sizeof(StartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := Visibility;
    if not CreateProcess(nil,
      zAppName,                      { pointer to command line string }
      nil,                           { pointer to process security attributes
}
      nil,                           { pointer to thread security attributes }
      false,                         { handle inheritance flag }
      CREATE_NEW_CONSOLE or          { creation flags }
      NORMAL_PRIORITY_CLASS,
      nil,                           { pointer to new environment block }
      nil,                           { pointer to current directory name }
      StartupInfo,                   { pointer to STARTUPINFO }
      ProcessInfo) then Result := -1 { pointer to PROCESS_INF }
    else
       begin
       WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
       GetExitCodeProcess(ProcessInfo.hProcess, temp);
       end;
  end;

{ Execute an external application APPNAME.
  Pass optional parameters in PARAMS, separated by spaces.
  Wait for completion of the application
  Returns FASLE if application failed.                     }
function ExecAppWait(AppName, Params: string): Boolean;
var  // structure containing and receiving info about application to start
     ShellExInfo: TShellExecuteInfo;
begin
  {$IFDEF DCC}
  FillChar(ShellExInfo, SizeOf(ShellExInfo), 0);
  with ShellExInfo do begin
    cbSize := SizeOf(ShellExInfo); fMask := see_Mask_NoCloseProcess;
    Wnd := Application.Handle; lpFile := PChar(AppName);
    lpParameters := PChar(Params);
    nShow := sw_SHOWNORMAL;    //nShow := sw_ShowMinNoActive;
  end;
  Result := ShellExecuteEx(@ShellExInfo);
  if Result then
    while WaitForSingleObject(ShellExInfo.HProcess, 100) = WAIT_TIMEOUT do
    begin
      Application.ProcessMessages;
      if Application.Terminated then Break;
    end;
  {$ENDIF}
  {$IFDEF FPC}
  if ShellExecute(0,'open',PChar(AppName),PChar(params),PChar(extractfilepath(AppName)),1) >32 then; //success
  {$ENDIF}

end;

//Executa e não espera
function ExecApp(AppName, Params: string): Boolean;
var  // structure containing and receiving info about application to start
     ShellExInfo: TShellExecuteInfo;
begin
  {$IFDEF DCC}
  FillChar(ShellExInfo, SizeOf(ShellExInfo), 0);
  with ShellExInfo do begin
    cbSize := SizeOf(ShellExInfo); fMask := see_Mask_NoCloseProcess;
    Wnd := Application.Handle; lpFile := PChar(AppName);
    lpParameters := PChar(Params);
    nShow := sw_SHOWNORMAL;    //nShow := sw_ShowMinNoActive;
  end;
  Result := ShellExecuteEx(@ShellExInfo);

  {$ENDIF}


end;

{$IFDEF DCC}
function ExecAppWaitHidden(AppName, Params: string): Boolean;
var
  // structure containing and receiving info about application to start
  ShellExInfo: TShellExecuteInfo;
begin
  FillChar(ShellExInfo, SizeOf(ShellExInfo), 0);
  with ShellExInfo do begin
    cbSize := SizeOf(ShellExInfo);
    fMask := see_Mask_NoCloseProcess;
    Wnd := Application.Handle;
    lpFile := PChar(AppName);
    lpParameters := PChar(Params);
    //nShow := sw_ShowMinNoActive;
    nShow := SW_HIDE;
  end;
  Result := ShellExecuteEx(@ShellExInfo);
  if Result then
    while WaitForSingleObject(ShellExInfo.HProcess, 100) = WAIT_TIMEOUT do
    begin
      Application.ProcessMessages;
      if Application.Terminated then Break;
    end;
end;
{$ENDIF}

// Função de escrita de log em ficheiro
// è executada sempre que for chamada
// se LOGFILENAME não existe, então escreve por defeito em media.log
procedure LogWrite(s: string);
var F1: textfile;
    LogDir, LogFile: string;
begin

     //   if not DelphiIsRunning then exit;

     LOGLINESCOUNT:=LOGLINESCOUNT+1;

        LogDir:=extractfiledir(application.exename)+'\logs';
        if LOGFILENAME='' then
         Logfile:='Media.log' else Logfile:=LOGFILENAME;
        if not DirectoryExists(LogDir) then
           if not CreateDir(LogDir) then
                raise Exception.Create('Cannot create '+LogDir);

        if  FileExists(LogDir+'\'+LogFile) then
          begin
                try
                 AssignFile(F1,LogDir+'\'+LogFile);
                 Append(F1);
                 writeln(F1,s);
                 Flush(F1);
                 CloseFile(F1);
                except

                end;

          end
        else
          begin
                AssignFile(F1,LogDir+'\'+LogFile);
                Rewrite(F1);
                writeln(F1,s);
                CloseFile(F1);
          end;

     if LOGLINESCOUNT>100 then TestLogFile;

end;

procedure LogWriteCustom(customlogfilename,s: string);
var F1: textfile;
    LogDir, LogFile: string;
begin


        LogDir:=extractfiledir(application.exename)+'\logs';
        Logfile:=customlogfilename;
        if not DirectoryExists(LogDir) then
           if not CreateDir(LogDir) then
                raise Exception.Create('Cannot create '+LogDir);

        if  FileExists(LogDir+'\'+LogFile) then
          begin
                AssignFile(F1,LogDir+'\'+LogFile);
                Append(F1);
                writeln(F1,s);
                Flush(F1);
                CloseFile(F1);
          end
        else
          begin
                AssignFile(F1,LogDir+'\'+LogFile);
                Rewrite(F1);
                writeln(F1,s);
                CloseFile(F1);
          end;


end;

// Executada sempre que DEBUGMODE=true
//Se LOGFILENAME não estiver definido, então escreve em debug.log
procedure DebugWrite( s: string );
var F1: textfile;
    LogDir, LogFile: string;
begin

      if not DEBUGMODE then exit;

      s:=formatdatetime('hh:mm:ss:zzz',now)+'_'+inttostr(MilliSecondsBetween(now,LastDebugTime))+'ms'+s;

       // if not DelphiIsRunning then exit;
      LOGLINESCOUNT:=LOGLINESCOUNT+1;

        LogDir:=extractfiledir(application.exename)+'\logs';
        if LOGFILENAME='' then
         Logfile:='debug.log' else Logfile:=LOGFILENAME;
        if not DirectoryExists(LogDir) then
           if not CreateDir(LogDir) then
                raise Exception.Create('Cannot create '+LogDir);

        if  FileExists(LogDir+'\'+LogFile) then
          begin
                AssignFile(F1,LogDir+'\'+LogFile);
                Append(F1);
                writeln(F1,s);
                Flush(F1);
                CloseFile(F1);
          end
        else
          begin
                AssignFile(F1,LogDir+'\'+LogFile);
                Rewrite(F1);
                writeln(F1,s);
                CloseFile(F1);
          end;

      if LOGLINESCOUNT>100 then TestLogFile;
      LastDebugTime:=Now;

end;

//Vai analizar o ficheiro de logs
//Se for maior do que 100MB, então cria um novo
procedure TestLogFile;
var LogDir, LogFile: string;
begin
    LogDir:=extractfiledir(application.exename)+'\logs';
    if LOGFILENAME='' then
     Logfile:='debug.log' else Logfile:=LOGFILENAME;

    if FileSize(logdir+'\'+logfile)>104857600 then
     begin
      RenameFile(logdir+'\'+logfile,
                 logdir+'\'+formatdatetime('YYYYMMDDHHNNSS_',now)+logfile);
      LOGLINESCOUNT:=0;
     end;


end;

procedure PLog( s: string);
var F1: textfile;
    LogDir, LogFile: string;
begin
        LogDir:=extractfiledir(application.exename)+'\logs';
        Logfile:='PLOG.log';
        if not DirectoryExists(LogDir) then
           if not CreateDir(LogDir) then
                raise Exception.Create('Cannot create '+LogDir);

        if  FileExists(LogDir+'\'+LogFile) then
          begin
                AssignFile(F1,LogDir+'\'+LogFile);
                Append(F1);
                writeln(F1,s);
                Flush(F1);
                CloseFile(F1);
          end
        else
          begin
                AssignFile(F1,LogDir+'\'+LogFile);
                Rewrite(F1);
                writeln(F1,s);
                CloseFile(F1);
          end;

end;


function ApagaFile( filename: string): boolean;
var fos: TSHFileOPStruct;
begin
       ZeroMemory(@fos, Sizeof(fos));
        with fos do
         begin
          wFunc :=FO_DELETE;
          fFlags:= FOF_NOCONFIRMATION;
          pFrom:= PChar(filename+#0);
         end;
       Result:=(0=ShFileOperation(fos));
end;

function CopiaFile( filename, tofilename: string): boolean;
var fos: TSHFileOPStruct;
begin
        ZeroMemory(@fos, Sizeof(fos));
        with fos do
         begin
          wFunc := FO_Copy;
          fFlags:= FOF_NOCONFIRMATION;
          pFrom:= PChar(filename+#0);
          pTo:=  PChar(tofilename+#0);
         end;
        Result:=(0=ShFileOperation(fos));
end;


function removefileext(FileName:String): string;
var a,l: integer;
    s: string;
begin
     l:=length(Filename);
     if Filename[l-3]='.' then
        s:=format('%'+inttostr(l-4)+'.'+inttostr(l-4)+'s',[Filename])
     else
        begin
                for a:=l downto 1 do
                 begin
                  if filename[a]='.' then break;
                 end;
               s:=format('%'+inttostr(a-1)+'.'+inttostr(a-1)+'s',[Filename])
        end;
     removefileext:=s;
end;

function IsStrANumber(NumStr : string) : bool;
var c:AnsiChar;
    i: integer;
    isok: boolean;
begin
    isOk:=True;
    if length(NumStr)<1 then isok:=False;
    for i:=1 to length(NumStr) do
     begin
      if not (NumStr[i] in ['0'..'9','.',',','-']) then isok:=False;
     end;

    result:=isOk;


end;

function GetFirstFree(var F: array of boolean; max: integer): integer;
var a: integer;
    r: integer;
begin
     r:=-1;
     for a:=0 to max do
      begin
        if F[a]=false then
         begin
          r:=a;
          f[a]:=true;
          logwrite('Found index free '+inttostr(r));
          break;
         end;
      end;
     result:=r;
end;

function GetFirstFree1(var F: array of boolean; max: integer): integer;
var a: integer;
    r: integer;
begin
     r:=-1;
     for a:=1 to max do
      begin
        if F[a]=false then
         begin
          r:=a;
          f[a]:=true;
          logwrite('Found index free '+inttostr(r));
          break;
         end;
      end;
     result:=r;
end;

//Extrai o primeiro número encontrado
function ExtractNumber(str: string):integer;
var i,a: integer;
    tot: integer;
    digits: TDigitSet;
begin
    digits:= ['0','1','2','3','4','5','6','7','8','9'];
    //Vai procurar o primeiro dígito
    a:=0;
    for i:=1 to length(str) do
     if (str[i] in digits) then begin
                                 a:=i; break;
                                end;
    {for i:=0 to 9 do
      if Pos(inttostr(i),Str)>0 then
       begin
         a:=Pos(inttostr(i),Str);
         break;
       end; }

    if a>0 then
     begin
       tot:=0;
       while (str[a] in digits) do
        begin
          tot:=tot*10+strtoint(str[a]);
          inc(a);
        end;
      ExtractNumber:=tot;
     end //a > 0
    else
      ExtractNumber:=-1;
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

function ExtractFloat(str: string):double;
var i,a: integer;
    r,d,dcount: integer;
    tot: integer;
    comma: boolean;
    validdigits: TDigitSet;
    signal: double;
begin
validdigits:= ['0','1','2','3','4','5','6','7','8','9'];

        a:=1;
        r:=0;
        d:=0;
        dcount:=0;
        comma:=False;
        str:=trim(str);
        signal:=1;

        //Negativo?
        if length(str)>0 then
         if str[1]='-' then
          begin
            signal:=-1;
            str:=Midstr(str,2,length(str)-1);
          end;

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

        result:=(r+d/power(10,dcount))*signal;

end;


//incrementa o primeiro número encontrado
function IncrementNumber(var str: string): string;
var i,a,aa: integer;
    tot: integer;
    digits: TDigitSet;
    sa,s: string;
begin
    digits:= ['0','1','2','3','4','5','6','7','8','9'];
    //Vai contar quantos dígitos
    a:=0; //Quantos digitos
    aa:=-1; //primeira posicao
    sa:='';
    for i:=1 to length(str) do
     if str[i] in digits then
      begin
       inc(a);
       sa:=sa+str[i];
       if aa<0 then aa:=i;
      end;

    tot:=ExtractNumber(str);
    inc(tot);

    s:=format('%'+inttostr(a)+'.'+inttostr(a)+'d',[tot]);

    str:=stringreplace(str,sa,s,[]);

    result:=str;
end;

function GetValidInt(str: string; default: integer): integer;
begin
    if IsStrANumber(trim(str)) then result:=strtoint(trim(str)) else result:=default;
end;

function GetValidInt64(str: string; default: integer): int64;
begin
   if IsStrANumber(trim(str)) then result:=StrToInt64(trim(str)) else result:=default;
end;

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

function str2ascii( str: string): string;
var a: integer;
    s1, s2: string;
begin
    s1:=stringreplace(str,' ','',[rfReplaceAll]);
    s2:='';
    for a:=1 to length(s1) do
      if ord(s1[a])>=32 then s2:=s2+s1[a];
    result:=s2;
end;

//******************************************************************************
// Replaces all the "replace" strings found by the string "by"
// Ignores the strings inside the "ignoreinside"
//
// ex:  strreplaceignoreinside( 'Hello "#1", my name is #1', '#1', 'Jon','""')
// results in 'Hello "#1", my name is Jon'
//******************************************************************************
function strreplaceignoreinside( str, replace, by, ignoreinside: string): string;
begin
    //
end;

//*****************************************************************************
//  Returns a Stringlist with all string that begin with A and end with B
//*****************************************************************************
//Nota: a variavel stringlist é criada dentro desta função, ao contrário de
//      sBreakApart
procedure GetAllinsideAB(str, A, B: string; StringList:TStringList);
begin
    //
end;

function LastPos(substr, s:string): integer;
var ss: string;
begin
        substr:=reverseString(substr);
        s:=reverseString(s);
        result:=length(s)-pos(substr,s)+1;
end;

//The sames as above but returns only the first
function GetinsideAB(str, A, B: string): string;
var i, j: integer;
begin
    i:=pos(A,str);
    j:=lastpos(B,str);
    result:=MidStr(str,i+length(A),j-i-length(B)-length(A)+1);
end;

//Remove os primeiros n caracteres da string
function StrRemoveFirst( str: string; n: integer): string;
var a: integer;
    s: string;
begin
    s:='';
    for a:=n+1 to length(str) do
     begin
      s:=s+str[a];
     end;
    result:=s;
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

function GetInsideParentesisRetos( str: string): string;
var a: integer;
    b, c: integer;
    s: string;
begin
    s:='';
    b:=pos('[',str);
    c:=pos(']',str);
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

function GetStrAfterLastChar( str,afterstr: string): string;
var i: integer;
begin
    if lastpos(afterstr,str)>0 then
     begin
      i:=length(str)-lastpos(afterstr,str)+1;
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

function isdigit(ch : AnsiChar) : Boolean;
begin
    Result := ch in ['0'..'9'];
end;

function islower(ch : AnsiChar) : Boolean;
begin
    Result := ch in ['a'..'z'];
end;

function isupper(ch : AnsiChar) : boolean;
begin
    Result := ch in ['A'..'Z'];
end;

procedure GetAllFileValues(resultlist,displaylist: TStrings;dir,filter: string;
                           usekey: boolean;key: string);
var
  sr: TSearchRec;
  F: TextFile;
  S, sfind,sfindend, sresult: string;
  found: boolean;
begin
 if FindFirst(dir+'\'+filter, faArchive , sr) = 0 then
    begin
      repeat
        resultlist.Add(sr.Name);
        if usekey then
        begin
        //Vai ler o ficheiro
         AssignFile(F,dir+'\'+sr.Name);
         Reset(F);
         found:=False;
         //key contem space, onde deve estar o valor a retornar
         sfind:=copy(key,1,pos(' ',key)-1);
         sfindend:=rightstr(key,length(key)-pos(' ',key));
         repeat
          begin
           Readln(F, S);
           if pos(sfind,s)>0 then begin
                                   found:=True;
                                   sresult:=GetinsideAB(s,sfind, sfindend);
                                   displaylist.Add(sresult);
                                  end;
          end;
         until (eof(F)) or (found);
         CloseFile(F);
        end //usekey
        else
         displaylist.Add(sr.Name);

      until FindNext(sr) <> 0;
      FindClose(sr);
    end;

end;

procedure EmptyDir(dir: string);
begin
  TDirectory.Delete(dir, True);
  ForceDirectories(Dir);
end;

//Devolve numa lista todos os ficheiros na pasta "dir" com o filtro
//filtro ex:  *.bmp    , ou    *.bmp|*.jpg
procedure GetAllFiles(resultlist:TStrings; dir,filter: string);
var sr: TSearchRec;
    lista: TStringList;
    i: integer;
begin
   lista:=TStringList.Create;
   sbreakapart(filter,'|',lista);
   for I := 0 to Lista.Count - 1 do
    begin
     if FindFirst(dir+'\'+lista[i], faArchive , sr) = 0 then
      begin
       repeat
         resultlist.Add(dir+'\'+sr.Name);
       until FindNext(sr) <> 0;
       FindClose(sr);
      end;
    end;//for i
end;

function StrOccurences(part,original: string): integer;
var occurs: integer;
begin
     occurs:=0;
     while pos(part,original)>0 do
      begin
       occurs:=occurs+1;
       original:=rightstr(original,length(original)-1);
      end;
     result:=occurs;
end;

function mysqldouble(n: double): string;
begin
    result:=stringreplace(floattostr(n),',','.',[rfReplaceAll]);
end;

function Push(var Lista: Tstringlist; str: string): integer;
begin
//
    lista.Append(str);
    result:= lista.Count-1;
end;

procedure Pop(Lista: Tstringlist; var str: string);
begin
//
     if lista.Count>0 then
      begin
     str:=lista.Strings[lista.count-1];
     lista.Delete(lista.Count-1);
     end
    else str:='';
end;

procedure Fifo(Lista: Tstringlist; var str: string);
begin
//
     if lista.Count>0 then
      begin
       str:=lista.Strings[0];
       lista.Delete(0);
      end
     else
      str:='';
end;

{$IFDEF DCC}
function DelphiIsRunning: boolean;
Begin
   //Result:=FindWindow('TAppBuilder', nil) > 0;
   if DebugHook <> 0
   then result:=True
   else result:=False;
End;
{$ENDIF}

//Lê valor do registry
//EX: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion
function GetRegistryValue(key,variable: string): string;
var Reg: TRegistry;
    Root: integer;
begin

        root:=-1;
        if pos('HKEY_CLASSES_ROOT',uppercase(key))>0
         then root:=HKEY_CLASSES_ROOT;
        if pos('HKEY_USERS',uppercase(key))>0
         then root:=HKEY_USERS;
        if pos('HKEY_CURRENT_CONFIG',uppercase(key))>0
         then root:=HKEY_CURRENT_CONFIG;
        if pos('HKEY_LOCAL_MACHINE',uppercase(key))>0
         then root:=HKEY_LOCAL_MACHINE;
        if pos('HKEY_CURRENT_USER',uppercase(key))>0
         then root:=HKEY_CURRENT_USER;
        if root=-1 then begin result:='ERROR'; Exit; end;

        Reg := TRegistry.Create;
        try
            Reg.RootKey := Root;
            if Reg.OpenKey(GetStrAfterChar(key,'\'), False) then
             begin
              result:=Reg.ReadString(variable);
              Reg.CloseKey;
             end
            else
             result:='';

          finally
            Reg.Free;
          end;
end;

//Cria ou escreve um valor no registry
//EX: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion
procedure WriteRegistryValue(key,variable, value: string);
var Reg: TRegistry;
    Root: integer;
begin

        root:=-1;
        if pos('HKEY_CLASSES_ROOT',uppercase(key))>0
         then root:=HKEY_CLASSES_ROOT;
        if pos('HKEY_USERS',uppercase(key))>0
         then root:=HKEY_USERS;
        if pos('HKEY_CURRENT_CONFIG',uppercase(key))>0
         then root:=HKEY_CURRENT_CONFIG;
        if pos('HKEY_LOCAL_MACHINE',uppercase(key))>0
         then root:=HKEY_LOCAL_MACHINE;
        if pos('HKEY_CURRENT_USER',uppercase(key))>0
         then root:=HKEY_CURRENT_USER;
        if root=-1 then Exit;

        Reg := TRegistry.Create;
        try
            Reg.RootKey := Root;
            if Reg.OpenKey(GetStrAfterChar(key,'\'), True) then
             begin
              Reg.WriteString(variable,value);
              Reg.CloseKey;
             end;

          finally
            Reg.Free;
          end;
end;

function DGetTempFileName (const Folder, Prefix : string) : string;
var
   FileName : array[0..MAX_PATH] of Char;
begin
   if GetTempFileName (PChar (Folder), PChar (Prefix), 0, FileName) = 0 then
       raise Exception.Create ('GetTempFileName error');
   Result := FileName;
end;

function GetNetUser : Ansistring;
var
  dwI : DWord;
begin 

  dwI := MAX_PATH;
  SetLength (Result, dwI + 1);
  if WNetGetUser (Nil, PChar (Result), dwI) = NO_ERROR then
    SetLength (Result, StrLen (PChar (Result)))
  else
   SetLength (Result, 0)

end;

//Adiciona à pasta "Meus documentos recentes"
procedure AddtoDocMenu(fName: string);
begin
  SHAddToRecentDocs(SHARD_PATH, PChar(fName));
end;

function extractUnixFilename(unixfilename: string):string;
var i: integer;
begin
        i:=LastPos('/',unixfilename);
        result:=rightstr(unixfilename,length(unixfilename)-i);
end;

//return the last position of the substr found in the string
function PosR(substr, str: string): integer;
var a, b, c: integer;
    stemp: string;
    found: boolean;
begin
        b:=length(str);
        c:=length(substr);
        a:=b-c+1;
        found:=False;
        repeat
          stemp:=copy(str, a, c);
          if AnsiCompareStr(substr,stemp)=0 then begin found:=true; break; end;
          dec(a);
        until (AnsiCompareStr(substr, str)=0) or (a<0);
        PosR:=a;
end;


function Color2String(cor: TColor): string;
var s: string;
begin
        s:=ColorToString(cor);
        if pos('cl',s)>0 then s:=RightStr(s,length(s)-2);
        result:=s;
end;

//Accepts color names or $02FF8800
function string2color(value: string): TColor;
var s: string;
begin
    s:=Value;
    if pos('$',s)=0 then
      begin
        //Default is black
        result:=$000000;

        s:=uppercase(s);
        if s='BLUE' then result:=$0000FF;
        if s='RED' then result:=$FF0000;
        if s='GREEN' then result:=$00FF00;
        if s='CYAN' then result:=$00FFFF;
        if s='YELLOW' then result:=$FFFF00;
        if s='PINK' then result:=$FF00FF;
        if s='DRAKGRAY' then result:=$404040;
        if s='GRAY' then result:=$808080;

        if s='WHITE' then result:=$FFFFFF;
        if s='BLACK' then result:=$000000;
      end
    else
     result:=StringToColor(s);
end;

function BrushStyle2String(value: TBrushStyle): string;
begin
    case value of
     bsSolid: result:='SOLID';
     bsClear: result:='CLEAR';
    else
     result:='CLEAR';
    end;
end;

function String2BrushStyle(value: string): TBrushStyle;
begin
    if value='SOLID' then result:=bsSolid
    else if value='CLEAR' then result:=bsClear
    else result:=bsClear;

end;

function float2money(value: double;decimals: integer;symbol: string): string;
begin
     result:=Format('%15.'+inttostr(decimals)+'f'+symbol,[value]);
end;

function Date2YYYYMMDD(data: TDateTime): string;
begin
  result:=FormatDateTime('YYYYMMDD',data);
end;

//Data será 1-1-2008 ou 1/1/2008
function DiaMesAno2Date(data: string): TDateTime;
var dia, mes, ano,a: integer;
begin
    dia:=0; mes:=0; ano:=0;
    a:=1;
    while (data[a] in ['0'..'9']) and (a<length(data)) do
     begin dia:=dia*10+strtoint(data[a]); inc(a); end;
    while not (data[a] in ['0'..'9']) do inc(a);
    while (data[a] in ['0'..'9']) and (a<length(data)) do
     begin mes:=mes*10+strtoint(data[a]); inc(a); end;
    while not (data[a] in ['0'..'9']) do inc(a);
    while (data[a] in ['0'..'9']) and (a<length(data)+1) do
     begin ano:=ano*10+strtoint(data[a]); inc(a); end;
   result:=encodedate(ano, mes, dia);
end;

//Data será YYYYMMDD
function AnoMesDia2Date(data: string): TDateTime;
var dia, mes, ano,a: integer;
begin
    dia:=1; mes:=1; ano:=1;
    if length(data)=8 then
     begin
      ano:=GetValidInt(midstr(data,1,4),1);
      mes:=GetValidInt(midstr(data,5,2),1);
      dia:=GetValidInt(midstr(data,7,2),1);
      result:=encodedate(ano, mes, dia);
     end
    else
     result:=encodedate(ano, mes, dia);
end;

//Esta funcção entra com um codigo postalcompleto e divide em numero e cidade
procedure SplitPostalCode(completepostalcode: string; var number,city: string);
var i: integer;
    ended: boolean;
begin
    number:=''; city:='';
    //Enquanto fôr digito, ou '-', é nº
    i:=1;   ended:=False;
    if length(completepostalcode)=0 then exit;
    repeat
     if completepostalcode[i] in
        ['0','1','2','3','4','5','6','7','8','9','-'] then
      number:=number+completepostalcode[i]
     else ended:=True;
     inc(i);
    until ended or (i>length(completepostalcode));
    //A cidade
    repeat
     city:=city+completepostalcode[i];
     inc(i);
    until (i>length(completepostalcode));
    city:=trim(city);
end;

function RemoveSpaces(str: string): string;
begin
  result:=stringreplace(str,' ','',[rfReplaceAll]);
end;

function GetIPFromHost(var HostName, IPaddr, WSAErr: string): Boolean;
type
  Name = array[0..100] of Char;
  PName = ^Name;
var
  HEnt: pHostEnt;
  HName: PName;
  WSAData: TWSAData;
  i: Integer;
begin
  Result := False;
  if WSAStartup($0101, WSAData) <> 0 then begin
    WSAErr := 'Winsock is not responding."';
    Exit;
  end;
  IPaddr := '';
  New(HName);
  if GetHostName(PAnsiChar(HName), SizeOf(Name)) = 0 then
  begin
    HostName := StrPas(HName^);
    HEnt := GetHostByName(PAnsichar(HName));
    for i := 0 to HEnt^.h_length - 1 do
     IPaddr :=
      Concat(IPaddr,
      IntToStr(Ord(HEnt^.h_addr_list^[i])) + '.');
    SetLength(IPaddr, Length(IPaddr) - 1);
    Result := True;
  end
  else begin
   case WSAGetLastError of
    WSANOTINITIALISED:WSAErr:='WSANotInitialised';
    WSAENETDOWN      :WSAErr:='WSAENetDown';
    WSAEINPROGRESS   :WSAErr:='WSAEInProgress';
   end;
  end;
  Dispose(HName);
  WSACleanup;
end;

/////////////////////////////////////////////////////////////////
//  MethodName: EnableControls
//  Function  : Set all Controls' , which is Child of :AParent, Enabled property
//  to :AEnabled
//  Author    : Chen Jiangyong
//  Date      : 1999/02/14
/////////////////////////////////////////////////////////////////
procedure EnableControls(AParent: TWinControl; const AEnabled: Boolean);
var
  i: Integer;
  AWinControl: TWinControl;
begin
  with AParent do
    for i := 0 to ControlCount - 1 do begin
     // Set enabled property
      Controls[i].Enabled := AEnabled;
      // Set all his children's property of enable
      if Controls[i] is TWinControl then begin
        AWinControl := TWinControl(Controls[i]);
        if AWinControl.ControlCount > 0 then
          EnableControls(AWinControl, AEnabled);
      end
    end
end;
/////////////////////////////////////////////////////////////////
//  MethodName: EnableAllControls
//  Function  : Set all Controls' , which is Child of :AParent, Enabled property
//  and :Parent itself's Enabled property to :AEnabled
//  Author    : Chen Jiangyong
//  Date      : 1999/02/14
/////////////////////////////////////////////////////////////////
procedure EnableAllControls(AParent: TWinControl; const AEnabled: Boolean);
begin
// Set enabled property of all its children
  EnableControls(AParent, AEnabled);
  // Set enabled property of itself
  AParent.Enabled := AEnabled;
end;

//Vai percorrer uma lista e devolver os items numa string separada por virgulas
function ListToComas(lista: TStrings): string;
var i: integer;
    s: string;
begin
    if lista.Count=0 then begin result:=''; exit; end;
    
    s:=lista[0];
    for I := 1 to Lista.Count - 1 do
     s:=s+','+lista[i];
    result:=s;
      
end;

//Vai percorrer uma lista e devolver os items numa string separada por qualque coisa
function ListToAny(lista: TStrings; anyseparator: string): string;
var i: integer;
    s: string;
begin
    if lista.Count=0 then begin result:=''; exit; end;
    
    s:=lista[0];
    for I := 1 to Lista.Count - 1 do
     s:=s+anyseparator+lista[i];
    result:=s;

end;

//Vai limpar caracteres inválidos para criar um nome possível
//apenas pode conter o nome do ficheiro e não a path
function CreateValidFilename(originalName: string): string;
begin
    originalName:=trim(originalName);
    OriginalName:=stringreplace(OriginalName,'/','',[rfreplaceall]);
    OriginalName:=stringreplace(OriginalName,'\\','',[rfreplaceall]);
    OriginalName:=stringreplace(OriginalName,'''','',[rfreplaceall]);
    OriginalName:=stringreplace(OriginalName,'"','',[rfreplaceall]);
    OriginalName:=stringreplace(OriginalName,'+','',[rfreplaceall]);
    OriginalName:=stringreplace(OriginalName,'<','',[rfreplaceall]);
    OriginalName:=stringreplace(OriginalName,'>','',[rfreplaceall]);
    OriginalName:=stringreplace(OriginalName,'»','',[rfreplaceall]);
    OriginalName:=stringreplace(OriginalName,'«','',[rfreplaceall]);
    result:=originalName;
end;

function DiadaSemana(data: TDateTime): string;
var d: integer;
    s: string;
begin
  d:=DayOfWeek(data);
  case d of
    1: s:='Domingo';
    2: s:='Segunda-feira';
    3: s:='Terça-feira';
    4: s:='Quarta-feira';
    5: s:='Quinta-feira';
    6: s:='Sexta-feira';
    7: s:='Sábado';
  end;
  result:=s;
end;

function Mes(data: TDateTime): string;
var d: integer;
    s: string;
begin
  d:=MonthOf(data);
  case d of
    1: s:='Janeiro';
    2: s:='Fevereiro';
    3: s:='Março';
    4: s:='Abril';
    5: s:='Maio';
    6: s:='Junho';
    7: s:='Julho';
    8: s:='Agosto';
    9: s:='Setembro';
    10: s:='Outubro';
    11: s:='Novembro';
    12: s:='Dezembro';
  end;
  result:=s;
end;

function Mes_3(data: TDateTime): string;
var d: integer;
    s: string;
begin
  d:=MonthOf(data);
  case d of
    1: s:='Jan';
    2: s:='Fev';
    3: s:='Mar';
    4: s:='Abr';
    5: s:='Mai';
    6: s:='Jun';
    7: s:='Jul';
    8: s:='Ago';
    9: s:='Set';
    10: s:='Out';
    11: s:='Nov';
    12: s:='Dez';
  end;
  result:=s;
end;

function CRC16str(InString: String): string;
Var
CRC,CRC16 : Word;
Index1, Index2 : Byte;

begin
 CRC := 0;
 For Index1 := 1 to length(InString) do
  begin
   CRC := (CRC xor (ord(InString[Index1]) SHL 8));
   For Index2 := 1 to 8 do
    if ((CRC and $8000) <> 0) then
     CRC := ((CRC SHL 1) xor $1021)
    else
     CRC := (CRC SHL 1)
  end;
 CRC16 := (CRC and $FFFF);
 result:=IntToHex(CRC16,2);
end;

function CRC16Anviz(data: string): string;
var
 CRC16Lo, CRC16Hi: word;
 CL,CH: byte;
 SaveHi,SaveLo: byte;
 i,flag: integer;
begin
  CRC16Lo:=$FF;
  CRC16Hi:=$FF;
  CL:=$8;
  CH:=$84;

  for i:=1 to length(data) do
   begin
    CRC16Lo:=CRC16Lo xor ord(data[i]);//Each data make XOR with the CRC Register
    for Flag:=0 To 7 do
     begin
      SaveHi:=CRC16Hi;
      SaveLo:=CRC16Lo;
      CRC16Hi:=CRC16Hi div 2; //The higher-bit move right one bit
      CRC16Lo:=CRC16Lo div 2; //The lower-bit move right one bit
      If ((SaveHi And $1) = $1) Then //If the last bit of the Higher-bit is 1
       CRC16Lo:=CRC16Lo Or $80;   //1 Add a 1 in the front of the data after the data move right one bit.

      If ((SaveLo And $1) = $1) Then //If the LSB is 1, make XOR with the polynomial $8408' +
       begin
        CRC16Hi:= CRC16Hi Xor CH;
        CRC16Lo:= CRC16Lo Xor CL;
       end; //if
     end; //for flag
    end; //for each data

    result:=IntToHex(CRC16Hi*256+ CRC16Lo,2);
end;

procedure Delay(MSec: Cardinal);
var
  Start: Cardinal;
begin
  Start := GetTickCount;
  repeat
    Application.ProcessMessages;
  until (GetTickCount - Start) >= MSec;
end;

function Get_File_Size2(sFileToExamine: string): integer;
var
  SearchRec: TSearchRec;
  sgPath: string;
  inRetval, I1: Integer;
begin
  sgPath := ExpandFileName(sFileToExamine);
  try
    inRetval := FindFirst(ExpandFileName(sFileToExamine), faAnyFile, SearchRec);
    if inRetval = 0 then
      I1 := SearchRec.Size
    else
      I1 := -1;
  finally
    SysUtils.FindClose(SearchRec);
  end;
  Result := I1;
end;

function CountWords(aText, aWord: string): integer;
var n: Integer;
  TempText, TempWord: string;
begin
  Result := 0;
  TempText := UpperCase(aText);
  TempWord := UpperCase(aWord);
  n := 1;
  repeat
    n := PosEx(TempWord, TempText, n);
    if n > 0 then
    begin
      Result := Result + 1;
      n := n +1;
    end;
  until n = 0;
end;

function GetTempDirectory: String;
var
  tempFolder: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

//Devolve a directoria utilizando CSIDL do windows
//AliasName CSIDL Description
//RECYCLEBIN CSIDL_BITBUCKET  Pasta do recicle bin
//DATACOMMON CSIDL_COMMON_APPDATA   Pasta de dados comum a todos os users
//DESKTOPCOMMON CSIDL_COMMON_DESKTOPDIRECTORY  Desktop comum a todos
//DOCSCOMMON  CSIDL_COMMON_DOCUMENTS   Documentos para todos
//MUSICCOMMON CSIDL_COMMON_MUSIC   Musica comum
//PICTURESCOMMON CSIDL_COMMON_PICTURES  Imagens comum
//PROGRAMSCOMMON CSIDL_COMMON_PROGRAMS Pasta de programas para todos
//FONTS CSIDL_FONTS  Pasta das fontes
//MYDOCUMENTS CSIDL_PERSONAL  Pasta dos documentos do user
//MYPROGRAMS  CSIDL_PROGRAM_FILES  Pasta dos programas
//SYSTEM  CSIDL_SYSTEM   pasta do sistema (C:\Windows\System32)
//WINDOWS CSIDL_WINDOWS   Pasta do windows (C:\Windows)
function GetSpecialDirectory(alias: string): string;
 var
    r: Bool;
    path: array[0..Max_Path] of Char;
    ifolder: integer;
begin
    ifolder:=CSIDL_PERSONAL; //Default
    if alias='RECYCLEBIN' then ifolder:=CSIDL_BITBUCKET;
    if alias='DATACOMMON' then ifolder:=CSIDL_COMMON_APPDATA;
    if alias='DESKTOPCOMMON' then ifolder:=CSIDL_COMMON_DESKTOPDIRECTORY;
    if alias='DOCSCOMMON' then ifolder:=CSIDL_COMMON_DOCUMENTS;
    if alias='MUSICCOMMON' then ifolder:=CSIDL_COMMON_MUSIC;
    if alias='PICTURESCOMMON' then ifolder:=CSIDL_COMMON_PICTURES;
    if alias='PROGRAMSCOMMON' then ifolder:=CSIDL_COMMON_PROGRAMS;
    if alias='FONTS' then ifolder:=CSIDL_FONTS;
    if alias='MYDOCUMENTS' then ifolder:=CSIDL_PERSONAL;
    if alias='MYPROGRAMS' then ifolder:=CSIDL_PROGRAM_FILES;
    if alias='SYSTEM' then ifolder:=CSIDL_SYSTEM;
    if alias='WINDOWS' then ifolder:=CSIDL_WINDOWS;

    r := ShGetSpecialFolderPath(0, path, ifolder, False) ;
    if not r then raise Exception.Create('Could not find folder location.') ;
    Result := Path;
end;

function CreateValidVarName(sugestedname: string): string;
var i: integer;
    s: string;
begin
    s:='';
    for i := 1 to length(sugestedname) do
     begin
      case ord(sugestedname[i]) of
       0..31: begin end;
       32: begin s:=s+'_'; end;
       33..47: begin end;
       48..57: begin s:=s+sugestedname[i]; end;
       58..64: begin end;
       65..90: begin s:=s+lowercase(sugestedname[i]); end;
       91..94: begin end;
       95: begin s:=s+sugestedname[i]; end;
       96: begin end;
       97..122: begin s:=s+sugestedname[i]; end;
       123..255: begin end;
      end;
     end;
    result:=s;
end;

//Format file byte size
function FormatByteSize(const bytes: Longint): string;
 const
   B = 1; //byte
   KB = 1024 * B; //kilobyte
   MB = 1024 * KB; //megabyte
   GB = 1024 * MB; //gigabyte
 begin
   if bytes > GB then
     result := FormatFloat('#.## GB', bytes / GB)
   else
     if bytes > MB then
       result := FormatFloat('#.## MB', bytes / MB)
     else
       if bytes > KB then
         result := FormatFloat('#.## KB', bytes / KB)
       else
         result := FormatFloat('#.## bytes', bytes) ;
 end;

 function FormatByteSize64(const bytes: int64): string;
  const
   B = 1; //byte
   KB = 1024 * B; //kilobyte
   MB = 1024 * KB; //megabyte
   GB = 1024 * MB; //gigabyte
 begin
   if bytes > GB then
     result := FormatFloat('#.## GB', bytes / GB)
   else
     if bytes > MB then
       result := FormatFloat('#.## MB', bytes / MB)
     else
       if bytes > KB then
         result := FormatFloat('#.## KB', bytes / KB)
       else
         result := FormatFloat('#.## bytes', bytes) ;
 end;

function FileSize(fileName : wideString) : Int64;
 var
   sr : TSearchRec;
 begin
   if FindFirst(fileName, faAnyFile, sr ) = 0 then
      result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
   else
      result := -1;

   FindClose(sr) ;
 end;

{$IFDEF DCC}
function MemoryUsed: cardinal;
var
    st: TMemoryManagerState;
    sb: TSmallBlockTypeState;
begin
    GetMemoryManagerState(st);
    result := st.TotalAllocatedMediumBlockSize + st.TotalAllocatedLargeBlockSize;
    for sb in st.SmallBlockTypeStates do begin
        result := result + sb.UseableBlockSize * sb.AllocatedBlockCount;
    end;
end;
{$ENDIF}

function GetTotalMemory: int64;
var
  memory: TMemoryStatus;
begin
  memory.dwLength := SizeOf(memory);
  GlobalMemoryStatus(memory);
  result:=memory.dwTotalPhys;
end;

function GetFreeMemory: int64;
var
  memory: TMemoryStatus;
begin
  memory.dwLength := SizeOf(memory);
  GlobalMemoryStatus(memory);
  result:=memory.dwAvailPhys;
end;

{$IFDEF DCC}
procedure DownloadJPG(url:string;Bitmap: TBitmap);
var
  strStream: String;
  memStream: TMemoryStream;
  jpegimg: TJPEGImage;
  idHTTP1: TidHTTP;
begin

  idHTTP1:=TidHTTP.Create(nil);
  memStream := TMemoryStream.Create;

  try
    idhttp1.Get(url,memStream);
  except
    //ShowMessage('Image was not found');
    Exit;
  end;
  jpegimg   := TJPEGImage.Create;
  try
    memStream.Position := 0;
    jpegimg.LoadFromStream(memStream);
    Bitmap.Assign(jpegimg);
  finally
    memStream.Free;
    jpegimg.Free;
  end;

  idHTTP1.Free;

end;

function DownloadFile(url:string):UTF8String;
var
  strStream: UTF8String;
  memStream: TMemoryStream;
  tempstrings: TStringList;
  idHTTP1: TidHTTP;
  sucess: boolean;
begin
  idHTTP1:=TidHTTP.Create(nil);
  idHTTP1.ReadTimeout:=5000;
  IdHTTP1.Request.CharSet := 'utf-8';
  tempstrings:=TStringList.Create;
  result:='';

  sucess:=true;
  try
    //strStream:= TStringStream.Create(idhttp1.Get(url), TEncoding.UTF8, true);
    strStream:=idhttp1.Get(url);
  except
    result:='ERROR';
    logwrite('Error Downloading');
    //idHTTP1.Free;
    //tempstrings.Free;
    //Exit;
    sucess:=false;
  end;

  if sucess then
   result:=strStream;

  idHTTP1.Free;
  tempstrings.Free;

end;

function DownloadToFile(url,Filename:string):boolean;
var
  IdHTTP1: TIdHTTP;
  Stream: TMemoryStream;
begin
//  Url := 'http://www.rejbrand.se';
//  Filename := 'download.htm';
  url:=StringReplace(url,' ','%20',[rfReplaceAll ]);
  result:=false;
  IdHTTP1 := TIdHTTP.Create(nil);
  IdHTTP1.ReadTimeout:=5000;
  IdHTTP1.HandleRedirects:=False;
  Stream := TMemoryStream.Create;
  try
   begin
    try
     debugwrite('IdHTTP1.Get(Url, Stream);');
     IdHTTP1.Get(Url, Stream);
     Stream.SaveToFile(FileName);
    finally
     debugwrite('Finally');
     Stream.Free;
     debugwrite('f1');
     IdHTTP1.Free;
     debugwrite('f2');
     result:=true;
    end;
   end;
  except
    // here catch the exception
    debugwrite('Except');
    result:=false;
  end;
end;

{$ENDIF}

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
  s:=MidStr(stringreplace(s,
               '’','',[rfReplaceAll]),1,maxchars);
  s:=MidStr(stringreplace(s,
               '\;','',[rfReplaceAll]),1,maxchars);

  //O corte abrupto pode originar de novo número impar de plicas
  c:=GetCharCount(s,'''');
  if odd(c) then
   s:=MidStr(s,1,maxchars-1);

  result:=s;
end;

//Quantity,UnitPrice,Discount in Euros
function GetTotalWithoutVat(Quantity,ItemUnitPriceEuros,DiscountEuros: extended):extended;
begin
  result:=Quantity*ItemUnitPriceEuros-DiscountEuros;
end;

//Quantity,UnitPrice,Discount in Euros, Vat (ex: 23,00)
function GetTotalWithVat(Quantity,ItemUnitPriceEuros,DiscountEuros,Vat: extended):extended;
begin
  result:=GetTotalWithoutVat(Quantity,ItemUnitPriceEuros,DiscountEuros)*(1+vat/100);
end;

function GetTotalofVat(Quantity,ItemUnitPriceEuros,DiscountEuros,Vat: extended):extended;
begin
  result:=GetTotalWithoutVat(Quantity,ItemUnitPriceEuros,DiscountEuros)*(vat/100);
end;

function GetDiscounPercentage(TotalAmmount,DiscountEuros: extended): extended;
begin
  if TotalAmmount<>0 then
   result:=DiscountEuros/TotalAmmount
  else
   result:=0;

end;

function SecondsBetweenDate(start,stop: TDateTime) : int64;
var TimeStamp : TTimeStamp;
begin
  TimeStamp := DateTimeToTimeStamp(Stop - Start);
  Dec(TimeStamp.Date, TTimeStamp(DateTimeToTimeStamp(0)).Date);
  Result := (TimeStamp.Date*24*60*60)+(TimeStamp.Time div 1000);
end;

function MinutesBetweenDate(start,stop: TDateTime) : int64;
begin
  Result := trunc(SecondsBetweenDate(start,stop) / 60);
end;

function FirstDayofMonth(Date: TDateTime): TDateTime;
  var
    Year, Month, Day: Word;
  begin
    DecodeDate(Date, Year, Month, Day);
    Result := EncodeDate(Year, Month, 1);
  end;

function LastDayofMonth(Date: TDateTime): TDateTime;
  var
    Year, Month, Day: Word;
  begin
    DecodeDate(Date, Year, Month, Day);
    Month:=Month+1;
    if Month=13 then begin Month := 1; inc(Year) end;
    Result := EncodeDate(Year, Month, 1) - 1;
  end;

{:Converts Unicode string to Ansi string using specified code page.
  @param   ws       Unicode string.
  @param   codePage Code page to be used in conversion.
  @returns Converted ansi string.
}
function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
var
  l: integer;
begin
  if ws = '' then
    Result := ''
  else
  begin
    l := WideCharToMultiByte(codePage,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], - 1, nil, 0, nil, nil);
    SetLength(Result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codePage,
        WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], - 1, @Result[1], l - 1, nil, nil);
  end;
end; { WideStringToString }

{:Converts Ansi string to Unicode string using specified code page.
  @param   s        Ansi string.
  @param   codePage Code page to be used in conversion.
  @returns Converted wide string.
}
function StringToWideString(const s: AnsiString; codePage: Word): WideString;
var
  l: integer;
begin
  if s = '' then
    Result := ''
  else
  begin
    l := MultiByteToWideChar(codePage, MB_PRECOMPOSED, PAnsiChar(@s[1]), - 1, nil, 0);
    SetLength(Result, l - 1);
    if l > 1 then
      MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PAnsiChar(@s[1]),
        - 1, PWideChar(@Result[1]), l - 1);
  end;
end; { StringToWideString }

function NumOfHex(c: Char): integer;
begin
result := 0;
if c>='a' then result := ord(c)-ord('a')+10
else if c>='A' then result := ord(c)-ord('A')+10
else if c>='0' then result := ord(c)-ord('0');
if result>16 then
raise exception.Create('Error of Integer: '+c);
end;

function encodedata(const BinData; size: integer): string;
var
i: integer;
da: pbytearray;
begin
setlength(result, size*2);
da:=@BinData;
for i:= 0 to size-1 do
begin
result[i*2+1]:=HexOfNum[da[i] div 16];
result[i*2+2]:=HexOfNum[da[i] mod 16];
end;
end;

function decodedata(const s: string): string;
var
i: integer;
da: pbytearray;
begin
setlength(result, length(s) div 2);
for i:= 1 to length(result) do
begin
result[i]:=char(NumOfHex(s[i*2-1])*16+NumOfHex(s[i*2]));
end;
end;

procedure WriteWideStringToStream(aString: widestring; aStream: tstream);
var i: integer;
tempstring: widestring;
begin
tempstring:= astring;
i:=length(tempstring) * sizeof(widechar);
astream.Seek(0,soFromBeginning);
aStream.write(i, sizeof(integer));
aStream.write(tempstring[1], i);
end;

procedure ReadWideStringFromStream(var aString: widestring; aStream: tStream);
var i: integer;
begin
astream.Seek(0,soFromBeginning);
i:=aStream.read(i, sizeof(integer));
setlength(aString, i div sizeof(widechar));
astream.read(astring[1], i);
end;

procedure WriteWideString(const ws: WideString; stream: TStream);
var
  nChars: LongInt;
begin
  nChars := Length(ws);
  stream.Seek(0,soFromBeginning);
  stream.WriteBuffer(nChars, SizeOf(nChars));
  if nChars > 0 then
    stream.WriteBuffer(ws[1], nChars * SizeOf(ws[1]));
end;

function ReadWideString(stream: TStream): WideString;
var
  nChars: LongInt;
begin
  stream.Seek(0,soFromBeginning);
  stream.ReadBuffer(nChars, SizeOf(nChars));
  SetLength(Result, nChars);
  if nChars > 0 then
    stream.ReadBuffer(Result[1], nChars * SizeOf(Result[1]));
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
end;

function Time2StrHM(time: TTime): string; // ->HH:MM
begin
    result:=FormatDatetime('HH:NN',time);
end;

function StrHM2Time(Strtime: string): TTime;  // HH:MM->
var h,m,s,ms: word;
begin
    h:=strtoint(GetStrBeforeChar(strtime,':'));
    m:=strtoint(GetStrAfterChar(strtime,':'));
    s:=0;
    ms:=0;
    result:=EncodeTime(h,m,s,ms);
end;


function AddMinutes(time: TTime; minutes: integer): TTime;
var h,m,s,ms: word;
    myDate : TDateTime;
begin
    decodetime(time,h,m,s,ms);
    myDate:=encodedatetime(2000,1,1,h,m,s,ms); //Aldraba
    mydate:=incminute(mydate,minutes);
    result:=timeof(mydate);

end;

function MinutesInside(strTime1,strTime2: string): integer; //HH:MM -> minutes
var h1,m1,h2,m2,min1,min2: word;
begin
    h1:=strtoint(GetStrBeforeChar(strtime1,':'));
    m1:=strtoint(GetStrAfterChar(strtime1,':'));
    h2:=strtoint(GetStrBeforeChar(strtime2,':'));
    m2:=strtoint(GetStrAfterChar(strtime2,':'));
    min1:=h1*60+m1;
    min2:=h2*60+m2;
    result:=min2-min1;
end;

function Minutes2StrHM(minutes: integer): string; // ->HH:NN
var temptime: TTime;
    hh,mm: integer;
begin
  hh:=minutes div 60;     //As horas não podem ser mais do que 24.....
  mm:=minutes mod 60;
  if hh<=23 then
   begin
    temptime:=EncodeTime(hh,mm,0,0);
    result:=FormatDatetime('HH:NN',temptime);
   end
  else
   begin
    temptime:=EncodeTime(0,mm,0,0);
    result:=inttostr(hh)+FormatDatetime(':NN',temptime);
   end;
end;

function Minutes2StrHour(minutes: integer): string; // ->8.2
var temptime: TTime;
    hh,mm: integer;
    hours: double;
begin
  hh:=minutes div 60;
  mm:=minutes mod 60;
  hours:=hh+mm/60;
  result:=formatfloat('0.0', hours);
end;

function MinutesOfTime(time: TDateTime): integer; //ex: 03:16 -> 3*60 + 16
begin
    result:=hourof(time)*60+minuteof(time);
end;


//Devolver versão windows
//6.1 Windows Seven
function GetWinVersion: TWinVersion;
 var
    osVerInfo: TOSVersionInfo;
    majorVersion, minorVersion: Integer;
 begin
    Result := wvUnknown;
    osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo) ;
    if GetVersionEx(osVerInfo) then
    begin
      minorVersion := osVerInfo.dwMinorVersion;
      majorVersion := osVerInfo.dwMajorVersion;
      case osVerInfo.dwPlatformId of
        VER_PLATFORM_WIN32_NT:
        begin
          if majorVersion <= 4 then
            Result := wvWinNT
          else if (majorVersion = 5) and (minorVersion = 0) then
            Result := wvWin2000
          else if (majorVersion = 5) and (minorVersion = 1) then
            Result := wvWinXP
          else if (majorVersion = 6) and (minorVersion = 0) then
            Result := wvWinVista
          else if (majorVersion = 6) and (minorVersion = 1) then
           Result := wvWinSeven;
        end;
        VER_PLATFORM_WIN32_WINDOWS:
        begin
          if (majorVersion = 4) and (minorVersion = 0) then
            Result := wvWin95
          else if (majorVersion = 4) and (minorVersion = 10) then
          begin
            if osVerInfo.szCSDVersion[1] = 'A' then
              Result := wvWin98SE
            else
              Result := wvWin98;
          end
          else if (majorVersion = 4) and (minorVersion = 90) then
            Result := wvWinME
          else
            Result := wvUnknown;
        end;
      end;
    end;
 end;

 function winVersiontoString(  WinVersion: TWinVersion ): string;
 var s: string;
 begin
      case winVersion of
        wvWinME: s:='Windows Millenium';
        wvWin98:  s:='Windows 98';
        wvWin98SE:   s:='Windows 98 SE';
        wvWin95: s:='Windows 95';
        wvWinSeven:  s:='Windows Seven';
        wvWinVista:  s:='Windows Vista';
        wvWinXP:  s:='Windows XP';
        wvWin2000: s:='Windows 2000';
        wvWinNT: s:='Windows NT';
        wvUnknown: s:='Desconhecido';
      end;
      result:=s;
 end;

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

 {$IFDEF DCC}
 function GetFolderDialog(parent: TFOrm; TheTitle,defaultFolder,language: string): string;
 var dir, selectdir, select: string;
     dialog: TFileOpenDialog;
 begin

  if language='PT' then
   begin
    select:='Escolher';
   end
  else
   begin
    select:='Select';
   end;

   if Win32MajorVersion >= 6 then
    begin
     dialog:=TFileOpenDialog.Create(parent);
     with dialog do
     try
      Title := TheTitle;
      Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem]; // YMMV
      OkButtonLabel := 'Select';
      DefaultFolder := defaultFolder;
      FileName := defaultFolder;
      if Execute then
        dir:=FileName;
     finally
      Free;
     end
   end
else
  if SelectDirectory(TheTitle, ExtractFileDrive(defaultFolder), defaultFolder,
             [sdNewUI, sdNewFolder]) then
    dir:=defaultFolder;

  result:=dir;

 end;

 function StrMaxLen(const S: string; MaxLen: integer): string;
var
  i: Integer;
begin
  result := S;
  if Length(result) <= MaxLen then Exit;
  SetLength(result, MaxLen);
  for i := MaxLen downto MaxLen - 2 do
    result[i] := '.';
end;

function removeLeadingZeros(const Value: string): string;
var
  i: Integer;
begin
  for i := 1 to Length(Value) do
    if Value[i]<>'0' then
    begin
      Result := Copy(Value, i, MaxInt);
      exit;
    end;
  Result := '';
end;


 {$ENDIF}

 function GetIndexStartingWith(Lista: TStrings; StartText: string):integer;
 var i: integer;
     found: integer;
 begin
    found:=-1;
    for i := 0 to lista.Count-1 do
     begin
      if pos(startText,lista[i])=1 then
       begin
        found:=i;
        break;
       end;
     end;
    result:=found;
 end;

 procedure SortTStrings(Strings:TStrings);
var
   tmp: TStringList;
begin
   if Strings is TStringList then
   begin
      TStringList(Strings).Sort;
   end
   else
   begin
      tmp := TStringList.Create;
      try
         // make a copy
         tmp.Assign(Strings);
         // sort the copy
         tmp.Sort;
         //
         Strings.Assign(tmp);
      finally
         tmp.Free;
      end;
   end;
end;

function BestFit(const AInput: AnsiString): AnsiString;
const
  CodePage = 20127; //20127 = us-ascii
var
  WS: WideString;
begin
  WS := WideString(AInput);
  SetLength(Result, WideCharToMultiByte(CodePage, 0, PWideChar(WS),
    Length(WS), nil, 0, nil, nil));
  WideCharToMultiByte(CodePage, 0, PWideChar(WS), Length(WS),
    PAnsiChar(Result), Length(Result), nil, nil);
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

function InttoBool(boolnumber: integer): Boolean;
begin
  if boolnumber=1 then result:=true
                  else result:=false;
end;

function BooltoInt(boolvalue: boolean): integer;  //Devolve 0 ou 1
begin
  if boolvalue then result:=1 else result:=0;
end;

function BooltoChar(boolvalue: boolean): string; //Devolve '0' ou '1'
begin
  if boolvalue then result:='1' else result:='0';
end;

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

function AppisRunning(appname: string):boolean;
var
  PE: TProcessEntry32;
  Snap: THandle;
  fName: String;
  ret: boolean;
begin
  ret:=false;
  pe.dwsize:=sizeof(PE);
  Snap:= CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap <> 0 then
  begin
    if Process32First(Snap, PE) then
    begin

     fName := String(PE.szExeFile);
     if appname=fname then ret:=true;

     while (not ret) and Process32Next(Snap, PE) do
      begin
       fName := String(PE.szExeFile);
       if appname=fname then ret:=true;
      end;

    end;
    CloseHandle(Snap);
  end;
  result:=ret;

end;

function HasInternet: Boolean;
begin
  with TIdHTTP.Create(nil) do
    try
      try
        HandleRedirects := True;
        Result := Get('http://www.Google.com/') <> '';
      except
        Result := false;
      end;
    finally
      free;
    end;
end;

function TestURL(testurl: string): Boolean;
begin
  with TIdHTTP.Create(nil) do
    try
      try
        HandleRedirects := True;
        Result := Get(testurl) <> '';
      except
        Result := false;
      end;
    finally
      free;
    end;
end;

function GetIntegerSign(signednumber: integer):string;
begin
  if signednumber>=0 then  result:='+' else result:='-';

end;

function InvertColor(const Color: TColor): TColor;
begin
    result := TColor(Windows.RGB(255 - GetRValue(Color),
                                 255 - GetGValue(Color),
                                 255 - GetBValue(Color)));
end;

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

function color2num(color: string): integer;
begin
  result:=$000000; //Black
  color:=uppercase(color);
  if color='BLACK' then result:=clblack;
  if color='WHITE' then result:=$FFFFFF;
  if color='BLUE' then result:=$FF0000;
  if color='RED' then result:=$0000FF;
  if color='GREEN' then result:=$00FF00;
  if color='YELLOW' then result:=$00FFFF;
  if color='PINK' then result:=$CD38FF;
  if color='GRAY' then result:=$A0A0A0;
  if color='CYAN' then result:=$EEFF00;
  if color='ORANGE' then result:=$00AEFF;
  if color='PURPLE' then result:=$FF0090;

  if ((pos('$',color)=1) and (length(color)=7)) then result:=StringToColor (color);
end;

function color2RGBHex(color: integer): string;
begin
  result:= GetBValue(Color).ToHexString(2)+
          GetGValue(Color).ToHexString(2)+
          GetRValue(Color).ToHexString(2);
end;

function FtpUploadFile( HostName: String; UserName: String; Password: String;
                             UploadFileName: String; ToHostDir : String ):boolean;
var
  FTP: TIdFTP;
  dir,s:string;
begin
  FTP := TIdFTP.Create(nil);

    FTP.Host  := HostName;
    FTP.Passive := True;
    FTP.IPVersion  := Id_IPv4;
    FTP.Username := UserName;
    FTP.Password := Password;
    FTP.Port := 21;

    try
      FTP.Connect;

      if FTP.Connected then
       begin

        FTP.Put(UploadFileName,ToHostDir);
        result:=true;
       end;
    finally
      FTP.free;

    end;

end;

//Devolve a,b,c,d a partir de uma string list
function GetCommaSeparatedFromList(lista: TStrings): string;
var s: string;
    i: integer;
begin
    if lista.Count>0 then s:=lista[0] else s:='';
    for i := 1 to lista.Count-1 do
     s:=s+','+lista[i];
    result:=s;
end;

//Pega na versão A.B.C.D e converte em A*1000+B*100+C*10+D
function Version2Number(version: string): integer;
begin
  if length(version)=7 then
   begin
    result:=(ord(version[1])-48)*1000+
            (ord(version[3])-48)*100+
            (ord(version[5])-48)*10+
            (ord(version[7])-48);
   end
  else
   result:=0;

end;

//Return all files in directory for the search rec (*.*)
function GetFilesinDir(DirList : TStrings; Path: String):boolean;
var SR: TSearchRec;
begin
  if directoryexists(path) then
   begin
    try
          if FindFirst(Path + '\*.*', faArchive, SR) = 0 then
          begin
            repeat
             DirList.Add(SR.Name); //Fill the list
            until FindNext(SR) <> 0;
            FindClose(SR);
          end;

     //do your stuff

    finally
    end;
   end
  else
   result:=false;
end;

//Kill process by exename
function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function RunAsAdmin(hWnd: hWnd; filename: string; Parameters: string; Visible: Boolean = true): Boolean;
{
  See Step 3: Redesign for UAC Compatibility (UAC)
  http://msdn.microsoft.com/en-us/library/bb756922.aspx
  This code is released into the public domain. No attribution required.
}
var
  sei: TShellExecuteInfo;
begin
  ZeroMemory(@sei, SizeOf(sei));
  sei.cbSize := SizeOf(TShellExecuteInfo);
  sei.Wnd := hWnd;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb := PChar('runas');
  sei.lpFile := PChar(filename); // PAnsiChar;
  if Parameters <> '' then
    sei.lpParameters := PChar(Parameters); // PAnsiChar;
  if Visible then
    sei.nShow := SW_SHOWNORMAL // Integer;
  else
    sei.nShow := SW_HIDE;

  Result := ShellExecuteEx(@sei);
end;

procedure HideTaskBar;
var hTaskBar : THandle;
begin
   hTaskbar := FindWindow('Shell_TrayWnd', Nil);
   ShowWindow(hTaskBar, SW_HIDE);
end;

procedure ShowTaskbar;
var hTaskBar : THandle;
begin
  hTaskbar := FindWindow('Shell_TrayWnd', Nil);
  ShowWindow(hTaskBar, SW_SHOWNORMAL);
end;

//wnd := FindWindow(PChar('OpusApp'), nil);
function IsAppRespondigNT(wnd: HWND): Boolean;
type
  TIsHungAppWindow = function(wnd:hWnd): BOOL; stdcall;
var
  hUser32: THandle;
  IsHungAppWindow: TIsHungAppWindow;
begin
  Result := True;
  hUser32 := GetModuleHandle('user32.dll');
  if (hUser32 > 0) then
  begin
    @IsHungAppWindow := GetProcAddress(hUser32, 'IsHungAppWindow');
    if Assigned(IsHungAppWindow) then
    begin
      Result := not IsHungAppWindow(wnd);
    end;
  end;
end;

function NewDownloadFile(SourceFile, DestFile: string): Boolean;
begin
  try
    Result := UrlDownloadToFile(nil, PChar(SourceFile), PChar(DestFile), 0, nil) = 0;
  except
    Result := False;
  end;
end;

end.

