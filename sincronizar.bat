@echo off
rem ============================================================
rem  SINCRONIZAR FUTBOL CESTO
rem  Doble click ANTES y DESPUES de trabajar en la PC.
rem  Hace todo en el orden correcto: guarda lo tuyo, se trae lo
rem  de la tablet, y despues sube todo junto.
rem ============================================================
cd /d "%~dp0"

echo.
echo ============================================
echo   SINCRONIZANDO FUTBOL CESTO
echo ============================================
echo.
echo --- Cambios locales ---
git status --short
echo.

rem 1) Guardar lo que hiciste en la PC, si hay algo
git add -A
git diff --cached --quiet
if errorlevel 1 (
    echo [1/3] Guardando tus cambios locales...
    git commit -m "Actualizacion PC %date% %time:~0,5%"
) else (
    echo [1/3] No hay cambios nuevos en la PC.
)

rem 2) Traer lo de la tablet y apoyar lo tuyo encima
echo.
echo [2/3] Trayendo cambios de GitHub...
git pull --rebase origin main
if errorlevel 1 (
    echo.
    echo ============================================
    echo   *** CONFLICTO ***
    echo   Tocaron el mismo archivo desde los dos
    echo   lados. NO subas nada todavia.
    echo   Pedile a Claude que lo resuelva.
    echo ============================================
    echo.
    pause
    exit /b
)

rem 3) Subir todo
echo.
echo [3/3] Subiendo a GitHub...
git push origin main
if errorlevel 1 (
    echo.
    echo *** FALLO EL PUSH: revisa tu conexion ***
) else (
    echo.
    echo ============================================
    echo   LISTO. PC, tablet y las dos webs
    echo   quedaron con la misma version.
    echo ============================================
)

echo.
pause
