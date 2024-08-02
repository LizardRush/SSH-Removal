@echo off
setlocal enabledelayedexpansion

rem Fetch the search patterns from the URL
set "url=https://raw.githubusercontent.com/LizardRush/SSH-Removal/main/searchfor.txt"
set "search_patterns="

rem Download the file and read it into the search_patterns variable
for /f "delims=" %%i in ('curl -s %url%') do (
    set "search_patterns=!search_patterns! %%i"
)

set "found_malware="

rem Check for SSH-related processes
for %%m in (!search_patterns!) do (
    tasklist | findstr /I "%%m" >nul
    if !errorlevel! equ 0 (
        echo Found: %%m
        set "found_malware=1"
    )
)

rem Check for executed scripts (e.g., .bat, .cmd, .ps1)
for %%f in (*.bat *.cmd *.ps1) do (
    echo Found executed script: %%~nxf
    set "found_malware=1"
)

if defined found_malware (
    set /p "uninstall=Uninstall these (y/n)? "
    if /i "!uninstall!"=="y" (
        for %%m in (!search_patterns!) do (
            taskkill /IM %%m /F >nul 2>&1
            if !errorlevel! neq 0 (
                echo %%m failed to uninstall, track requests (y/n)?
                set /p "track= "
                if /i "!track!"=="y" (
                    echo Tracking requests from %%m...
                    rem Insert tracking logic here
                )
            )
        )

        for %%f in (*.bat *.cmd *.ps1) do (
            del "%%f" >nul 2>&1
            if !errorlevel! neq 0 (
                echo %%~nxf failed to uninstall, track requests (y/n)?
                set /p "track= "
                if /i "!track!"=="y" (
                    echo Tracking requests from %%~nxf...
                    rem Insert tracking logic here
                )
            )
        )
    )
) else (
    echo No SSH-related processes or executed scripts found.
)

endlocal
