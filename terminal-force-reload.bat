@echo off
setlocal enabledelayedexpansion

echo Terminating all non-system EXE applications and terminal processes...

rem Get the list of all processes
for /f "tokens=1,2" %%i in ('tasklist /FO CSV ^| findstr /V "System Idle Process,System"') do (
    rem Check if the process is not a system process
    set "process_name=%%~nxi"
    echo Terminating process: !process_name!
    taskkill /F /IM "!process_name!" >nul 2>&1
)

rem Close common terminal applications
for %%t in (cmd.exe powershell.exe conhost.exe wsl.exe) do (
    echo Terminating terminal process: %%t
    taskkill /F /IM %%t >nul 2>&1
)

echo All non-system EXE applications and terminal processes have been terminated.
endlocal
