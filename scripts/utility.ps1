# Script: utility.ps1

# Backup scripts before processing
function BackupScripts {
    try {
        $scriptFiles = Get-ChildItem $global:sourcePath -File
        foreach ($file in $scriptFiles) {
            $destination = Join-Path $global:backupPath $file.Name
            Copy-Item $file.FullName -Destination $destination -Force
        }
        Write-Host "$($scriptFiles.Count) script(s) backed up successfully."
    } catch {
        Write-Host "An error occurred during the backup process: $_"
    }
}

function CleanScripts {
    try {
        BackupScripts
        $scriptFiles = Get-ChildItem $global:sourcePath -File
        if ($scriptFiles.Count -eq 0) {
            Write-Host "No scripts found to process in the 'Dirty' directory."
        } else {
            foreach ($file in $scriptFiles) {
                $scriptType = DetermineScriptType $file.Name
                if ($scriptType -eq 'Unknown') {
                    Write-Host "Unsupported Format: $($file.Name)"
                    continue
                }
                Write-Host "Processing $($file.Name)..."
                $cleanContent = @()
                $content = Get-Content $file.FullName
                foreach ($line in $content) {
                    $sanitizedLine = SanitizeContentBasedOnType $scriptType $line
                    if ($sanitizedLine -ne $null) {
                        $cleanContent += $sanitizedLine
                    }
                }
                $cleanFilePath = Join-Path $global:cleanPath $file.Name
                Set-Content -Path $cleanFilePath -Value $cleanContent
                Remove-Item $file.FullName -Force
                Write-Host "Successfully processed and moved to 'Clean' directory."
            }
        }
    } catch {
        Write-Host "An error occurred during script processing: $_"
    }
}



# Initial checks and setup
function InitializeCleanCodeEnvironment {
    CheckAndCreateDirectories
    # Any other initialization logic can be added here
}

function DebugCleanScripts {
    # Clear the .\Clean directory
    Get-ChildItem $global:cleanPath -File | Remove-Item -Force
    Write-Host "Cleaned scripts directory has been cleared."
}


function DetermineScriptType {
    param (
        [string]$filename
    )
    $extension = [System.IO.Path]::GetExtension($filename).ToLower()
    switch ($extension) {
        '.py' { return 'Python' }
        '.ps1' { return 'PowerShell' }
        '.bat' { return 'Batch' }
        '.mq5' { return 'MQL5' }
        default { return 'Unknown' }
    }
}


function DebugCleanLogs {
    param (
        [string]$LogDirectory = ".\Dirty"
    )

    # Find all log files in the directory
    $logFiles = Get-ChildItem -Path $LogDirectory -Filter "*.log"

    if ($logFiles.Count -eq 0) {
        Write-Host "No log files found to clean in the '$LogDirectory' directory."
    }
    else {
        foreach ($logFile in $logFiles) {
            $logPath = $logFile.FullName
            try {
                # Read the log file content
                $content = Get-Content -Path $logPath -Raw

                # Replace ANSI escape sequences with nothing
                $cleanedContent = $content -replace '\x1b\[\d*;?\d*;?\d*m', ''

                # Overwrite the original log file with the cleaned content
                Set-Content -Path $logPath -Value $cleanedContent

                Write-Host "Cleaned log file: $($logFile.Name)"
            }
            catch {
                Write-Host "Error cleaning log file: $($logFile.Name): $_"
            }
        }
    }
    Start-Sleep -Seconds 2
}


function SanitizeContentBasedOnType {
    param (
        [string]$scriptType,
        [string]$line
    )
    switch ($scriptType) {
        'Python' {
            if ($line.Trim().StartsWith("#")) { return $null } # Remove Python comments
            else { return $line.Trim() }
        }
        'PowerShell' {
            if ($line.Trim().StartsWith("#")) { return $null } # Remove PowerShell comments
            else { return $line.Trim() }
        }
        'Batch' {
            if ($line.Trim().StartsWith("REM") -or $line.Trim().StartsWith("::")) { return $null } # Remove Batch comments
            else { return $line.Trim() }
        }
        'MQL5' { # Implement sanitization for MQL5
            if ($line.Trim().StartsWith("//")) { return $null } # Remove MQL5 comments
            else { return $line.Trim() }
        }
        default {
            return $line
        }
    }
}


function Run-OldFilesMaintenance {
    $foldersWithCutoffs = @{
        '.\Backup' = (Get-Date).AddMonths(-6)
        '.\Clean' = (Get-Date).AddMonths(-4)
        '.\Reject' = (Get-Date).AddMonths(-2)
    }
    Write-Host "Checking Old Files.."
    foreach ($folder in $foldersWithCutoffs.Keys) {
        $cutoffDate = $foldersWithCutoffs[$folder]
        $oldFiles = Get-ChildItem $folder -File | Where-Object { $_.LastWriteTime -lt $cutoffDate }

        if ($oldFiles.Count -gt 0) {
            Write-Host "Old Files in ${folder}:"
            $oldFiles | ForEach-Object {
                Write-Host "`t$($_.Name)"
                Remove-Item $_.FullName -Force
            }
        } else {
            Write-Host "$folder Is Acceptable"
        }
    }
    Write-Host "Old Files Checked.`n"
}



function Run-RemoveUnsupportedFiles {
    # Define allowed file extensions
    $allowedExtensions = @('.ps1', '.py', '.bat', '.mq5', '.log')
    $scriptFiles = Get-ChildItem $global:sourcePath -File
    $unsupportedFiles = @()

    Write-Host "Checking File Formats.."
    foreach ($file in $scriptFiles) {
        if ($file.Extension.ToLower() -notin $allowedExtensions) {
            $unsupportedFiles += $file
            $destination = Join-Path $global:rejectPath $file.Name
            Move-Item $file.FullName -Destination $destination -Force
        }
    }
    if ($unsupportedFiles.Count -gt 0) {
        Write-Host "Rejected Files Moved:"
        $unsupportedFiles | ForEach-Object {
            Write-Host "`t$($_.Name)"
        }
    } else {
        Write-Host "..No Unsupported Files.."
    }
    Write-Host "..File Formats Checked.`n"
}
