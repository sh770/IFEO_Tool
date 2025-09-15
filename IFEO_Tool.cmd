@echo off
:: ===================================================
:: IFEO_Tool.cmd - מנהל IFEO: חסימה / הצגה / ביטול
:: הערות בקוד בעברית, פלט למשתמש באנגלית
:: ===================================================

:: בדיקה אם הסקריפט רץ בהרשאות מנהל
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrative privileges required - relaunching as admin...
    if "%~1"=="" (
        powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    ) else (
        powershell -Command "Start-Process -FilePath '%~f0' -ArgumentList '%*' -Verb RunAs"
    )
    exit /b
)

echo Running as administrator - continuing...
echo.

:MENU
echo ===============================
echo IFEO Tool - Choose an option:
echo 1. Block EXE file(s)
echo 2. List actually blocked EXE files (with Debugger)
echo 3. Unblock EXE file(s)
echo 4. Exit
echo ===============================
set /p CHOICE=Enter your choice (1-4): 

if "%CHOICE%"=="1" goto :BlockMenu
if "%CHOICE%"=="2" goto :ListBlocked
if "%CHOICE%"=="3" goto :UnblockMenu
if "%CHOICE%"=="4" goto :Exit
echo Invalid choice. Try again.
echo.
goto :MENU

:: ===================================================
:BlockMenu
set /p FILES=Enter EXE filenames to block (comma separated, with or without .exe): 
if "%FILES%"=="" (
    echo No filenames entered. Returning to menu...
    echo.
    goto :MENU
)

setlocal enabledelayedexpansion
for %%F in (%FILES%) do (
    set "FNAME=%%F"
    call :EnsureExe FNAME
    echo Blocking file: !FNAME!
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\!FNAME!" /v Debugger /t REG_SZ /d "debugger.exe" /f >nul 2>&1
    if errorlevel 1 (
        echo ERROR: Failed to add registry entry for !FNAME!.
    ) else (
        echo SUCCESS: !FNAME! blocked.
    )
)
endlocal
echo.
pause
goto :MENU

:: ===================================================
:ListBlocked
echo Currently blocked EXE files (with Debugger):

setlocal enabledelayedexpansion
set "CURRENTKEY="
set "FOUND=0"

for /f "usebackq delims=" %%L in (`reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /s 2^>nul`) do (
    set "LINE=%%L"

    :: אם השורה מתחילה ב-HKEY - נשמור אותה
    if "!LINE:~0,4!"=="HKEY" (
        set "CURRENTKEY=!LINE!"
    ) else (
        :: אם השורה מכילה Debugger - נדפיס את שם הקובץ מהשורה הקודמת
        echo !LINE! | findstr /i "Debugger" >nul
        if !errorlevel! equ 0 (
            for %%F in (!CURRENTKEY!) do set "LAST=%%~nxF"
            echo !LAST!
            set "FOUND=1"
        )
    )
)

if "!FOUND!"=="0" (
    echo (none)
)

endlocal
echo.
pause
goto :MENU





:: ===================================================
:UnblockMenu
set /p FILES=Enter EXE filenames to unblock (comma separated, with or without .exe): 
if "%FILES%"=="" (
    echo No filenames entered. Returning to menu...
    echo.
    goto :MENU
)

setlocal enabledelayedexpansion
for %%F in (%FILES%) do (
    set "FNAME=%%F"
    call :EnsureExe FNAME
    reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\!FNAME!" /v Debugger >nul 2>&1
    if errorlevel 1 (
        echo !FNAME! is already UNBLOCKED or has no Debugger value.
    ) else (
        reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\!FNAME!" /f >nul 2>&1
        if errorlevel 1 (
            echo ERROR: Failed to remove the block for !FNAME!.
        ) else (
            echo SUCCESS: Block removed for !FNAME!.
        )
    )
)
endlocal
echo.
pause
goto :MENU

:: ===================================================
:Exit
echo Exiting IFEO Tool...
echo Window will close automatically in 5 seconds.
for /l %%i in (5,-1,1) do (
    echo %%i...
    timeout /t 1 >nul
)
exit /b

:: ===================================================
:EnsureExe
setlocal enabledelayedexpansion
set "TMP=!%1!"
if /i "!TMP:~-4!" neq ".exe" set "TMP=!TMP!.exe"
endlocal & set "%1=%TMP%"
exit /b
