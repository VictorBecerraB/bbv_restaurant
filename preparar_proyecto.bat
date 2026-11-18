@echo off
REM Prepara el proyecto: genera carpetas de plataforma, descarga dependencias y corre pruebas.
cd /d "%~dp0"
set LOG=%~dp0_log_preparar.txt
echo ==== %DATE% %TIME% > "%LOG%"
echo ==== where >> "%LOG%"
where flutter >> "%LOG%" 2>&1
where git >> "%LOG%" 2>&1
echo ==== flutter --version >> "%LOG%"
call flutter --version >> "%LOG%" 2>&1
echo ==== flutter create >> "%LOG%"
call flutter create . --project-name bbv_restaurant --org com.tacosbrothers --platforms=android,windows,web >> "%LOG%" 2>&1
echo ==== flutter pub get >> "%LOG%"
call flutter pub get >> "%LOG%" 2>&1
echo ==== flutter analyze >> "%LOG%"
call flutter analyze >> "%LOG%" 2>&1
echo ==== flutter test >> "%LOG%"
call flutter test >> "%LOG%" 2>&1
echo ==== flutter devices >> "%LOG%"
call flutter devices >> "%LOG%" 2>&1
echo ==== FIN >> "%LOG%"
