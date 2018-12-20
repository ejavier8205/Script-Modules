@echo off
cls
Mode con: cols=80 lines=15
color 4f
title SCRIPT UNDER CONSTRUCTION
echo.
echo        This script or module still under development.
echo.
choice /c YN /n /m "-       Would you like to continue? [ Y / N ]: "
    If %errorlevel% equ 2 exit
    If %errorlevel% equ 1 exit /b