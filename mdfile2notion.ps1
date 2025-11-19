# mdfile2notion.ps1 - Windows PowerShell script to upload Markdown to Notion
# Reads configuration from .env file

param (
    [Parameter(Mandatory=$true)]
    [string]$filePath
)

Write-Host "--- Starting Markdown to Notion script ---"

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

# --- Define the path to the Node.js script ---
$nodeScriptPath = Join-Path $PSScriptRoot "upload-md-to-notion.js"

# Verify the script file exists
if (-not (Test-Path $nodeScriptPath)) {
    Write-Error "ERROR: Node.js script not found at path: $nodeScriptPath"
    Read-Host "Press Enter to exit..."
    exit 1
}

# --- Execute the upload ---
Write-Host "Calling Node.js script to upload content..."
# Read file content with UTF-8 encoding to properly support Unicode/Chinese characters
$markdownContent = Get-Content -Path $filePath -Raw -Encoding UTF8

$OutputEncoding = [System.Text.Encoding]::UTF8

# Use increased memory for Node.js to handle API operations
$result = $markdownContent | node --max-old-space-size=8192 $nodeScriptPath

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