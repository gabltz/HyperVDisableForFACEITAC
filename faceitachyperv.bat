@echo off
title HYPER V DISABLER/ENABLER FOR FACEIT AC AND WSL 2 COMPATIBILITY

C:
CD\
CLS

:MENU
CLS

ECHO  ============= HYPER V DISABLER/ENABLER FOR FACEIT AC AND WSL 2 COMPATIBILITY =============
ECHO            Made with love by Gab. https://github.com/heyimgab/HyperVDisableForFACEITAC
ECHO _____________________________________
ECHO            Since FACEIT AC does not longer support WSL2 compatibility, Hyper-V needs to be disabled. This tool do all the stuff by itself and let you revert the changes as easy as possible
ECHO 1.  Disable HYPER-V for FACEIT
ECHO 2.  Re-Enable Hyper-V for WSL2
ECHO 3.  Exit the program
ECHO _____________________________________
echo.
ECHO.


SET INPUT=
SET /P INPUT=Please select a number:

IF /I '%INPUT%'=='1' GOTO disable
IF /I '%INPUT%'=='2' GOTO enable
IF /I '%INPUT%'=='3' GOTO Exit
CLS

PAUSE > NUL
GOTO MENU

:disable

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO args = "ELEV " >> "%temp%\OEgetPrivileges.vbs"
ECHO For Each strArg in WScript.Arguments >> "%temp%\OEgetPrivileges.vbs"
ECHO args = args ^& strArg ^& " "  >> "%temp%\OEgetPrivileges.vbs"
ECHO Next >> "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" %*

:gotPrivileges
if '%1'=='ELEV' shift /1
setlocal & pushd .
cd /d %~dp0

bcdedit /set hypervisorlaunchtype off
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Disabled" /t REG_DWORD /d 0 /f

cls


ECHO ======PRESS ANY KEY TO CONTINUE======
ECHO ======PLEASE RESTART YOUR COMPUTER TO APPLY CHANGES======

PAUSE > NUL
GOTO MENU

:enable

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO args = "ELEV " >> "%temp%\OEgetPrivileges.vbs"
ECHO For Each strArg in WScript.Arguments >> "%temp%\OEgetPrivileges.vbs"
ECHO args = args ^& strArg ^& " "  >> "%temp%\OEgetPrivileges.vbs"
ECHO Next >> "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" %*

:gotPrivileges
if '%1'=='ELEV' shift /1
setlocal & pushd .
cd /d %~dp0

bcdedit /set hypervisorlaunchtype on 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 0 /f

cls


ECHO ======PRESS ANY KEY TO CONTINUE======
ECHO ======PLEASE RESTART YOUR COMPUTER TO APPLY CHANGES======

PAUSE > NUL
GOTO MENU

:Exit

CLS

ECHO ==============THANKYOU===============
ECHO -------------------------------------
ECHO ======PRESS ANY KEY TO CONTINUE======
PAUSE>NUL

start https://github.com/heyimgab

EXIT
