@echo off
REM Windows ICO Generator Script
REM Requires Python with Pillow: pip install Pillow

echo ===================================
echo Windows ICO Generator for Nana Apps
echo ===================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://python.org
    pause
    exit /b 1
)

REM Check if Pillow is installed
python -c "import PIL" >nul 2>&1
if errorlevel 1 (
    echo Installing Pillow...
    pip install Pillow
)

echo Generating ICO files...
echo.

python generate_windows_icons.py

echo.
echo Done! ICO files have been generated.
echo Please rebuild the Windows apps to apply the new icons.
pause
