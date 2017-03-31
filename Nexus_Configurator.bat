@echo off
mode con: cols=80 lines=35
CD %~dp0
Title Nexus CPU Miner Configurator
REM Disclosure Agreement
echo ************************************************** 
echo *            Nexus Configurator                  *
echo **************************************************
echo *  for Nexus Pool Miner v0.0.1 by Videlicet      *
echo *  Configurator v0.0.1 by CommsTech              *
echo *  http://CryptoSoldier.com                      *
echo **************************************************
echo *                                                *
echo * This is a tool to  assist in the configuration *
echo * of the Nexus CPU miner .conf for your computer.*
echo * The creator of this software holds no          *
echo * liability.                                     *
echo *                                                *
echo *                                                *
echo *   That being said....                          *
echo *      Let's continue!                           * 
echo *                                                *
echo **************************************************
echo *             Press ENTER to start               *
echo ************************************************** 
pause

:START
REM Gather information and set Variables
CLS
echo ************************************************** 
echo *               Nexus Configurator               *
echo **************************************************
echo     Lets start by identifying your hardware
echo.
echo     Looks like you have a
echo %PROCESSOR_IDENTIFIER% %PROCESSOR_LEVEL% %PROCESSOR_REVISION%
wmic cpu get L2CacheSize, L2CacheSpeed, L3CacheSize, L3CacheSpeed
setlocal EnableDelayedExpansion
SET os=
FOR /F "delims=" %%i IN ('wmic os get osarchitecture') DO if ("!osa!"=="") (set osa=%%i) else (set osa=!osa!%os%%%i)
ECHO %osa%
SET PROM=%osa:osarchitecture =%
SET OSS=%PROM: =%
set /a OST=%OSS:~0,2%
set ARC=%OST%
SET lf=
FOR /F "delims=" %%i IN ('wmic cpu get L2CacheSize') DO if ("!out!"=="") (set out=%%i) else (set out=!out!%lf%%%i)
ECHO %out%
SET PREM=%out:L2CacheSize =%
SET KB=%PREM: =%
set /a KBCS=%KB%/1
SET oc=
FOR /F "delims=" %%i IN ('wmic cpu get L3CacheSize') DO if ("!otr!"=="") (set otr=%%i) else (set otr=!otr!%oc%%%i)
ECHO %otr%
SET PRAM=%otr:L3CacheSize =%
SET LC=%PRAM: =%
SET /a OCS=%LC%/1
SET /a threads=%NUMBER_OF_PROCESSORS% / 2 + 1
SET /a OH=%LC% / 1024 / 2 / 2 * %NUMBER_OF_PROCESSORS% * 128
SET /a TCS=%KBCS%
IF /I "%KBCS%" LEQ "1024" SET TCS=2048
IF /I "%KBCS%" GEQ "4096" SET /a TCS=%KBCS%/%threads%
IF /I "%KBCS%" EQU "3072" SET TCS=2432
IF /I "%TCS%" GEQ "3072" SET TCS=1664
IF /I "%threads%" EQU "%NUMBER_OF_PROCESSORS%" SET /a threads=%NUMBER_OF_PROCESSORS% - 1
SET /a arrays=%TCS% * 80 * %ARC%
SET PRIME=12
IF /I "arrays" LEQ "8388608" set PRIME=10
IF /I "%arrays%" GEQ "12582912" set PRIME=14
echo.
echo     Using %TCS% (Cache) x 80  x %ARC% (OS)
echo     to set your bit array size to %arrays%
echo     and you have %NUMBER_OF_PROCESSORS% cores
echo     so we will use %threads% total threads
echo     We will set your shieve to %PRIME%
echo     Your current error level is %errorlevel%
echo.
echo      press any key to continue
pause

:ADDRESS
REM Setup wallet address info
CLS
echo ************************************************** 
echo *              Nexus Configurator                *
echo **************************************************
echo *                                                *
echo * Go to your wallet and copy your address        *
echo * Paste your address below                       *
echo * If left blank you will be donating your shares *
echo *                                                *
echo **************************************************
SET /P ADDR=Enter Your Nexus (NXS) Address Here:
If "%ADDR%"=="" SET ADDR=2RGMypvsvDxbYUXUDKJ9zc4Cd6ZuE6SVq6ggmLupLgoNU9xmCEn

:POOL
REM Gather pool status and select pool
CLS
SET POOL1=nxscpupool.com  
SET POOL2=nxsminingpool.com
SET POOL3=nxspool.com
SET POOL4=nexusminingpool.com

echo **************************************************
echo *             Nexus Configurator                 *
echo **************************************************
echo     We will now verify the pools status

ping -n 1 %POOL1% | find "TTL="
if errorlevel 1 (
set error1=Failed
) else (
set error1=Good
)

ping -n 1 %POOL2% | find "TTL="
if errorlevel 1 (
set error2=Failed
) else (
set error2=Good
)

ping -n 1 %POOL3% | find "TTL="
if errorlevel 1 (
 set error3=Failed
 ) else (
 set error3=Good
 )
 
ping -n 1 %POOL4% | find "TTL="
if errorlevel 1 (
set error4=Failed
) else (
set error4=Good
)

echo     Below is a list of all the pools
echo     along with your ability to connect to them
echo.
echo          1. nxscpupool.com %error1%
echo.
echo          2. nxsminingpool.com %error2%
echo.
echo          3. nxspool.com %error3%
echo.
echo          4. nexusminingpool.com %error4%
echo.
echo.
echo     *NOTE*  Please review the pools webpage before selecting
echo.
SET /P M=Type Your Choice then press ENTER :
IF %M%==1 GOTO POOLA 
IF %M%==2 GOTO POOLB 
IF %M%==3 GOTO POOLC 
IF %M%==4 GOTO POOLD

:POOLA
SET MP=nxscpupool.com
GOTO VERIFY

:POOLB
SET MP=nxsminingpool.com
GOTO VERIFY

:POOLC
SET MP=nxspool.com
GOTO VERIFY

:POOLD
SET MP=nexusminingpool.com
GOTO VERIFY

:VERIFY
REM Allow user to verify information for correctness
CLS
echo **************************************************
echo *             Nexus Configurator                 *
echo **************************************************
echo * Please Verify this information below           *
echo **************************************************
echo.
echo     Pool = %MP%
echo     NXS Address = %ADDR%
echo     Threads = %threads%
echo     Bit Array size = %arrays%
echo.
echo.
echo     Press 1 to write the .conf file
echo     Press 2 to restart the configurator
echo.
SET /P M=Type Your Choice then press ENTER :
IF %M%==1 GOTO WRITEOUT 
IF %M%==2 GOTO START 

:WRITEOUT
REM Write the .conf file to current directory
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
echo "primorial_end_prime": %PRIME% ^}
) > miner.conf

:END
REM Setup complete notification
CLS
echo *******************************************************
echo *               Nexus Configurator                    *
echo *******************************************************
echo * Your Miner is now Configured                        *
echo *                                                     *
echo * If you found this tool useful                       * 
echo * please feel free to donate NXS to                   *
echo * 2RGMypvsvDxbYUXUDKJ9zc4Cd6ZuE6SVq6ggmLupLgoNU9xmCEn *
echo * or visit http://cryptosoldier.com                   *
echo *                                                     *
echo *                                                     *
echo *                                                     *
echo * Press 1 to Start Mining                             *
echo * Press 2 to view cryptosoldier.com
echo * Press 3 to Exit                                     *
echo *******************************************************
SET /P M=Type Your Choice then press ENTER :
IF %M%==1 GOTO MINE
IF %M%==2 GOTO WEB
IF %M%==3 GOTO EXIT 

:MINE
REM Startup miner if in the current directory
start nexus_cpuminer.exe
pause

:WEB
REM Open website
start http://cryptosoldier.com

:EXIT
REM Close window
exit
