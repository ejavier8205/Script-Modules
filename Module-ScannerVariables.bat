@echo off



::FILES NAMES
Set "UserInfoFile=UserInfo"

::FOLDERS NAMES
Set "ModulesFolder=Script-Modules"
Set "ScansFolder=SCANS"

Set "ScannerWindowTitle=SCANNER SCRIPT"


::LOCAL DIRECTORIES


:: PARENT DIRECTORIES
for %%i in ("!HomeDirectory!..\") do set "ParentDirectory=%%~fi"

        Set "UserInformation=!ParentDirectory!!SCANS!\!UserID!\!UserInfoFile!"
        Set "InputCheckModule=!ParentDirectory!!ModulesFolder!\Module-InputCheck.bat"
        Set "LargeWhiteWindowModule=!ParentDirectory!!ModulesFolder!\Module-LargeWhiteWindow.bat"
        Set "SmallRedWindowModule=!ParentDirectory!!ModulesFolder!\Module-SmallRedWindow.bat"
    if exist "!UserInformation!" for /f "Delims=, tokens=1,2,3,4,5,6,7,8,9,10" %%A in ('type "!UserInformation!"') do (
            Set "UserID=%%A"
            Set "UserName=%%B"
            Set "SO=%%C" 
            Set "DefaultScan=%%D" 
            Set "ScannindMode=%%E" 
            Set "var6=%%F"
            set "var7=%%G"
            Set "var8=%%H"
            Set "var9=%%I"
            Set "var10=%%J"
    )

if "!UserID!"=="!NA!" Set "UserID="
if "!UserName!"=="!NA!" Set "UserName="
if "!SO!"=="!NA!" set "SO="
if "!DefaultScan!"=="!NA!" Set "DefaultScan="
if "!ScannindMode!"=="!NA!" Set "ScannindMode="
If "!Var6!"=="!NA!" Set "Var6="
If "!Var7!"=="!NA!" Set "Var7="
If "!Var8!"=="!NA!" Set "Var8="
If "!Var9!"=="!NA!" Set "Var9="
If "!Var10!"=="!NA!" Set "Var10="
