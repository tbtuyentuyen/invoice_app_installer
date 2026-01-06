@echo off
setlocal enabledelayedexpansion

:: --- CONFIG ---
set REPO=tbtuyentuyen/invoice_app
set OUTPUT=latest_release.zip

echo Getting latest release tag...

:: Get the tag name using the GitHub API
curl -s https://api.github.com/repos/%REPO%/releases/latest > latest.json

:: Extract "tag_name": "v1.0.0"
set TAG=
for /f "tokens=2 delims=:" %%A in ('findstr /i "tag_name" latest.json') do (
    set raw=%%A
)

:: Cleanup tag value (remove quotes and comma)
set raw=%raw:"=%
set raw=%raw:,=%
set TAG=%raw: =%

echo Latest tag: %TAG%
echo Finding .zip asset...

set DOWNLOAD_URL=https://github.com/tbtuyentuyen/invoice_app/archive/refs/tags/%TAG%.zip

echo Download URL: %DOWNLOAD_URL%
echo Downloading file...
curl -L -o "%OUTPUT%" "%DOWNLOAD_URL%"

echo Extracting latest_release.zip
set TEMP_DIR=temp_extract
set FINAL_DIR=invoice_app
powershell -Command "Expand-Archive -Force latest_release.zip %TEMP_DIR%"

for /d %%D in (%TEMP_DIR%\invoice_app-*) do (
    move "%%D" "%FINAL_DIR%"
)
echo Done.

del latest.json
del latest_release.zip
rmdir /s /q %TEMP_DIR%
