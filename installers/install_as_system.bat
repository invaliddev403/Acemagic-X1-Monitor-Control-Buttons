@echo off
set "APP_NAME=AcemagicControl"
set "INSTALL_DIR=C:\Program Files\%APP_NAME%"
set "EXE_NAME=AcemagicControl.exe"

:: Check for Admin Rights (Required for Program Files & Task Scheduler)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This installer needs Administrator privileges.
    echo Please right-click and select "Run as Administrator".
    pause
    exit
)

echo Installing %APP_NAME% System-Wide...
echo.

:: 1. Kill running instances
taskkill /F /IM "%EXE_NAME%" >nul 2>&1

:: 2. Create Program Files Directory
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

:: 3. Copy EXE to permanent location
if not exist "%~dp0%EXE_NAME%" (
    echo [ERROR] %EXE_NAME% not found in current folder!
    pause
    exit
)

copy "%~dp0%EXE_NAME%" "%INSTALL_DIR%\" /Y >nul
if %errorLevel% neq 0 (
    echo [ERROR] Failed to copy files.
    pause
    exit
)

:: 4. Create the Scheduled Task (Runs hidden at Logon with High Privileges)
:: /sc ONLOGON = Runs when user logs in
:: /rl HIGHEST = Runs with admin rights (bypasses UAC prompts)
:: /tn = Task Name
:: /tr = Path to executable
schtasks /create /f /sc ONLOGON /tn "%APP_NAME%" /tr "'%INSTALL_DIR%\%EXE_NAME%'" /rl HIGHEST

echo.
echo [SUCCESS] Installed successfully!
echo.
echo  - Location: %INSTALL_DIR%
echo  - Trigger:  Runs automatically at User Logon
echo  - Status:   Active
echo.
echo You can start it now by rebooting or running the EXE manually once.
pause