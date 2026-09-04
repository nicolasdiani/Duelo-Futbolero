@echo off
rem ============================================================
rem  BAJAR FUTBOL CESTO DESDE GITHUB
rem  Doble click ANTES de ponerte a trabajar en la PC, para
rem  traerte lo que hayas hecho desde la tablet.
rem ============================================================
cd /d "E:\Proyectos\Duelo-Futbolero"

echo.
echo === Cambios locales sin subir ===
git status --short
echo.

git diff --quiet
if errorlevel 1 (
    echo *** OJO: tenes cambios locales sin subir. ***
    echo *** Corre subir.bat primero, o se van a mezclar. ***
    echo.
    pause
    exit /b
)

echo === Bajando de GitHub... ===
git pull origin main
if errorlevel 1 (
    echo.
    echo *** FALLO EL PULL: revisa tu conexion o la configuracion del remoto ***
) else (
    echo.
    echo === Listo! Ya tenes la ultima version. ===
)

echo.
pause
