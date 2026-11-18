@echo off
REM Crea el repositorio git local con el avance 1 y, si GitHub CLI esta instalado, lo publica.
cd /d "%~dp0"
set LOG=%~dp0_log_git.txt
echo ==== %DATE% %TIME% > "%LOG%"
git config user.name >nul 2>&1 || git config user.name "Victor Becerra Benavides"
git config user.email >nul 2>&1 || git config user.email "victor@users.noreply.github.com"
if not exist .git git init -b main >> "%LOG%" 2>&1
git add -A >> "%LOG%" 2>&1
git commit -m "Avance 1: login, pantalla inicial de mesas, mockups y propuesta" >> "%LOG%" 2>&1
git log --oneline -3 >> "%LOG%" 2>&1
echo ==== gh >> "%LOG%"
where gh >> "%LOG%" 2>&1 && (
  gh auth status >> "%LOG%" 2>&1 && gh repo create bbv-restaurant --public --source . --remote origin --push --description "App Flutter de comandas para Tacos Brothers (BBV Restaurant)" >> "%LOG%" 2>&1
)
git remote -v >> "%LOG%" 2>&1
echo ==== FIN >> "%LOG%"
