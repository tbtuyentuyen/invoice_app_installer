
; variable
#define AppPath "{app}"
#define PythonInstaller "python-3.12.9-amd64.exe"
#define PythonInstallPath "{app}\python"
#define MongoDBFile "mongod.exe"
#define MongoDBInstallPath "{app}\mongodb"
#define MongoDBPath "{app}\InvoiceDatabase"
#define AppFolder "invoice_app"

[Setup]
AppName=InvoiceApp
AppVersion=1.0
DefaultDirName={commonpf}\InvoiceApp
DisableDirPage=no
UsePreviousAppDir=yes
DefaultGroupName=InvoiceApp
OutputDir=Output
OutputBaseFilename=InvoiceAppSetup

[Dirs]
; create the parent folder for python if you want (optional)
Name: "{#PythonInstallPath}"
Name: "{#MongoDBInstallPath}"
Name: "{#MongoDBPath}"

[Files]
; Bundle the Python installer into your setup
Source: "bin\{#PythonInstaller}"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "bin\{#MongoDBFile}"; DestDir: "{#MongoDBInstallPath}"
Source: "{#AppFolder}\*"; DestDir: "{app}\{#AppFolder}"; Flags: recursesubdirs

[Icons]
Name: "{group}\InvoiceApp"; Filename: "{app}\run.bat"
Name: "{commondesktop}\InvoiceApp"; Filename: "{app}\run.bat"

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "INVOICE_APP_HOME"; ValueData: "{app}"; Flags: preservestringtype
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "INVOICE_PYTHON"; ValueData: "{#PythonInstallPath}"; Flags: preservestringtype
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "INVOICE_APP_PATH"; ValueData: "{app}\{#AppFolder}"; Flags: preservestringtype
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "MONGOD_EXE"; ValueData: "{#MongoDBInstallPath}/{#MongoDBFile}"; Flags: preservestringtype
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "DB_PATH"; ValueData: "{#MongoDBPath}"; Flags: preservestringtype


[Run]
Filename: "{tmp}\{#PythonInstaller}"; \
  Parameters: "/quiet InstallAllUsers=0 Include_doc=0 Include_test=0 Include_pip=1 TargetDir=""{#PythonInstallPath}"""; \
  StatusMsg: "Installing Python..."; \
  Flags: waituntilterminated runhidden; \
  Check: InstallPython;

Filename: "{app}\python\python.exe"; \
  Parameters: "-m pip install openpyxl==3.1.5"; \
  StatusMsg: "Installing openpyxl components..."; \
  Flags: waituntilterminated runhidden; \
  Check: InstallOpenpyxl

Filename: "{app}\python\python.exe"; \
  Parameters: "-m pip install Pillow==12.1.0"; \
  StatusMsg: "Installing Pillow components..."; \
  Flags: waituntilterminated runhidden; \
  Check: InstallPillow

Filename: "{app}\python\python.exe"; \
  Parameters: "-m pip install pydotdict==3.3.11"; \
  StatusMsg: "Installing pydotdict components..."; \
  Flags: waituntilterminated runhidden; \
  Check: InstallPydotdict

Filename: "{app}\python\python.exe"; \
  Parameters: "-m pip install pymongo==4.15.5"; \
  StatusMsg: "Installing pymongo components..."; \
  Flags: waituntilterminated runhidden; \
  Check: InstallPymongo

Filename: "{app}\python\python.exe"; \
  Parameters: "-m pip install PyQt5==5.15.11"; \
  StatusMsg: "Installing PyQt5 components..."; \
  Flags: waituntilterminated runhidden; \
  Check: InstallPyQt5

Filename: "{app}\python\python.exe"; \
  Parameters: "-m pip install QtAwesome==1.4.0"; \
  StatusMsg: "Installing QtAwesome components..."; \
  Flags: waituntilterminated runhidden; \
  Check: InstallQtAwesome

Filename: "{app}\python\python.exe"; \
  Parameters: "-m pip install Spire.Xls.Free==14.12.4"; \
  StatusMsg: "Installing Spire.Xls.Free components..."; \
  Flags: waituntilterminated runhidden; \
  Check: InstallSpireXls

Filename: "cmd"; Parameters: "/c setx ""{#PythonInstallPath}"""; Flags: runhidden

[Code]
var
  ComponentPage: TInputOptionWizardPage;

procedure InitializeWizard();
begin
  ComponentPage := CreateInputOptionPage(
    wpSelectDir,
    'Optional components',
    'Choose components to install',
    'Select the features you want',
    False, False);

  ComponentPage.Add('Install Python (required)');
  ComponentPage.Add('Openpyxl');
  ComponentPage.Add('Pillow');
  ComponentPage.Add('Pydotdict');
  ComponentPage.Add('Pymongo');
  ComponentPage.Add('PyQt5');
  ComponentPage.Add('QtAwesome');
  ComponentPage.Add('Spire.Xls.Free');
  
  ComponentPage.Values[0] := True;
  ComponentPage.Values[1] := True;  
  ComponentPage.Values[2] := True;
  ComponentPage.Values[3] := True;
  ComponentPage.Values[4] := True;
  ComponentPage.Values[5] := True;
  ComponentPage.Values[6] := True;
  ComponentPage.Values[7] := True;
end;

function InstallPython(): Boolean;
begin
  Result := ComponentPage.Values[0];
end;

function InstallOpenpyxl(): Boolean;
begin
  Result := ComponentPage.Values[1];
end;

function InstallPillow(): Boolean;
begin
  Result := ComponentPage.Values[2];
end;

function InstallPydotdict(): Boolean;
begin
  Result := ComponentPage.Values[3];
end;

function InstallPymongo(): Boolean;
begin
  Result := ComponentPage.Values[4];
end;

function InstallPyQt5(): Boolean;
begin
  Result := ComponentPage.Values[5];
end;

function InstallQtAwesome(): Boolean;
begin
  Result := ComponentPage.Values[6];
end;

function InstallSpireXls(): Boolean;
begin
  Result := ComponentPage.Values[7];
end;

procedure CreateRunBat();
var
  BatContent: string;
  BatPath: string;
begin
  BatPath := ExpandConstant('{app}\run.bat');

  BatContent :=
    '@echo off' + #13#10 +
    'set INVOICE_APP_HOME=' + ExpandConstant('{app}') + #13#10 +
    'set INVOICE_APP_PATH=' + ExpandConstant('{app}\{#AppFolder}') + #13#10 +
    'set MONGOD_EXE=' + ExpandConstant('{#MongoDBInstallPath}\{#MongoDBFile}') + #13#10 +
    'set DB_PATH=' + ExpandConstant('{#MongoDBPath}') + #13#10 +
    'set CONFIG_DIR=%INVOICE_APP_HOME%\user_data' + #13#10 +
    '"%INVOICE_PYTHON%\python.exe" "%INVOICE_APP_PATH%\main.py"' + #13#10;

  SaveStringToFile(BatPath, BatContent, False);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    CreateRunBat();
  end;
end;