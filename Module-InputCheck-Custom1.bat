
    ::==========================================================================================================
    :: Description

            ::  receives a string a validates input format
            ::  Does not allow numbers or symbols 
            ::  removes trailing spaces
            ::  Outputs:    validation result & string without trailing spaces
    
    ::==========================================================================================================
    
    
    @echo off
    SetLocal EnableDelayedExpansion
    set HomeDirectory=%~dp0%

    ::SET CURRENT DIRECTORY

    ::PASS VARIABLES

    Set "Input=%1" & Set Input=!Input:"=!
    Set "InputType=%2"
    Set "InputType2=%3"
 


    Set "Tab1=     "
    Set "Tab2=          "
  
     ::INPUT AUTHENTICATION
            :InputCheck

            Set  "InputCheck=ValidInput"
            echo !Input! | Findstr /r "!InputType! ^! ^@ ^~ & ( ) ` - _ + = { } [ ] ; : ' " >nul 2>nul
            
            if %errorlevel% equ 0 (
                color 8f
                Set  "InputCheck=InvalidInput"
                echo.
                echo !tab2! Invalid entry.
                timeout /t 2 >nul 2>nul
            )
    
            for /f "tokens=* delims= " %%a in ("%input%") do set input=%%a
            for /l %%a in (1,1,100) do if "!input:~-1!"==" " set input=!input:~0,-1!


    ::pass variables
    EndLocal & Set "StringOutput=%input%" & Set "InputStatus=%InputCheck%"