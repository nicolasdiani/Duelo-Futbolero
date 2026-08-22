@echo off
rem ============================================================
rem  SUBIR FUTBOL CESTO A GITHUB
rem  Doble click en este archivo cada vez que quieras subir
rem  los cambios. Solo commitea si hay algo nuevo.
rem ============================================================
cd /d "F:\CLAUDE PROYECTOS\Skate web\futbol-cesto"

echo.
echo === Cambios detectados ===
git status --short
echo.

git add -A
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Actualizacion %date% %time:~0,5%"
    echo.
    echo === Subiendo a GitHub... ===
    git push origin main
    if errorlevel 1 (
        echo.
        echo *** FALLO EL PUSH: revisa tu conexion o la configuracion del remoto ***
    ) else (
        echo.
        echo === Listo! Proyecto subido. ===
    )
) else (
    echo No hay cambios nuevos desde la ultima subida.
)

echo.
pause
