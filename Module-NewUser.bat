     @echo off
    SetLocal EnableDelayedExpansion
    
    set "HomeDirectory=%~dp0%"


    ::SET CURRENT DIRECTORY
   
    Set "NewUserID=%1" & Set "NewUserID=!NewUserID:"=!"
    
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

    if not exist "!ScansFolder!\!NewUserID!" mkdir "!ScansFolder!\!NewUserID!"


    echo    User !NewUserID! folder has been created!.
    echo.
    set /p "NewUserName=-       Please enter first and last name:"
                :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                ::Call inputcheck module
                set "Input=!NewUserName!"

                if not defined Input goto start
                if defined Input call "!InputCheckModule!" "!Input!" [0-9]
                set /p Result=<"%temp%\ModuleOutput"
                if ["!Result!"] == ["InvalidInput"] goto start
                :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                Set /p NewUserName=<"%temp%\ModuleOutputString"

                echo !NewUserID!,!NewUserName!>"!ScansFolder!\!NewUserID!\UserInfo"

EndLocal