@echo off
REM =====================================================
REM MCH Kenya Health Worker - Development Build Script
REM =====================================================

REM Load environment variables from .env file
for /f "tokens=1,2 delims==" %%a in (.env) do (
    if "%%a"=="SUPABASE_URL" set SUPABASE_URL=%%b
    if "%%a"=="SUPABASE_ANON_KEY" set SUPABASE_ANON_KEY=%%b
)

echo Running MCH Health Worker (Development)...
echo Supabase URL: %SUPABASE_URL%

flutter run --dart-define=SUPABASE_URL=%SUPABASE_URL% --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY% %*
