@echo off
CD %~dp0
Title Nexus CPU Miner Configurator
CLS
echo [*] 

echo [*] Nexus Pool Miner .conf Maker

echo [*] v0.0.1

echo [*] by CommsTech

echo [*] http://CryptoSoldier.com
echo [*]

echo [*] 

echo [*] 

echo [*] This is a tool to  assist in the configuration 

echo [*] of the Nexus CPU miner settings for your computer.

echo [*] The creator of this software
echo [*] holds no liability to any

echo [*] ill actions done with it.

echo [*]

echo [*]

echo [*] That being said....

echo [*]		Let's continue!

echo [*]

echo [*]

echo [*] 

echo [*] 

echo [*] 

echo [*]

echo [*] Press enter to go to the Menu
pause

:START
CLS
echo [*]
Lets start by identifying your hardware
echo [*] 


echo [*] 
echo [*] Looks like you have a 
echo %PROCESSOR_IDENTIFIER% %PROCESSOR_LEVEL% %PROCESSOR_REVISION%
wmic cpu get L2CacheSize, L2CacheSpeed, L3CacheSize, L3CacheSpeed
setlocal EnableDelayedExpansion
SET lf=
FOR /F "delims=" %%i IN ('wmic cpu get L2CacheSize') DO if ("!out!"=="") (set out=%%i) else (set out=!out!%lf%%%i)
ECHO %out%
SET PREM=%out:L2CacheSize =%
SET KB=%PREM: =%
set /a KBCS=%KB%/1
SET /a threads=%NUMBER_OF_PROCESSORS% / 2 + 1
SET /a arrays=%KBCS% * 8000 / %NUMBER_OF_PROCESSORS% * %threads%
echo [*]
echo [*] L2 Cache Size is %KBCS%
echo [*] and you have %NUMBER_OF_PROCESSORS% cores
echo current error level %errorlevel%
echo [*]
pause

:ADDRESS
CLS
echo [*]
echo [*]
echo [*]
echo [*]
SET /P ADDR=Copy and Paste your Nexus (NXS) Address Here then press ENTER


:POOL
CLS
SET POOL1=nxscpupool.com  
SET POOL2=nxsminingpool.com
SET POOL3=nxspool.com
SET POOL4=nexusminingpool.com
SET TTL= 200

ECHO verifying Server response

ping -n 1 %POOL1% | find "TTL"
if not errorlevel 1 set error1=GOOD
if errorlevel 1 set error1=fail

ping -n 1 %POOL2% | find "TTL"
if not errorlevel 1 set error2=GOOD
if errorlevel 1 set error2=fail

ping -n 1 %POOL3% | find "TTL"
if not errorlevel 1 set error3=GOOD
if errorlevel 1 set error3=fail

ping -n 1 %POOL4% | find "TTL"
if not errorlevel 1 set error4=GOOD
if errorlevel 1 set error4=fail


echo [*] Below is a list of all the pools and your
echo [*] along with your ability to connect to them

echo [*]
echo [*] 1. nxscpupool.com %error1%

echo [*]

echo [*] 2. nxsminingpool.com
 %error2%

echo [*]

echo [*] 3. nxspool.com %error3%


echo [*]

echo [*] 4. nexusminingpool.com %error4%


echo [*]

echo [*]
echo [*] *NOTE*  the faster your connection
echo [*] the faster you can submit shares
SET /P M=Type Your Choice then press ENTER
IF %M%==1 GOTO POOLA 
IF %M%==2 GOTO POOLB 
IF %M%==3 GOTO POOLC 
IF %M%==4 GOTO POOLD


:POOLA
CLS
SET MP=nxscpupool.com
GOTO VERIFY

:POOLB
CLS
SET MP=nxsminingpool.com
GOTO VERIFY

:POOLC
CLS
SET MP=nxspool.com
GOTO VERIFY

:POOLD
CLS
SET MP=nexusminingpool.com
GOTO VERIFY

:VERIFY
echo [*] Please Verify this information
echo [*] Pool = %MP%
echo [*] NXS Address = %ADDR%
echo [*] Threads = %threads%
echo [*] Bit Array size = %arrays%
echo [*] 
echo [*] 
echo [*] If this is correct press 1
echo [*] If this is incorrect press 2
SET /P M=Type Your Choice then press ENTER
IF %M%==1 GOTO WRITEOUT 
IF %M%==2 GOTO START 


:WRITEOUT
(
echo ^{
	
echo "host": "%MP%",
	
echo "port": "9549",
	
echo "nxs_address": "%ADDR%",

echo "threads": "%threads%",
 
echo "timeout": "10",
 
echo "bit_array_size": %arrays%,

echo "prime_limit": 71378571,

echo "n_prime_limit": 4194304,
 
echo "primorial_end_prime": 12^}
) > miner.conf
echo [*] Your Miner is now Configured
echo [*]
echo [*] If you found this tool useful 
echo [*] please feel free to donate NXS to
echo [*] 2RGMypvsvDxbYUXUDKJ9zc4Cd6ZuE6SVq6ggmLupLgoNU9xmCEn
echo [*] or visit http://cryptosoldier.com
echo [*] 
echo [*] Press any key to exit
pause


