@echo off
rem ########################################################################
rem ##  Filename: ssh_pipe.bat				Version: 1.4
rem ##  Function:
rem ##  This script makes use of the command line version of PuTTY called 
rem ##  plink to connect to run a set of commands against multiple hosts
rem ##  then dump the results into a text file.
rem ##  
rem ##  Requirements:
rem ## -plink.exe Windows command line version of PuTTY:
rem ##    http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
rem ## -hosts.txt file containing single IP addresses, each on a new line.
rem ##    Optionally the hostname can follow the IP separated by a space to 
rem ##    assist with naming of the log output.
rem ## -actions.txt file containing each command that is to be run, each on
rem ##  a new line.
rem ##  
rem ##  Uses:
rem ##  This script is useful for stat or information gathering.
rem ##  
rem ########################################################################
rem     Author: Alan Tennent
setlocal
rem set plink_loc="E:\Program Files (x86)\Putty\plink.exe"
set plink_loc=plink.exe

set /P _uname=Username: 
if /I %_uname%==[] goto exit
set /P _pword=Password: 
if /I %_pword%==[] goto exit
echo.
for /f "tokens=1* delims= " %%h in (hosts.txt) do (
	echo ## Running commands to %%i_%%h
	%plink_loc% -pw %_pword% -batch %_uname%@%%h < actions.txt > %%i_%%h.log
	echo.
	)

:exit
endlocal
echo.
echo Exiting..
echo.
rem pause