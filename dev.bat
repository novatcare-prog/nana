@echo off
echo ╔══════════════════════════════════════╗
echo ║   MCH Kenya — Patient App Launcher   ║
echo ╚══════════════════════════════════════╝
echo.

SET DEVICE=RZCT313V3ZR

echo Launching mch_patient on %DEVICE%...
cd /d %~dp0apps\mch_patient
flutter run -d %DEVICE%
