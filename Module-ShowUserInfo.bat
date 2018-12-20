                  
                  @echo off

                        Set "UserID=%1" & Set "UserID=!UserID:"=!"
                        Set "SCANS=SCANS"

                        set "HomeDirectory=%~dp0%"
                        for %%i in ("!HomeDirectory!..\") do set "ParentDirectory=%%~fi"   
                        :::::::::::::::::::::::::::::::::::::
                        
                        echo. & echo.   
                        echo            USER INFORMATION:
                        echo            ================================================================================
                        echo.
                        :::::::::::::::::::::::::::::::::::::
                        Set "UserInformation=!ParentDirectory!!SCANS!\!UserID!\UserInfo"

                                        
                                for /f "Delims=, tokens=1,2,3,4" %%A in ('type "!UserInformation!"') do (
                                        Set "UserID=%%A"
                                        Set "UserName=%%B"
                                        Set "SO=%%C"
                                        Set "CurrentScan=%%D"
                                )
                        
                        echo            User Id:        !UserID!
                        echo.
                        echo            Name:           !UserName!
                        echo.
        if defined so   echo            Sales Order:    !SO!
        if defined so   echo.
If defined CurrentScan  echo           Scan:           !CurrentScan!
If Defined CurrentScan  echo.
