@echo off
:: Script created by smug_cat

setlocal EnableDelayedExpansion

:: Define firewall rule name
set "RuleName=BlockSteamAccess"

:: Define paths for Steam and Steam Service
set "SteamPath=C:\Program Files (x86)\Steam"
set "SteamServicePath=C:\Program Files (x86)\Common Files\Steam\steamservice.exe"

:: Predefined paths for Steam executables
set "SteamExePath=%SteamPath%\Steam.exe"
set "SteamWebHelperPath=%SteamPath%\bin\cef\cef.win7x64\steamwebhelper.exe"

:Start
cls
echo Steam Internet Access Control
echo --------------------------------
call :CheckAccess
echo --------------------------------
echo 1. Block Steam Internet Access
echo 2. Allow Steam Internet Access
echo 3. Exit
echo.
echo Script created by smug_cat
echo.
set /p choice="Enter your choice (1-3): "
echo.

if "%choice%"=="1" (
    echo Blocking Steam Internet Access...
    goto Block
)
if "%choice%"=="2" (
    echo Allowing Steam Internet Access...
    goto Allow
)
if "%choice%"=="3" goto End
echo Invalid choice, please try again.
echo The Cake is a lie 
pause
goto Start

:CheckAccess
netsh advfirewall firewall show rule name="%RuleName%_Steam" > nul 2>&1
if %errorlevel% equ 0 (
    echo Steam Internet Access is Blocked.
) else (
    echo Steam Internet Access is Allowed.
)
goto :eof

:Block
REM Check if the rule already exists before adding
netsh advfirewall firewall show rule name="%RuleName%_Steam" > nul 2>&1
if %errorlevel% neq 0 (
    
    
    timeout /t 1 > nul
    REM Block Steam.exe
    echo Blocking Steam.exe...
    echo.
    netsh advfirewall firewall add rule name="%RuleName%_Steam" dir=out action=block program="%SteamExePath%" enable=yes
    netsh advfirewall firewall add rule name="%RuleName%_Steam" dir=in action=block program="%SteamExePath%" enable=yes
    echo Outbound and Inbound rules for Steam.exe have been added.
    echo.


    timeout /t 1 > nul
    REM Block steamwebhelper.exe
    echo Blocking steamwebhelper.exe...
    echo.
    netsh advfirewall firewall add rule name="%RuleName%_WebHelper" dir=out action=block program="%SteamWebHelperPath%" enable=yes
    netsh advfirewall firewall add rule name="%RuleName%_WebHelper" dir=in action=block program="%SteamWebHelperPath%" enable=yes
    echo Outbound and Inbound rules for steamwebhelper.exe have been added.
    echo.

    timeout /t 1 > nul
    REM Block steamservice.exe
    echo Blocking steamservice.exe...
    echo.
    netsh advfirewall firewall add rule name="%RuleName%_Service" dir=out action=block program="%SteamServicePath%" enable=yes
    netsh advfirewall firewall add rule name="%RuleName%_Service" dir=in action=block program="%SteamServicePath%" enable=yes
    echo Outbound and Inbound rules for steamservice.exe have been added.
    echo.
    echo.


    echo Steam Internet Access has been Blocked.
) else (
    echo Steam's internet access is already blocked by existing rules.
)
pause
goto Start

:Allow
REM Delete the rule if it exists
netsh advfirewall firewall delete rule name="%RuleName%_Steam" > nul 2>&1
netsh advfirewall firewall delete rule name="%RuleName%_WebHelper" > nul 2>&1
netsh advfirewall firewall delete rule name="%RuleName%_Service" > nul 2>&1

echo Steam Internet Access has been Allowed.
pause
goto Start

:End
endlocal
