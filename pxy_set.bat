@echo off
rem //v1.0                    pxy_set.bat                  Date: 20-07-2011
rem |--------------------------------------------------------------------------
rem | The script is for swapping around proxy settings between pac files, 
rem | static settings and disabling of both.
rem | Author: Alan Tennent
rem |--------------------------------------------------------------------------
setlocal
:begin
set msg=
set lmsg=
set pa_val=

:main
cls
echo ------------------------------[    Main     ]------------------------------
echo ------------------------------[ Current Set ]------------------------------
for /f "tokens=1,3" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable') do ( echo %%a %%b | find "ProxyEnable" )
for /f "tokens=1,3" %%c in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer') do ( echo %%c %%d | find "ProxyServer" )
for /f "tokens=1,3" %%e in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride') do ( echo "%%e %%f" | find "ProxyOverride" )
for /f "tokens=1,3" %%g in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL') do ( echo %%g %%h | find "AutoConfigURL" )
echo ---------------------------------------------------------------------------
echo What would you like to do?
echo 1. See the current settings.
echo 2. Disabled the proxy.
echo 3. Set a manual proxy.
echo 4. Set pac file.
echo.
echo 0. Exit.
echo ---------------------------------------------------------------------------
echo Info: %msg%
echo.
set /P chm=[1,2,3,4,0]?
if /I "%chm%"=="0" goto exit
if /I "%chm%"=="4" goto pac_act
if /I "%chm%"=="3" goto pxy_act
if /I "%chm%"=="2" goto pxy_dis
if /I "%chm%"=="1" goto pxy_see
set msg="Invalid option selected"
goto main

:pxy_see
cls
echo -------------------------------[ Proxy Conf ]------------------------------
rem reg location HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings
rem Manual Proxy:
for /f "tokens=1,3" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable') do ( echo %%a %%b | find "ProxyEnable" )
rem Manual Proxy Server:
for /f "tokens=1,3" %%c in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer') do ( echo %%c %%d | find "ProxyServer" )
rem Proxy override addresses:
for /f "tokens=1,3" %%e in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride') do ( echo "%%e %%f" | find "ProxyOverride" )
rem Pac file config:
for /f "tokens=1,3" %%g in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL') do ( echo %%g %%h | find "AutoConfigURL" )
echo -------------------------------[ Proxy Conf ]------------------------------
set msg=
goto main

:pxy_dis
cls
echo -------------------------------[ DisablePxy ]------------------------------
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 00000000 /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /f
echo -------------------------------[ DisablePxy ]------------------------------
set msg="proxy and pac configs disabled"
goto main

:pxy_act
cls
echo ------------------------------[ Prxy Action ]------------------------------
echo What would you like to set?
echo 1. Stock Proxy 1: 192.168.0.28:8080
echo 2. Stock Proxy 2: 192.168.0.22:8080
echo 3. Set a custom proxy.
echo 4. Disable the proxy.
echo 5. Enable the proxy.
echo.
echo 0. Exit.
echo ---------------------------------------------------------------------------
echo Info: %msg%
echo.
set /P pa=[1,2,3,4,0]?
if /I "%pa%"=="0" goto main
if /I "%pa%"=="5" (
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 00000001 /f
	set lmsg="Manual proxy has been enabled"
	goto exit
	)
if /I "%pa%"=="4" (
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 00000000 /f
	set lmsg="Manual proxy has been disabled"
	goto exit
	)
if /I "%pa%"=="3" (
	set /P paval=Please enter the proxy ip/host:port that you want to use: 
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 00000001 /f
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d %paval% /f
	set lmsg="Proxy set to: %paval%"
	goto exit
	)
if /I "%pa%"=="2" (
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 00000001 /f
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d 192.168.0.22:8080 /f
	set lmsg="Proxy set to: 192.168.0.22:8080"
	goto exit
	)
if /I "%pa%"=="1" (
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 00000001 /f
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d 192.168.0.28:8080 /f
	set lmsg="Proxy set to: 192.168.0.28:8080"
	goto exit
	)
set msg="Invalid option selected"
goto pxy_act

:pac_act

:exit
cls
endlocal
echo ---------------------------------------------------------------------------
echo %lmsg%
echo Exiting...
echo ---------------------------------------------------------------------------
goto :eof