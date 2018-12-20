@echo off

Set "UserID=%1" & Set "UserID=!UserID:"=!"
Set "UserName=%2" & Set "UserName=!UserName:"=!"
Set "SO=%3" & Set "SO=!SO:"=!"
Set "DefaultScanName=%4" & Set "DefaultScanName=!DefaultScanName:"=!"



for %%i in ("!HomeDirectory!..\") do set "ParentDirectory=%%~fi" 
        
        Set "ScansFolder=!ParentDirectory!!SCANS!"
        Set "SOFolder=!ScansFolder!\!UserID!"
        
        Set "CurrentSO=!SOFolder!\!SO!"

set /a count+=1
For /f %%A in ('Dir /b /a:-d /o:n "!CurrentSO!\*.txt"') do (
    Set /a count+=1
    Set "temp=%%A"
    Set "temp2=!temp:~0,-4!"
)


if not defined temp2 Set "count=1" & set "DefaultScanName=!DefaultScanName!-!Count!.txt"
if defined temp2 set "DefaultScanName=!DefaultScanName!-!Count!.txt"

Type nul>"!CurrentSO!\!DefaultScanName!"
echo !UserID!,!UserName!,!SO!,!DefaultScanName!>"!SOFolder!\Userinfo"