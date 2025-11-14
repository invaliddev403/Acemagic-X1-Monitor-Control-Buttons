@echo off
echo Building AcemagicControl.exe...

:: Ensure PyInstaller is installed
pip install pyinstaller >nul 2>&1

:: Run Build
:: Output will be placed in the "installers" folder for easy access
cd ..
pyinstaller --noconsole --onefile --clean --distpath installers --name "AcemagicControl" src\AcemagicControl.pyw

:: Cleanup Junk
rmdir /s /q build
del AcemagicControl.spec

echo.
echo Build Complete! Check the "installers" folder for the new EXE.
pause