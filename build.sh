#!/bin/bash
echo "Building Ink Runtime DLL..."
cd Runtime
dotnet build -c Release
if [ $? -eq 0 ]; then
    echo ""
    echo "Build successful! DLL location:"
    echo "Runtime/bin/Release/netstandard2.1/Ink.dll"
else
    echo ""
    echo "Build failed!"
    exit 1
fi

