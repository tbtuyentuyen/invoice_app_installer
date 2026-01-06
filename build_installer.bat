@echo off

if exist "invoice_app" (
    echo Removing existing invoice_app...
    rmdir /s /q "invoice_app"
)

echo Downloading repository...
call scripts/download_repo.bat

if not exist "invoice_app" (
  echo ERROR: Output folder not found
  exit /b 1
)

echo Compiling installer...
"ISCC.exe" setup.iss

if exist "invoice_app" (
    echo Removing invoice_app...
    rmdir /s /q "invoice_app"
)

echo Done.
