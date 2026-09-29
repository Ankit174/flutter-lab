@echo off
title Temperature Converter Launcher
echo ========================================================
echo   Starting Temperature Converter Mobile App in Chrome...
echo ========================================================
cd /d "%~dp0"
"C:\src\flutter\bin\flutter.bat" run -d chrome
pause
