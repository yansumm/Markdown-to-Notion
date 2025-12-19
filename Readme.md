# Markdown2Notion - Fast Markdown to Notion
# Markdown2Notion - 快速将Markdown内容上传到Notion

>A powerful tool that allows you to <u> fast upload `file` or `clipboard contetnt` in `Markdown` format to your Notion pages via **hotkeys** </u>.
一款强大的工具，让您能够<u>通过**快捷键**快速将`文件`或`剪贴板内容`以 Markdown 格式上传至您的 Notion 页面</u>。



## 📝 背景 / Background

**Why this tool exists:** Markdown is a very common file format, and many people use AI to organize notes or use Notion to record notes. However, Notion has suboptimal support for directly pasting Markdown content - particularly for mathematical formulas (`$$...$$`) which don't render as Notion blocks. While Notion supports many Markdown syntaxes, it's built on a block-based logic that creates challenges when organizing notes.

**为什么需要这个工具：** Markdown是一种非常常见的文件格式，许多人使用AI来整理笔记或使用Notion记录笔记。但是，Notion对于直接粘贴Markdown内容的支持并不完善，特别是数学公式（`$$...$$`）不会被渲染为Notion块。尽管Notion支持许多Markdown语法，但它基于块状逻辑构建，这在整理笔记时会带来挑战。

For example, in a Markdown file containing many mathematical formulas, Notion cannot automatically convert `$$...$$` syntax, leaving it as literal `$$...$$` text. Users must manually convert each formula one by one (using mouse or shortcut Ctrl+Shift+E). For documents with numerous formulas - common when studying various subjects or reading academic papers - this process becomes tedious and extremely time-consuming.

例如，在包含许多数学公式的Markdown文件中，Notion无法自动转换`$$...$$`语法，将其保留为字面量`$$...$$`文本。用户必须一个一个手动转换公式（使用鼠标或快捷键Ctrl+Shift+E）。对于具有大量公式的文档，这在学习各种学科或阅读学术论文时很常见，这个过程变得繁琐且极其耗时。

Browser plugins are limited solutions as modern web applications can detect and block automated script operations. This tool solves this problem by converting Markdown (especially with LaTeX formulas) to proper Notion blocks before uploading.

浏览器插件是有限的解决方案，因为现代Web应用程序可以检测和阻止自动化脚本操作。这个工具通过在上传之前将Markdown（特别是LaTeX公式）转换为适当的Notion块来解决这个问题。


## 🚀 完整设置和使用指南 / Complete Setup & Usage Guide

### 步骤1：安装 / Step 1: Installation

#### 方法1：一键安装（推荐）/ Method 1: One-Click Installation (Recommended)

1. Run `setup.bat`
2. The script will automatically:
   1. 运行 `setup.bat`
   2. 脚本将自动：
   - Check for and install Node.js dependencies
   - Automatically download and install AutoHotkey if needed
   - Verify all required files exist
   - Create .env file from example if needed
   - 检查并安装Node.js依赖项
   - 必要时自动下载并安装AutoHotkey
   - 验证所有必需文件是否存在
   - 如需要，从示例创建.env文件

#### 方法2：手动设置 / Method 2: Manual Setup

1. Install Node.js (version 18 or higher)
2. Run `npm install` to install dependencies
   1. 安装Node.js（版本18或更高）
   2. 运行 `npm install` 来安装依赖项

### 步骤2：配置 / Step 2: Configuration

1. Copy `.env.example` to `.env`
2. Add your Notion integration token and page ID:
   1. 复制 `.env.example` 到 `.env`
   2. 添加您的Notion集成令牌和页面ID：

```env
# Notion Integration Token
# Get this from your Notion integrations page
NOTION_TOKEN=secret_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Notion Page ID
# The ID of the page you want to upload to (from the URL: notion.so/name/title-<pageID>)
NOTION_PAGE_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

# Notion 集成令牌
# 从您的Notion集成页面获取
NOTION_TOKEN=secret_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Notion 页面ID
# 您要上传到的页面ID（来自URL：notion.so/name/title-<pageID>）
NOTION_PAGE_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

#### 获取Notion集成令牌 / Getting Notion Integration Token

1. Go to [https://www.notion.so/my-integrations](https://www.notion.so/my-integrations)
2. Create a new integration or use an existing one
3. Copy the "Internal Integration Token"
4. Authorize this token with the permission of modifying the target Notion page.

1. 访问 [https://www.notion.so/my-integrations](https://www.notion.so/my-integrations)
2. 创建新集成或使用现有集成
3. 复制"内部集成令牌"
4. 使用修改目标Notion页面的权限授权此令牌。

#### 获取Notion页面ID / Getting Notion Page ID

1. Open your target Notion page
2. Copy the URL: `https://www.notion.so/your-workspace/Page-Title-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
3. The Page ID is the last part after the final dash: `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
4. Trick: you can create a notion page for transferring markdown notes. After transferring the markdown notes to this Notion page, you can Ctrl+X these blocks and paste into your final target page. In this way, you will not need to modify the Notion page each time.

1. 打开您的目标Notion页面
2. 复制URL：`https://www.notion.so/your-workspace/Page-Title-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
3. 页面ID是最后一个破折号后的部分：`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
4. 技巧：您可以创建一个notion页面来传输markdown笔记。将markdown笔记传输到这个Notion页面后，您可以使用Ctrl+X这些块并粘贴到最终目标页面。这样，您无需每次都修改Notion页面。

### 步骤3：使用选项 / Step 3: Usage Options

The tool provides two main ways to upload content:
该工具提供两种主要的上传内容方式：

#### **从文件上传 / Upload from File**

**Method 1 (Recommended): Hotkey File Upload**
**方法1（推荐）：热键文件上传**

1. After setup completes, select a Markdown file in Windows Explorer
2. Press hotkey `Ctrl+Alt+U` to upload the selected file to Notion
   1. 完成设置后，在Windows资源管理器中选择一个Markdown文件
   2. 按热键 `Ctrl+Alt+U` 上传选定的文件到Notion

**Method 2: Command Line File Upload**
**方法2：命令行文件上传**

```powershell
powershell -ExecutionPolicy Bypass -File "mdfile2notion.ps1" "path\to\your\file.md"
```

#### **从剪贴板上传 / Upload from Clipboard**

**Method 1 (Recommended): Hotkey Clipboard Upload**
**方法1（推荐）：热键剪贴板上传**

1. The setup script automatically installs AutoHotkey if not present
2. Run `markdown2notion.ahk` (this enables the hotkeys)
3. Copy text content to clipboard (Ctrl+C)
4. Use hotkey `Ctrl+Alt+N` to upload clipboard content to Notion

1. 设置脚本会自动安装AutoHotkey（如果不存在）
2. 运行 `markdown2notion.ahk` （这将启用热键）
3. 复制文本内容到剪贴板（Ctrl+C）
4. 使用热键 `Ctrl+Alt+N` 上传剪贴板内容到Notion

**Method 2: Direct Clipboard Script**
**方法2：直接剪贴板脚本**

```powershell
powershell -ExecutionPolicy Bypass -File "clipboard2notion.ps1"
```

## ✅ 功能 / Features

- **Unicode Support**: Full support for Chinese characters and other Unicode content
- **Unicode支持**：完全支持中文字符和其他Unicode内容
- **LaTeX Formulas**: Automatically converts `$...$` and `$$...$$` to Notion equations
- **LaTeX公式**：自动将`$...$`和`$$...$$`转换为Notion方程
- **Hotkey Support**: Easy access via keyboard shortcuts (Ctrl+Alt+N for clipboard, Ctrl+Alt+U for file)
- **热键支持**：通过键盘快捷键轻松访问（Ctrl+Alt+N用于剪贴板，Ctrl+Alt+U用于文件）
- **Clipboard Support**: Upload content directly from clipboard (Ctrl+C)
- **剪贴板支持**：直接从剪贴板上传内容（Ctrl+C）
- **AutoHotkey Integration**: Hotkey functionality for quick uploads
- **AutoHotkey集成**：用于快速上传的热键功能
- **One-Click Setup**: Automatically downloads and installs dependencies including AutoHotkey
- **一键设置**：自动下载并安装依赖项，包括AutoHotkey
- **Markdown Blocks**: Preserves formatting, lists, code blocks, etc.
- **Markdown块**：保留格式、列表、代码块等。

## ⚠️ 故障排除 / Troubleshooting

- For PowerShell execution policy errors, run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- 对于PowerShell执行策略错误，运行：`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- If hotkey functionality doesn't work, ensure AutoHotkey is properly installed and the script `markdown2notion.ahk` is running
- 如果热键功能不起作用，请确保AutoHotkey已正确安装且脚本`markdown2notion.ahk`正在运行
- If clipboard functionality doesn't work, ensure AutoHotkey is properly installed
- 如果剪贴板功能不起作用，请确保AutoHotkey已正确安装
- For credential errors, double-check your `.env` file format
- 对于凭据错误，请仔细检查您的`.env`文件格式
- If the .env file is not found, make sure you've created it from the .env.example template
- 如果找不到.env文件，请确保您已从.env.example模板创建了它

## 📁 项目结构 / Project Structure

```
md2notion/
├── .env(.example)          # Configuration file
├── setup.bat               # One-click installation script (downloads and configures AutoHotkey)
├── mdfile2notion.ps1       # PowerShell script for MD file upload
├── clipboard2notion.ps1    # PowerShell script for clipboard upload
├── markdown2notion.ahk     # AutoHotkey script for hotkey functionality
├── upload-md-to-notion.js  # Node.js core functionality
├── package.json            # Node.js dependencies
└── Readme.md              # This file

md2notion/
├── .env(.example)          # 配置文件
├── setup.bat               # 一键安装脚本（下载并配置AutoHotkey）
├── mdfile2notion.ps1       # 用于MD文件上传的PowerShell脚本
├── clipboard2notion.ps1    # 用于剪贴板上传的PowerShell脚本
├── markdown2notion.ahk     # 用于热键功能的AutoHotkey脚本
├── upload-md-to-notion.js  # Node.js核心功能
├── package.json            # Node.js依赖项
└── Readme.md              # 本文件
```

## 📝 备注 / Notes

- This tool is based on the macOS version of [Markdown2Notion](https://github.com/LFF8888/Markdown2Notion), providing equivalent functionality for Windows users with additional clipboard and hotkey support
- 这个工具基于[Markdown2Notion](https://github.com/LFF8888/Markdown2Notion)的macOS版本，为Windows用户提供等效功能，并补充了剪贴板和热键支持
- Always keep your `.env` file secure and never commit it to version control
- 始终确保您的`.env`文件安全，永远不要将其提交到版本控制中
- The integration requires proper Notion API permissions for the target page
- 集成需要目标页面的适当Notion API权限
- To use hotkey functionality, ensure the `markdown2notion.ahk` script is running in the background
- 要使用热键功能，请确保`markdown2notion.ahk`脚本在后台运行

## 📄 许可证 / License

## 📜 License

This project is licensed under the **GNU General Public License v3.0 (GPLv3)**.
You may copy, distribute and modify the software as long as you track changes/dates in source files. Any modifications to or software including (via compiler) GPL-licensed code must also be made available under the GPL along with build & install instructions.
