# Script: utility.ps1

# Backup before process
function BackupFiles {
    param (
        [string]$FileType
    )
    try {
        $files = $null
        switch ($FileType) {
            'Script' {
                $files = Get-ChildItem $global:sourcePath -File | Where-Object { DetermineScriptType $_.Name -ne 'Unknown' }
            }
            'Log' {
                $files = Get-ChildItem $global:sourcePath -File | Where-Object { $_.Extension -eq '.log' }
            }
        }

        foreach ($file in $files) {
            $destination = Join-Path $global:backupPath $file.Name
            Copy-Item $file.FullName -Destination $destination -Force
        }
        Write-Host "Backed up, $($files.Count) $FileType files"
    } catch {
        Write-Host "Backup failed, $_"
    }
}

# Clean dirty scripts
function CleanScriptFiles {
    try {
        # Call to backup script files before cleaning
        BackupFiles 'Script'

        $scriptFiles = Get-ChildItem $global:sourcePath -File | Where-Object { DetermineScriptType $_.Name -ne 'Unknown' }
        if ($scriptFiles.Count -eq 0) {
            Write-Host "No scripts, Dirty empty"
            return
        }

        foreach ($file in $scriptFiles) {
            $scriptType = DetermineScriptType $file.Name
            Write-Host "Processing, $($file.Name)"

            $preStats = Get-FileStats -FilePath $file.FullName -ScriptType $scriptType
            Write-Host "$($file.Name), Pre stats: $($preStats.Blanks), $($preStats.Comments), $($preStats.Total)"

            $cleanContent = ProcessFile -FilePath $file.FullName -ScriptType $scriptType

            $postStats = Get-FileStats -Content $cleanContent -ScriptType $scriptType
            $reduction = CalculateReduction -PreTotal $preStats.Total -PostTotal $postStats.Total
            Write-Host "$($file.Name), Post stats: $($postStats.Blanks), $($postStats.Comments), $($postStats.Total)"
            Write-Host "Reduction, $reduction%`n"

            Start-Sleep -Seconds 1
        }
    } catch {
        Write-Host "Processing failed, $_"
    }
}


# Stats calculation
function Get-FileStats {
    param (
        [string]$FilePath,
        [string[]]$Content,
        [string]$ScriptType
    )
    if ($null -ne $FilePath) {
        $Content = Get-Content $FilePath
    }
    $stats = @{'Blanks' = 0; 'Comments' = 0; 'Total' = 0}
    foreach ($line in $Content) {
        $stats['Total']++
        if (-not $line.Trim()) {
            $stats['Blanks']++
            continue
        }
        if (IsCommentLine -Line $line -ScriptType $ScriptType) {
            $stats['Comments']++
        }
    }
    return $stats
}

# Comment check
function IsCommentLine {
    param (
        [string]$Line,
        [string]$ScriptType
    )
    switch ($ScriptType) {
        'Python' { return $Line.Trim().StartsWith("#") }
        'PowerShell' { return $Line.Trim().StartsWith("#") }
        'Batch' { return $Line.Trim().StartsWith("REM") -or $Line.Trim().StartsWith("::") }
        'MQL5' { return $Line.Trim().StartsWith("//") }
        default { return $false }
    }
}



# Process file content
function ProcessFile {
    param (
        [string]$FilePath,
        [string]$ScriptType
    )
    $content = Get-Content -Path $FilePath
    $cleanContent = $content | Where-Object { -not (IsCommentLine -Line $_ -ScriptType $ScriptType) -and $_.Trim() }
    return $cleanContent
}

# Reduction calculation
function CalculateReduction {
    param (
        [int]$PreTotal,
        [int]$PostTotal
    )
    return "{0:N2}" -f ((($PreTotal - $PostTotal) / $PreTotal) * 100)
}

# Script type determination
function DetermineScriptType {
    param ([string]$filename)
    switch ([System.IO.Path]::GetExtension($filename).ToLower()) {
        '.py' { 'Python' }
        '.ps1' { 'PowerShell' }
        '.bat' { 'Batch' }
        '.mq5' { 'MQL5' }
        default { 'Unknown' }
    }
}

# Clean log files
function CleanLogFiles {
    param (
        [string]$LogDirectory = ".\Dirty"
    )

    # Call to backup log files before cleaning
    BackupFiles 'Log'

    $logFiles = Get-ChildItem -Path $LogDirectory -Filter "*.log"
    if ($logFiles.Count -eq 0) {
        Write-Host "Logs not found, Directory empty"
        return
    }

    foreach ($logFile in $logFiles) {
        try {
            $logPath = $logFile.FullName
            $content = Get-Content -Path $logPath -Raw
            $cleanedContent = $content -replace '\x1b\[\d*;?\d*;?\d*m', ''
            Set-Content -Path $logPath -Value $cleanedContent
            Write-Host "Cleaned, $($logFile.Name)"
        }
        catch {
            Write-Host "Clean failed, $($logFile.Name)"
        }
    }
    Start-Sleep -Seconds 2
}


# Sanitize based on type
function SanitizeContentBasedOnType {
    param (
        [string]$scriptType,
        [string]$line
    )
    switch ($scriptType) {
        'Python' {
            if ($line.Trim().StartsWith("#")) { return $null }
            else { return $line.Trim() }
        }
        'PowerShell' {
            if ($line.Trim().StartsWith("#")) { return $null }
            else { return $line.Trim() }
        }
        'Batch' {
            if ($line.Trim().StartsWith("REM") -or $line.Trim().StartsWith("::")) { return $null }
            else { return $line.Trim() }
        }
        'MQL5' {
            if ($line.Trim().StartsWith("//")) { return $null }
            else { return $line.Trim() }
        }
        default {
            return $line.Trim()
        }
    }
}


# Old files maintenance
function Run-OldFilesMaintenance {
    $foldersWithCutoffs = @{
        '.\Backup' = (Get-Date).AddMonths(-6)
        '.\Clean' = (Get-Date).AddMonths(-4)
        '.\Reject' = (Get-Date).AddMonths(-2)
    }

    Write-Host "Checking, Old files.."
    foreach ($folder in $foldersWithCutoffs.Keys) {
        $cutoffDate = $foldersWithCutoffs[$folder]
        $oldFiles = Get-ChildItem $folder -File | Where-Object { $_.LastWriteTime -lt $cutoffDate }

        if ($oldFiles.Count -gt 0) {
            Write-Host "Found old, ${folder}"
            foreach ($file in $oldFiles) {
                Write-Host "Removing, $($file.Name)"
                Remove-Item $file.FullName -Force
            }
        } else {
            Write-Host "All clear, $folder"
        }
    }
    Write-Host "..Maintenance done.`n"
}

# Unsupported files handler
function Run-RemoveUnsupportedFiles {
    $allowedExtensions = @('.ps1', '.py', '.bat', '.mq5', '.log')
    $scriptFiles = Get-ChildItem $global:sourcePath -File
    $unsupportedFiles = $scriptFiles | Where-Object { $_.Extension.ToLower() -notin $allowedExtensions }
    Write-Host "Checking .\Dirty Folder.."
    if ($unsupportedFiles.Count -gt 0) {
        Write-Host "..Unsupported Scripts!"
        foreach ($file in $unsupportedFiles) {
            $destination = Join-Path $global:rejectPath $file.Name
            Move-Item $file.FullName -Destination $destination -Force
            Write-Host "Rejected: $($file.Name)"
        }
    } else {
        Write-Host "..All scripts supported."
    }
	Write-Host ""
}
