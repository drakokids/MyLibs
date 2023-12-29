unit FDACFunctions;

//Apenas para windows

interface

uses system.classes,FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys,  FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet,system.sysutils,system.strutils,
  system.types, Data.db,
   FireDAC.VCLUI.Wait,vcl.comctrls ,vcl.forms,vcl.stdctrls, vcl.extctrls,
   vcl.graphics,
  Datasnap.DBClient;

type
PMyRec = ^TMyRec;
TMyRec = record
  MyID: integer;
end;

function FDFloat(number: double): string;
function FDFloatSigned(number: double): string;
function FDDate(date: TDateTime): string;
function FDTime(time: TTime): string;
function FDDateTime(date: TDateTime): string;
function FDDateTimess(date: TDateTime): string;
function FDDate2Date(FDDate: string): TDate;
function FDTime2Time(FDTime: string): TTime;
function FDMinutes2Time(minutes: integer): TTime;
function FDTime2Minutes(time: TTime): integer;
function FDDateTime2DateTime(FDDatetimeStr: string): TDateTime;
function TimeStamp2DateTimeFD(timestamp: string): TDateTime; //Returns TDateTime
function GetVarIncFD(Connection: TFDConnection;varname: string): string;
function GetNewDocumentNumberFD(counter: integer; Formato: string): string;
function GetValueFromConfigFD(Connection: TFDConnection;Variable: string): string;
procedure SetValueToConfigFD(Connection: TFDConnection;Variable,value: string);
function GetGENFD(Connection: TFDConnection;GENERATORNAME, TABLENAME: string):string;

function prepareSQL(originalsql: string): string;
function prepareSQLSize(originalsql: string; ColumnSize: integer): string;
function GetNumRecordsFD( Connection: TFDConnection;tablename,where: string): integer;
function GetAllRecordsFD(Connection: TFDConnection;Lista: TStrings;tablename, fieldname, where: string): integer;
function GetAllRecordsFDFast(Connection: TFDConnection;Lista: TStrings;tablename, fieldname, where: string): integer;
function GetAllRecordsTwoFieldsFD(Connection: TFDConnection;Lista: TStrings;tablename, fieldname1, fieldname2, where: string): integer;
function GetTwoFieldsFD(Connection: TFDConnection;tablename,where,fieldname1, fieldname2: string; var fieldvalue1,fieldvalue2:string ): integer;
function GetThreeFieldsFD(Connection: TFDConnection;tablename,where,fieldname1, fieldname2, fieldname3: string; var fieldvalue1,fieldvalue2,fieldvalue3:string ): integer;
function GetFourFieldsFD(Connection: TFDConnection;tablename,where,fieldname1, fieldname2, fieldname3, fieldname4: string;
                                                               var fieldvalue1,fieldvalue2,fieldvalue3, fieldvalue4: string ): integer;
function GetSQLValueFD(Connection: TFDConnection; sqlexp, tablename, where: string):string;
function GetSQLValueFDRowNumber(Connection: TFDConnection; sqlexp, tablename, where: string; RowNumber:integer):string;
function GetSQLDatetimeFDRowNumber(Connection: TFDConnection; sqlexp, tablename, where,orderby: string; RowNumber:integer):TDateTime;
function SQLExecuteFD(Connection: TFDConnection; sqlstring: string):boolean;
function GetMaxValueFD(Connection: TFDConnection; tablename, fieldname: string): integer;
function GetMaxDateFD(Connection: TFDConnection; tablename, fieldname,where: string; incdays: integer): Tdate;
function GetMinValueFD(Connection: TFDConnection; tablename, fieldname: string): integer;
function GetMaxFieldValueFD(Connection: TFDConnection;tablename, fieldname,where: string): integer;
function GetMinFieldValueFD(Connection: TFDConnection;tablename, fieldname,where: string): integer;
procedure GetRowDataFD(Connection: TFDConnection;var colunas: TStringList; Query: string);
function GetSumIntValueFD(Connection: TFDConnection; tablename, fieldname, where: string): integer;
//******************* People Related ***************************
procedure DBGiveAccesstoDeviceFD(Connection: TFDConnection; PeopleID, DeviceID: string);
procedure DBRemoveAccessfromDeviceFD(Connection: TFDConnection; PeopleID, DeviceID: string);
procedure DBPropagatePeopleFD(Connection: TFDConnection; PeopleEnroll: string );
procedure DBRemovePeopleFD(Connection: TFDConnection; PeopleEnroll: string );
procedure DBRemovePeopleFingerFD(Connection: TFDConnection; PeopleID: string );
function GetUserRightsFD(Connection: TFDConnection; UserID: integer; QuestionRights: string; Var R,W,I,D: boolean):boolean;
function ProcessHollidaysFD(Connection: TFDConnection; ProgressBar: TProgressBar): boolean;

function GetPeopleJobFD(FBConn: TFDConnection; JobID,ReturnLANG: string): string;
function GetDepartmentInOutHoursFD(Conn: TFDConnection; DepID: integer; var HoursIN,HoursOUT,BreakBegin,BreakOut: TTime; var workinghours: integer):boolean;
function GetPeopleInOutHoursFD(Conn: TFDConnection; PeopleID: integer; var HoursIN,HoursOUT,BreakBegin,BreakOut: TTime; var workinghours: integer):boolean;
function GetInOutHoursFD(Conn: TFDConnection; TimetableID: integer; var HoursIN,HoursOUT,BreakBegin,BreakOut: TTime; var workinghours: integer):boolean;
function GetDefaultInOutHoursFD(Conn: TFDConnection; var HoursIN,HoursOUT,BreakBegin,BreakOut: TTime; var workinghours: integer):boolean;
function GetWorkingTimeforShiftFD(Conn: TFDConnection; Shiftid:integer): integer; //Em minutos
procedure GetWorkingHoursforShiftFD(Conn: TFDConnection; Shiftid:integer; var FromTime, ToTime: TTime);

//Funções PEOPLE para os Devices
function GetAllDevicesFD(Connection: TFDConnection; DevList,DevDescription: TStringList): boolean;
function GetAllAllowedDeviceFD(Connection: TFDConnection; DevList: TStringList; PeopleID:string): boolean;
function GetAllGroupAllowedDeviceFD(Connection: TFDConnection; DevList: TStringList; GroupID:string): boolean;
function DBGeneratePeopleFD(Connection: TFDConnection; PEOPLE_NUMBER:integer): string;
function ProcessPeopleLogsFD(Connection: TFDConnection; ProgressBar: TProgressBar):boolean;
function ReprocessPeopleLogsFD(Connection: TFDConnection; FromDate,ToDate: TDate; Enroll: String):boolean;
//Vai buscar os dados registados da pessoa para determinado dia. Devolve false se não houver informação
function GetPeopleDayInfoFD(Connection: TFDConnection; peopleid: integer; day: TDate;
      var minutespresent: integer; var lastperiod,status: char ;
      var firsttime,lasttime: TDateTime; var LastEvent,FirstEvent: char) : boolean;
procedure NewPeopleDayFD(Connection: TFDConnection; peopleid: integer; day: TDate);
procedure NewChildrenDayFD(Connection: TFDConnection; childrenlist: TStrings; day: TDate);
procedure UpdateChildrenDayFD(Connection: TFDConnection; childrenlist: TStrings; day: TDate;
         TIME_PRESENT:integer; PRESENT,JUSTIFIED,LAST_EVENT,FIRST_EVENT,
         LAST_PERIOD,STATUS: char; F_EVENT_TIME, L_EVENT_TIME: TDateTime;
         JUSTIFICATION: string);
procedure UpdatePeopleDayFD(Connection: TFDConnection; peopleid: integer; day: TDate;
         TIME_PRESENT:integer; PRESENT,JUSTIFIED,LAST_EVENT,FIRST_EVENT,
         LAST_PERIOD,STATUS: char; F_EVENT_TIME, L_EVENT_TIME: TDateTime; JUSTIFICATION: string);
procedure NewPeopleBreakFD(Connection: TFDConnection; peopleid: integer; day: TDate;BREAK_BEGIN,BREAK_END: TDatetime);
//
procedure FillCombosFD( TheForm:TForm; Connection: TFDConnection; INFOSTRING: TArray<String>; lang: string);
function FillFormFD(TheForm:TForm;Connection: TFDConnection;SQLQuery: string;INFOSTRING: TArray<String>; lang: string):boolean;
function ReplicateBlobFD(Connection1,Connection2: TFDConnection;tablename,fieldname,where:string):boolean;
function SavePicturetoBlobFD(Connection: TFDConnection; tablename, fieldname, where:string; MyPicture: TPicture): boolean;
function LoadBitmapfromBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; var MyBitmap: TBitmap): boolean;
function SaveBitmapToBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; MyBitmap: TBitmap): boolean;
function SaveJpegToBlobFD(Connection: TFDConnection; tablename, fieldname, where,jpgfile: string): boolean;
function LoadJpegfromBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; var MyPicture: TPicture): boolean;
Function LoadLinesfromBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; var MyLines: TStringList): boolean;
Function UploadLinestoBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; MyLines: TStringList): boolean;
function UploadFileToBlobField(Connection: TFDConnection; tablename, fieldname, where: string; OriginFilename: string): boolean;
//Families
procedure DBLoadFamiliesTreeFD(Connection: TFDConnection; MyTreeItems: TTreeNodes);
procedure DBLoadCustomFamiliesTreeFD(Connection: TFDConnection; MyTreeItems: TTreeNodes;
                  tablename,where,fieldID,FieldParentID,FieldFamilyName,orderby,parentnull : string);
//Março 2019
procedure DBGiveVehicleAccesstoDeviceFD(Connection: TFDConnection; VehicleID, DeviceID: string);
procedure DBRemoveVehicleAccessfromDeviceFD(Connection: TFDConnection; VehicleID, DeviceID: string);
procedure DBPropagateVehicleFD(Connection: TFDConnection; VehicleID: string );
procedure DBRemoveVehicleFD(Connection: TFDConnection; VehicleID: string );

function GetCountryIndexFD(Connection: TFDConnection; ComboItems: TStrings; CountryID: string): integer;
function GetDepartmentIndexFD(Connection: TFDConnection; ComboItems: TStrings;DepartmentID: string): integer;
function EncryptPasswordFD(password: string): string;
function ValidLoginPasswordFD(Connection: TFDConnection;login,password: string): boolean;
function ValidPasswordFD(Connection: TFDConnection;userid: integer;password: string): boolean;

function GetDevicesFD(connection: TFDConnection; InfoStrings: TStringList; Filter: string): boolean;
function GetDeviceFD(connection: TFDConnection; var Info: string; Filter: string): boolean;
procedure GetPeopleVersionFD(connection: TFDConnection; var major,minor,release,build:integer);
function prepareforlike(oldstring:string):string; //Retira caracteres estranhos e substitui por %

function FixCodepageString(oldString: string): string;
function ListIDs2SQLSet(ids: TStringlist): string; //Returns (1,40,81,67) from a list of ids

//Database related
procedure ListAllTables( connection: TFDConnection; AllTables: TStringList);

implementation

uses functions, dateutils,numedit, EnhGraphicLib, international, MyBarcodeLib;

//Devolve um float no formato string para ser usado queries IB SQL
//ex: 21.00     (em vez de 21,00)
function FDFloat(number: double): string;
var LeftNumber: integer;
    s,RightNumber: string;
begin
   leftNumber:=trunc(Int(number));
   //s:=floattostr(Frac(number));
   s:=format('%20.6f',[number-leftNumber]);
   //Ou é virgula ou é ponto
   if pos(',',s)>0 then RightNumber:=GetStrAfterChar(s,',')
   else
   if pos('.',s)>0 then RightNumber:=GetStrAfterChar(s,'.')
   else RightNumber:='0';

   result:=inttostr(leftNumber)+'.'+RightNumber;
end;

//Devolve um float com sinal no formato string para ser usado queries IB SQL
//ex: +21.00 ou -21
function FDFloatSigned(number: double): string;
var LeftNumber: integer;
    s,RightNumber,signal: string;
begin
   leftNumber:=trunc(Int(number));
   //s:=floattostr(Frac(number));
   s:=format('%20.6f',[number-leftNumber]);
   //Ou é virgula ou é ponto
   if pos(',',s)>0 then RightNumber:=GetStrAfterChar(s,',')
   else
   if pos('.',s)>0 then RightNumber:=GetStrAfterChar(s,'.')
   else RightNumber:='0';

   s:=inttostr(leftNumber)+'.'+RightNumber;

   if (pos('+',s)>0) or (pos('-',s)>0) then
    begin
      result:=s;
    end
   else
    begin
     if number>=0 then result:='+'+s
     else result:='-'+s;

    end;

end;

//Vai fazer a data no formato de Interbase
function FDDate(date: TDateTime): string;
var yy,mm,dd: integer;
begin
    yy:=Yearof(Date);
    mm:=monthof(date);
    dd:=dayof(date);
    //result:=formatdatetime('dd-mm-yyyy',encodedatetime(yy,mm,dd,0,0,0,0));
    result:=formatdatetime('dd.mm.yyyy',encodedatetime(yy,mm,dd,0,0,0,0)); //20080818
end;

function FDTime(time: TTime): string;
var hh,nn,ss: integer;
begin
    hh:=hourof(time);
    nn:=minuteof(time);
    ss:=secondof(time);
    //result:=formatdatetime('dd-mm-yyyy',encodedatetime(yy,mm,dd,0,0,0,0));
    result:=formatdatetime('hh:nn:ss',time); //20080818
end;

function FDDateTime(date: TDateTime): string;
var yy,mm,dd,hh,nn: integer;
begin
    yy:=Yearof(Date);
    mm:=monthof(date);
    dd:=dayof(date);
    hh:=hourof(date);
    nn:=minuteof(date);
    //result:=formatdatetime('dd-mm-yyyy',encodedatetime(yy,mm,dd,0,0,0,0));
    result:=formatdatetime('dd.mm.yyyy hh:nn',encodedatetime(yy,mm,dd,hh,nn,0,0)); //20080818
end;

function FDDateTimess(date: TDateTime): string;
var yy,mm,dd,hh,nn,ss: integer;
begin
    yy:=Yearof(Date);
    mm:=monthof(date);
    dd:=dayof(date);
    hh:=hourof(date);
    nn:=minuteof(date);
    ss:=secondof(date);
    result:=formatdatetime('dd.mm.yyyy hh:nn:ss',encodedatetime(yy,mm,dd,hh,nn,ss,0));
end;

//Formato IB dd.mm.yyyy para TDate??
// ou então dd/mm/yyyy
// ou ainda dd-mm-yyyy
//e aceitamos trocados yyyy-mm-dd ou yyyy/mm/dd ou yyyy.mm.dd
function FDDate2Date(FDDate: string): TDate;
var lista: TStringList;
    year,month,day: word;
    breakchar: string;
begin
  lista:=TStringList.Create;
  if pos('.',FDDate)>0 then breakchar:='.' else breakchar:='/';
  if pos('-',FDDate)>0 then breakchar:='-';

  sbreakapart(FDDate,breakchar,lista);
  if lista.Count=3 then
   begin
    if length(lista[0])=4 then //ano em primeiro lugar
     begin
      year:=GetValidint(lista[0],2000);
      month:=GetValidint(lista[1],1);
      day:=GetValidint(lista[2],1);
     end
    else
     begin
      year:=GetValidint(lista[2],2000);
      month:=GetValidint(lista[1],1);
      day:=GetValidint(lista[0],1);
     end;
   end
  else
   begin
    year:=Yearof(now);
    month:=monthof(now);
    day:=dayof(now);
   end;
  lista.Free;
  result:=EncodeDate(year,month,day);
end;

//Input: HH:NN(:SS)
function FDTime2Time(FDTime: string): TTime;
var hour,min,sec,msec: word;
    lista: TStringList;
begin
  lista:=TStringList.Create;
  sbreakapart(FDTime,':',lista);
  if lista.Count>=3 then
   begin
    hour:=GetValidInt(lista[0],0);
    min:=GetValidInt(lista[1],0);
    sec:=GetValidInt(lista[2],0);
    msec:=0;
   end
  else
  if lista.Count>=2 then
   begin
    hour:=GetValidInt(lista[0],0);
    min:=GetValidInt(lista[1],0);
    sec:=0;
    msec:=0;
   end
  else
   begin
    hour:=0;
    min:=0;
    sec:=0;
    msec:=0;
   end;
  lista.Free;
  result:=Encodetime(hour,min,sec,msec);
end;

//Pega em minutos do dia e converta para a hora do dia (ex: 500-> h=500/60 m=500-500/60
function FDMinutes2Time(minutes: integer): TTime;
var hh,mm: integer;
begin
  hh:=minutes div 60;

  if hh>=24 then
   begin
    hh:=hh-24;
    minutes:=minutes-24*60;
   end;

  mm:=minutes-(hh*60);

  result:=encodeTime(hh,mm,0,0);
end;

//Pega nas horas e converte para minutos  ( ex: 10:30 = 10*60 + 30 )
function FDTime2Minutes(time: TTime): integer;
begin
  result:=Hourof(time)*60+minuteof(time);
end;

//Formato IB dd.mm.yyyy HH:MM(:SS) para TDateTime
//Ou então pode ser apenas dd.mm.yyyy ou dd/mm/yyyy
//ou apenas HH:MM(:SS)
function FDDateTime2DateTime(FDDatetimeStr: string): TDateTime;
var datestr,timestr: string;
    date: TDate;
    time: TTime;
    year,month,day,hour,min,sec,msec: word;
begin
    datestr:=GetStrBeforeChar( FDDatetimeStr,' ');
    if (datestr='') and ((pos('.',FDDatetimeStr)>0) or (pos('/',FDDatetimeStr)>0) )
    then datestr:=FDDatetimeStr;

    timestr:=GetStrAfterChar(  FDDatetimeStr,' ');
    if (timestr='') and (pos(':',FDDatetimeStr)>0) then timestr:=FDDatetimeStr;

    date:=FDDate2Date(Datestr);
    time:=FDTime2Time(TimeStr);
    decodedate(date,year,month,day);
    decodetime(time,hour,min,sec,msec);
    result:=encodedatetime(year,month,day,hour,min,sec,msec);
end;

//Input YYYY-MM-DD HH:NN:SS
function TimeStamp2DateTimeFD(timestamp: string): TDateTime; //Returns TDateTime
var yyyy,mm,dd,hh,nn,ss: integer;
begin
  if length(timestamp)>=16 then
   begin
    yyyy:=strtoint(timestamp[1]+timestamp[2]+timestamp[3]+timestamp[4]);
    mm:=strtoint(timestamp[6]+timestamp[7]);
    dd:=strtoint(timestamp[9]+timestamp[10]);
    hh:=strtoint(timestamp[12]+timestamp[13]);
    nn:=strtoint(timestamp[15]+timestamp[16]);
    if length(timestamp)>=19 then
     ss:=strtoint(timestamp[18]+timestamp[19])
    else ss:=0;
    result:=encodedatetime(yyyy,mm,dd,hh,nn,ss,00);
   end
  else
   result:=encodedatetime(2000,1,1,0,0,0,0);
end;

function GetVarIncFD(Connection: TFDConnection;varname: string): string;
var Query1: TFDQuery;
    s,ss: string;
    newnum: integer;
    newint64: int64;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select varvalue from ALL_VARS where varname='''+varname+'''');
    Query1.open;
    //Caso o resultado seja vazio, podemos resolver para algumas variáveis
    if query1.RecordCount>0 then
     begin
      if varname='INVOICE_COUNTER' then ss:='INVOICE_FORMAT';
      if varname='VD_COUNTER' then ss:='VD_FORMAT';
      if varname='FEE_COUNTER' then ss:='FEE_FORMAT';
      if varname='FEES_R_COUNTER' then ss:='FEES_R_FORMAT';
      if varname='CREDITNOTE_COUNTER' then ss:='CREDNOTE_FORMAT';
      if varname='REFERRAL_COUNTER' then ss:='REFERRAL_FORMAT';
      if varname='ORDER_COUNTER' then ss:='ORDER_FORMAT';
      if varname='CUSTOMER_CODE' then ss:='CUSTCODE_FORMAT';
      if varname='MEMBER_CODE' then ss:='MEMBERCOD_FORMAT';
      if varname='PROD_CODE' then ss:='PRODCODE_FORMAT';
      if varname='TEMP_INVOICE_COUNTER' then ss:='T00000';
      if varname='TEMP_FEE_COUNTER' then ss:='T00000';
      if varname='TEMP_FEES_R_COUNTER' then ss:='T00000';
      if varname='TEMP_CREDITNOTE_COUNTER' then ss:='T00000';
      if varname='TEMP_REFERRAL_COUNTER' then ss:='T00000';
      if varname='TEMP_ORDER_COUNTER' then ss:='T00000';
      if varname='TEMP_CUSTOMER_CODE' then ss:='T00000';
      if varname='TEMP_MEMBER_CODE' then ss:='T00000';
      if varname='W_ORDER_COUNTER' then ss:='0000000';
      if varname='S_ORDER_COUNTER' then ss:='0000000';
      if varname='I_ORDER_COUNTER' then ss:='0000000';


      if (varname='INVOICE_COUNTER')
        or (varname='VD_COUNTER')
        or (varname='FEE_COUNTER')
        or (varname='FEES_R_COUNTER')
        or (varname='CREDITNOTE_COUNTER')
        or (varname='REFERRAL_COUNTER')
        or (varname='ORDER_COUNTER')
        or (varname='CUSTOMER_CODE')
        or (varname='MEMBER_CODE')
        or (varname='PROD_CODE')
        or (varname='W_ORDER_COUNTER')
        or (varname='S_ORDER_COUNTER')
        or (varname='I_ORDER_COUNTER')
        then s:=GetNewDocumentNumberFD(
          GetValidInt(Query1.fieldbyname('varvalue').asstring,0),
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME='''+ss+''''))
        else
          s:=Query1.fieldbyname('varvalue').asstring;

      if varname='BARCODE' then
       begin
        newint64:=GetValidInt64(Query1.fieldbyname('varvalue').asstring,0)+1;
        s:=GetValidEAN13(inttostr(newint64)); //Mas devolve um com 13 digitos
       end
      else
       newnum:=GetValidInt(Query1.fieldbyname('varvalue').asstring,0)+1;


     end
    else
     begin

      if varname='INVOICE_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''INVOICE_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''INVOICE_FORMAT'''));
        newnum:=1;
       end;

      if varname='VD_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''VD_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''VD_FORMAT'''));
        newnum:=1;
       end;

      if varname='FEE_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''FEE_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''FEE_FORMAT'''));
        newnum:=1;
       end;

      if varname='FEES_R_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''FEES_R_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''FEES_R_FORMAT'''));
        newnum:=1;
       end;

      if varname='CREDITNOTE_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''CREDITNOTE_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''CREDNOTE_FORMAT'''));
        newnum:=1;
       end;

      if varname='REFERRAL_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''REFERRAL_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''REFERRAL_FORMAT'''));
        newnum:=1;
       end;

      if varname='ORDER_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''ORDER_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''ORDER_FORMAT'''));
        newnum:=1;
       end;

      if varname='CUSTOMER_CODE' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''CUSTOMER_CODE'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''CUSTCODE_FORMAT'''));
        newnum:=1;
       end;

      if varname='MEMBER_CODE' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''MEMBER_CODE'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''MEMBERCOD_FORMAT'''));
        newnum:=1;
       end;

      if varname='PROD_CODE' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''PROD_CODE'',''0'')');
        s:=GetNewDocumentNumberFD(0,
          GetSQLValueFD(Connection,'VALOR','CONFIG','NAME=''PRODCODE_FORMAT'''));
        newnum:=1;
       end;

      if varname='TEMP_INVOICE_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''TEMP_INVOICE_COUNTER'',''0'')');
        s:='T00000';
        newnum:=1;
       end;

      if varname='TEMP_FEES_R_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''TEMP_FEES_R_COUNTER'',''0'')');
        s:='T00000';
        newnum:=1;
       end;

      if varname='TEMP_FEE_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''TEMP_FEE_COUNTER'',''0'')');
        s:='T00000';
        newnum:=1;
       end;


      if varname='TEMP_CREDITNOTE_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''TEMP_CREDITNOTE_COUNTER'',''0'')');
        s:='T00000';
        newnum:=1;
       end;

      if varname='TEMP_REFERRAL_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''TEMP_REFERRAL_COUNTER'',''0'')');
        s:='T00000';
        newnum:=1;
       end;

      if varname='TEMP_ORDER_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''TEMP_ORDER_COUNTER'',''0'')');
        s:='T00000';
        newnum:=1;
       end;

      if varname='TEMP_CUSTOMER_CODE' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''TEMP_CUSTOMER_CODE'',''0'')');
        s:='T00000';
        newnum:=1;
       end;

      if varname='TEMP_MEMBER_CODE' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''TEMP_MEMBER_CODE'',''0'')');
        s:='T00000';
        newnum:=1;
       end;

      if varname='BARCODE' then
       begin
        s:='200000000000'; //Apenas 12 digitos
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''BARCODE'','''+s+''')');
        s:=GetValidEAN13(s); //Mas devolve um com 13 digitos
       end;

      if varname='W_ORDER_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''W_ORDER_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,'0000000');
        newnum:=1;
       end;

      if varname='S_ORDER_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''S_ORDER_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,'0000000');
        newnum:=1;
       end;

      if varname='I_ORDER_COUNTER' then
       begin
        sqlexecuteFD(Connection,'insert into ALL_VARS (varname,varvalue) '+
          'values (''I_ORDER_COUNTER'',''0'')');
        s:=GetNewDocumentNumberFD(0,'0000000');
        newnum:=1;
       end;


     end;
    result:=s;

    if query1.RecordCount>0 then
     begin
      if varname='BARCODE' then
       sqlexecuteFD(Connection,'update ALL_VARS set varvalue='''+inttostr(newint64)+''' where varname='''+varname+'''')
      else
       sqlexecuteFD(Connection,'update ALL_VARS set varvalue='''+inttostr(newnum)+''' where varname='''+varname+'''');
     end;

    Query1.close;
    Query1.Free;

end;

function GetNewDocumentNumberFD(counter: integer; Formato: string): string;
var counterdigits: integer;
    s: string;
begin
    counterdigits:=1;
    if pos('0',formato)>0 then counterdigits:=1;
    if pos('00',formato)>0 then counterdigits:=2;
    if pos('000',formato)>0 then counterdigits:=3;
    if pos('0000',formato)>0 then counterdigits:=4;
    if pos('00000',formato)>0 then counterdigits:=5;
    if pos('000000',formato)>0 then counterdigits:=6;
    if pos('0000000',formato)>0 then counterdigits:=7;
    if pos('00000000',formato)>0 then counterdigits:=8;
    if pos('000000000',formato)>0 then counterdigits:=9;
    if pos('0000000000',formato)>0 then counterdigits:=10;
    if pos('00000000000',formato)>0 then counterdigits:=11;
    if pos('000000000000',formato)>0 then counterdigits:=12;

    s:=stringreplace(Formato,'(YYYY)',formatdatetime('YYYY',now),[rfIgnoreCase]);
    s:=stringreplace(s,'(MM)',formatdatetime('MM',now),[rfIgnoreCase]);
    s:=stringreplace(s,'(DD)',formatdatetime('DD',now),[rfIgnoreCase]);
    s:=stringreplace(s,format('%'+inttostr(counterdigits)+'.'+inttostr(counterdigits)+
                'd',[0]),
                format('%'+inttostr(counterdigits)+'.'+inttostr(counterdigits)+
                'd',[counter+1]),
                [rfIgnoreCase]);
    result:=s;

end;

function GetValueFromConfigFD(Connection: TFDConnection;Variable: string): string;
begin
    result:=GetSQLValueFD(Connection,'VALOR','CONFIG','NAME='''+variable+'''');
end;

procedure SetValueToConfigFD(Connection: TFDConnection;Variable,value: string);
begin
   if GetNumRecordsFD(Connection,'config','NAME='''+Variable+'''')=0 then
    SQLExecuteFD(Connection,'insert into config (NAME,VALOR) values ( '''+Variable+''','''+value+''')')
   else
    SQLExecuteFD(Connection,'update config set VALOR='''+value+''' where NAME='''+Variable+'''');
end;

function GetGENFD(Connection: TFDConnection;GENERATORNAME, TABLENAME: string):string;
var Query1: TFDQuery;
begin
    if GENERATORNAME='' then GENERATORNAME:='GEN_'+uppercase(TABLENAME)+'_ID';

    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Add('select GEN_ID('+GENERATORNAME+',1) as SEQI from rdb$database');
    logwrite(query1.sql.Text);

    try
    Query1.Open;

    if not Query1.Eof then
      result:=inttostr(GetValidInt(Query1.Fields[0].AsString,1))
    else
     result:='';
    except
     Query1.Close;
     result:='';
    end;
    Query1.Free;
end;

function prepareSQL(originalsql: string): string;
begin
 result:=stringreplace(originalsql,'''','''''',[rfReplaceAll ]);
 result:=stringreplace(result,'’','''''',[rfReplaceAll ]);
 result:=stringreplace(result,'‘','''''',[rfReplaceAll ]);

end;

function prepareSQLSize(originalsql: string; ColumnSize: integer): string;
begin
  result:=MidStr(prepareSQL(originalsql),1,ColumnSize);
end;

function GetAllRecordsFD(Connection: TFDConnection;Lista: TStrings;tablename, fieldname, where: string): integer;
var Query1: TFDQuery;
    s: string;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select '+fieldname+' from '+tablename);
    if trim(where)<>'' then
      query1.SQL.Add('where '+where);
    Query1.Open;
    repeat
     s:=Query1.Fields[0].AsString;
     lista.Add(s);
     Query1.Next;
    until Query1.Eof;
    Query1.Free;
    result:=GetNumRecordsFD(connection,tablename,where);
end;

function GetAllRecordsFDFast(Connection: TFDConnection;Lista: TStrings;tablename, fieldname, where: string): integer;
var Query1: TFDQuery;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select list('+fieldname+',ASCII_CHAR(13)) from '+tablename);
    if trim(where)<>'' then
      query1.SQL.Add('where '+where);
    Query1.Open;
    if query1.RecordCount>0 then
     begin
      //lista.Delimiter:=',';
      //lista.DelimitedText:=query1.Fields.Fields[0].AsString;
      lista.Text:=query1.Fields.Fields[0].AsString;
     end;
    FreeAndNil(Query1); //No novo mobile compiler
    result:=GetNumRecordsFD(connection,tablename,where);
end;

function GetAllRecordsTwoFieldsFD(Connection: TFDConnection;Lista: TStrings;tablename, fieldname1, fieldname2, where: string): integer;
var Query1: TFDQuery;
    s1,s2: string;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select '+fieldname1+','+fieldname2+' from '+tablename);
    if trim(where)<>'' then query1.SQL.Add('where '+where);
    Query1.Open;
    repeat
     s1:=stringreplace(Query1.Fields[0].AsString,#10,'',[rfReplaceAll]);
     s1:=stringreplace(s1,#13,'',[rfReplaceAll]);
     s2:=stringreplace(Query1.Fields[1].AsString,#10,'',[rfReplaceAll]);
     s2:=stringreplace(s2,#13,'',[rfReplaceAll]);
     lista.Add(s1);
     lista.Add(s2);
     Query1.Next;
    until Query1.Eof;
    Query1.Free;
end;

function GetTwoFieldsFD(Connection: TFDConnection;tablename,where,fieldname1, fieldname2: string; var fieldvalue1,fieldvalue2:string ): integer;
var Query1: TFDQuery;
begin
    if getnumrecordsFD(connection,tablename,where)>0 then
     begin

    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select '+fieldname1+','+fieldname2+' from '+tablename);
    if trim(where)<>'' then query1.SQL.Add('where '+where);
    Query1.Open;

    fieldvalue1:=Query1.Fields[0].AsString;
    fieldvalue2:=Query1.Fields[1].AsString;

    query1.Free;
    result:=1;
     end
    else
     result:=0;
end;

function GetThreeFieldsFD(Connection: TFDConnection;tablename,where,fieldname1, fieldname2, fieldname3: string; var fieldvalue1,fieldvalue2,fieldvalue3:string ): integer;
var Query1: TFDQuery;
begin

    if getnumrecordsFD(connection,tablename,where)>0 then
     begin

    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select '+fieldname1+','+fieldname2+','+fieldname3+' from '+tablename);
    if trim(where)<>'' then query1.SQL.Add('where '+where);
    Query1.Open;

    fieldvalue1:=Query1.Fields[0].AsString;
    fieldvalue2:=Query1.Fields[1].AsString;
    fieldvalue3:=Query1.Fields[2].AsString;

    query1.Free;
    result:=1;
     end
    else
     result:=0;

end;

function GetFourFieldsFD(Connection: TFDConnection;tablename,where,fieldname1, fieldname2, fieldname3, fieldname4: string;
                      var fieldvalue1,fieldvalue2,fieldvalue3, fieldvalue4: string ): integer;
var Query1: TFDQuery;
begin

    if getnumrecordsFD(connection,tablename,where)>0 then
     begin

    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select '+fieldname1+','+fieldname2+','+fieldname3+','+fieldname4+' from '+tablename);
    if trim(where)<>'' then query1.SQL.Add('where '+where);
    Query1.Open;

    fieldvalue1:=Query1.Fields[0].AsString;
    fieldvalue2:=Query1.Fields[1].AsString;
    fieldvalue3:=Query1.Fields[2].AsString;
    fieldvalue4:=Query1.Fields[3].AsString;

    query1.Free;
    result:=1;
     end
    else
     result:=0;

end;

//Vai devolver apenas uma row...em certos casos é melhor usar um order by
function GetSQLValueFD(Connection: TFDConnection; sqlexp, tablename, where: string):string;
var Query1: TFDQuery;
    s,swhere: string;
    valid: boolean;
begin

//    if Connection=nil then exit;
//
//
//    if getNumRecordsFD(Connection,tablename,where)=0 then
//     begin
//      result:='';
//      exit;
//     end;

    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    //Vai validar o where apenas se tiver = e se a comparacao for vazia
    //Isto apenas para funcionar em debug time
    if trim(where)<>'' then valid:=True
    else valid:=False;
    //estas linhas a seguir estão a cortar o querie a valores vazios? e dá erro sem elas?
    s:=GetStrAfterChar(where,'=');
    if s<>'' then
     begin
      s:=GetStrInsidePlicas(s);
      if s<>'' then valid:=true else valid:=False;
     end;
    //***********************************************
    if valid then swhere:=' where '+where else swhere:='';
    if (Connection.DriverName='SQLite') or (Connection.DriverName='MySQL') then
     Query1.SQL.Add('select '+sqlexp+' from '+tablename+swhere+' LIMIT 1')
    else
     Query1.SQL.Add('select first 1 '+sqlexp+' from '+tablename+swhere);

    //Em run time, vamos proteger contra excepcoes
    try
     Query1.open;
     //para palavras reservadas
     sqlexp:=stringreplace(sqlexp,'"','',[rfReplaceAll]);
     if pos(' as ',sqlexp)>0 then
       sqlexp:=GetStrAfterChar(sqlexp,' as ');
     s:=Query1.fieldbyname(sqlexp).asstring;
    except
     s:='';
    end;

    Query1.free;
    result:=s;

end;

//Vai devolver a row pedida , ex: 1, 2, 3, 4, ......
function GetSQLValueFDRowNumber(Connection: TFDConnection; sqlexp, tablename, where: string; RowNumber:integer):string;
var Query1: TFDQuery;
    s,swhere: string;
    valid: boolean;
begin
 Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    //Vai validar o where apenas se tiver = e se a comparacao for vazia
    //Isto apenas para funcionar em debug time
    if trim(where)<>'' then valid:=True
    else valid:=False;
    //estas linhas a seguir estão a cortar o querie a valores vazios? e dá erro sem elas?
    s:=GetStrAfterChar(where,'=');
    if s<>'' then
     begin
      s:=GetStrInsidePlicas(s);
      if s<>'' then valid:=true else valid:=False;
     end;
    //***********************************************
    if valid then swhere:=' where '+where else swhere:='';
    if Connection.DriverName='SQLite' then
     Query1.SQL.Add('select '+sqlexp+' from '+tablename+swhere+' LIMIT 1 OFFSET '+inttostr(RowNumber-1))
    else
     Query1.SQL.Add('select first 1 skip '+inttostr(RowNumber-1)+sqlexp+' from '+tablename+swhere);

    //Em run time, vamos proteger contra excepcoes
    try
     Query1.open;
     //para palavras reservadas
     sqlexp:=stringreplace(sqlexp,'"','',[rfReplaceAll]);
     if pos(' as ',sqlexp)>0 then
       sqlexp:=GetStrAfterChar(sqlexp,' as ');
     s:=Query1.fieldbyname(sqlexp).asstring;
    except
     s:='';
    end;

    Query1.free;
    result:=s;
end;

//Vai devolver a row pedida , ex: 1, 2, 3, 4, ......
function GetSQLDatetimeFDRowNumber(Connection: TFDConnection; sqlexp, tablename, where,orderby: string; RowNumber:integer):TDateTime;
var Query1: TFDQuery;
    s,swhere: string;
    valid: boolean;
begin
 Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    //Vai validar o where apenas se tiver = e se a comparacao for vazia
    //Isto apenas para funcionar em debug time
    if trim(where)<>'' then valid:=True
    else valid:=False;
    //estas linhas a seguir estão a cortar o querie a valores vazios? e dá erro sem elas?
    s:=GetStrAfterChar(where,'=');
    if s<>'' then
     begin
      s:=GetStrInsidePlicas(s);
      if s<>'' then valid:=true else valid:=False;
     end;
    //***********************************************
    if valid then swhere:=' where '+where else swhere:='';
    if trim(orderby)<>'' then orderby:=' order by '+orderby;

    if Connection.DriverName='SQLite' then
     Query1.SQL.Add('select '+sqlexp+' from '+tablename+swhere+' LIMIT 1 OFFSET '+inttostr(RowNumber-1)+orderby)
    else
     Query1.SQL.Add('select first 1 skip '+inttostr(RowNumber-1)+sqlexp+' from '+tablename+swhere+orderby);

    //Em run time, vamos proteger contra excepcoes
    try
     Query1.open;
     //para palavras reservadas
     sqlexp:=stringreplace(sqlexp,'"','',[rfReplaceAll]);
     if pos(' as ',sqlexp)>0 then
       sqlexp:=GetStrAfterChar(sqlexp,' as ');
     result:=Query1.fieldbyname(sqlexp).AsDateTime;
    except
     result:=EncodeDateTime(2000,1,1,0,0,0,0);
    end;

    Query1.free;

end;

function GetNumRecordsFD( Connection: TFDConnection;tablename,where: string): integer;
begin
  if pos(' order ',where)>0 then
   where:=midstr(where,0,pos(' order ',where));
  result:=strtoint(GetSQLValueFD(Connection,'count(*) as soma', tablename, where));
end;

function SQLExecuteFD(Connection: TFDConnection; sqlstring: string):boolean;
var Query1: TFDQuery;
    T1: TFDTransaction;
begin

//    Connection.ExecSQL(sqlstring);
//    result:=true;


    if not Connection.Connected then begin result:=false; exit; end;


  //  if Connection.InTransaction then Connection.Rollback;

    result:=false;
    try
   // Connection.StartTransaction;

    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add(sqlstring);

    Query1.ExecSQL;
    result:=query1.RowsAffected>0;
    Query1.Close;
    Query1.Free;

   // Connection.Commit;
    finally
     result:=true;
    end;

end;

function GetMaxValueFD(Connection: TFDConnection; tablename, fieldname: string): integer;
var Query1: TFDQuery;
begin
   Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    //***********************************************
    Query1.SQL.Add('select max('+fieldname+') from '+tablename);
    //Em run time, vamos proteger contra excepcoes
    try
     Query1.open;
     result:=Query1.Fields[0].asinteger;
    except
     result:=-1;
    end;
    Query1.free;
end;

function GetSumIntValueFD(Connection: TFDConnection; tablename, fieldname, where: string): integer;
var Query1: TFDQuery;
    sql: string;
begin
   Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    //***********************************************
    sql:=  'select sum('+fieldname+') from '+tablename;
    if where<>'' then sql:=sql+' where '+where;

    Query1.SQL.Add(sql);
    //Em run time, vamos proteger contra excepcoes
    try
     Query1.open;
     result:=Query1.Fields[0].asinteger;
    except
     result:=-1;
    end;
    Query1.free;
end;

function GetMaxDateFD(Connection: TFDConnection; tablename, fieldname,where: string; incdays: integer): Tdate;
var Query1: TFDQuery;
begin
   Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    //***********************************************
    Query1.SQL.Add('select max('+fieldname+') from '+tablename);
    //Em run time, vamos proteger contra excepcoes
    try
     Query1.open;
     result:=Query1.Fields[0].AsDateTime;
    except
     result:=-1;
    end;
    Query1.free;

    if incdays<>0 then
     result:=incday(result,incdays);
end;

function GetMinValueFD(Connection: TFDConnection; tablename, fieldname: string): integer;
var Query1: TFDQuery;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;

    //***********************************************
    Query1.SQL.Add('select min('+fieldname+') from '+tablename);

    //Em run time, vamos proteger contra excepcoes
    try
     Query1.open;
     result:=Query1.Fields[0].asinteger;
    except
     result:=-1;
    end;

    Query1.free;
end;

function GetMaxFieldValueFD(Connection: TFDConnection;tablename, fieldname,where: string): integer;
var Query1: TFDQuery;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select max('+fieldname+') as maximo from '+tablename);
    if where<>'' then
     Query1.SQL.Add(' where '+where);
    Query1.Open;
    if query1.RecordCount>0 then
     result:=GetValidInt(Query1.FieldByName('maximo').AsString,0)
    else
     result:=0;
    Query1.Free;
end;

function GetMinFieldValueFD(Connection: TFDConnection;tablename, fieldname,where: string): integer;
var Query1: TFDQuery;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select min('+fieldname+') as minimo from '+tablename);
    if where<>'' then
     Query1.SQL.Add(' where '+where);
    Query1.Open;
    if query1.RecordCount>0 then
     result:=GetValidInt(Query1.FieldByName('minimo').AsString,0)
    else
     result:=0;
    Query1.Free;
end;

procedure GetRowDataFD(Connection: TFDConnection;var colunas: TStringList; Query: string);
var cd: TFDquery;
    i: integer;
begin
  try

    cd:=TFDquery.Create(nil);
    cd.Connection:=Connection;
    cd.SQL.Text:=query;
    cd.Open;
    if cd.RecordCount=1 then
     begin
      for i := 0 to cd.FieldCount - 1 do
       colunas.Add(cd.Fields.Fields[i].FieldName+'='+
          cd.FieldByName(cd.Fields.Fields[i].FieldName).AsString);
     end;
    cd.Close;
    cd.Free;
    //sqlconn.Execute(Query,nil,@ResultSet);
  finally
  end;

end;

//Vai colocar comandos para tirar indivíduo de todos os devices
procedure DBRemovePeopleFD(Connection: TFDConnection; PeopleEnroll: string );
var DevList: TStringList;
    i: integer;
    peoplename,peopleid: string;
begin
      //E manda a ordem para todos os devices autorizados
      //ADD PEOPLE {devicename||ALL} PEOPLE_NUMBER PEOPLE_NAME
      peoplename:=getSQLValueFD(Connection,'FIRST_NAME','PEOPLE',
          'PEOPLE_NUMBER='''+ PeopleEnroll+'''');
      peopleid:=getSQLValueFD(Connection,'ID','PEOPLE','PEOPLE_NUMBER='''+
                                      PeopleEnroll+'''');
      DevList:=TStringList.Create;
      GetAllAllowedDeviceFD(Connection,DevList,PeopleID);
      for i := 0 to DevList.Count-1 do
       begin
        if DevList[i]<>'' then
        SQLExecuteFD(Connection,'insert into DEVICE_ORDERS (ID,DEVICE_ID,'+
                 'ORDER_ARRAY,ORDER_PROCESSED) values (null,'+DevList[i]+
                 ',''DEL PEOPLE ALL '+PeopleEnroll+''',''N'')');
       end;

      DevList.Free;
end;

//Vai Dar acesso à pessoa para aquele device. Propaga também para o device
procedure DBGiveAccesstoDeviceFD(Connection: TFDConnection; PeopleID, DeviceID: string);
var peoplenumber:string;
    q1: TFDQuery;
begin
    peoplenumber:=getSQLValueFD(Connection, 'PEOPLE_NUMBER','PEOPLE',
         'ID='+PeopleID);
    SQLEXecuteFD(Connection,'insert into PEOPLE_ACCESS (PEOPLE_ID,DEVICE_ID)'+
       'values ('+peopleID+','+deviceID+')');

    //A pessoa pode ter dedos
    q1:=TFDQuery.Create(nil);
    q1.Connection:=Connection;
    q1.SQL.Text:='Select * from PEOPLE_FINGERS where PEOPLE_NUMBER='+peoplenumber;
    q1.Open;
    while not q1.Eof do
     begin
      SQLEXecuteFD(Connection,'insert into DEVICE_ORDERS (ID,DEVICE_ID,ORDER_ARRAY,'+
               'ORDER_PROCESSED,ORDER_STRING,CREATED_DATETIME)'+
              'values(null,'+deviceid+',''ADD FINGER ALL '+peoplenumber+
              ''',''N'','''+q1.FieldByName('FINGER_INDEX').AsString+
              ''',CURRENT_TIMESTAMP)'
      );
      q1.Next;
     end;
     q1.Close;

     // e também cartões
     q1.SQL.Text:='Select * from CARDS where PEOPLE_ID='+PeopleID;
    q1.Open;
    while not q1.Eof do
     begin
      SQLEXecuteFD(Connection,'insert into DEVICE_ORDERS (ID,DEVICE_ID,ORDER_ARRAY,'+
               'ORDER_PROCESSED,ORDER_STRING,CREATED_DATETIME)'+
              'values(null,'+deviceid+',''ADD CARD ALL '+peoplenumber+
              ''',''N'','''+q1.FieldByName('CARD_INTERNAL_NUMBER').AsString+
              ' '+q1.FieldByName('NAME_ON_CARD').AsString +
              ''',CURRENT_TIMESTAMP)'
      );
      q1.Next;
     end;
     q1.Close;

     //E cartões secundários
     q1.SQL.Text:='Select * from PEOPLE_SECONDARY where PEOPLE_NUMBER='''+peoplenumber+'''';
     q1.Open;
     while not q1.Eof do
      begin
       SQLEXecuteFD(Connection,'insert into DEVICE_ORDERS (ID,DEVICE_ID,ORDER_ARRAY,'+
               'ORDER_PROCESSED,ORDER_STRING,CREATED_DATETIME)'+
              'values(null,'+deviceid+',''ADD CARD ALL '+q1.FieldByName('SECONDARY_NUMBER').AsString+
              ''',''N'','''+q1.FieldByName('CARD_INTERNAL_NUMBER').AsString+
              ' '+q1.FieldByName('NAME_ON_CARD').AsString +
              ''',CURRENT_TIMESTAMP)'
      );
      q1.Next;
      end;
     q1.Close;

     q1.Free;

end;

procedure DBRemoveAccessfromDeviceFD(Connection: TFDConnection; PeopleID, DeviceID: string);
var peoplenumber:string;
    q1: TFDQuery;
begin
    peoplenumber:=getSQLValueFD(Connection, 'PEOPLE_NUMBER','PEOPLE',
         'ID='+PeopleID);
    SQLEXecuteFD(Connection,'DELETE from  PEOPLE_ACCESS where PEOPLE_ID='+
         peopleID+' and DEVICE_ID='+deviceID);

    SQLEXecuteFD(Connection,'insert into DEVICE_ORDERS (ID,DEVICE_ID,ORDER_ARRAY,'+
               'ORDER_PROCESSED,CREATED_DATETIME)'+
              'values(null,'+deviceid+',''DEL PEOPLE '+peoplenumber+
              ''',''N'',CURRENT_TIMESTAMP)');
end;

//Envia comandos para inserir indivíduo nos devices para os quais está configurado
procedure DBPropagatePeopleFD(Connection: TFDConnection; PeopleEnroll: string );
var DevList: TStringList;
    i: integer;
    peoplename,peopleid: string;
begin
      //E manda a ordem para todos os devices autorizados
      //ADD PEOPLE {devicename||ALL} PEOPLE_NUMBER PEOPLE_NAME
      //
      peoplename:=getSQLValueFD(Connection,'FIRST_NAME','PEOPLE','PEOPLE_NUMBER='''+
                                      PeopleEnroll+'''');
      peopleid:=getSQLValueFD(Connection,'ID','PEOPLE','PEOPLE_NUMBER='''+
                                      PeopleEnroll+'''');
      DevList:=TStringList.Create;
      GetAllAllowedDeviceFD(Connection,DevList,PeopleID);
      for i := 0 to DevList.Count-1 do
       begin
        if DevList[i]<>'' then
        SQLExecuteFD(Connection,'insert into DEVICE_ORDERS (ID,DEVICE_ID,'+
                 'ORDER_ARRAY,ORDER_STRING,ORDER_PROCESSED) values (null,'+DevList[i]+
                 ',''ADD PEOPLE ALL '+PeopleEnroll+''','''+peoplename+''',''N'')');
       end;

      DevList.Free;

end;


procedure DBRemovePeopleFingerFD(Connection: TFDConnection; PeopleID: string );
begin

end;

//Vai buscar os direitos do utilizador
//QuestionRights=PEOPLE / ACCESS / COMPANY_EVENTS / FRONTOFFICE_SHOP / Etc
//Devolve se pode Read/Write/Insert/Delete
//Nas versões mais simples (LITE) esta função não deve ser chamada
function GetUserRightsFD(Connection: TFDConnection; UserID: integer; QuestionRights: string; Var R,W,I,D: boolean):boolean;
var s: string;
begin
    s:=GetSQLValueFD(Connection,QuestionRights+'_RWID','USER_RIGHTS','USER_ID='+inttostr(UserID));
    if length(s)=4 then
     begin
      R:=GetValidBool(s[1]);
      W:=GetValidBool(s[2]);
      I:=GetValidBool(s[3]);
      D:=GetValidBool(s[4]);
     end
    else
    //Se não está nada configurado, então não tem acesso
     begin
      R:=False;
      W:=False;
      I:=False;
      D:=False;
     end;
    result:=true;
end;

//Vai processar as férias indicadas como não usadas mas apenas até ao dia de ontem
//Se existirem vai marcar como marcada ou não dependendo se a pessoa veio trabalhar
//USED=0 não utilizou ainda, USED=1 Utilizou não vindo trabalhar
//USED=E  , Erro, não devia ter vindo trabalhar
function ProcessHollidaysFD(Connection: TFDConnection; ProgressBar: TProgressBar): boolean;
var howmany,cursor: integer;
    myquery: TFDQuery;
    Enroll: string;
begin
      howmany:=GetNumRecordsFD(Connection,'HOLLIDAYS','USED=''0'' and '+
       'DAY_OFF<cast(''Now'' as date)');
    ProgressBar.Max:=howmany;
    ProgressBar.Min:=0;

    myquery:=TFDQuery.Create(nil);
    myquery.Connection:=Connection;
    myquery.SQL.Text:='select * from HOLLIDAYS where USED=''0'' and '+
       'DAY_OFF<cast(''Now'' as date)';
    myquery.Open;

    cursor:=0;
    while not myquery.Eof do
     begin
      cursor:=cursor+1;
      ProgressBar.Position:=cursor;
      application.ProcessMessages;

      //PEOPLE_LOG está a usar o People_number apenas
      Enroll:=GetSQLValueFD(Connection,'PEOPLE_NUMBER','PEOPLE',
          'ID='+myquery.FieldByName('PEOPLE_ID').AsString);

      if GetNumRecordsFD(Connection,'PEOPLE_LOG','PEOPLE_NUMBER='''+
         Enroll+''' and DATETIME like '''+
           formatdatetime('YYYY-MM-DD',
           myquery.FieldByName('DAY_OFF').AsDateTime)+'%''')=0
      then
        //Não veio nesse dia, logo utilizamos o dia
         sqlExecuteFD(Connection,'update Hollidays set USED=''1'' where '+
            'people_id='+myquery.FieldByName('PEOPLE_ID').AsString+
            ' and DAY_OFF='''+FDdate(myquery.FieldByName('DAY_OFF').AsDateTime)+'''')
       else
        //Não devia ter vindo trabalhar
        sqlExecuteFD(Connection,'update Hollidays set USED=''E'' where '+
            'people_id='+myquery.FieldByName('PEOPLE_ID').AsString+
            ' and DAY_OFF='''+FDdate(myquery.FieldByName('DAY_OFF').AsDateTime)+'''');

      myquery.Next;
     end;


    myquery.Free;


end;

function GetAllDevicesFD(Connection: TFDConnection; DevList,DevDescription: TStringList): boolean;
var Query1: TFDQuery;
    s: string;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Add('select * from devices where ENABLED=''T''');
    Query1.Open;
    repeat
      DevList.Add(Query1.FieldByName('ID').AsString);
      DevDescription.Add(Query1.FieldByName('DESCRIPTION').AsString);
      Query1.Next;
    until Query1.Eof;

    Query1.close;
    Query1.free;
    result:=true;
end;

function GetAllAllowedDeviceFD(Connection: TFDConnection; DevList: TStringList; PeopleID:string): boolean;
var Query1: TFDQuery;
    s,groupID: string;
    c: integer;
begin
 result:=false;

    //Primeiro vamos ver se a pessoa tem permissões individuais
    if getNumRecordsFD(Connection,'people_access, devices',
       'devices.id=people_access.device_id '+
          'and  people_id='+PEOPLEID)>0 then
     begin
      Query1:=TFDQuery.Create(nil);
      Query1.Connection:=Connection;
      Query1.SQL.Add('select * from people_access, devices '+
          'where devices.id=people_access.device_id '+
          'and  people_id='+PEOPLEID);
      Query1.Open;
      c:=0;
      repeat
        DevList.Add(Query1.FieldByName('ID').AsString);
        Query1.Next;
        c:=c+1;
      until Query1.Eof;

      Query1.close;
      Query1.free;

      if c>0 then
        result:=true;

     end
    else
     begin
      //Ou se tem por grupo
      groupID:=GetSQLValueFD(Connection,'GROUP_ID','PEOPLE','ID='+PeopleID);
      if groupID<>'' then
       result:=GetAllGroupAllowedDeviceFD(Connection,DevList,groupID);
     end;

end;

function GetAllGroupAllowedDeviceFD(Connection: TFDConnection; DevList: TStringList; GroupID:string): boolean;
var Query1: TFDQuery;
    s: string;
    c: integer;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Add('select * from people_group_access, devices '+
          'where devices.id=people_group_access.device_id '+
          'and  group_id='+GroupID);
    Query1.Open;
    c:=0;
    repeat
      DevList.Add(Query1.FieldByName('ID').AsString);
      Query1.Next;
      c:=c+1;
    until Query1.Eof;

    Query1.close;
    FreeAndNil(query1); //No novo mobile compiler

    if c>0 then
     result:=true
    else
     result:=false;
end;

function DBGeneratePeopleFD(Connection: TFDConnection; PEOPLE_NUMBER:integer): string;
var newGEN: string;
    i: integer;
begin
   newGEN:=GetGENFD(Connection,'GEN_PEOPLE_ID','PEOPLE');
   SQLExecuteFD(Connection,'insert into PEOPLE '+
      '(ID,FIRST_NAME,MIDDLE_NAME,LAST_NAME,TAX_NUMBER,BIRTH_DATE,'+
      'HOME_ADDRESS,HOME_STATE,HOME_POSTAL_CODE,HOME_POSTAL_CITY,BI,'+
      'LICENCE_NUMBER,CIVIL_STATE,SEX,'+
      'MOBILE_PHONE,HOME_PHONE,EMAIL,IS_EMPLOYEE,IS_STUDENT,IS_MEMBER,'+
      'IS_GUEST,IS_TEACHER,IS_DEALER,IS_PARENT,IMAGEM,PEOPLE_NUMBER) '+
      'values ('+newGEN+','+
      ''''','''','''','''',null,'''','''','''','''','''','+
      ''''','''',null,'+
      ''''','''','''',''N'',''N'',''N'',''N'',''N'',''N'',''N'',null,'+
      inttostr(PEOPLE_NUMBER)+')'
      );
   result:=newGen;
end;

//Vai processar registos lidos dos terminais e agora em PEOPLE_LOGS
//E atualizar tabelas PEOPLE_DAY e PEOPLE_NOW
//Vai atualizar estado do processamento no FormCommunicating
function ProcessPeopleLogsFD(Connection: TFDConnection; ProgressBar: TProgressBar):boolean;
var max,actual,peoplecount,i: integer;
    people,childrenlist: TStringList;
    Query1: TFDQuery;
    daytime: TDateTime;
    minutespresent,totalMins: integer;
    lastperiod,status: char ;
    firsttime,lasttime: TDateTime; //era TTime
    LastTimeIn,LastTimeOut: TDateTime; //era TTime
    LastEvent,FirstEvent: char;
    havechildren: boolean; //Se o indivíduo é pai com miúdos pelo braço
    peopleid,parentid,pnumber: string;  //Para introduzir também as crianças
    mainclock,secclock: string;
    canprocess: boolean;
begin
   //Quantos registos a processar?
   max:=GetNumRecordsFD(Connection,'PEOPLE_LOG','processed=''F'' or processed=''0''');
   childrenlist:=TStringList.Create;

   ProgressBar.Max:=max;
   ProgressBar.Position:=0;

   //Quantos individuos a calcular?
   people:=TStringList.Create;
   GetAllRecordsFD(Connection,people,'PEOPLE_LOG',
                                   'distinct people_number as people',
                                   '(processed=''F'' or processed=''0'')');

   //LogWrite('Processing '+inttostr(max)+' People Logs for '+inttostr(people.Count)+' People');

   Query1:=TFDQuery.Create(nil);
   Query1.Connection:=Connection;
   //E vai percorrer todos os indivíduos nesse lote a processar
   for i := 0 to people.Count-1 do
    begin

     //People_Number em People[i]
     peopleid:=getSQLValueFD(Connection,'ID','PEOPLE','PEOPLE_NUMBER='''+people[i]+'''');

     //Se não existir, então salta este people
     if peopleid='' then
      begin
       //Atualiza como processado
       ProgressBar.Position:=ProgressBar.Position+GetnumrecordsFD(Connection,'PEOPLE_LOG','PEOPLE_NUMBER='''+people[i]+''' and PROCESSED=''F''');
       SQLExecuteFD(Connection,'update PEOPLE_LOG set processed=''E'' where PEOPLE_NUMBER='''+people[i]+
            ''' and (PROCESSED=''F'' or processed=''0'')');
       continue;
      end;


     Query1.Close;
     Query1.SQL.Text:='select * from people_log  where (processed=''F'' or processed=''0'') '+
                      'and people_number='''+people[i]+''' order by DATETIME';
     Query1.open;

     //Apenas para o Lilliput e Scholl
     //Vai ver se é pai e se tem filhos
     if GETSqlValueFD(Connection,'IS_PARENT','PEOPLE','PEOPLE_NUMBER='''+people[i]+'''' )='Y' then
      begin
       parentid:=peopleid;
       if GetNumRecordsFD(Connection,'STUDENT_HAS_PARENT','PARENT_ID='+parentid)>0
        then begin
              havechildren:=true;
              childrenlist.Clear;
              GetAllRecordsFD(Connection,childrenlist,
                'student_has_parent shp,people p',
                'p.id as peopleid',
                'p.id=shp.student_id and shp.parent_id='+parentid);
             end
        else havechildren:=False;
      end
     else havechildren:=False;

     while not query1.Eof do
      begin
       //Vai ver o dia e a hora que existe para registar
       daytime:=FDDateTime2DateTime(Query1.FieldByName('DATETIME').AsString);

       //02-05-2017 Se fôr funcionário e se apenas verificamos o relógio, ignorando o resto
       mainclock:=GETSqlValueFD(Connection,'MAIN_TIMECLOCK','PEOPLE','PEOPLE_NUMBER='''+people[i]+'''' );
       secclock:=GETSqlValueFD(Connection,'SEC_TIMECLOCK','PEOPLE','PEOPLE_NUMBER='''+people[i]+'''' );

       if mainclock='-1' then canprocess:=true
       else
        if (mainclock=Query1.FieldByName('DEVICE_ID').AsString) or (secclock=Query1.FieldByName('DEVICE_ID').AsString) then
         canprocess:=True
        else canprocess:=False;

      if not canprocess then             //Salta o loop para o próximo
       begin
        //Atualiza na mesma como processado
        SQLExecuteFD(Connection,'update PEOPLE_LOG set processed=''1'' where id='+query1.FieldByName('ID').AsString);
        ProgressBar.Position:=ProgressBar.Position+1;
        //((progressbar.Parent as TRectangle).Parent as TForm).Invalidate;
        Application.ProcessMessages;
        query1.Next;
        continue;
       end;

       //Vai ver se o dia não existe
       if not GetPeopleDayInfoFD(Connection,strtoint(peopleid),
                 daytime,minutespresent,lastperiod,status,
                  firsttime,lasttime,LastEvent,FirstEvent)
       then begin
             NewPeopleDayFD(Connection,strtoint(peopleid),daytime);
             if havechildren then
              NewChildrenDayFD(Connection,childrenlist,daytime);

             minutespresent:=0;
             totalMins:=0; //20180620
        		 firsttime:=daytime;
        		 lasttime:=daytime;
        		 firstevent:='I'; //Entrada
        		 lastevent:='I';  //Entrada
        		 lastperiod:='?'; //Ainda não está definido
       			 status:='W'; //Fica à espera de saída
             LastTimeIn:=daytime;
             //LastTimeOut  não interessa agora
            end
       else begin
             //Quanto tempo passou desde a última entrada?
             //Passou menos de 3 minutos? É repetição, mas atualiza hora
             if minutesbetween(daytime,lasttime)<=3 then
              begin
               //Troquei totalMins por minutespresent
               //totalMins:=totalMins+minutesbetween(daytime,lasttime); //Vai contando intervalos apenas
               minutespresent:=minutespresent+minutesbetween(daytime,lasttime); //Vai contando intervalos apenas
               UpdatePeopleDayFD(Connection, strtoint(peopleid), daytime,
                  minutespresent,'1',' ',
                  LastEvent,FirstEvent ,lastperiod,'W',
                  firsttime,daytime,'');
               if havechildren then
                UpdateChildrenDayFD(Connection,childrenlist, daytime,
                  minutespresent,'1',' ',
                  LastEvent,FirstEvent ,lastperiod,'W',
                  firsttime,daytime,'');
              end
             else
             //Se passou mais de 2 minutos, temos que registar como entrada ou como saída
              begin
               //O anterior registo foi entrada?
               if LastEvent='I' then
                begin
                 //Vai registar uma saída
                 lastevent:='O';  //Saída
                 lastperiod:='I'; //Esteve dentro
                 status:='P'; //Processou sem problemas
                 LastTimeOut:=daytime; //última saída
                 LastTimeIn:=lasttime;
                 //O tempo de permanência aumentou
                 totalMins:=minutesbetween(daytime,LastTimeIn);
                 minutespresent:=minutespresent+totalMins;

                end
               else
               //o anterior registo foi saída
                begin
                 //Vai registar uma entrada
                 lastevent:='I';  //Entrada
                 lastperiod:='O'; //Esteve fora
                 status:='R'; //Voltou a entrar, reentrou
                 LastTimeIn:=Daytime; //ùltima entrada
                 LastTimeOut:=lasttime;
                 //Não aumenta o tempo de permanência
                 //Mas vai aumentar o break time
                 NewPeopleBreakFD(Connection,strtoint(peopleid),daytime,
                    LastTimeOut,daytime);


                end;

               UpdatePeopleDayFD(Connection,strtoint(peopleid),daytime,
                  minutespresent,'1',' ',
                 LastEvent,FirstEvent ,lastperiod,status,
                 firsttime, daytime,'');
               if havechildren then
                UpdateChildrenDayFD(Connection,childrenlist,daytime,
                  minutespresent,'1',' ',
                 LastEvent,FirstEvent ,lastperiod,status,
                 firsttime, daytime,'');

              end;



            end;

       //Atualiza como processado
       SQLExecuteFD(Connection,'update PEOPLE_LOG set processed=''1'' where id='+query1.FieldByName('ID').AsString);
       ProgressBar.Position:=ProgressBar.Position+1;
       //((progressbar.Parent as TRectangle).Parent as TForm).Invalidate;
       Application.ProcessMessages;


       query1.Next;
      end;  //while not query1.Eof do


    end; //End FOR
   Query1.Close;

   FreeAndNil(childrenlist); //No novo mobile compiler
   FreeAndNil(people); //No novo mobile compiler

   result:=true;

end;

//Vai alterar as tabelas de logs para estado por processar de acordo com
//datas e pessoa(opcional)
function ReprocessPeopleLogsFD(Connection: TFDConnection; FromDate,ToDate: TDate; Enroll: String):boolean;
var whereEnroll: string;
begin
    if Enroll<>'' then whereEnroll:=' and PEOPLE_NUMBER='''+Enroll+''''
                  else whereEnroll:='';

    sqlexecuteFD(Connection,'delete from people_day where "DAY">='''+
        FDdate(fromdate)+''' and "DAY"<='''+FDdate(todate)+''''+whereEnroll);
    sqlexecuteFD(Connection,'delete from people_breaks where "DAY">='''+
        FDdate(fromdate)+''' and "DAY"<='''+FDdate(todate)+''''+whereEnroll);
    sqlexecuteFD(Connection,'update people_log set processed=''0'' where "DATETIME">='''+
        FDdate(fromdate)+''' and "DATETIME"<'''+FDdate(incday(todate,1))+''''+whereEnroll);

    result:=true;

end;


procedure FillCombosFD( TheForm:TForm; Connection: TFDConnection; INFOSTRING: TArray<String>; lang: string);
var i: integer;
    ds: TStringDynArray;
    s,tempcombo,nomecampo,NomeEdit,tipodeedit,fname,tname: string;
    tempObj: TComponent;
begin
  //Vai preencher as combos de forma automática no form


  for i := 0 to length(INFOSTRING)-1 do
     begin
       ds:=SplitString(INFOSTRING[i],'#');
       NomeEdit:=ds[0];
       nomecampo:=ds[1]; //Pode ser função
       tipodeedit:=ds[2]; //n=numeric,f=decimal,s=string,c=combo,i=image,b=checkbox, d=date


       if tipodeedit='c' then
        begin
         tempObj:=TheForm.FindComponent(NomeEdit);

         tempcombo:=ds[3]; //qual a tabela a que se refere?
         (tempObj as TComboBox).Clear;
         //(tempObj as TscComboBox).Clear;

         if lang='EN' then FNAME:='DESCRIPTION_EN'  else
         if lang='FR' then FNAME:='DESCRIPTION_FR'  else
         if lang='ES' then FNAME:='DESCRIPTION_ES'
         else FNAME:='DESCRIPTION_PT';

         //Algumas correções
         if (tempcombo='TITLE')
         or (tempcombo='SEX')
         then if FNAME='DESCRIPTION_PT' then FNAME:='DESCRIPTION';

         if (tempcombo='DEPARTMENT')
         then
          if (FNAME='DESCRIPTION_PT') or (FNAME='DESCRIPTION_EN')
          or (FNAME='DESCRIPTION_ES') or (FNAME='DESCRIPTION_FR')
           then FNAME:='DESCRIPTION';

         if tempcombo='TITLE' then tname:='TITLES';
         if tempcombo='SEX' then tname:='SEX';
         if tempcombo='DEPARTMENT' then tname:='DEPARTMENTS';
         if tempcombo='JOB' then tname:='JOB_FUNCTIONS';
         if tempcombo='DEGREE' then tname:='GRADUATION_DEGREE';
         if tempcombo='CIVILSTATE' then tname:='CIVIL_STATE';
         if tempcombo='CONTRACT' then tname:='CONTRACT_TYPE';
         if tempcombo='VEHICLE_BRANDS' then
          begin
           tname:='VEHICLE_BRANDS';
           Fname:='BRAND_DESCRIPTION';
          end;


         //GetAllRecordsIB(Database,(tempObj as TscComboBox).Items,tname, FNAME ,'');
         GetAllRecordsFD(Connection,(tempObj as TComboBox).Items,tname, FNAME ,'');


        end;


     end;


end;

//Vai preencher um form com edits, combos, check, etc a partir de um query
//e de comandos de como preencher
function FillFormFD(TheForm:TForm;Connection: TFDConnection;SQLQuery: string;INFOSTRING: TArray<String>; lang: string):boolean;
var Query1: TFDQuery;
    lista: TStringList;
    i,j: integer;
    ds: TStringDynArray;
    s,nomecampo,NomeEdit,tipodeedit,returnfield,tablename,remotefield,specialcodes,fname: string;
    tempObj: TComponent;
    blob: TStream;
    isnotempty: boolean;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Text:=SQLQuery;
    query1.Open;

    if query1.RecordCount<1 then
     begin
       result:=false;
       isnotempty:=false;
       //exit;
     end
    else
     begin
       isnotempty:=true;
     end;


    //Cada linha tem  NomeEdit#nomecampo#tipodeedit ( n=numeric,d=decimal,s=string,c=combo,i=image,b=checkbox)#specialcodes
    //special codes ->  t-translate
    //ex1: 'BioCodeEdit#PEOPLE_ID#n'
    //Uma combo funciona assim GET( returnfield, tablename, remotefield, nomecampo)
    //ex 'ComboTitle#GET(DESCRIPTION,TITLES,ID,TITLE_ID)#c#t'
    //ex 'CheckActive#IS_ACTIVE#b'
    //ex 'EditName#FIRST_NAME#s'
    //ex 'Photo#IMAGEM#i'
    for i := 0 to length(INFOSTRING)-1 do
     begin
       ds:=SplitString(INFOSTRING[i],'#');
       NomeEdit:=ds[0];
       nomecampo:=ds[1]; //Pode ser função
       tipodeedit:=ds[2]; //n=numeric,d=decimal,s=string,c=combo,i=image,b=checkbox
       if length(ds)>3 then specialcodes:=ds[3] else specialcodes:='';

       tempObj:=TheForm.FindComponent(NomeEdit);

       // TEDIT
       if tipodeedit='s' then
        if isnotempty then
         (tempObj as TEdit).Text:=query1.FieldByName(nomecampo).AsString
        else
         (tempObj as TEdit).Text:='';
       // TMEMO
       if tipodeedit='S' then
        if isnotempty then
         (tempObj as TMemo).Lines.Text:=query1.FieldByName(nomecampo).AsString
        else
         (tempObj as TMemo).Lines.Text:='';
       //NUMERIC
       if tipodeedit='n' then
         if isnotempty then
          (tempObj as TFloatEdit).Value:=query1.FieldByName(nomecampo).AsSingle
         else
          (tempObj as TFloatEdit).Value:=0;
       //CHECK BOX
       if tipodeedit='b' then
        begin
         if isnotempty then
          begin
           if ((query1.FieldByName(nomecampo).AsString='Y') or (query1.FieldByName(nomecampo).AsString='1'))
            then
             (tempObj as TCheckBox).Checked:=true
            else
             (tempObj as TCheckBox).Checked:=false;
          end
          else
           (tempObj as TCheckBox).Checked:=false;
        end;
       //TIMAGE
       if tipodeedit='i' then
        if isnotempty then
        if not Query1.FieldByName(nomecampo).IsNull then
         begin


          blob := Query1.CreateBlobStream(Query1.FieldByName(nomecampo),bmRead);

          try
            (tempObj as TImage).Picture.LoadFromStream(blob);

          finally
           FreeAndNil(blob); //No novo mobile compiler

          end;
         end
        else
        (tempObj as TImage).Picture:=nil;
       //TDATEEDIT
       if tipodeedit='d' then
        if isnotempty then
         begin
          if Query1.FieldByName(nomecampo).AsString='' then  (tempObj as TDateTimePicker).Date:=today
          else
          (tempObj as TDateTimePicker).Date:=FDDate2Date(Query1.FieldByName(nomecampo).AsString);
         end;
       //TCOMBOEDIT
       if tipodeedit='c' then
        if isnotempty then
         begin
          if lang='EN' then FNAME:='DESCRIPTION_EN'
          else
          if lang='FR' then FNAME:='DESCRIPTION_FR'
          else
          if lang='ES' then FNAME:='DESCRIPTION_ES'
          else FNAME:='DESCRIPTION_PT';

          if Query1.FieldByName(nomecampo).AsString='' then
           begin
            (tempObj as TComboBox).ItemIndex:=-1;
            (tempObj as TComboBox).Text:='';
           end
          else
           begin

            if specialcodes='TITLE' then
             begin
              if FNAME='DESCRIPTION_PT' then FNAME:='DESCRIPTION'; //Pequena correçao
              s:=GetSQLValueFD(Connection,FNAME,'TITLES','ID='''+Query1.FieldByName(nomecampo).AsString+'''');
             end;
            if specialcodes='SEX' then
             begin
              if FNAME='DESCRIPTION_PT' then FNAME:='DESCRIPTION'; //Pequena correçao
              s:=GetSQLValueFD(Connection,FNAME,'SEX','KEY='''+Query1.FieldByName(nomecampo).AsString+'''');
             end;
            if specialcodes='JOB' then s:=GetSQLValueFD(Connection,FNAME,'JOB_FUNCTIONS','ID='''+Query1.FieldByName(nomecampo).AsString+'''');
            if specialcodes='DEPARTMENT' then s:=GetSQLValueFD(Connection,'DESCRIPTION','DEPARTMENTS','ID='''+Query1.FieldByName(nomecampo).AsString+'''');
            if specialcodes='DEGREE' then s:=GetSQLValueFD(Connection,FNAME,'GRADUATION_DEGREE','ID='''+Query1.FieldByName(nomecampo).AsString+'''');
            if specialcodes='CIVILSTATE' then s:=GetSQLValueFD(Connection,FNAME,'CIVIL_STATE','KEY='''+Query1.FieldByName(nomecampo).AsString+'''');
            if specialcodes='CONTRACT' then s:=GetSQLValueFD(Connection,FNAME,'CONTRACT_TYPE','KEY='''+Query1.FieldByName(nomecampo).AsString+'''');

            if specialcodes='MARCAS' then s:=GetSQLValueFD(Connection,'DESCRIPTION','MARCAS','ID='''+Query1.FieldByName(nomecampo).AsString+'''');

            if specialcodes='COUNTRIES' then s:=GetSQLValueFD(Connection,'COUNTRY_NAME','COUNTRIES','ID='''+Query1.FieldByName(nomecampo).AsString+'''');
            if specialcodes='PRODUCT_TYPES' then s:=GetSQLValueFD(Connection,'DESCRIPTION','PRODUCT_TYPES','KEY='''+Query1.FieldByName(nomecampo).AsString+'''');
            if specialcodes='PRODUCT_GRIDS' then s:=GetSQLValueFD(Connection,'GRIDLINE_NAME','PRODUCT_GRIDS','ID='''+Query1.FieldByName(nomecampo).AsString+'''');
            if specialcodes='PRODUCT_CONDITION' then GetSQLValueFD(Connection,FNAME,'PRODUCT_CONDITION','KEY='''+Query1.FieldByName(nomecampo).AsString+'''');
            if specialcodes='STOCK_STATUS' then s:=GetSQLValueFD(Connection,'DESCRIPTION','STOCK_STATUS','ID='''+Query1.FieldByName(nomecampo).AsString+'''');
            if specialcodes='DISCOUNT_LEVELS' then s:=GetSQLValueFD(Connection,'DISCOUNT_PERCENT','DISCOUNT_LEVELS','LEVEL_KEY='''+Query1.FieldByName(nomecampo).AsString+'''');


            j:=(tempObj as TComboBox).Items.IndexOf(s);
            (tempObj as TComboBox).ItemIndex:=j;
           end;

         end;

     end;


    FreeAndNil(Query1); //No novo mobile compiler
    result:=true;

end;

//Vai copiar o blob field de uma tabela para outra com o mesmo nome numa BD diferente
function ReplicateBlobFD(Connection1,Connection2: TFDConnection;tablename,fieldname,where:string):boolean;
var blob1,blob2: TStream;
    Table1: TFDTable;
    Query1: TFDQuery;
    data: array of byte;
    mem: TMemoryStream;
begin
  Query1:=TFDQuery.Create(nil);
  Query1.Connection:=Connection1;
  Query1.SQL.Add('select '+fieldname+' from '+tablename);
  if trim(where)<>'' then
     Query1.SQL.Add('where '+where);
  Query1.Open;
  if query1.RecordCount>0 then
   begin

      blob1 := Query1.CreateBlobStream(Query1.FieldByName(fieldname),bmRead);
      setlength(data,blob1.Size);
      mem:=Tmemorystream.Create;
      mem.LoadFromStream(blob1);

      try
        //MyBitmap.LoadFromStream(blob);
        //Connection2.StartTransaction;
        Table1:=TFDTable.Create(nil);
        //Table1.CachedUpdates:=True;
        Table1.Connection:=Connection2;
        Table1.TableName:=tablename;
        Table1.Open;
        Table1.Filter:=where;
        Table1.Filtered:=true;
        Table1.Edit;

        blob2 := Table1.CreateBlobStream(Table1.FieldByName(fieldname),bmWrite);

        try
         mem.SaveToStream(blob2);

        finally
         blob2.Free
        end;

        table1.Post;
        //Table1.ApplyUpdates;
        //Table1.Transaction.CommitRetaining;
        Table1.close;
        Table1.free;

        Connection2.Commit;

      finally
        blob1.Free;
        result:=true;
      end;

   end
  else
   result:=false;

  Query1.close;
  Query1.free;
end;

function SavePicturetoBlobFD(Connection: TFDConnection; tablename, fieldname, where:string; MyPicture: TPicture): boolean;
var blob: TStream;
    Table1: TFDTable;
begin

  Connection.StartTransaction;

  Table1:=TFDTable.Create(nil);
  Table1.CachedUpdates:=True;
  Table1.Connection:=Connection;
  Table1.TableName:=tablename;
  Table1.Open;
  Table1.Filter:=where;
  Table1.Filtered:=true;
  Table1.Edit;

  blob := Table1.CreateBlobStream(Table1.FieldByName(fieldname),bmWrite);

  try
   MyPicture.Graphic.SaveToStream(blob);
  finally
   blob.Free
  end;

  table1.Post;
  Table1.ApplyUpdates;
  //Table1.Transaction.CommitRetaining;
  Table1.close;
  Table1.free;

  Connection.Commit;

  result:=true;

end;

function LoadBitmapfromBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; var MyBitmap: TBitmap): boolean;
var Query1: TFDQuery;
    blob: TStream;
begin
  Query1:=TFDQuery.Create(nil);
  Query1.Connection:=Connection;
  Query1.SQL.Add('select * from '+tablename);
  if trim(where)<>'' then
     Query1.SQL.Add('where '+where);
  Query1.Open;
  if query1.RecordCount>0 then
   begin

  blob := Query1.CreateBlobStream(Query1.FieldByName(fieldname),bmRead);

  try
   MyBitmap.LoadFromStream(blob);

  finally
   blob.Free;
   result:=true;
  end;

   end
  else
   result:=false;

  Query1.close;
  Query1.free;
end;

//20210207 Dá erro duplicate row found - vamos trocar TFDTable por TFDQuery
function SaveBitmapToBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; MyBitmap: TBitmap): boolean;
var blob: TStream;
    Table1: TFDTable;
    Query1: TFDQuery;
begin

  Connection.StartTransaction;

  //Table1:=TFDTable.Create(nil);
  Query1:=TFDQuery.Create(nil);
  //Table1.CachedUpdates:=True;
  Query1.CachedUpdates:=true;
  //Table1.Connection:=Connection;
  Query1.Connection:=Connection;
  //Table1.TableName:=tablename;
  Query1.SQL.Text:='select * from '+tablename;
  if where<>'' then Query1.SQL.Text:=Query1.SQL.Text+' where '+where;

  //Table1.Open;
  Query1.Open;
  //Table1.Filter:=where;
  //Table1.Filtered:=true;
  //Table1.Edit;
  Query1.Edit;

  //blob := Table1.CreateBlobStream(Table1.FieldByName(fieldname),bmWrite);
  blob := Query1.CreateBlobStream(Query1.FieldByName(fieldname),bmWrite);

  try
   MyBitmap.SavetoStream(blob);

  finally
   blob.Free
  end;

  //table1.Post;
  Query1.Post;
  //Table1.ApplyUpdates;
  Query1.ApplyUpdates;
  //Table1.Transaction.CommitRetaining;

  connection.Commit;

  //Table1.close;
  Query1.close;
  //Table1.free;
  Query1.free;

  result:=true;

end;

function SaveJpegToBlobFD(Connection: TFDConnection; tablename, fieldname, where,jpgfile: string): boolean;
var blob: TStream;
    Table1: TFDTable;
    pic1: TPicture;
begin

  Connection.StartTransaction;

  Table1:=TFDTable.Create(nil);
  Table1.CachedUpdates:=True;
  Table1.Connection:=Connection;
  Table1.TableName:=tablename;
  Table1.Open;
  Table1.Filter:=where;
  Table1.Filtered:=true;
  Table1.Edit;

  blob := Table1.CreateBlobStream(Table1.FieldByName(fieldname),bmWrite);
  pic1:=TPicture.Create;
  pic1.LoadFromFile(jpgfile);
  SetJPEGOptions(pic1);

  try
   pic1.Graphic.SaveToStream(blob);
  finally
   blob.Free
  end;

  table1.Post;
  Table1.ApplyUpdates;
  //Table1.Transaction.CommitRetaining;
  Table1.close;
  Table1.free;
  pic1.Free;

  Connection.Commit;

  result:=true;

end;

function LoadJpegfromBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; var MyPicture: TPicture): boolean;
var Query1: TFDQuery;
    blob: TStream;
    tgra: TGraphic;
begin
  Query1:=TFDQuery.Create(nil);
  Query1.Connection:=Connection;
  Query1.SQL.Add('select * from '+tablename);
  if trim(where)<>'' then
     Query1.SQL.Add('where '+where);
  Query1.Open;

  blob := Query1.CreateBlobStream(Query1.FieldByName(fieldname),bmRead);



  SetJPEGOptions(MyPicture);

  try
   MyPicture.Graphic.LoadFromStream(blob);

  finally
   blob.Free
  end;

  Query1.close;
  Query1.free;

  result:=true;

end;

//Passa apenas a poder ler linhas do tipo strings
Function LoadLinesfromBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; var MyLines: TStringList): boolean;
var Query1: TFDQuery;
    blob: TStream;

    field: TBlobField;
    stream: TMemoryStream;

    s: string;
    linhas: TStringlist;
    ob_BlobStream:TClientBlobStream;
begin
//
  Query1:=TFDQuery.Create(nil);
  Query1.Connection:=Connection;
  Query1.SQL.Add('select * from '+tablename);
  if trim(where)<>'' then
     Query1.SQL.Add('where '+where);
  Query1.Open;
  if query1.RecordCount>0 then
   begin

   //stream:=TMemoryStream.Create;
   MyLines.Text:=query1.FieldByName(fieldname).AsString;

    result:=true;
   end
  else
   result:=false;

  Query1.close;
  Query1.free;


end;

//Passa apenas a poder ler linhas do tipo strings
Function UploadLinestoBlobFD(Connection: TFDConnection; tablename, fieldname, where: string; MyLines: TStringList): boolean;
var Query1: TFDQuery;
    Table1: TFDTable;
    blob: TStream;
begin
//


  Connection.StartTransaction;

  //Query1:=TIBQuery.Create(nil);
  Table1:=TFDTable.Create(nil);
  Table1.CachedUpdates:=True;
  //Query1.Database:=Database;
  Table1.Connection:=Connection;
  table1.TableName:=tablename;
  //Query1.SQL.Add('select * from '+tablename);
  if trim(where)<>'' then
     //Query1.SQL.Add('where '+where);
   begin
     table1.Filter:=where;
     table1.Filtered:=True;
   end;
  table1.Open;

  if table1.RecordCount=1 then
   begin

    //Query1.Edit;
    table1.Edit;
    table1.FieldByName(fieldname).AsString:=mylines.Text;



    table1.Post;
    table1.ApplyUpdates;
    //table1.Transaction.CommitRetaining;
    result:=true;

   end
  else
   result:=False;

  //Query1.Free;
  table1.Free;

  Connection.Commit;


end;

function UploadFileToBlobField(Connection: TFDConnection; tablename, fieldname, where: string; OriginFilename: string): boolean;
var blob,fs: TStream;
    Table1: TFDTable;
begin

    Connection.StartTransaction;

    Table1:=TFDTable.Create(nil);
    Table1.CachedUpdates:=True;
    Table1.Connection:=Connection;
    Table1.TableName:=tablename;
    Table1.Open;
    Table1.Filter:=where;
    Table1.Filtered:=true;
    Table1.Edit;
    blob := Table1.CreateBlobStream(Table1.FieldByName(fieldname), bmWrite);
    try
      blob.Seek(0, soFromBeginning);

      fs := TFileStream.Create(OriginFilename, fmOpenRead or fmShareDenyWrite);
      try
        blob.CopyFrom(fs, fs.Size)
      finally
        fs.Free
      end;

    finally
      blob.Free
    end;

    table1.Post;
    Table1.ApplyUpdates;
    Table1.close;
    Table1.free;

    Connection.Commit;

    result:=true;

end;


procedure DBLoadFamiliesTreeFD(Connection: TFDConnection; MyTreeItems: TTreeNodes);
begin
  DBLoadCustomFamiliesTreeFD(Connection,MyTreeItems,'FAMILY','','ID','PARENT_ID',
      'FAMILY_NAME','FAMILY_NAME,ORD_INDEX','null');
end;

procedure DBLoadCustomFamiliesTreeFD(Connection: TFDConnection; MyTreeItems: TTreeNodes;
                  tablename,where,fieldID,FieldParentID,FieldFamilyName,orderby,
                  parentnull: string);
var s: string;
    i,id,parentid,level,c, ocur: integer;
    tempnode: TTreenode;
    MyRecPtr: PMyRec;
    occured: boolean;
    fastlist,idslist, findlist: TStringlist;
    Query1: TFDQuery;
begin
     //Vamos criar uma lista para guardar os id's introduzidos
      fastlist:=TStringlist.Create;
      idslist:=TStringlist.Create;

      Query1:=TFDQuery.Create(nil);
      Query1.Connection:=Connection;
      Query1.SQL.Text:='Select * from '+tablename;
      if where<>'' then Query1.SQL.Text:=Query1.SQL.Text+' where '+where;
      if orderby<>'' then Query1.SQL.Text:=Query1.SQL.Text+' order by '+ orderby;


      Query1.Open;

      MyTreeItems.Clear;

      if query1.RecordCount=0 then
       begin
        FreeAndNil(fastlist);
        FreeAndNil(idslist);

        Query1.close;
        Query1.Free;
        exit;
       end;


      //Vamos encher as famílias
      repeat
       s:=Query1.FieldByName(FieldFamilyName).AsString;
       idslist.Add(Query1.FieldByName(fieldID).AsString+'='+s);

       if parentnull='null' then
        begin
         if not Query1.FieldByName(FieldParentID).IsNull then
          i:=Query1.FieldByName(FieldParentID).AsInteger
         else i:=-1;
        end
       else
        if Query1.FieldByName(FieldParentID).AsString<>parentnull then
         i:=Query1.FieldByName(FieldParentID).AsInteger
        else i:=-1;

       fastlist.Add(Query1.FieldByName(fieldID).AsString+'='+inttostr(i));

       Query1.Next;
      until Query1.Eof;

      level:=0;
      c:=0;
      ocur:=0;
      i:=0;
      repeat
        occured:=False;
        id:=strtoint(idslist.Names[c]);
        parentid:=strtoint(fastlist.Values[inttostr(id)]);
        s:=idslist.Values[inttostr(id)];
         if (level=0) and (parentid=-1) then
          begin
           New(MyRecPtr);
           MyRecPtr^.MyID:=id;
           MyTreeItems.AddObject(MyTreeItems.GetFirstNode,s,MyRecPtr);
           //IDsStrings.Add(inttostr(id));
           fastlist.Delete(c);
           idslist.Delete(c);
           inc(ocur);
           occured:=True;
          end;
         if (level>0) then
          begin //Vai ver se o item encaixa em algum....
           for i:=0 to MyTreeItems.Count-1 do
            if parentid=PMyRec(MyTreeItems.Item[i].Data)^.MyID then
             begin
              New(MyRecPtr);
              MyRecPtr^.MyID:=id;
              MyTreeItems.AddChildObject(MyTreeItems[i],s,MyRecPtr);
              //IDsStrings.Add(inttostr(id));
              fastlist.Delete(c);
              idslist.Delete(c);
              inc(ocur);
              occured:=True;
              break;
             end;
          end;

        if not occured then inc(c);
        if (c>=fastlist.Count) and (ocur>0) then
         begin
          c:=0;
          ocur:=0;
          inc(level);
         end;
      until (fastlist.Count=0) or (c>=fastlist.Count);



      FreeAndNil(fastlist);
      FreeAndNil(idslist);

      Query1.close;
      Query1.Free;

end;

function GetDepartmentInOutHoursFD(Conn: TFDConnection; DepID: integer; var HoursIN,HoursOUT,BreakBegin,BreakOut: TTime; var workinghours: integer):boolean;
var timetableid: string;
begin
   timetableid:='';
   if DepID<>-1 then
      timetableid:=GetSQLValueFD(Conn,'TIMETABLE_ID','DEPARTMENTS','ID='''+inttostr(DepID)+'''');

   if timetableid<>'' then
     begin
      result:=GetInOutHoursFD(Conn,strtoint(TimetableID),HoursIN,HoursOUT,BreakBegin,BreakOut,workinghours);
     end
    else
     //Vai para os valores por defeito no config
     begin
      result:=GetDefaultInOutHoursFD(Conn,HoursIN,HoursOUT,BreakBegin,BreakOut,workinghours);
     end;

   result:=true;
end;

function GetPeopleJobFD(FBConn: TFDConnection; JobID,ReturnLANG: string): string;
var termination: string;
begin
  if JobID<>'' then
   begin
    termination:='_'+ReturnLANG; //_PT, _ES, _EN, _FR
    result:=GetSQLValueFD(FBConn,'DESCRIPTION'+termination,'JOB_FUNCTIONS','ID='''+jobID+'''');
   end
  else
   result:='';
end;

function GetPeopleInOutHoursFD(Conn: TFDConnection; PeopleID: integer; var HoursIN,HoursOUT,BreakBegin,BreakOut: TTime; var workinghours: integer):boolean;
var timetableid,departmentid: string;
begin
    //Tem um horário atribuído?
    timetableid:=GetSQLValueFD(Conn,'TIMETABLE_ID','PEOPLE','ID='''+inttostr(PeopleID)+'''');
    if timetableid='' then
     begin
       departmentid:=GetSQLValueFD(Conn,'DEPARTMENT_ID','PEOPLE','ID='''+inttostr(PeopleID)+'''');
       if departmentid<>'' then
        timetableid:=GetSQLValueFD(Conn,'TIMETABLE_ID','DEPARTMENTS','ID='''+departmentid+'''');
     end;

    if timetableid<>'' then
     begin
      result:=GetInOutHoursFD(Conn,strtoint(TimetableID),HoursIN,HoursOUT,BreakBegin,BreakOut,workinghours);
     end
    else
     //Vai para os valores por defeito no config
     begin
      result:=GetDefaultInOutHoursFD(Conn,HoursIN,HoursOUT,BreakBegin,BreakOut,workinghours);
     end;

   result:=true;

end;

//O timetable ID deverá existir
function GetInOutHoursFD(Conn: TFDConnection; TimetableID: integer; var HoursIN,HoursOUT,BreakBegin,BreakOut: TTime; var workinghours: integer):boolean;
var Query: TFDQuery;
    s: string;
begin
    Query:=TFDQuery.Create(nil);
    query.Connection:=Conn;
    Query.Transaction:=Conn.Transaction;

    //Começa por olhar para o horário como um todo
    Query.SQL.Text:='select * from TIMETABLE where ID='+inttostr(TimetableID);
    Query.Open;

    s:=Query.FieldByName('START_HOUR').AsString;
    if s<>'' then HoursIN:=FDTime2Time(s) else HoursIN:=encodetime(0,0,0,0);;
    s:=Query.FieldByName('END_HOUR').AsString;
    if s<>'' then HoursOUT:=FDTime2Time(s) else HoursOUT:=encodetime(0,0,0,0);
    s:=Query.FieldByName('BREAK_BEGIN').AsString;
    if s<>'' then BreakBegin:=FDTime2Time(s) else BreakBegin:=encodetime(0,0,0,0);
    s:=Query.FieldByName('BREAK_END').AsString;
    if s<>'' then BreakOut:=FDTime2Time(s) else BreakOut:=encodetime(0,0,0,0);
    s:=Query.FieldByName('DAILY_HOURS').AsString;
    if s<>'' then workinghours:=strtoint(s);

    Query.close;
    FreeAndNil(Query); //No novo mobile compiler

    result:=true;

end;

//Vai buscar os valores ao config
function GetDefaultInOutHoursFD(Conn: TFDConnection; var HoursIN,HoursOUT,BreakBegin,BreakOut: TTime; var workinghours: integer):boolean;
var s: string;
begin
    //Se o timetable não está atribuído, então por defeito apanha o horário da empresa
    s:=GetValueFromConfigFD(Conn, 'TIME_IN_1');
    if s<>'' then HoursIN:=FDTime2Time(s) else HoursIN:=encodetime(0,0,0,0);
    s:=GetValueFromConfigFD(Conn, 'TIME_OUT_1');
    if s<>'' then BreakBegin:=FDTime2Time(s) else BreakBegin:=encodetime(0,0,0,0);
    s:=GetValueFromConfigFD(Conn, 'TIME_IN_2');
    if s<>'' then BreakOut:=FDTime2Time(s) else BreakOut:=encodetime(0,0,0,0);
    s:=GetValueFromConfigFD(Conn, 'TIME_OUT_2');
    if s<>'' then HoursOUT:=FDTime2Time(s) else HoursOUT:=encodetime(0,0,0,0);


    workinghours:=minutesbetween(breakbegin,hoursIN)+minutesbetween(breakout,HoursOut);

    result:=true;

end;

function GetWorkingTimeforShiftFD(Conn: TFDConnection; Shiftid:integer): integer; //Em minutos
var Query1: TFDQuery;
begin
   Query1:=TFDQuery.Create(nil);
   Query1.Connection:=Conn;
   Query1.SQL.Text:='select * from SHIFTS where ID='+inttostr(shiftid);
   Query1.Open;

   if query1.RecordCount>0 then
    begin
      result:=minutesbetween(query1.FieldByName('END_HOUR').AsDateTime,
                             query1.FieldByName('START_HOUR').AsDateTime)
             -query1.FieldByName('FREE_MIN_BREAK').AsInteger;
    end
   else
    result:=0;

   FreeAndNil(query1); //No novo mobile compiler
end;

procedure GetWorkingHoursforShiftFD(Conn: TFDConnection; Shiftid:integer; var FromTime, ToTime: TTime);
var Query1: TFDQuery;
begin
   Query1:=TFDQuery.Create(nil);
   Query1.Connection:=Conn;
   Query1.SQL.Text:='select * from SHIFTS where ID='+inttostr(shiftid);
   Query1.Open;

   if query1.RecordCount>0 then
    begin
      FromTime:=query1.FieldByName('START_HOUR').AsDateTime;
      ToTime:=query1.FieldByName('END_HOUR').AsDateTime;
    end;

   FreeAndNil(query1); //No novo mobile compiler
end;

//Vai buscar os dados registados da pessoa para determinado dia. Devolve false se não houver informação
function GetPeopleDayInfoFD(Connection: TFDConnection; peopleid: integer; day: TDate;
      var minutespresent: integer; var lastperiod,status: char ;
      var firsttime,lasttime: TDateTime; var LastEvent,FirstEvent: char) : boolean;
var Query1: TFDQuery;
    s: string;
begin
   Query1:=TFDQuery.Create(nil);
   Query1.Connection:=Connection;
   Query1.SQL.Add('select * from PEOPLE_DAY where people_id='+inttostr(peopleid)
          +' and "DAY"='''+fddate(day)+'''');
   Query1.Open;

   if query1.RecordCount=0 then
    begin
     Query1.close;
     Query1.free;
     result:=false;
     exit;
    end;

   minutespresent:=Query1.FieldByName('TIME_PRESENT').AsInteger;
   if Query1.FieldByName('LAST_PERIOD').AsString<>''
    then lastperiod:=Query1.FieldByName('LAST_PERIOD').AsString[1]
    else lastperiod:=' ';
   if Query1.FieldByName('STATUS').AsString<>''
    then status:=Query1.FieldByName('STATUS').AsString[1]
    else status:=' ';
   firsttime:=Query1.FieldByName('F_EVENT_TIME').AsDateTime;  //Ficou com date not valid
   firsttime:=encodedatetime(yearof(Day),monthof(day),dayof(day),hourof(firsttime),
             minuteof(firsttime),secondof(firsttime),0);
   lasttime:=Query1.FieldByName('L_EVENT_TIME').AsDateTime;   //Ficou com date not valid
   lasttime:=encodedatetime(yearof(Day),monthof(day),dayof(day),hourof(lasttime),
             minuteof(lasttime),secondof(lasttime),0);
   if Query1.FieldByName('LAST_EVENT').AsString<>''
    then LastEvent:=Query1.FieldByName('LAST_EVENT').AsString[1]
    else lastevent:=' ';
   if Query1.FieldByName('FIRST_EVENT').AsString<>''
    then FirstEvent:=Query1.FieldByName('FIRST_EVENT').AsString[1]
    else FirstEvent:=' ';

   Query1.close;
   Query1.free;
   result:=true;
end;

procedure NewPeopleDayFD(Connection: TFDConnection; peopleid: integer; day: TDate);
var PEOPLE_NUMBER: string;
begin
   //Vai ver qual é o people_number para esta pessoa
   PEOPLE_NUMBER:=getSQLValueFD(Connection,'PEOPLE_NUMBER','PEOPLE','ID='+
      inttostr(peopleid));
   //E vai inserir na BD
   //Por defeito é uma entrada.....pois estamos a inserir por ordem
   //E depois está logo presente
   sqlexecuteFD(Connection,'insert into PEOPLE_DAY ( '+
     'PEOPLE_ID,"DAY",PRESENT,JUSTIFIED,TIME_PRESENT,'+
     'LAST_UPDATED,LAST_EVENT, FIRST_EVENT, F_EVENT_TIME,L_EVENT_TIME,'+
     'LAST_PERIOD,JUSTIFICATION,STATUS, TIME_DIFF,PEOPLE_NUMBER) values ('+
     inttostr(peopleid)+','''+fddate(day)+''',''1'',null,0,'+
     'CURRENT_TIMESTAMP,''I'',''I'','''+fdtime(day)+''','''+fdtime(day)+''','+
     'null,null,null,null,'''+PEOPLE_NUMBER+''')');

end;

//Vai registar uma entrada de crianças
// childrenlist:  peopleid das crianças
// Em princípio as crianças vieram todas com o mesmo pai
procedure NewChildrenDayFD(Connection: TFDConnection; childrenlist: TStrings; day: TDate);
var i: integer;
begin
    for i := 0 to childrenlist.Count-1 do
     begin
      NewPeopleDayFD(Connection,strtoint(childrenlist[i]),day);
     end;
end;

//Vai atualizar entradas e saídas de crianças
// childrenlist:  peopleid das crianças
// Em princípio as crianças vieram todas com o mesmo pai
procedure UpdateChildrenDayFD(Connection: TFDConnection; childrenlist: TStrings; day: TDate;
         TIME_PRESENT:integer; PRESENT,JUSTIFIED,LAST_EVENT,FIRST_EVENT,
         LAST_PERIOD,STATUS: char; F_EVENT_TIME, L_EVENT_TIME: TDateTime;
         JUSTIFICATION: string);
var i: integer;
begin
    for i := 0 to childrenlist.Count-1 do
     begin
      UpdatePeopleDayFD(Connection,strtoint(childrenlist[i]),day,
         TIME_PRESENT,PRESENT,JUSTIFIED,LAST_EVENT,FIRST_EVENT,
         LAST_PERIOD,STATUS,F_EVENT_TIME, L_EVENT_TIME,JUSTIFICATION);
     end;

end;

//Vai atualizar o dia evento a evento
//DAY: dia a atualizar; TIME_PRESENT: tempo total presente em minutos;
//TIME_DIFF: diferença de tempo da última entrada à atual
//PRESENT: Y / N ;  Was present?
//LAST_EVENT: I/O ; FIRST_EVENT: I/O    control wich events we are processing
//LAST_PERIOD: I/O/?  In and Out gives period identification
//STATUS: W
//FIRST_EVENT_TIME, LAST_EVENT_TIME: hora do primeiro e do último evento
//JUSTIFIED: Y / N ;  Is justified the absence?  JUSTIFICATION: the motif text
procedure UpdatePeopleDayFD(Connection: TFDConnection; peopleid: integer; day: TDate;
         TIME_PRESENT:integer; PRESENT,JUSTIFIED,LAST_EVENT,FIRST_EVENT,
         LAST_PERIOD,STATUS: char; F_EVENT_TIME, L_EVENT_TIME: TDateTime; JUSTIFICATION: string);
var TIME_DIFF: integer;
begin
   TIME_DIFF:=minutesbetween(day,L_EVENT_TIME);
   sqlexecuteFD(Connection,'update PEOPLE_DAY set PRESENT='''+present+
      ''',JUSTIFIED='''+justified+''',TIME_PRESENT='+inttostr(time_present)+
      ',TIME_DIFF='+inttostr(time_diff)+',LAST_EVENT='''+LAST_EVENT+
      ''',FIRST_EVENT='''+FIRST_EVENT+''',LAST_PERIOD='''+LAST_PERIOD+
      ''',STATUS='''+STATUS+''',F_EVENT_TIME='''+fdtime(timeof(F_EVENT_TIME))+
      ''',L_EVENT_TIME='''+fdtime(timeof(L_EVENT_TIME))+ ''' where PEOPLE_ID='+
      inttostr(peopleid)+' and "DAY"='''+fddate(day)+'''');
end;

//Vai registar um período de pausa da pessoa
procedure NewPeopleBreakFD(Connection: TFDConnection; peopleid: integer; day: TDate;BREAK_BEGIN,BREAK_END: TDatetime);
var PEOPLE_NUMBER: string;
    BREAK_TIME: integer;
begin
    //Vai ver qual é o people_number para esta pessoa
   PEOPLE_NUMBER:=getSQLValueFD(Connection,'PEOPLE_NUMBER','PEOPLE','ID='+
      inttostr(peopleid));
   BREAK_TIME:=minutesbetween(BREAK_BEGIN,BREAK_END);
   //E vai inserir na BD
   sqlexecuteFD(Connection,'insert into PEOPLE_BREAKS ( '+
     'PEOPLE_ID,PEOPLE_NUMBER,"DAY",BREAK_BEGIN,BREAK_TIME) values ('+
     inttostr(peopleid)+','''+PEOPLE_NUMBER+''','''+fddate(day)+
     ''','''+fdtime( timeof(BREAK_BEGIN))+''','+inttostr(BREAK_TIME)+')');

end;

procedure DBGiveVehicleAccesstoDeviceFD(Connection: TFDConnection; VehicleID, DeviceID: string);
begin
//
end;

procedure DBRemoveVehicleAccessfromDeviceFD(Connection: TFDConnection; VehicleID, DeviceID: string);
begin
//
end;

procedure DBPropagateVehicleFD(Connection: TFDConnection; VehicleID: string );
begin
//
end;

procedure DBRemoveVehicleFD(Connection: TFDConnection; VehicleID: string );
begin
//
end;

function GetCountryIndexFD(Connection: TFDConnection; ComboItems: TStrings; CountryID: string): integer;
var s:string;
begin
  case ActiveLanguage of
   0: s:='Country_name';
   1: s:='Country_name_en';
   2: s:='Country_name_fr';
  end;
  if CountryID='' then result:=-1
  else
  result:=comboitems.IndexOf(GetSQLValueFD(connection,s,'COUNTRIES','ID='''+CountryID+''''));
end;

function GetDepartmentIndexFD(Connection: TFDConnection; ComboItems: TStrings;DepartmentID: string): integer;
begin
  if DepartmentID='' then result:=-1
  else
  result:=comboitems.IndexOf(GetSQLValueFD(Connection,'DESCRIPTION','DEPARTMENTS','ID='''+DepartmentID+''''));
end;

function EncryptPasswordFD(password: string): string;
begin
    result:=RealsisEncryptDecrypt(password);
end;

function ValidLoginPasswordFD(Connection: TFDConnection;login,password: string): boolean;
var codedpassword,userid,s: string;
begin
   userid:=GetSQLValueFD(Connection,'ID','users','login='''+login+'''');
   if userid<>'' then
    begin
     s:=EncryptPasswordFD(password);
     codedpassword:=GetSQLValueFD(Connection,'chave','users','id='''+userid+'''');
     result:= EncryptPasswordFD(password)=codedpassword;
    end
   else
    result:=false;
end;

function ValidPasswordFD(Connection: TFDConnection;userid: integer;password: string): boolean;
var codedpassword: string;
begin
   codedpassword:=GetSQLValueFD(Connection,'chave','users','id='+inttostr(userid));
   result:= EncryptPasswordFD(password)=codedpassword;
end;

//Returns ";" separated the following
//ID,DESCRIPTION,MODEL,COMMUNICATION,ENABLED,PASSWD,SHORT_DESC,TIMEZ1,TIMEZ2,TIMEZ3,DEVICE_TYPE,BRAND,REMOTE_DEVICE
function GetDevicesFD(connection: TFDConnection; InfoStrings: TStringList; Filter: string): boolean;
var Query: TFDQuery;
    brandID,brand: string;
begin
    Query:=TFDQuery.Create(nil);
    query.connection:=connection;
    Query.Transaction:=connection.Transaction;
    Query.SQL.Text:='select ID,DESCRIPTION,MODEL,COMMUNICATION,ENABLED,PASSWD,SHORT_DESC,TIMEZ1,TIMEZ2,TIMEZ3,DEVICE_TYPE,REMOTE_DEVICE from DEVICES';
    if filter<>'' then
    Query.SQL.Text:=Query.SQL.Text+' where '+filter;
    Query.Open;


    InfoStrings.Clear;
    while not Query.eof do
     begin

      brandID:=GetSQLValueFD(connection,'BRAND_ID','DEVICE_MODELS',
       'MODEL='''+Query.FieldByName('MODEL').AsString+'''');
      if brandID<>'' then
        brand:=GetSQLValueFD(connection,'BRAND','DEVICE_BRANDS','ID='+brandID)
      else
        brand:='';

      InfoStrings.Add(Query.FieldByName('ID').AsString+';'+
                      Query.FieldByName('DESCRIPTION').AsString+';'+
                      Query.FieldByName('MODEL').AsString+';'+
                      Query.FieldByName('COMMUNICATION').AsString+';'+
                      Query.FieldByName('ENABLED').AsString+';'+
                      Query.FieldByName('PASSWD').AsString+';'+
                      Query.FieldByName('SHORT_DESC').AsString+';'+
                      Query.FieldByName('TIMEZ1').AsString+';'+
                      Query.FieldByName('TIMEZ2').AsString+';'+
                      Query.FieldByName('TIMEZ3').AsString+';'+
                      Query.FieldByName('DEVICE_TYPE').AsString+';' +
                      brand+';'+
                      Query.FieldByName('REMOTE_DEVICE').AsString
                      );
      Query.Next;
     end;

    FreeAndNil(Query); //No novo mobile compiler
    result:=true;
end;


function GetDeviceFD(connection: TFDConnection; var Info: string; Filter: string): boolean;
var results: TStringList;
begin
    results:=TStringList.Create;
    GetDevicesFD(connection,results,Filter);

    if results.Count=1 then
     begin
       info:=results[0];
       result:=true;
     end
    else
     begin
      result:=false;
     end;


    FreeAndNil(results); //No novo mobile compiler


end;


procedure GetPeopleVersionFD(connection: TFDConnection; var major,minor,release,build:integer);
var version: string;
    lista: TStringList;
begin
  version:=GetSQLValueFD(connection,'VERSION','ABOUT','');
  lista:=TStringList.Create;
  sbreakapart(version,'.',lista);
  major:=GetValidInt(lista[0],0);
  minor:=GetValidInt(lista[1],0);
  release:=GetValidInt(lista[2],0);
  build:=GetValidInt(lista[3],0);
  FreeAndNil(lista); //No novo mobile compiler
end;

function prepareforlike(oldstring:string):string;
var s: string;
begin
  s:=stringreplace(oldstring,'í','%',[rfreplaceall]);
  s:=stringreplace(s,'ì','%',[rfreplaceall]);
  s:=stringreplace(s,'á','%',[rfreplaceall]);
  s:=stringreplace(s,'à','%',[rfreplaceall]);
  s:=stringreplace(s,'ç','%',[rfreplaceall]);
  s:=stringreplace(s,'ã','%',[rfreplaceall]);
  s:=stringreplace(s,'â','%',[rfreplaceall]);
  s:=stringreplace(s,'ó','%',[rfreplaceall]);
  s:=stringreplace(s,'ò','%',[rfreplaceall]);
  s:=stringreplace(s,'é','%',[rfreplaceall]);
  s:=stringreplace(s,'è','%',[rfreplaceall]);
  result:=s;
end;

function FixCodepageString(oldString: string): string;
var s,news: string;
begin
   s:=oldstring;

   if pos('Ã',s)>0 then
    begin
     news:=s;                     //UTF8 ???
     news:=stringreplace(news,'Ã'+chr($0080),'À',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($0081),'Á',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($0082),'Â',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($0083),'Ã',[rfReplaceAll]);

     news:=stringreplace(news,'Ã'+chr($0088),'È',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($0089),'É',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($008A),'Ê',[rfReplaceAll]);

     news:=stringreplace(news,'Ã'+chr($008C),'Ì',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($008D),'Í',[rfReplaceAll]);

     news:=stringreplace(news,'Ã'+chr($0092),'Ò',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($0093),'Ó',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($0094),'Ô',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($0095),'Õ',[rfReplaceAll]);

     news:=stringreplace(news,'Ã'+chr($0099),'Ù',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($009A),'Ú',[rfReplaceAll]);

     news:=stringreplace(news,'Ã'+chr($00A0),'à',[rfReplaceAll]);
     news:=stringreplace(news,'Ã¡','á',[rfReplaceAll]);
     news:=stringreplace(news,'Ã£','ã',[rfReplaceAll]);
     news:=stringreplace(news,'Ã¢','â',[rfReplaceAll]);

     news:=stringreplace(news,'Ã'+chr($00A8),'è',[rfReplaceAll]);
     news:=stringreplace(news,'Ã©','é',[rfReplaceAll]);
     news:=stringreplace(news,'Ãª','ê',[rfReplaceAll]);

     news:=stringreplace(news,'Ã'+chr($00AC),'ì',[rfReplaceAll]);
     news:=stringreplace(news,'Ã­','í',[rfReplaceAll]);

     news:=stringreplace(news,'Ã'+chr($00B2),'ò',[rfReplaceAll]);
     news:=stringreplace(news,'Ã³','ó',[rfReplaceAll]);
     news:=stringreplace(news,'Ãµ','õ',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($00B4),'ô',[rfReplaceAll]);

     news:=stringreplace(news,'Ã'+chr($00B9),'ù',[rfReplaceAll]);
     news:=stringreplace(news,'Ãº','ú',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($00BB),'û',[rfReplaceAll]);

     news:=stringreplace(news,'Ã§','ç',[rfReplaceAll]);
     news:=stringreplace(news,'Ã'+chr($0087),'Ç',[rfReplaceAll]);

     result:=news;

    end
   else
    result:=s;

end;

function ListIDs2SQLSet(ids: TStringlist): string; //Returns (1,40,81,67) from a list of ids
var i: integer;
    s: string;
begin
    if ids.Count>0 then s:=ids[0] else s:='';

    for i := 1 to ids.Count-1 do
     begin
      s:=s+','+ids[i];
     end;

    result:='('+s+')';
end;

procedure ListAllTables( connection: TFDConnection; AllTables: TStringList);
var Query: TFDQuery;
begin
    Query:=TFDQuery.Create(nil);
    query.connection:=connection;
    Query.Transaction:=connection.Transaction;
    Query.SQL.Text:='SELECT a.RDB$RELATION_NAME FROM RDB$RELATIONS a '+
      'WHERE COALESCE(RDB$SYSTEM_FLAG, 0) = 0 AND RDB$RELATION_TYPE = 0 '+
      'ORDER BY a.RDB$RELATION_NAME';
    Query.Open;


    AllTables.Clear;
    while not Query.eof do
     begin
      AllTables.Add(query.Fields[0].asstring);
      Query.Next;
     end;


     Query.Free;
end;

end.

