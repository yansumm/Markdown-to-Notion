# clipboard-to-notion.ps1 - Windows PowerShell script to upload clipboard content to Notion

Write-Host "--- Starting Clipboard to Notion script ---"
  
# Load environment variables from .env file
$envPath = Join-Path $PSScriptRoot ".env"
if (Test-Path $envPath) {
    Get-Content $envPath | Foreach-Object {
        $line = $_.Trim()
        if ($line -and !$line.StartsWith("#") -and $line.Contains("=")) {
            $key, $value = $line.Split("=", 2)
            $key = $key.Trim()
            $value = $value.Trim().Trim('"', "'")
            [Environment]::SetEnvironmentVariable($key, $value, "Process")
            Set-Item -Path "env:$key" -Value $value
        }
    }
    Write-Host ".env file loaded successfully." -ForegroundColor Green
} else {
    Write-Error ".env file not found. Please create one based on .env.example"
    Read-Host "Press Enter to exit..."
    exit 1
}

# Check if required environment variables are set
if (-not $env:NOTION_TOKEN) {
    Write-Error "NOTION_TOKEN not found in .env file. Please add it to your .env file."
    Read-Host "Press Enter to exit..."
    exit 1
} else {
    Write-Host "NOTION_TOKEN found in .env file." -ForegroundColor Green
}

if (-not $env:NOTION_PAGE_ID) {
    Write-Error "NOTION_PAGE_ID not found in .env file. Please add it to your .env file."
    Read-Host "Press Enter to exit..."
    exit 1
} else {
    Write-Host "NOTION_PAGE_ID found in .env file." -ForegroundColor Green
}


# --- Verify Node.js is available ---
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Error "ERROR: Node.js is not found in PATH. Please install Node.js and try again."
    Read-Host "Press Enter to exit..."
    exit 1
}

# --- Get content from clipboard ---
# --- Get content from clipboard ---
try {
    # 直接使用兼容 PowerShell 5.1 的 .NET 方法
    Add-Type -AssemblyName System.Windows.Forms
    $clipboardContent = [System.Windows.Forms.Clipboard]::GetText()

    if (-not $clipboardContent -or $clipboardContent.Trim().Length -eq 0) {
        Write-Error "ERROR: Clipboard is empty or contains no text."
        Read-Host "Press Enter to exit..."
        exit 1
    }
    
    Write-Host "Retrieved content from clipboard (length: $($clipboardContent.Length) characters)."
} catch {
    Write-Error "ERROR: Could not access clipboard content: $($_.Exception.Message)"
    Read-Host "Press Enter to exit..."
    exit 1
}

# --- Define the path to the Node.js script ---
$nodeScriptPath = Join-Path $PSScriptRoot "upload-md-to-notion.js"

# Verify the script file exists
if (-not (Test-Path $nodeScriptPath)) {
    Write-Error "ERROR: Node.js script not found at path: $nodeScriptPath"
    Read-Host "Press Enter to exit..."
    exit 1
}

# --- Execute the upload ---
Write-Host "Calling Node.js script to upload clipboard content..."

$OutputEncoding = [System.Text.Encoding]::UTF8

$result = $clipboardContent | node --max-old-space-size=8192 $nodeScriptPath

# Output the result from the Node.js script
if ($result) {
    Write-Host $result
} else {
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        Write-Host "Node.js script exited with code: $exitCode" -ForegroundColor Red
    }
}

Write-Host "--- Script finished. ---"