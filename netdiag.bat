@echo off
rem //v1.1                    netdiag.bat                  20-04-2009
rem |--------------------------------------------------------------------------
rem | Basic network dignostic utility.
rem | This batch file will check basic network configurations, connectivity
rem | and file versions relating to the default configurations of the F+P
rem | network.
rem |--------------------------------------------------------------------------
:vars
 
set winver = "ver"
 
:begin
echo ---------------------------------------------------------------------------
echo This diagnostic file will check your general network connectivity prior to
echo connecting to any of the Foster + Partners VPN services.
echo ---------------------------------------------------------------------------
echo test IP one: %1
echo test IP two: %2
if exist c:\net_outp.txt (
echo Cleaning up old diagnostic output.
del c:\net_outp.txt
echo Done.
goto diag
	) else (
		rem goto test
		goto diag
	)
 
:diag
echo ---------------------------------------------------------------------------
echo Please be patient while this executes.  At most the whole diagnostic will
echo take approximately 10 minutes.
echo ---------------------------------------------------------------------------
c:
cd \
echo -------------------------------[ Start      ]------------------------------ >> net_outp.txt
echo -------------------------------[ ipconfig   ]------------------------------ >> net_outp.txt
ipconfig /all >> net_outp.txt
echo -------------------------------[ route dump ]------------------------------ >> net_outp.txt
route print >> net_outp.txt
echo -------------------------------[ ping       ]------------------------------ >> net_outp.txt
ping -n 10 -w 10000 "www.google.com" >> net_outp.txt
echo -------------------------------[ tracert    ]------------------------------ >> net_outp.txt
tracert "remote.company.com" >> net_outp.txt
echo -------------------------------[ file check ]------------------------------ >> net_outp.txt
dir c:\proxy.pac >> net_outp.txt
dir c:\windows\system32\drivers\etc\hosts >> net_outp.txt
dir c:\windows\system32\drivers\etc\lmhosts >> net_outp.txt
echo -------------------------------[ version ck ]------------------------------ >> net_outp.txt
type c:\lmh_pxy.txt | find "//v" >> net_outp.txt
type c:\proxy.pac | find "//v" >> net_outp.txt
type c:\windows\system32\drivers\etc\hosts | find "//v" >> net_outp.txt
type c:\windows\system32\drivers\etc\lmhosts | find "//v" >> net_outp.txt
echo -------------------------------[ Reg Output ]------------------------------ >> net_outp.txt
echo HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings >> net_outp.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable | find "ProxyEnable" >> net_outp.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer | find "ProxyServer" >> net_outp.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride | find "ProxyOverride" >> net_outp.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL | find "AutoConfigURL" >> net_outp.txt
echo -------------------------------[ EOF        ]------------------------------ >> net_outp.txt
goto exit
 
:exit
echo Diagnostic completed.
echo ---------------------------------------------------------------------------
echo Please refer to the output file c:\net_outp.txt for analysis or email the
echo output file to tech support.
echo ---------------------------------------------------------------------------
pause
goto :eof