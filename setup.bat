@echo off
REM Enabling deferred variable extension is the key to correctly obtaining variable values in the IF/FOR code block
SETLOCAL ENABLEDELAYEDEXPANSION
REM Set the code page to UTF-8 to support various characters
chcp 65001 >nul

echo.
echo ================================================
echo        md2notion - Setup Script
echo ================================================
echo.

REM --- 1. check Node.js env ---
echo 1. Checking for Node.js installation...
node --version >nul 2>nul
if !errorlevel! neq 0 (
    echo    ERROR: Node.js is not installed or not in PATH.
    echo    Please install Node.js from https://nodejs.org/ and run this script again.
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('node --version') do set "node_version=%%i"
echo    ^> Node.js found: %node_version%


REM --- 2. install Node.js dependencies ---
echo.
echo 2. Installing Node.js dependencies...
if exist "%~dp0package.json" (
    call npm install
    if !errorlevel! neq 0 (
        echo    ERROR: Failed to install Node.js dependencies. Check your network or run 'npm install' manually.
        pause
        exit /b 1
    ) else (
        echo    ^> Dependencies installed successfully.
    )
) else (
    echo    ERROR: package.json not found in the current directory.
    pause
    exit /b 1
)

REM --- 3. check .env configuration file ---
echo.
echo 3. Checking for configuration file...
if not exist "%~dp0.env" (
    if exist "%~dp0.env.example" (
        echo    ^> .env file not found, creating from example...
        copy "%~dp0.env.example" "%~dp0.env"
        echo    IMPORTANT: Please edit the .env file with your Notion integration token and page ID.
    ) else (
        echo    WARNING: Neither .env nor .env.example found.
        echo    Please create a .env file containing NOTION_TOKEN and NOTION_PAGE_ID.
    )
) else (
    echo    ^> .env configuration file found.
)

REM --- 4. check and prepare AutoHotkey ---
echo.
echo 4. Checking for AutoHotkey...
if exist "%~dp0AutoHotkey\AutoHotkeyU64.exe" (
    echo    ^> AutoHotkey found.
) else (
    echo    ^> AutoHotkey not found. Attempting to download...
    powershell -Command "Invoke-WebRequest -Uri 'https://www.autohotkey.com/download/1.1/AutoHotkey_1.1.37.02.zip' -OutFile '%~dp0AutoHotkey.zip'"
    if !errorlevel! neq 0 (
        echo    ERROR: Failed to download AutoHotkey. Please check your network or install it manually.
        pause
        exit /b 1
    )
    powershell -Command "Expand-Archive -Path '%~dp0AutoHotkey.zip' -DestinationPath '%~dp0AutoHotkey' -Force"
    del "%~dp0AutoHotkey.zip"
    
    if exist "%~dp0AutoHotkey\AutoHotkeyU64.exe" (
        echo    ^> AutoHotkey downloaded and extracted successfully.
    ) else (
        echo    ERROR: Failed to download or extract AutoHotkey.
        pause
        exit /b 1
    )
)

REM --- 5. Verify whether the required script file exists. ---
echo.
echo 5. Verifying required scripts...
if exist "%~dp0mdfile2notion.ps1" (
    echo    ^> mdfile2notion.ps1 found.
) else (
    echo    ERROR: mdfile2notion.ps1 not found.
    pause
    exit /b 1
)

if exist "%~dp0clipboard2notion.ps1" (
    echo    ^> clipboard2notion.ps1 found.
) else (
    echo    ERROR: clipboard2notion.ps1 not found.
    pause
    exit /b 1
)

if exist "%~dp0markdown2notion.ahk" (
    echo    ^> clipboard2notion.ahk found ^(for clipboard hotkey functionality^).
    powershell -Command "%~dp0AutoHotkey\AutoHotkeyU64.exe %~dp0markdown2notion.ahk"
) else (
    echo    INFO: clipboard2notion.ahk not found. Clipboard hotkey will not be available.
)

echo.
echo ================================================
echo  Setup completed successfully!
echo ================================================
echo.
echo Next steps:
echo 1. Edit the .env file with your Notion integration token and page ID.
echo 2. To upload Markdown files, click any .md file and press hotkey Ctrl+Alt+U.
echo 3. To upload from clipboard, copy the target content and press hotkey Ctrl+Alt+N.
echo 4. If you want to modify the hotkeys, edit the markdown2notion.ahk script.
echo.
pause