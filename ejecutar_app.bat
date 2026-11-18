@echo off
REM Ejecuta la app BBV Restaurant como aplicacion de escritorio de Windows.
REM Para correrla en Chrome cambia "-d windows" por "-d chrome".
cd /d "%~dp0"
call flutter run -d windows
pause
