unit UCommFunction;

interface
uses Windows{MAX_PATH},SysUtils{fileexists},ComObj{createcomobject},ActiveX{IPersistFile},ShlObj{IShellLink},Classes{TStrings};

procedure OperateLinkFile(ExePathAndName:string; LinkFileName: widestring;
  LinkFilePos:integer;AddorDelete: boolean);
function ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):boolean;stdcall;external 'OptionSetForm.dll';
function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'DESCrypt.dll';//解密
function EnCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'DESCrypt.dll';//加密
function GetHDSn(const RootPath:Pchar):Pchar;stdcall;external 'LYFunction.dll';
function TryStrToFloatExt(const pSourStr:Pchar; var Value: Single): Boolean;stdcall;external 'LYFunction.dll';
function StrToList(const SourStr:string;const Separator:string):TStrings;
function CheckSum_Vitros(const ASourStr:string):string;

implementation

procedure OperateLinkFile(ExePathAndName:string; LinkFileName: widestring;
  LinkFilePos:integer;AddorDelete: boolean);
VAR
  tmpobject:IUnknown;
  tmpSLink:IShellLink;
  tmpPFile:IPersistFile;
  PIDL:PItemIDList;
  LinkFilePath:array[0..MAX_PATH]of char;
  StartupFilename:string;
begin
  case LinkFilePos of
    1:SHGetSpecialFolderLocation(0,CSIDL_BITBUCKET,pidl);
    2:SHGetSpecialFolderLocation(0,CSIDL_CONTROLS,pidl);
    3:SHGetSpecialFolderLocation(0,CSIDL_DESKTOP,pidl);
    4:SHGetSpecialFolderLocation(0,CSIDL_DESKTOPDIRECTORY,pidl);
    5:SHGetSpecialFolderLocation(0,CSIDL_DRIVES,pidl);
    6:SHGetSpecialFolderLocation(0,CSIDL_FONTS,pidl);
    7:SHGetSpecialFolderLocation(0,CSIDL_NETHOOD,pidl);
    8:SHGetSpecialFolderLocation(0,CSIDL_NETWORK,pidl);
    9:SHGetSpecialFolderLocation(0,CSIDL_PERSONAL,pidl);
    10:SHGetSpecialFolderLocation(0,CSIDL_PRINTERS,pidl);
    11:SHGetSpecialFolderLocation(0,CSIDL_PROGRAMS,pidl);
    12:SHGetSpecialFolderLocation(0,CSIDL_RECENT,pidl);
    13:SHGetSpecialFolderLocation(0,CSIDL_SENDTO,pidl);
    14:SHGetSpecialFolderLocation(0,CSIDL_STARTMENU,pidl);
    15:SHGetSpecialFolderLocation(0,CSIDL_STARTUP,pidl);
    16:SHGetSpecialFolderLocation(0,CSIDL_TEMPLATES,pidl);
  end;
  shgetpathfromidlist(pidl,LinkFilePath);
  linkfilename:=LinkFilePath+LinkFileName;
  if AddorDelete then
  begin
    if not fileexists(linkfilename) then
    begin
      startupfilename:=ExePathAndName;
      tmpobject:=createcomobject(CLSID_ShellLink);
      tmpSLink:=tmpobject as ishelllink;
      tmpPfile:=tmpobject as IPersistFile;
      tmpslink.SetPath(pchar(startupfilename));
      tmpslink.SetWorkingDirectory(pchar(extractfilepath(startupfilename)));
      tmppfile.save(pwchar(linkfilename),false);
    end;
  end else
  begin
    if fileexists(linkfilename) then deletefile(linkfilename);
  end;
end;

function StrToList(const SourStr:string;const Separator:string):TStrings;
//根据指定的分隔字符串(Separator)将字符串(SourStr)导入到字符串列表中
var
  vSourStr,s:string;
  ll,lll:integer;
begin
  vSourStr:=SourStr;
  Result := TStringList.Create;
  lll:=length(Separator);

  while pos(Separator,vSourStr)<>0 do
  begin
    ll:=pos(Separator,vSourStr);
    Result.Add(copy(vSourStr,1,ll-1));
    delete(vSourStr,1,ll+lll-1);
  end;  //}
  Result.Add(vSourStr);
  s:=vSourStr;
end;

function CheckSum_Vitros(const ASourStr:string):string;
var
  i, R: integer;
begin
  R := 0;
  for i := 1 to Length(ASourStr) do
    R := R + Ord(ASourStr[i]);

  r:= r mod 256;     

  Result:=inttohex(r,2);
end;

end.
