; === MdToNotion AutoHotkey Script ===
;
; This script provides two hotkeys for interacting with Notion.
;
; 1. Ctrl + Alt + N: Uploads Markdown content from the CLIPBOARD.
; 2. Ctrl + Alt + U: Uploads the SELECTED Markdown FILE from Windows Explorer.

; ==============================================================================
; Hotkey 1: Upload from Clipboard
; ==============================================================================
^!n::
{
    ; Path to the PowerShell script that handles clipboard content.
    psClipboardScript := A_ScriptDir . "\clipboard2notion.ps1"

    if (!FileExist(psClipboardScript))
    {
        MsgBox, 48, Error, PowerShell script not found at:`n%psClipboardScript%
        return
    }

    command := "powershell.exe -ExecutionPolicy Bypass -File """ . psClipboardScript . """"
    Run, %command%,, Hide
    TrayTip, Markdown to Notion, Uploading clipboard content to Notion..., 10
    return
}


; ==============================================================================
; Hotkey 2: Upload Selected File
; ==============================================================================
; ^ = Ctrl
; ! = Alt
; u = u key (for "Upload")
;
; How to use:
; 1. Click on a single Markdown file in Windows Explorer to select it.
; 2. Press Ctrl + Alt + U.

^!u::
{
    ; Path to the PowerShell script that handles file uploads.
    ; This should be your 'runner.ps1' or equivalent.
    psFileRunnerScript := A_ScriptDir . "\mdfile2notion.ps1"

    if (!FileExist(psFileRunnerScript))
    {
        MsgBox, 48, Error, PowerShell script not found at:`n%psFileRunnerScript%`n`nMake sure runner.ps1 is in the same directory as this script.
        return
    }

    ; --- Get the path of the selected file ---
    ; 1. Backup the current clipboard content
    backupClipboard := ClipboardAll
    ; 2. Clear the clipboard to ensure we get fresh data
    Clipboard := ""
    ; 3. Send Ctrl+C to copy the selected file path
    Send, ^c
    ; 4. Wait for the clipboard to contain data (max 1 second)
    ClipWait, 1

    if (ErrorLevel) ; ClipWait timed out
    {
        MsgBox, 48, Error, Could not copy file path to clipboard.`n`nPlease select a file in Windows Explorer first.
        Clipboard := backupClipboard ; Restore original clipboard
        return
    }

    ; 5. Store the file path from the clipboard
    selectedFilePath := Clipboard
    ; 6. Restore the original clipboard content immediately
    Clipboard := backupClipboard

    ; --- Validate the path ---
    ; Check if the clipboard content is actually a valid, existing file path.
    if (!FileExist(selectedFilePath))
    {
        MsgBox, 48, Warning, The copied item is not a valid file path.`n`nPath: %selectedFilePath%
        return
    }

    ; --- Execute the upload script ---
    ; Construct the command, passing the file path as an argument to the PowerShell script.
    ; Note the format: -filePath "C:\path\to\your\file.md"
    command := "powershell.exe -ExecutionPolicy Bypass -File """ . psFileRunnerScript . """ -filePath """ . selectedFilePath . """"

    ; Run the command hidden in the background.
    Run, %command%,, Hide

    ; Provide user feedback.
    TrayTip, Markdown to Notion, Uploading file:`n%selectedFilePath%, 10
    return
}