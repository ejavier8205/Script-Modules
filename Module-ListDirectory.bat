@echo off
SetLocal EnableDelayedExpansion
set HomeDirectory=%~dp0%

 Set "DPath=%1" & Set DPath=!DPath:"=!

:start
MODE CON:cols=160 lines=100
title D I R E C T   T H E R M A L   L A B E L   P R I N T   :   A V A I L A B L E   T H E R M A L   L A B E L S
color f0
cls



Set "SelectedLabel="
Set "ChooseLabel="

:SelectThermalLabel

 set count=0
for /f  "tokens=1 delims=" %%A in ('dir "!DPath!" /b /A:D') do ( 
    set "CFolder=%%A"
    echo    _______________________________________________________________________
    echo.
    echo    --!CFolder!--
    echo.
    for /f "tokens=1 delims=" %%a in ('dir "!DPath!\!CFolder!" /b') do (
        set /a count+=1
        set "Label=%%a"
    
        echo                [ !count! ]       !Label!
        if /i "!ChooseLabel!" == "!Count!" goto :LabelSelectionMade
        echo.
        )
)
echo    _______________________________________________________________________

if not defined ChooseLabel goto :enterLabel

:LabelSelectionMade

            title D I R E C T   T H E R M A L   L A B E L   P R I N T   :   L A B E L   S E L E C T E D

            color f5
            cls
            echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.  
            echo                                            S E L E C T E D : !Label!
            echo. & echo. & echo.

            
            CHOICE /c YN /m "-                                  I S   T H I S   C O R R E C T"
            if %errorlevel% equ 2 Set "SelectedLabel=" & goto :start
            if %errorlevel% equ 1 echo !Label!>"%temp%\SelectedLabel" & echo !DPath!\!CFolder!\!Label!>"%temp%\SelectedPath" & goto :SelectionCompleted



:enterLabel
set /p "ChooseLabel=-      S E L E C T   A   L A B E L : "
goto :SelectThermalLabel

:SelectionCompleted
endlocal 



