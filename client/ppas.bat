@echo off
c:\lazarus\fpc\2.2.4\bin\i386-win32\windres.exe --include c:/lazarus/fpc/222A9D~1.4/bin/I386-W~1/ -O res -o R:\OsProjects\client\estbk.res R:/OSPROJ~1/client/estbk.rc --preprocessor=c:\lazarus\fpc\2.2.4\bin\i386-win32\cpp.exe
if errorlevel 1 goto linkend
SET THEFILE=R:\OsProjects\client\estbk.exe
echo Linking %THEFILE%
c:\lazarus\fpc\2.2.4\bin\i386-win32\ld.exe -b pe-i386 -m i386pe  --gc-sections   --subsystem windows --entry=_WinMainCRTStartup    -o R:\OsProjects\client\estbk.exe R:\OsProjects\client\link.res
if errorlevel 1 goto linkend
c:\lazarus\fpc\2.2.4\bin\i386-win32\postw32.exe --subsystem gui --input R:\OsProjects\client\estbk.exe --stack 16777216
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
