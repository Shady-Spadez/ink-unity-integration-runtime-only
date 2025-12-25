# ink-unity-integration-runtime-only

本项目提供 ink 叙事脚本语言的纯 C# 运行时，可以独立运行，不依赖 Unity。

## 项目目标

- 提供纯 C# 运行时，允许 ink 在纯 C# 环境中运行
- 构建独立的 .NET Standard 2.1 DLL
- 方便同步主仓库（https://github.com/inkle/ink-unity-integration）的修改

## 项目结构

```
ink-unity-integration-runtime-only/
├── Runtime/                    # 纯 C# 运行时项目
│   ├── InkRuntime/            # 运行时核心代码
│   ├── InkCompiler/           # 编译器代码
│   └── Ink.csproj             # .NET Standard 2.1 项目文件
├── upstream/                   # 主仓库 submodule
├── build.bat                   # Windows 构建脚本
├── build.sh                    # Linux/Mac 构建脚本
└── README.md                   # 本文件
```

## 构建 DLL

### 使用构建脚本

**Windows:**
```bash
build.bat
```

**Linux/Mac:**
```bash
chmod +x build.sh
./build.sh
```

### 手动构建

```bash
cd Runtime
dotnet build -c Release
```

构建完成后，DLL 位于：
```
Runtime/bin/Release/netstandard2.1/Ink.dll
```

## 同步主仓库更新

本项目使用 git submodule 来跟踪主仓库的更新。

### 初始化 submodule（首次克隆项目时）

```bash
git submodule update --init --recursive
```

### 更新主仓库代码

```bash
# 更新 submodule 到主仓库的最新提交
git submodule update --remote upstream

# 如果主仓库有更新，需要同步到 Runtime/ 目录
# 手动复制 Packages/Ink/InkLibs/ 下的文件到 Runtime/ 目录
```

### 同步流程

1. 更新 submodule：
   ```bash
   git submodule update --remote upstream
   ```

2. 从 submodule 复制最新代码到 Runtime 目录：
   ```bash
   # 复制 InkRuntime
   Get-ChildItem -Path "upstream/Packages/Ink/InkLibs/InkRuntime" -Filter "*.cs" -Recurse | Copy-Item -Destination { $_.FullName -replace [regex]::Escape("upstream/Packages/Ink/InkLibs/InkRuntime"), "Runtime\InkRuntime" } -Force
   
   # 复制 InkCompiler
   Get-ChildItem -Path "upstream/Packages/Ink/InkLibs/InkCompiler" -Filter "*.cs" -Recurse | ForEach-Object { $destPath = $_.FullName -replace [regex]::Escape("upstream/Packages/Ink/InkLibs/InkCompiler"), "Runtime\InkCompiler"; $destDir = Split-Path $destPath -Parent; if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Force -Path $destDir | Out-Null }; Copy-Item $_.FullName -Destination $destPath -Force }
   ```

3. 重新构建 DLL：
   ```bash
   build.bat
   ```

4. 提交更改：
   ```bash
   git add Runtime/
   git commit -m "Sync with upstream"
   ```

## 使用 DLL

生成的 `Ink.dll` 可以在任何支持 .NET Standard 2.1 的项目中使用：

```csharp
using Ink.Runtime;
using Ink;

// 从 JSON 加载故事
var json = File.ReadAllText("story.json");
var story = new Story(json);

// 运行故事
while (story.canContinue) {
    var text = story.Continue();
    Console.WriteLine(text);
}

// 处理选择
foreach (var choice in story.currentChoices) {
    Console.WriteLine($"{choice.index + 1}. {choice.text}");
}
```

## 分支

当前分支：`runtime-only`

## 许可证

与原项目保持一致。
