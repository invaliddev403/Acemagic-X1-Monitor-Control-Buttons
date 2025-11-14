@echo off
setlocal
set "APP_NAME=AcemagicControl"
set "INSTALL_DIR=C:\Program Files\%APP_NAME%"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: -------------------------------------------------
:: Check for the /legacy switch
:: -------------------------------------------------
if /I "%1" == "/legacy" goto :LegacyUninstall

:: -------------------------------------------------
:: Default Mode: Full System Uninstall
:: -------------------------------------------------
:FullUninstall
echo Uninstalling CURRENT (System Task) version...
echo This will remove the System Task and Program Files.
echo.

:: Check for Admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This uninstaller needs Administrator privileges.
    echo Please right-click and select "Run as Administrator".
    echo.
    echo To remove only the Startup version, run:
    echo uninstall.bat /legacy
    pause
    goto :eof
)

call :KillProcess
call :RemoveSystemTask
call :RemoveProgramFiles
call :RemoveLegacy
echo.
echo [SUCCESS] Full uninstallation complete.
goto :Done

:: -------------------------------------------------
:: Legacy Mode: Startup Folder Only
:: -------------------------------------------------
:LegacyUninstall
echo Uninstalling LEGACY Startup Folder version...
echo.
call :KillProcess
call :RemoveLegacy
echo.
echo [SUCCESS] Legacy version removed.
goto :Done


:: -------------------------------------------------
:: --- FUNCTIONS ---
:: -------------------------------------------------

:KillProcess
echo  - Stopping %APP_NAME%.exe process...
taskkill /F /IM "%APP_NAME%.exe" >nul 2>&1
goto :eof

:RemoveLegacy
echo  - Cleaning Startup Folder...
:: Remove the EXE if installed via script
if exist "%STARTUP_DIR%\%APP_NAME%.exe" (
    del "%STARTUP_DIR%\%APP_NAME%.exe"
    echo     -> Deleted AcemagicControl.exe from Startup.
)
:: Remove the Shortcut if created manually
if exist "%STARTUP_DIR%\%APP_NAME%.lnk" (
    del "%STARTUP_DIR%\%APP_NAME%.lnk"
    echo     -> Deleted AcemagicControl.lnk from Startup.
)
:: Remove the Python script shortcut (older manual method)
if exist "%STARTUP_DIR%\AcemagicControl.pyw.lnk" (
    del "%STARTUP_DIR%\AcemagicControl.pyw.lnk"
    echo     -> Deleted Python script shortcut.
)
goto :eof

:RemoveSystemTask
echo  - Removing System Task...
schtasks /delete /tn "%APP_NAME%" /f >nul 2>&1
goto :eof

:RemoveProgramFiles
echo  - Removing Program Files directory...
if exist "%INSTALL_DIR%" (
    rmdir /s /q "%INSTALL_DIR%"
    echo     -> Directory deleted.
)
goto :eof

:Done
pause
endlocal