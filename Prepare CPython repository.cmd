@echo off
setlocal

if "%~1"=="" (
    set "REPO=."
) else (
    set "REPO=%~1"
)

git -C "%REPO%" rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ERROR: "%REPO%" is not a Git repository.
    exit /b 1
)

echo Configuring CPython repository line endings...

git -C "%REPO%" config --local core.autocrlf input
if errorlevel 1 exit /b 1

git -C "%REPO%" config --local core.eol lf
if errorlevel 1 exit /b 1

echo.
echo core.autocrlf:
echo Effective configuration:
git -C "%REPO%" config --get core.autocrlf
echo core.eol:
git -C "%REPO%" config --get core.eol

echo Re-materializing repository with the configured line endings policy...
git -C "%REPO%" checkout-index --all --force
if errorlevel 1 exit /b 1

echo.
echo CPython repository configured successfully.
exit /b 0
