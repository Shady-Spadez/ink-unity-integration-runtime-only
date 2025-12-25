@echo off
echo Building Ink Runtime DLL...
cd Runtime
dotnet build -c Release
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Build successful! DLL location:
    echo Runtime\bin\Release\netstandard2.1\Ink.dll
) else (
    echo.
    echo Build failed!
    exit /b %ERRORLEVEL%
)

