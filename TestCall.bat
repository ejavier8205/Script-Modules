@echo off
SetLocal EnableDelayedExpansion
set HomeDirectory=%~dp0%

:start
cls

set "DPath=\\storage1\Prod\Quality Assurance\SIGNS AND LABELS\Thermal Labels"
call "!HomeDirectory!Module-ListDirectory" "!DPath!"

pause
goto :start

endlocal
