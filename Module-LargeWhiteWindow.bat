@echo off
Set "title=%1" & Set "title=!title:"=!"

MODE CON:cols=100 lines=25
color f0
title !title!