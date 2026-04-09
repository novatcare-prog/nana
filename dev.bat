@echo off
echo ╔══════════════════════════════════════╗
echo ║   MCH Kenya — PC App Installer       ║
echo ╚══════════════════════════════════════╝
echo.

echo ==========================================
echo Building Patient App for Windows...
echo ==========================================
cd /d "%~dp0apps\mch_patient"
echo Cleaning build cache...
call flutter clean
echo Building for Windows...
call flutter build windows

echo Creating Desktop Shortcut for Patient App...
powershell -Command "$wshell = New-Object -ComObject WScript.Shell; $shortcut = $wshell.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\MCH Patient.lnk'); $shortcut.TargetPath = '%~dp0apps\mch_patient\build\windows\x64\runner\Release\mch_patient.exe'; $shortcut.WorkingDirectory = '%~dp0apps\mch_patient\build\windows\x64\runner\Release'; $shortcut.Save()"

echo.
echo ==========================================
echo Building Health Worker App for Windows...
echo ==========================================
cd /d "%~dp0apps\mch_health_worker"
echo Cleaning build cache...
call flutter clean
echo Building for Windows...
call flutter build windows

echo Creating Desktop Shortcut for Health Worker App...
powershell -Command "$wshell = New-Object -ComObject WScript.Shell; $shortcut = $wshell.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\MCH Health Worker.lnk'); $shortcut.TargetPath = '%~dp0apps\mch_health_worker\build\windows\x64\runner\Release\mch_health_worker.exe'; $shortcut.WorkingDirectory = '%~dp0apps\mch_health_worker\build\windows\x64\runner\Release'; $shortcut.Save()"

echo.
echo Apps built for Windows and shortcuts created on your Desktop!
