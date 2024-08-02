@echo off
setlocal enabledelayedexpansion

echo Terminating all non-system EXE applications...

rem Get the list of all processes excluding system processes
for /f "tokens=1,2" %%i in ('tasklist /FO CSV ^| findstr /V "System Idle Process,System"') do (
    set "process_name=%%~nxi"
    echo Terminating process: !process_name!
    taskkill /F /IM "!process_name!" >nul 2>&1
)

echo All non-system EXE applications have been terminated.
endlocal
