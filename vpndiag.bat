@echo off
rem //v1.1                    vpndiag.bat                 20-04-2009
rem |--------------------------------------------------------------------------
rem | Basic VPN dignostic utility.
rem | This batch file will check basic network configurations, connectivity
rem | and file versions relating to the default configurations of the F+P
rem | network while connected a VPN.
rem | Command line options:
rem |  vpndiag.bat <ip1> <ip2>
rem |--------------------------------------------------------------------------
 
:begin
echo ---------------------------------------------------------------------------
echo This diagnostic file will check your general network connectivity while
echo connected to any VPN services.
echo ---------------------------------------------------------------------------
echo test IP one: %1
echo test IP two: %2
if exist c:\vpn_outp.txt (
echo Cleaning up old diag output.
del c:\vpn_outp.txt
goto diag
	) else (
		goto diag
	)
 
:diag
echo ---------------------------------------------------------------------------
echo Please be patient while this executes.  At most the whole diagnostic will
echo take about 10 minutes.
echo ---------------------------------------------------------------------------
c:
cd \
echo -------------------------------[ Start      ]------------------------------ >> vpn_outp.txt
echo -------------------------------[ ipconfig   ]------------------------------ >> vpn_outp.txt
ipconfig /all >> vpn_outp.txt
echo -------------------------------[ route dump ]------------------------------ >> vpn_outp.txt
route print >> vpn_outp.txt
echo -------------------------------[ ping       ]------------------------------ >> vpn_outp.txt
ping -n 10 -w 10000 $1 >> vpn_outp.txt
echo -------------------------------[ tracert    ]------------------------------ >> vpn_outp.txt
tracert -h 10 ip1 >> vpn_outp.txt
echo -------------------------------[ nslookup 1 ]------------------------------ >> vpn_outp.txt
nslookup %1  >> vpn_outp.txt
nslookup %1 dns_server1 >> vpn_outp.txt
echo -------------------------------[ nslookup 2 ]------------------------------ >> vpn_outp.txt
nslookup %2  >> vpn_outp.txt
nslookup %2 dns_server2 >> vpn_outp.txt
echo -------------------------------[ file check ]------------------------------ >> vpn_outp.txt
dir c:\proxy.pac >> vpn_outp.txt
dir c:\windows\system32\drivers\etc\hosts >> vpn_outp.txt
dir c:\windows\system32\drivers\etc\lmhosts >> vpn_outp.txt
echo -------------------------------[ version ck ]------------------------------ >> vpn_outp.txt
type c:\lmh_pxy.txt | find "//v" >> vpn_outp.txt
type c:\proxy.pac | find "//v" >> vpn_outp.txt
type c:\windows\system32\drivers\etc\hosts | find "//v" >> vpn_outp.txt
type c:\windows\system32\drivers\etc\lmhosts | find "//v" >> vpn_outp.txt
echo -------------------------------[ Reg Output ]------------------------------ >> vpn_outp.txt
echo HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings >> vpn_outp.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable | find "ProxyEnable" >> vpn_outp.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer | find "ProxyServer" >> vpn_outp.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride | find "ProxyOverride" >> vpn_outp.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL | find "AutoConfigURL" >> vpn_outp.txt
echo -------------------------------[ EOF        ]------------------------------ >> vpn_outp.txt
goto exit
 
:exit
echo Diagnostic completed.
echo ---------------------------------------------------------------------------
echo Please refer to the output file c:\vpn_outp.txt for analysis or email the
echo output file to tech support.
echo ---------------------------------------------------------------------------
pause
goto :eof