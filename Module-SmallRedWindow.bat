@echo off
Set "title=%1" & Set "title=!title:"=!"

MODE CON:cols=50 lines=16
color 4f
title !title!