@echo off
setlocal

REM ====== CONFIG ======
set PYTHON_URL=https://www.python.org/ftp/python/3.12.9/python-3.12.9-amd64.exe
set MONGO_URL=https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-8.2.3.zip

set DOWNLOAD_DIR=%~dp0downloads
set MONGO_DIR=%DOWNLOAD_DIR%\mongodb
REM ====================

echo Creating download directory...
mkdir "%DOWNLOAD_DIR%" 2>nul

echo.
echo Downloading Python 3.12.9 installer...
powershell -Command "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%DOWNLOAD_DIR%\python-3.12.9-amd64.exe'"

echo.
echo Downloading MongoDB (mongod)...
powershell -Command "Invoke-WebRequest -Uri '%MONGO_URL%' -OutFile '%DOWNLOAD_DIR%\mongodb.zip'"

echo.
echo Extracting MongoDB...
powershell -Command "Expand-Archive -Force '%DOWNLOAD_DIR%\mongodb.zip' '%MONGO_DIR%'"

echo.
echo Done.
echo Python installer: %DOWNLOAD_DIR%\python-3.12.9-amd64.exe
echo mongod.exe location:
echo %MONGO_DIR%\mongodb-windows-x86_64-8.2.3\bin\mongod.exe

pause
endlocal
