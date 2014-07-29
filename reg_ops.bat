@echo off
rem //v1.4		reg_op.bat		14-01-2010
rem |--------------------------------------------------------------------------
rem |  This script will toggle various registry settings on both local and 
rem |  remote systems.
rem |  Auth: ATennent
rem |--------------------------------------------------------------------------
setlocal
:vars
set npath="\\corporate\data\IT\IT_Operations\Security\scripts"

:begin
echo ---------------------------------------------------------------------------
echo This script will toggles various registry settings on both local and 
echo remote systems.  Unsafe functions will be noted and prompted for.
pause
del .\*cur.op /f

:sys
cls
set /P _sysname=Please enter the system you would like to work on or enter to exit:
if /I %_sysname%=="NULL" goto exit
set msg="Selected system is %_sysname%."
goto main

:main
cls
echo ------------------------------[    Main     ]------------------------------
echo ---------------------------------------------------------------------------
echo Which setting would you like to modify?
echo 1. Terminal Services.
echo 2. System Restore.
echo 3. Reboot.
echo 4. Process handling operations.
rem echo 5. defaulting reg settings HKLM\sw\ms\win\cv\policies\system\DisableTaskMgr dword 0x00000000
rem 		HKCU\sw\ms\win\cv\Policies\System\DisableTaskMgr dword 0x00000001
rem		HKU\<user_string>\sw\ms\win\cv\policies\system\DisableTaskMgr dword 0x00000000
echo 5. Remote command prompt.
echo 6. Speed test between two hosts
echo.
echo 9. Set system name or IP of the computer you would like to configure.
echo 0. Exit.
echo ---------------------------------------------------------------------------
echo Info: %msg%
echo.
set /P chm=[1,2,3,4,5,9,0]?
if /I "%chm%"=="0" goto exit
if /I "%chm%"=="9" goto sys
if /I "%chm%"=="6" goto spd_test
if /I "%chm%"=="5" goto cmd
if /I "%chm%"=="4" goto psops
if /I "%chm%"=="3" goto reboot
if /I "%chm%"=="2" goto sysrestr
if /I "%chm%"=="1" goto termserv
set msg="Invalid option"
goto main

:termserv
cls
echo ------------------------------[  Term Serv  ]------------------------------
echo ---------------------------------------------------------------------------
echo Would you like to enable or disable Remote Desktop Connection?
echo 1. Enable
echo 2. Disable
echo 3. Current Setting
echo.
echo 9. Back
echo 0. Exit
echo ---------------------------------------------------------------------------
echo Info: %msg%
echo.
set /P chts=[1,2,3,9,0]?
if /I "%chts%"=="0" goto exit
if /I "%chts%"=="9" goto main
if /I "%chts%"=="1" goto tsen
if /I "%chts%"=="2" goto tsdis
if /I "%chts%"=="3" goto tscur
set msg="Invalid option"
goto termserv

:tsen
reg add "\\%_sysname%\HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 00000000 /f
set msg="Terminal Services is now enabled on %_sysname%."
goto main

:tsdis
reg add "\\%_sysname%\HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 00000001 /f
set msg="Terminal Services is now disabled on %_sysname%."
goto main

:tscur
reg query "\\%_sysname%\HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections | find "fDenyTSConnections" > .\tscur.op
for /f "tokens=3*" %%g in (.\tscur.op) do (
if "%%g"=="0x0" (
	set msg="Terminal Services are currently enabled"
	del .\tscur.op /f
	goto termserv
) else (
	set msg="Terminal Services are currently disabled"
	del .\tscur.op /f
	goto termserv
	)
)
set msg="System is unavailable"
del .\tscur.op /f
goto main

:sysrestr
cls
echo ------------------------------[ Sys Restore ]------------------------------
echo ---------------------------------------------------------------------------
echo Would you like to enable or disable System Restore?
echo 1. Enable
echo 2. Disable
echo 3. Current Setting
echo 4. Reboot
echo 9. Back
echo 0. Exit
echo ---------------------------------------------------------------------------
echo Info: %msg%
echo.
set /P chsr=[1,2,3,9,0]?
if /I "%chsr%"=="0" goto exit
if /I "%chsr%"=="9" goto main
if /I "%chsr%"=="1" goto sren
if /I "%chsr%"=="2" goto srdis
if /I "%chsr%"=="3" goto srcur
if /I "%chsr%"=="3" goto reboot
set msg="Invalid option"
goto sysrestr

:sren
reg add "\\%_sysname%\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v DisableSR /t REG_DWORD /d 00000000 /f
set msg="System Restore in now enabled on %_sysname%."
goto main

:srdis
reg add "\\%_sysname%\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v DisableSR /t REG_DWORD /d 00000001 /f
set msg="System Restore is now disabled on %_sysname%."
goto main

:srcur
reg query "\\%_sysname%\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v DisableSR | find "DisableSR" > .\srcur.op
for /f "tokens=3*" %%g in (.\srcur.op) do (
if "%%g"=="0x0" (
	set msg="System Restore is currently enabled"
	del .\srcur.op /f
	goto sysrestr
) else (
	set msg="System Restore is currently disabled"
	del .\srcur.op /f
	goto sysrestr
	)
)
set msg="System is unavailable"
del .\srcur.op /f
goto main

:reboot
cls
echo ------------------------------[   Reboot    ]------------------------------
echo ---------------------------------------------------------------------------
echo When would you like to reboot the selected system?
echo 1. Reboot immediately
echo 2. Delayed reboot
echo 3. Cancel Reboot
echo.
echo 9. Back
echo 0. Exit
echo ---------------------------------------------------------------------------
echo Info: %msg%
echo.
set /P chr=[1,2,3,9,0]?
if /I "%chr%"=="0" goto exit
if /I "%chr%"=="9" goto main
if /I "%chr%"=="1" goto rbi
if /I "%chr%"=="2" goto rbd
if /I "%chr%"=="3" goto rbc
set msg="Invalid option."
goto reboot

:rbi
shutdown -r -t 00 -m \\%_sysname%
set msg="System reboot has been sent to %_sysname%."
goto main

:rbd
cls
echo ------------------------------[   Reboot    ]------------------------------
echo ---------------------------------------------------------------------------
echo Keep in mind that this can be interrupted by the user or can be canceled by
echo running the 'shutdown -a' command localy or remotely.
echo.
set /P rd=Please enter the delay time in seconds for the reboot or enter to return:
if /I %rd%=="NULL" goto reboot
shutdown -r -t %rd% -m \\%_sysname%
set msg="System reboot has been sent to %_sysname%"
goto main

:rbc
shutdown -a -m \\%_sysname%
set msg="System reboot on %_sysname% has been cancelled."
goto main

:cmd
cls
echo.
echo This service is still under development, returning to the main menu..
pause
rem set /P uname=Please enter your username or enter to return:
rem if /I %uname%=="NULL" goto main
rem set /P pword=Please enter your password or enter to return:
rem if /I %pword%=="NULL" goto main
rem "%npath%\bin\psexec.exe \\%_sysname% -u %uname% cmd"
rem set pword="NULL"
rem set uname="NULL"
rem echo Returning to main menu..
rem set msg="Remote command prompt to %_sysname% closed."
goto main

:psops
cls
echo ------------------------------[ Process Ops ]------------------------------
echo ---------------------------------------------------------------------------
echo Bare in mind that it is adviseable to first run the process monitor to
echo confirm the process IP or name that you want to kill.
echo Please select what remote process operations you would like to perform:
echo.
echo 1. List and Monitor Processes
echo 2. Kill a process
echo.
echo 9. Back
echo 0. Exit
echo ---------------------------------------------------------------------------
echo Info: %msg%
echo.
set /P chps=[1,2,9,0]?
if /I "%chps%"=="0" goto exit
if /I "%chps%"=="9" goto main
if /I "%chps%"=="1" goto pslist
if /I "%chps%"=="2" goto pskill
set msg="Invalid option"
goto psops

:pslist
cls
echo.
set /P uname=Please enter your username or enter to return:
if /I %uname%=="NULL" goto main
rem set /P pword=Please enter your password or enter to return:
rem if /I %pword%=="NULL" goto main
"%npath%\bin\pslist.exe" -s \\%_sysname% -u %uname%
set pword="NULL"
set uname="NULL"
echo Returning to Process Ops menu..
set msg="Process monitor on %_sysname% has been closed."
goto psops

:pskill
cls
echo.
set /P killp=Please enter the PID or process name that you would like to terminate:
if /I %killp%=="NULL" goto psops
set /P uname=Please enter your username or enter to return:
if /I %uname%=="NULL" goto main
rem set /P pword=Please enter your password or enter to return:
rem if /I %pword%=="NULL" goto main
"%npath%\bin\pskill.exe" -t \\%_sysname% -u %uname% %killp%
rem set pword="NULL"
set uname="NULL"
echo Returning to Process Ops menu..
set msg="Process %killp% on %_sysname% has been terminated."
set killp="NULL"
goto psops

:spd_test
echo ---------------------------------------------------------------------------
echo This is currently still under development
pause
goto main

:exit
cls
endlocal
echo ---------------------------------------------------------------------------
echo Exiting...
echo ---------------------------------------------------------------------------
goto :eof