@echo off

SetLocal EnableDelayedExpansion
Set "Input=%1" & Set Input=!Input:"=!


for %%L IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO SET input=!input:%%L=%%L!

echo !Input!>"%temp%\ModuleOutputString"


EndLocal
EXIT /b

