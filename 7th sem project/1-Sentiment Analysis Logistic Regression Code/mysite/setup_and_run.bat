@echo off
setlocal EnableDelayedExpansion
title Sentiment Analysis - Setup and Run

:: Go to the folder where this batch file lives (mysite)
cd /d "%~dp0"

echo.
echo ============================================
echo   Sentiment Analysis - Setup and Run
echo ============================================
echo.

:: --- Step 1: Find or install Python ---
set "PYTHON_CMD="
where python >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('python -c "import sys; print(sys.executable)" 2^>nul') do set "PYTHON_CMD=%%i"
)
if not defined PYTHON_CMD (
    where py >nul 2>&1
    if %errorlevel% equ 0 (
        for /f "tokens=*" %%i in ('py -3 -c "import sys; print(sys.executable)" 2^>nul') do set "PYTHON_CMD=%%i"
    )
)

if not defined PYTHON_CMD (
    echo [1/2] Python not found. Attempting to install via winget...
    winget install Python.Python.3.12 --accept-package-agreements --accept-source-agreements 2>nul
    if %errorlevel% neq 0 (
        echo.
        echo   Could not install Python automatically.
        echo   Please install Python 3 from https://www.python.org/downloads/
        echo   Make sure to check "Add Python to PATH" during installation.
        echo   Then run this batch file again.
        echo.
        pause
        exit /b 1
    )
    echo.
    echo   Python was installed. Please close this window, then double-click
    echo   setup_and_run.bat again to continue setup and run the project.
    echo.
    pause
    exit /b 0
)

:: Prefer 'python' for the rest of the script so venv activation works
where python >nul 2>&1
if %errorlevel% equ 0 (
    set "PY=python"
) else (
    set "PY=py -3"
)
echo [1/6] Using Python: %PY%
%PY% --version
echo.

:: --- Step 2: Create virtual environment if missing ---
if not exist "venv\Scripts\activate.bat" (
    echo [2/6] Creating virtual environment...
    %PY% -m venv venv
    if %errorlevel% neq 0 (
        echo Failed to create venv.
        pause
        exit /b 1
    )
    echo   Done.
) else (
    echo [2/6] Virtual environment already exists.
)
echo.

:: --- Step 3: Activate venv and install requirements ---
echo [3/6] Activating venv and installing requirements...
call venv\Scripts\activate.bat
pip install -q --upgrade pip
pip install -q -r requirements.txt
if %errorlevel% neq 0 (
    echo pip install failed.
    pause
    exit /b 1
)
echo   Done.
echo.

:: --- Step 4: Download NLTK data ---
echo [4/6] Downloading NLTK data (twitter_samples, stopwords)...
python -c "import nltk; nltk.download('twitter_samples', quiet=True); nltk.download('stopwords', quiet=True); print('  Done.')"
echo.

:: --- Step 5: Train model (create pickles) if missing ---
if not exist "polls\freqs.pickle" (
    echo [5/6] Training sentiment model (first time only, may take a minute)...
    cd polls
    python Sentiment_classifier_LG.py
    cd ..
    if not exist "polls\freqs.pickle" (
        echo   Training failed or pickles not created.
        pause
        exit /b 1
    )
    echo   Done.
) else (
    echo [5/6] Model files already exist, skipping training.
)
echo.

:: --- Step 6: Django migrate and run server ---
echo [6/6] Applying migrations and starting server...
python manage.py migrate --noinput
if %errorlevel% neq 0 (
    echo migrate failed.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   Server starting. Open in browser:
echo   http://127.0.0.1:8000/
echo ============================================
echo   Press Ctrl+C to stop. Run this batch file
echo   again to start the server if it stops.
echo ============================================
echo.

:run
python manage.py runserver
echo.
echo Server stopped. Restarting in 3 seconds...
timeout /t 3 /nobreak >nul
goto run
