unit FDACSQLite;

interface

uses system.classes,FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet,system.types, system.strutils, system.sysutils,
 {$IFDEF ANDROID}
   fmx.graphics,
  {$ELSE}
   vcl.graphics,
  {$IFEND}
  system.DateUtils, data.db;

function GetValidSQLInteger(value,default: string; return_null: boolean): string;
function GetValidSQLDecimal(value,default: string; return_null: boolean): string;
function GetValidSQLStringwithplicas(value,default: string; return_null: boolean): string;
function GetValidSQLDatewithplicas(value,default: string; return_null: boolean): string; //'YYYYMMDD'
function GetValidSQLTimewithplicas(value,default: string; return_null: boolean): string; //'HH:MM:SS'
function GetValidSQLBoolwithplicas(value,default: string; return_null: boolean): string; //'0' ou '1'
function SQLiteTime(time: TTime): string;
function SQLiteDate(date: TDateTime): string;
function PHPDate2Date(IBDate: string): TDate;
function PHPDate2StringTime(IBDate: string): string;
function SQLiteTime2Time(IBTime: string): TTime;
function SQLiteDayTime2StringTimestamp(YYYYMMDD,HHMM: string):string;
function SQLiteDay2StringDate(YYYYMMDD:string):string;
function GetNumRecordsSQLite( Connection: TFDConnection;tablename,where: string): integer;
function GetSQLValueSQLite(Connection: TFDConnection; sqlexp, tablename, where: string):string;
function SQLExecuteSQLite(Connection: TFDConnection; sqlstring: string):boolean;
function GetMaxValue(Connection: TFDConnection;Tablename,Fieldname: string): integer;
function GetAllRecordsSQLite(Connection: TFDConnection; Lista: TStrings;tablename, fieldname, where: string): integer;
function GetAllValuesSQLite(Connection: TFDConnection; Lista: TStrings;tablename, fieldname1,fieldname2, where: string): integer;
function prepareSQL(originalsql: string): string;
function Get2ValuesSQLite(Connection: TFDConnection;tablename,field1,field2,where:string; var Value1,Value2:string):boolean;
function Get3ValuesSQLite(Connection: TFDConnection;tablename,field1,field2,field3,where:string; var Value1,Value2,Value3:string):boolean;
function GetValidSQLDate(FDDate: string): String;
function GetValidSQLTime(FDTime: string): string;
function GetSQLList(Connection: TFDConnection;tablename,field,filter: string): string; //devolve do tipo "valor1,valor2,valor3"
//Some login for SQLite
function DoPinLogin( Connection: TFDConnection; login: string ; Pin: string):boolean;
function DoSmartLogin(Connection: TFDConnection;  login: string; smartlock: string): boolean;
procedure ChangePass(Connection: TFDConnection;  login: string ; pass: string );
procedure ChangePin(Connection: TFDConnection;  login: string ; Pin: string );
procedure ChangeSmartLock(Connection: TFDConnection; login: string; smartlock: string);
procedure SaveLogin(Connection: TFDConnection; login: string; GPSLat,GPSLon:string);
//Outros
procedure GetRowDataSQLite(Connection: TFDConnection; var colunas: TStringList; Query: string);
function SaveBitmaptoBlobSQLite(Connection: TFDConnection; bmp: TBitmap; FieldName,TableName,Filter: String):boolean;
function LoadBitmapFromBlobSQLite(Connection: TFDConnection; var bmp: TBitmap;FieldName,TableName,Filter: String):boolean;
function Getnullifempty(value:string): string;
function Getnullifemptyplicas(value:string): string;

implementation

{$IFDEF ANDROID}
 uses functionsFM;
{$ELSE}
uses functions;
{$IFEND}

function GetValidSQLInteger(value,default: string; return_null: boolean): string;
begin
   if IsStrANumber(value) then
    result:=value
   else
    begin
     if return_null then result:='null' else result:=default;
    end;
end;

function GetValidSQLDecimal(value,default: string; return_null: boolean): string;
begin
  if isValidFloat(value) then
   result:=value
  else
   begin
     if return_null then result:='null' else result:=default;
    end;
end;

function GetValidSQLStringwithplicas(value,default: string; return_null: boolean): string;
begin
   if value<>'' then
    result:=''''+prepareSQL(value)+''''
   else
    begin
      if return_null then result:='null' else result:=''''+default+'''';
    end;
end;

function GetValidSQLDatewithplicas(value,default: string; return_null: boolean): string; //'YYYYMMDD'
begin
  if value<>'' then
   begin
    result:=''''+GetValidSQLDate(value)+'''';
   end
  else
    begin
      if return_null then result:='null' else result:=''''+default+'''';
    end;
end;

function GetValidSQLTimewithplicas(value,default: string; return_null: boolean): string; //'HH:MM:SS'
begin
  if value<>'' then
   begin
    result:=''''+GetValidSQLTime(value)+'''';
   end
  else
    begin
      if return_null then result:='null' else result:=''''+default+'''';
    end;
end;

function GetValidSQLBoolwithplicas(value,default: string; return_null: boolean): string; //'0' ou '1'
begin
  if value<>'' then
   begin
    if (value='1') or (value='T') or (value='Y') or (value='V') then
     result:='''1''' else result:='''0''';
   end
   else
    begin
      if return_null then result:='null' else result:=''''+default+'''';
    end;
end;

function SQLiteTime(time: TTime): string;
var hh,nn,ss: integer;
begin
    hh:=hourof(time);
    nn:=minuteof(time);
    ss:=secondof(time);
    //result:=formatdatetime('dd-mm-yyyy',encodedatetime(yy,mm,dd,0,0,0,0));
    result:=formatdatetime('hh:nn:ss',time); //20080818
end;

//Vai fazer a data no formato de Interbase
function SQLiteDate(date: TDateTime): string;
var yy,mm,dd: integer;
begin
    yy:=Yearof(Date);
    mm:=monthof(date);
    dd:=dayof(date);
    //result:=formatdatetime('dd-mm-yyyy',encodedatetime(yy,mm,dd,0,0,0,0));
    result:=formatdatetime('dd.mm.yyyy',encodedatetime(yy,mm,dd,0,0,0,0)); //20080818
end;

//Formato PHP YYYY-MM-DD para TDate??
function PHPDate2Date(IBDate: string): TDate;
var lista: TStringList;
    year,month,day: word;
    breakchar,strdate: string;
begin
  lista:=TStringList.Create;
  breakchar:='-';
  strdate:=GetStrBeforeChar( IBDate,' ');
  sbreakapart(strdate,breakchar,lista);
  if lista.Count=3 then
   begin
    year:=GetValidint(lista[0],2000);
    month:=GetValidint(lista[1],1);
    day:=GetValidint(lista[2],1);
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

//Formato PHP YYYY-MM-DD HH:NN:SS para HH:NN:SS
function PHPDate2StringTime(IBDate: string): string;
var lista: TStringList;
    breakchar: string;
begin
   lista:=TStringList.Create;
   breakchar:=' ';
   sbreakapart(IBDate,breakchar,lista);
   if lista.Count=2 then
    result:=lista[1]
   else result:='';
end;

function SQLiteTime2Time(IBTime: string): TTime;
var hour,min,sec,msec: word;
    lista: TStringList;
begin
  lista:=TStringList.Create;
  sbreakapart(IBTime,':',lista);
  if lista.Count>=3 then
   begin
    hour:=GetValidInt(lista[0],0);
    min:=GetValidInt(lista[1],0);
    sec:=GetValidInt(lista[2],0);
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

//recebe por exemplo YYYYMMDD e HH:NN e devolve YYYY-MM-DD HH:NN
function SQLiteDayTime2StringTimestamp(YYYYMMDD,HHMM: string):string;
begin
  if (YYYYMMDD<>'') and (HHMM<>'') then
   result:=midstr(YYYYMMDD,1,4)+'-'+midstr(YYYYMMDD,5,2)+'-'+midstr(YYYYMMDD,7,2)+
     ' '+HHMM
  else
   result:='';
end;

//recebe por exemplo YYYYMMDD e devolve YYYY-MM-DD
function SQLiteDay2StringDate(YYYYMMDD:string):string;
begin
if (YYYYMMDD<>'') then
   result:=midstr(YYYYMMDD,1,4)+'-'+midstr(YYYYMMDD,5,2)+'-'+midstr(YYYYMMDD,7,2)
  else
   result:='';
end;

function GetSQLValueSQLite(Connection: TFDConnection; sqlexp, tablename, where: string):string;
var Query1: TFDQuery;
    s: string;
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
    Query1.SQL.Add('select '+sqlexp+' from '+tablename);
    if valid then Query1.SQL.Add(' where '+where);
    Query1.SQL.Add(' limit 1');

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

function GetNumRecordsSQLite( Connection: TFDConnection;tablename,where: string): integer;
begin
   result:=strtoint(GetSQLValueSQlite(Connection,'count(*) as soma', tablename, where));
end;

function GetMaxValue(Connection: TFDConnection;Tablename,Fieldname: string): integer;
begin
  result:=getvalidint(GetSQLValueSQLite(Connection,'max('+fieldname+') as maximo', tablename,''),0);
end;

function SQLExecuteSQLite(Connection: TFDConnection; sqlstring: string):boolean;
var Query1: TFDQuery;
    T1: TFDTransaction;
begin
    if not Connection.Connected then begin result:=false; exit; end;


    if Connection.InTransaction then Connection.Rollback;



    Connection.StartTransaction;

    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add(sqlstring);

    Query1.ExecSQL;
    result:=query1.RowsAffected>0;
    Query1.Close;
    Query1.Free;

    Connection.Commit;
end;

function GetAllRecordsSQLite(Connection: TFDConnection; Lista: TStrings;tablename, fieldname, where: string): integer;
var Query1: TFDQuery;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select '+fieldname+' from '+tablename);
    if trim(where)<>'' then
      query1.SQL.Add('where '+where);
    Query1.Open;
    if query1.RecordCount>0 then
     begin
      while not query1.Eof do
       begin
        lista.Add(query1.Fields.Fields[0].AsString);
        query1.Next;
       end;
     end;
    FreeAndNil(Query1); //No novo mobile compiler
end;

//Vai buscar todos os valores na forma fieldname1=fieldname2
function GetAllValuesSQLite(Connection: TFDConnection; Lista: TStrings;tablename, fieldname1,fieldname2, where: string): integer;
var Query1: TFDQuery;
begin
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select '+fieldname1+','+fieldname2+' from '+tablename);
    if trim(where)<>'' then
      query1.SQL.Add('where '+where);
    Query1.Open;
    if query1.RecordCount>0 then
     begin
      while not query1.Eof do
       begin
        lista.Add(query1.Fields.Fields[0].AsString+'='+query1.Fields.Fields[1].AsString);
        query1.Next;
       end;
     end;
    FreeAndNil(Query1); //No novo mobile compiler
end;

function prepareSQL(originalsql: string): string;
begin
 result:=stringreplace(originalsql,'''','''''',[rfReplaceAll ]);
 result:=stringreplace(result,'’','''''',[rfReplaceAll ]);
 result:=stringreplace(result,'‘','''''',[rfReplaceAll ]);
end;

//Receber os campos em Value1 e 2 e retorna os valores
function Get2ValuesSQLite(Connection: TFDConnection;tablename,field1,field2,where:string; var Value1,Value2:string):boolean;
var Query1: TFDQuery;
begin
   Query1:=TFDQuery.Create(nil);
   Query1.Connection:=Connection;
   Query1.SQL.Clear;
   if where<>'' then where:=' where '+where;
   Query1.SQL.Add('select '+field1+','+field2+' from '+tablename+where);
   Query1.Open;
   if query1.RecordCount>0 then
    begin
     value1:= query1.Fields.Fields[0].AsString;
     value2:= query1.Fields.Fields[1].AsString;
     result:=true;
    end
   else
    result:=False;
end;

//Receber os campos em Value1, 2, e 3 e retorna os valores
function Get3ValuesSQLite(Connection: TFDConnection;tablename,field1,field2,field3,where:string; var Value1,Value2,Value3:string):boolean;
var Query1: TFDQuery;
begin
   Query1:=TFDQuery.Create(nil);
   Query1.Connection:=Connection;
   Query1.SQL.Clear;
   if where<>'' then where:=' where '+where;
   Query1.SQL.Add('select '+field1+','+field2+','+ field3+' from '+tablename+where);
   Query1.Open;
   if query1.RecordCount>0 then
    begin
     value1:= query1.Fields.Fields[0].AsString;
     value2:= query1.Fields.Fields[1].AsString;
     value3:= query1.Fields.Fields[2].AsString;
     result:=true;
    end
   else
    result:=False;
end;

//Formato IB dd.mm.yyyy para YYYYMMDD
// ou então dd/mm/yyyy
// ou ainda dd-mm-yyyy
//e aceitamos trocados yyyy-mm-dd ou yyyy/mm/dd ou yyyy.mm.dd
function GetValidSQLDate(FDDate: string): String;
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
  result:=format('%4.4d%2.2d%2.2',[year,month,day]);
end;

//Input: HH:NN(:SS)  Output: HH:MM:SS
function GetValidSQLTime(FDTime: string): string;
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
  result:=format('%2.2d:%2.2d:%2.2d',[hour,min,sec]);
end;

function DoPinLogin(Connection: TFDConnection;  login: string ; Pin: string):boolean;
begin
   if GetNumRecordsSQLite( Connection,'users_unlock',
    'upper(login)='''+uppercase(login)+''' and pin='''+pin+'''')>0
     then result:=true else result:=false;
end;

function DoSmartLogin(Connection: TFDConnection;  login: string; smartlock: string): boolean;
begin
   if GetNumRecordsSQLite( Connection,'users_unlock',
    'upper(login)='''+uppercase(login)+''' and smartlock='''+smartlock+'''')>0
     then result:=true else result:=false;
end;

procedure ChangePass(Connection: TFDConnection;  login: string ; pass: string );
begin
   if GetNumRecordsSQLite(connection,'users_unlock','upper(login)='''+uppercase(login)+'''')=0
   then
    SQLExecuteSQLite(Connection,'insert into users_unlock (login,chave) values ('''+login+''','''+pass+''')')
   else
    SQLExecuteSQLite(Connection,'update users_unlock set chave='''+pass+
     ''' where upper(login)='''+uppercase(login)+'''');
end;

procedure ChangePin(Connection: TFDConnection;  login: string ; Pin: string );
begin
   if GetNumRecordsSQLite(connection,'users_unlock','upper(login)='''+uppercase(login)+'''')=0
   then
    SQLExecuteSQLite(Connection,'insert into users_unlock (login,pin) values ('''+login+''','''+pin+''')')
   else
    SQLExecuteSQLite(Connection,'update users_unlock set pin='''+pin+
     ''' where upper(login)='''+uppercase(login)+'''');
end;

procedure ChangeSmartLock(Connection: TFDConnection; login: string; smartlock: string);
begin
   if GetNumRecordsSQLite(connection,'users_unlock','upper(login)='''+uppercase(login)+'''')=0
   then
    SQLExecuteSQLite(Connection,'insert into users_unlock (login,smartlock) values ('''+login+''','''+smartlock+''')')
   else
    SQLExecuteSQLite(Connection,'update users_unlock set smartlock='''+smartlock+
     ''' where upper(login)='''+uppercase(login)+'''');
end;

procedure SaveLogin(Connection: TFDConnection; login: string; GPSLat,GPSLon:string);
var uid: string;
begin
   SQLExecuteSQLite(Connection,'update config set varvalue='''+login+''' where varname=''lastuser''');
   uid:=GetSQLValueSQLite(Connection,'id','users','upper(login)='''+uppercase(login)+'''');
   if GetNumRecordsSQLite(connection,'users_log','userid='+uid)=0 then
    SQLExecuteSQLite(Connection,'insert into users_log (userid,data,hora,gps_lat,gps_lon) '+
      'values ('+uid+','''+formatdatetime('YYYYMMDD',now)+''','''+
      formatdatetime('HH:NN:SS',now)+''','''+GPSlat+''','''+GPSLon+''')');
end;

function GetSQLList(Connection: TFDConnection;tablename,field,filter: string): string; //devolve do tipo "valor1,valor2,valor3"
var Query1: TFDQuery;
    retorno: string;
begin
    retorno:='';
    Query1:=TFDQuery.Create(nil);
    Query1.Connection:=Connection;
    Query1.SQL.Clear;
    Query1.SQL.Add('select '+field+' from '+tablename);
    if trim(filter)<>'' then
      query1.SQL.Add('where '+filter);
    Query1.Open;
    if query1.RecordCount>0 then
     begin
      while not query1.Eof do
       begin
        if retorno<>'' then
         retorno:=retorno+',';
        retorno:=retorno+(query1.Fields.Fields[0].AsString);
        query1.Next;
       end;
     end;
    FreeAndNil(Query1); //No novo mobile compiler

end;

procedure GetRowDataSQLite(Connection: TFDConnection; var colunas: TStringList; Query: string);
var cd: TFDquery;
    i:integer;
begin
  try

    cd:=TFDquery.Create(nil);
    cd.connection:=Connection;
    cd.SQL.Text:=query;
    cd.Open;
    if cd.RecordCount=1 then
     begin
      for i := 0 to cd.FieldCount - 1 do
       colunas.Add(cd.Fields.Fields[i].FieldName+'='+
          cd.FieldByName(cd.Fields.Fields[i].FieldName).AsString);
     end;
    cd.Close;
    FreeAndNil(cd); //No novo mobile compiler
    //sqlconn.Execute(Query,nil,@ResultSet);
  finally
  end;
end;

function SaveBitmaptoBlobSQLite(Connection: TFDConnection; bmp: TBitmap; FieldName,TableName,Filter: String):boolean;
var blob: TStream;
    Table1: TFDTable ;
begin
  blob:=TMemoryStream.Create;
  BMP.SavetoStream(blob);


  Table1:=TFDTable.Create(nil);
  Table1.Connection:=Connection;
  table1.Params.Add('blobVal',TFieldType.ftBlob);
  table1.Params.ParamByName('blobVal').LoadFromStream(blob,ftBlob);
  table1.SQL.Text:='update '+tablename+' set '+fieldname+'=:blobVal where '+Filter;
  table1.ExecSQL(true);


  FreeAndNil(blob); //No novo mobile compiler

  FreeAndNil(Table1); //No novo mobile compiler

  result:=true;
end;

function LoadBitmapFromBlobSQLite(Connection: TFDConnection; var bmp: TBitmap;FieldName,TableName,Filter: String):boolean;
var blob: TStream;
    Table1: TFDTable;
begin
  Table1:=TFDTable.Create(nil);
  Table1.Connection:=Connection;
  Table1.TableName:=tablename;
  Table1.Open;
  Table1.Filter:=filter;
  Table1.Filtered:=true;
  Table1.Edit;

  blob := Table1.CreateBlobStream(Table1.FieldByName(fieldname),bmWrite);

  try
   bmp.SavetoStream(blob);

  finally
   FreeAndNil(blob); //No novo mobile compiler
  end;

  table1.Post;
  Table1.close;
  FreeAndNil(Table1); //No novo mobile compiler

  result:=true;
end;

function Getnullifempty(value:string): string;
begin
  if value='' then result:='null' else result:=value;
end;

function Getnullifemptyplicas(value:string): string;
begin
  if value='' then result:='null' else result:=''''+value+'''';
end;


end.
