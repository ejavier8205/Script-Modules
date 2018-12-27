        @echo off
        cls
        setlocal EnableDelayedExpansion
        Set "HomeDirectory=%~dp0%"
        MODE CON:cols=160 lines=30
        Set "LabelTemplate="
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
        
:ChangeLabel

        taskkill /im "bartend.exe" >NUL 2>NUL
        echo No Data>"c:\apex\serials.txt"
        cls
        echo.
        title D I R E C T   T H E R M A L   L A B E L   P R I N T 
        color 5f
        cls
        echo. & echo. & echo.

        
        if not exist "%temp%\SelectedLabel" goto :listTemplates
        if exist "%temp%\SelectedLabel" goto :CheckCurrentTemplate

                :CheckCurrentTemplate
                if /i "!ITEM!" == "C" goto :listTemplates
                Set /p LabelTemplate=<"%temp%\SelectedLabel"

                echo                            C O N T I N U E   U S I N G :   !LabelTemplate!   [ Y / N ]
                Choice /c YN /n 
                        If %errorlevel% equ 2 Goto :listTemplates
                        If %errorlevel% equ 1 Goto :openTemplate
                

:listTemplates

        set "DPath=\\storage1\Prod\Quality Assurance\SIGNS AND LABELS\Thermal Labels"
        call "!HomeDirectory!Module-ListDirectory" "!DPath!"
        Set /p LabelTemplate=<"%temp%\SelectedLabel"


:openTemplate

        ::start "" "C:\Program Files (x86)\Seagull\BarTender Suite\bartend.exe" /min=taskbar /nosplash /F="\\storage1\Prod\Quality Assurance\SIGNS AND LABELS\Thermal Labels\BALTIMORE COUNTY\!LabelTemplate!"
        goto :exitthis

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


        if not exist "%temp%\ScannedSerials.txt" type nul>"%temp%\ScannedSerials.txt"


:start

        MODE CON:cols=160 lines=30
        color 5f
        title D I R E C T   T H E R M A L   L A B E L   P R I N T : S E L E C T   S C A N   M O D E
        cls
        Set "ScanFile=Serials.txt"
        Set "ScanDir=C:\Apex"
        Set "Scan=!ScanDir!\!ScanFile!"
        set /p LabelTemplate=<"%temp%\SelectedLabel"

        If not defined printMode (
                goto :ChooseMode
        ) else (
        goto :EnterItem
        )

:ChooseMode

        cls
        echo. & echo. & echo.

                echo.
                echo            S E L E C T   S C A N   M O D E:
                echo. & echo. & echo.
                echo                    1   D I R E C T   P R I N T
                echo. & echo.
                echo                    2   S C A N   N   P R I N T

        choice /c 12 /n 
                if %errorlevel% equ 2 Set "printMode=SCAN N PRINT"
                if %errorlevel% equ 1 Set "printMode=DIRECT PRINT"
        

:EnterItem

        color 5f
        title  D I R E C T   T H E R M A L   L A B E L   P R I N T   :   S T A R T   S C A N N I N G
        cls

        type "%temp%\ScannedSerials.txt" | find "" /v /c >"%Temp%\ModuleOutputString"
        Set /p ItemsCount=<"%Temp%\ModuleOutputString"

        echo.
        echo            L A B E L:      !LabelTemplate!
        echo.
        echo            M O D E:        !printMode!     
        echo. & echo. & echo.
        echo    _________________________________________________________________________________________________________________________________________________
        echo.
        echo    [ C ] CHANGE LABEL     -     [ V ] VIEW SCAN     -     [ P ] PRINT ALL (!ItemsCount!)     -     [ M ] PRINT MODE     -     [ D ] DELETE DATA        
        echo    _________________________________________________________________________________________________________________________________________________
        
        If /I "!ITEM!" == "C" Set "ITEM="
        If /I "!ITEM!" == "V" Set "ITEM="
        If /I "!ITEM!" == "P" Set "ITEM="
        If /I "!ITEM!" == "M" Set "ITEM="
        If /I "!ITEM!" == "D" Set "ITEM="
        
        if defined ITEM echo. & echo. & echo.
        if defined ITEM echo            L A S T   !ItemMsg!   I T E M:   !ITEM!
        
        echo. & echo. & echo.
        
        Set "ITEM="
        Set "BatchPrint="
        Set /p "ITEM=-          S C A N   I T E M :    "
                :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                ::Call inputcheck module
                Set "InputCheckModule=%HomeDirectory%Module-InputCheck-Custom1.bat"
                if not defined ITEM goto :EnterItem 
                set "Input=!ITEM!"
                if defined Input call "!InputCheckModule!" "!input!"
                set /p Result=<"%temp%\ModuleOutput"
                if ["!Result!"] == ["InvalidInput"] goto :EnterItem
                :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                set /p ITEM=<"%temp%\ModuleOutputString"
::CHECK IF USER FOLDER EXIST IN SCANS FOLDER

                If /I "!ITEM!" == "D" (

                        if !ItemsCount! equ 0 (
                                cls
                                color 4f
                                TITLE N O   D A T A   A V A I L A B L E
                                echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.  
                                echo                                                            N O   D A T A   T O   D E L E T E
                                echo.
                                timeout /t 2 >nul 2>nul
                                GOTO :EnterItem
                        ) 
                 


                        type nul>"%Temp%\ScannedSerials.txt"
                        cls
                        color 4f
                        TITLE D E L E T E   D A T A
                        echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.  
                        echo                                                            D A T A   H A S   B E E N   D E L E T E D
                        echo.
                        timeout /t 2 >nul 2>nul
                        GOTO :EnterItem 
                )

        If /I "!ITEM!" == "M" GOTO :ChooseMode 

        If /I "!ITEM!" == "C" goto :ChangeLabel    

        If /I "!ITEM!" == "V" (start /max "" "%Temp%\ScannedSerials.txt") & goto :EnterItem

        If /I "!ITEM!" == "P" (
                if !ItemsCount! equ 0 (
                        cls
                        color 4f
                        TITLE N O   D A T A   A V A I L A B L E
                        echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.  
                        echo                                                            N O   D A T A   T O   P R I N T
                        echo.
                        timeout /t 2 >nul 2>nul
                        GOTO :EnterItem 
                )
                goto PrintAll
        ) else (
                goto PrintCurrentLabel
        )
        
:PrintAll

                cls
                COLOR DF
                echo. & echo.
                title D I R E C T   T H E R M A L   L A B E L   P R I N T   :   P R I N T   A L L
                
                type "%temp%\ScannedSerials.txt" | find "" /v /c >"%Temp%\ModuleOutputString"
                Set /p ItemsCount=<"%Temp%\ModuleOutputString"
                
                echo            P R I N T   A L L   [ !ItemsCount! ]   I T E M S?   [   Y   /   N   ]:
                CHOICE /c YN /n
                        If %errorlevel% equ 2 goto :EnterItem
                        if %errorlevel% equ 1 goto :ContinueToPrint
                
:ContinueToPrint

                        TITLE D I R E C T   T H E R M A L   L A B E L   P R I N T   :   P R I N T I N G
                        Set "BatchPrint=Y"
                        color df                  
                        type "%Temp%\ScannedSerials.txt">"!Scan!" & goto :startPrinting


:PrintCurrentLabel
        Call "!HomeDirectory!Module-ConvertToUpperCase.bat" "!ITEM!"
        set /p ITEM=<"%temp%\ModuleOutputString"


        FOR /F "tokens=1 delims=," %%A in ('echo !ITEM!') do (
                Set ITEM=%%A
        )

        echo !ITEM!>"!Scan!"
        echo !ITEM!>>"%Temp%\ScannedSerials.txt"

:PrintLabels

        IF /i "!printMode!"  == "SCAN N PRINT" Set "ItemMsg= S A V E D" && GOTO :EnterItem

:startPrinting

        Set "ItemMsg= P R I N T E D"
        echo  SIMULATED PRINT : \\storage1\Prod\Quality Assurance\SIGNS AND LABELS\Thermal Labels\BALTIMORE COUNTY\!LabelTemplate!
        PAUSE
        ::start "" "C:\Program Files (x86)\Seagull\BarTender Suite\bartend.exe" /F="\\storage1\Prod\Quality Assurance\SIGNS AND LABELS\Thermal Labels\BALTIMORE COUNTY\!LabelTemplate!" /P
        
:CheckPrintJob

        if /i "!BatchPrint!" == "Y" (

                cls
                title D I R E C T   T H E R M A L   L A B E L   P R I N T   :   P R I N T   S T A T U S
                echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. 
                set /p  "PrintJob=-                                             L A B E L S   P R I N T E D   P R O P E R L Y ?   [   Y   /   N   ] :   "                        
                echo.

                if /i "!PrintJob!" == "Y"  Type nul>"!Scan!" && Type nul>"%Temp%\ScannedSerials.txt" && goto :EnterItem

                if /i "!PrintJob!" == "N" (
                        goto :EnterItem
                ) else (
                        goto :CheckPrintJob
                )
        )


        goto :EnterItem

endlocal 
