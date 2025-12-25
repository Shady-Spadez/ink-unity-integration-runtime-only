# Ink Runtime

这是 ink 叙事脚本语言的纯 C# 运行时实现。

## 包含内容

- **InkRuntime/**: 运行时核心代码，用于执行已编译的 ink 故事
- **InkCompiler/**: 编译器代码，用于将 .ink 文件编译为 JSON

## 构建

```bash
dotnet build -c Release
```

生成的 DLL 位于 `bin/Release/netstandard2.1/Ink.dll`

## 目标框架

.NET Standard 2.1

## 命名空间

- `Ink.Runtime` - 运行时类
- `Ink` - 编译器类

