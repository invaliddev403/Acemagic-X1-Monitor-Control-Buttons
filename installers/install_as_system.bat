@echo off
set "APP_NAME=AcemagicControl"
set "INSTALL_DIR=C:\Program Files\%APP_NAME%"
set "EXE_NAME=AcemagicControl.exe"

:: Check for Admin Rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This installer needs Administrator privileges.
    echo Please right-click and select "Run as Administrator".
    pause
    exit
)

echo Installing %APP_NAME% System-Wide...

:: 1. Kill running instances
taskkill /F /IM "%EXE_NAME%" >nul 2>&1

:: 2. Create Directory
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 3. Copy EXE (Assumes EXE is in the same folder as this script)
if not exist "%~dp0%EXE_NAME%" (
    echo [ERROR] %EXE_NAME% not found! Please place the .exe next to this script.
    pause
    exit
)
copy "%~dp0%EXE_NAME%" "%INSTALL_DIR%\" /Y >nul

:: 4. Create Hidden Scheduled Task (Runs at Logon with High Privileges)
schtasks /create /f /sc ONLOGON /tn "%APP_NAME%" /tr "'%INSTALL_DIR%\%EXE_NAME%'" /rl HIGHEST

echo.
echo [SUCCESS] Installed! The buttons will work automatically on next login.
echo You can reboot now to test.
pause