@echo off
cls
setlocal EnableDelayedExpansion
Set "HomeDirectory=%~dp0%"
MODE CON:cols=120 lines=16
Set "LabelTemplate="
SET "BCPS_White=BCPS LABEL ( WHITE ).btw"
Set "BCPS_Silver=BCPS LABEL ( SILVER ).btw"
Set "ThisScript=%~n0%~x0"

Ping -n 2 -w 2000 storage1 | Find /i "TTL" >nul 2>nul && goto :ConnectionStablished || goto :NoConnection

:NoConnection
        color 47
        echo.
        echo            Labels Directory could not be accessed...Check your network connection.
        echo.
        pause >nul 2>nul
        exit    


:ConnectionStablished
echo            Connection to Storage1....OK
timeout /t 1 >nul 2>nul

        
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::OBTAIN ADMINISTRATIVE PRIVILEGES 
        :getPrivileges
        IF '%1'=='ELEV' (shift & GOTO :gotPrivileges)
        setlocal DisableDelayedExpansion
        SET "batchPath=%~0"
        setlocal EnableDelayedExpansion
        ECHO SET UAC = CreateObject^("Shell.Application"^) > "%temp%\UAC.vbs"
        ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\UAC.vbs"
        

        title BCPS Direc Thermal label printer: Select label to print
                color 5f
                cls
                echo.
                echo            Select the label to print:
                echo.
                echo                    1       !BCPS_Silver!
                echo                    2       !BCPS_White!
                Choice /c 12 /n 
                        If %errorlevel% equ 2 Set "LabelTemplate=!BCPS_White!"
                        If %errorlevel% equ 1 Set "LabelTemplate=!BCPS_Silver!"
                echo !LabelTemplate!>"%temp%\CurrentLabel"
        start /min "" "C:\Program Files (x86)\Seagull\BarTender Suite\bartend.exe" /F="\\storage1\Prod\Quality Assurance\SIGNS AND LABELS\Thermal Labels\BOE-BCPS LABELS\!LabelTemplate!"
        :waitaSec
        cls
        color 5f
        echo.
        echo Opening required Bartender template: !LabelTemplate!
        
        tasklist | findstr /i "bartend" >nul 2>nul && goto FindInTaskBar || goto waitaSec
       
        :FindInTaskBar
         
        "!HomeDirectory!cmdow" /t | Findstr /i "Bartender" >nul 2>nul && goto exitthis || goto waitaSec
        :exitthis
        timeout /t 2 >nul 2>nul
        "%temp%\UAC.vbs"
        exit /b
:gotPrivileges
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


type nul>"%temp%\ScannedSerials.txt"

:start
MODE CON:cols=120 lines=16
color 5f
title BCPS Direc Thermal label printer: Scan serial to print

cls
Set "ScanFile=Serials.txt"
Set "ScanDir=C:\Apex"
Set "Scan=!ScanDir!\!ScanFile!"
set /p LabelTemplate=<"%temp%\CurrentLabel"

Set "InputCheckModule=!HomeDirectory!Module-InputCheck.bat"
if not exist "!ScanDir!" mkdir "!ScanDir!"
:EnterItem
        echo.
        echo            CURRENT LABEL: !LabelTemplate!          
        echo. & echo. & echo.
        echo            Press [ C ]  and Enter to Change Label to print            
        echo.
        echo            Press [ V ] and Enter to view recently scanned items.
        echo.
        echo            Press [ R ] and Enter to re-print ALL recently scanned items.                 
        
        
        If /I "!ITEM!" == "C" Set "ITEM="
        If /I "!ITEM!" == "V" Set "ITEM="
        If /I "!ITEM!" == "R" Set "ITEM="
        

        
        if defined ITEM echo. & echo. & echo.
        if defined ITEM echo            Just printed:   !ITEM!
        echo. & echo. & echo.
        
        Set /p "ITEM=-          SCAN ITEM:    "
                :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                ::Call inputcheck module
                
                if not defined ITEM goto start
                set "Input=!ITEM!"
                if defined Input call "!InputCheckModule!" "!input!"
                set /p Result=<"%temp%\ModuleOutput"
                if ["!Result!"] == ["InvalidInput"] goto start
                :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                set /p ITEM=<"%temp%\ModuleOutputString"
::CHECK IF USER FOLDER EXIST IN SCANS FOLDER


If /I "!ITEM!" == "C" Call "!HomeDirectory!!ThisScript!" & exit

If /I "!ITEM!" == "V" (start /max "" "%Temp%\ScannedSerials.txt") & goto start
If /I "!ITEM!" == "R" (
        goto RePrintAll
) else (
        goto PrintCurrentLabel
)
        
        :RePrintAll
                cls
                echo. & echo.
                title RE-PRINT ALL
                
                type "%temp%\ScannedSerials.txt" | find "" /v /c >"%Temp%\ModuleOutputString"
                Set /p ItemsCount=<"%Temp%\ModuleOutputString"
                
                echo Would you like to print All [ !ItemsCount! ] recently scanned items? [ Y / N ]:
                CHOICE /c YN /n
                        If %errorlevel% equ 2 goto start
                        if %errorlevel% equ 1 goto ContinueToPrint
                
                :ContinueToPrint
                TITLE PRINTING ALL SCANNED ITEMS OF THIS SESSION
                color 2f                  
                type "%Temp%\ScannedSerials.txt">"!Scan!" & goto PrintLabels


:PrintCurrentLabel
Call "!HomeDirectory!Module-ConvertToUpperCase.bat" "!ITEM!"
set /p ITEM=<"%temp%\ModuleOutputString"

echo !ITEM!>"!Scan!"
echo !ITEM!>>"%Temp%\ScannedSerials.txt"

:PrintLabels
start /min ""  "C:\Program Files (x86)\Seagull\BarTender Suite\bartend.exe" /F="\\storage1\Prod\Quality Assurance\SIGNS AND LABELS\Thermal Labels\BOE-BCPS LABELS\!LabelTemplate!" /P

echo !HomeDirectory!Module-ConvertToUpperCase.bat
echo %temp%\ModuleOutputString
pause
goto start
endlocal 
