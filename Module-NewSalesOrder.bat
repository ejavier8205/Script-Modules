     @echo off
    SetLocal EnableDelayedExpansion
    
    set "HomeDirectory=%~dp0%"


    ::SET CURRENT DIRECTORY
   
    Set "UserID=%1" & Set "UserID=!UserID:"=!"
    Set "UserName=%2" & Set "UserName=!UserName:"=!"
    Set "NewSO=%3" & Set "NewSO=!NewSO:"=!"

    :start
 
    cls
    ::VARIABLES

    Set "Tab1=     "
    Set "Tab2=          "
    Set "ModulesFolder=Script-Modules"
    Set "ScansFolder=SCANS"
    Set "NewUserName="

    Set "InputCheckModule=!HomeDirectory!Module-InputCheck.bat"
    
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: Set Requiered Parent Directories
            for %%i in ("!HomeDirectory!..\") do set "ParentDirectory=%%~fi" 
            
            ::SCANS FOLDER
            Set "ScansFolder=!ParentDirectory!!ScansFolder!"

    if not exist "!ScansFolder!\!UserID!\!NewSO!" mkdir "!ScansFolder!\!UserID!\!NewSO!"

    echo.

                echo !UserID!,!UserName!,!NewSO!>"!ScansFolder!\!UserID!\UserInfo"

EndLocal