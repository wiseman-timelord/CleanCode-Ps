# Script: cleaner.ps1

# Clean dirty scripts
function CleanScriptFiles {
    Clear-Host
    PrintProgramTitle
    try {
        Write-Host "Backing Up Scripts.."
        BackupFiles 'Script'
        Write-Host "..Scripts Backed Up.`n"
        $scriptFiles = Get-ChildItem ".\Dirty" -File | Where-Object { DetermineScriptType $_.Name -ne 'Unknown' }
        if ($scriptFiles.Count -eq 0) {
            Write-Host "No Scripts In .\Dirty"
            return
        }
        Write-Host "Cleaning Scripts.."
        foreach ($file in $scriptFiles) {
            $scriptType = DetermineScriptType $file.Name
            Write-Host "Processing: $($file.Name)"

            $preStats = Get-FileStats -FilePath $file.FullName -ScriptType $scriptType
            Write-Host "State: Blanks=$($preStats.Blanks), Comments=$($preStats.Comments), Total=$($preStats.Total)"

            $cleanContent = ProcessFile -FilePath $file.FullName -ScriptType $scriptType

            $postStats = Get-FileStats -Content $cleanContent -ScriptType $scriptType
            $reduction = CalculateReduction -PreTotal $preStats.Total -PostTotal $postStats.Total
            Write-Host "After: Blanks=$($postStats.Blanks), Comments=$($postStats.Comments), Total=$($postStats.Total)"
            Write-Host "Reduction=$reduction%`n"

            Start-Sleep -Seconds 1
        }
        Write-Host "..Scripts Cleaned."		
    } catch {
        Write-Host "Error Cleaning: $_"
    } finally {
        Start-Sleep -Seconds 2
    }
}

# Clean log files
function CleanLogFiles {
    param (
        [string]$LogDirectory = ".\Dirty"
    )
    Clear-Host
    PrintProgramTitle
    try {


        Write-Host "Backing Up Logs.."
        BackupFiles 'Log'
        Write-Host "..Logs Backed Up.`n"
		Start-Sleep -Seconds 1
		
        $logFiles = Get-ChildItem -Path $LogDirectory -Filter "*.log"
        if ($logFiles.Count -eq 0) {
            Write-Host "No Logs In .\Dirty"
            return
        }
		
        Write-Host "Cleaning Logs.."
        foreach ($logFile in $logFiles) {
            $logPath = $logFile.FullName
            $content = Get-Content -Path $logPath -Raw
            # Replace escape sequences for colors and styles in logs
            $cleanedContent = $content -replace '\x1b\[\d*;?\d*;?\d*m', ''
            Set-Content -Path $logPath -Value $cleanedContent
            Write-Host "Cleaned: $($logFile.Name)"
			Start-Sleep -Seconds 1
        }
        Write-Host "..Logs Cleaned."
    } catch {
        Write-Host "Error Cleaning: $_"
    } finally {
        Start-Sleep -Seconds 2
    }
}


# Sanitize based on type
function SanitizeContentBasedOnType {
    param (
        [string]$line
    )
    $scriptType = $global:ScriptType_x6s
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


# Comment check
function IsCommentLine {
    param (
        [string]$Line
    )
    $ScriptType = $global:ScriptType_x6s
    switch ($ScriptType) {
        'Python' { return $Line.Trim().StartsWith("#") }
        'PowerShell' { return $Line.Trim().StartsWith("#") }
        'Batch' { return $Line.Trim().StartsWith("REM") -or $Line.Trim().StartsWith("::") }
        'MQL5' { return $Line.Trim().StartsWith("//") }
        default { return $false }
    }
}



# Process file content
# Process file content and count error indicators
function ProcessFile {
    param (
        [string]$FilePath
    )
    $Content = Get-Content -Path $FilePath
    $ErrorCount = 0
    $CleanedContent = @()

    foreach ($Line in $Content) {
        # Check if line is a comment or should be trimmed and not added to cleaned content
        if (-not (IsCommentLine -Line $Line) -and $Line.Trim()) {
            # Add non-comment, non-empty lines to cleaned content
            $CleanedContent += $Line.Trim()
        }

        # Check for lines starting with "Line" indicating an error
        if ($Line.Trim().StartsWith("Line")) {
            $ErrorCount++
        }
    }

    # Optionally, save the cleaned content back to a file or process further
    # Set-Content -Path $FilePath -Value $CleanedContent

    # Return or report the error count
    Write-Host "Errors Cleaned: $ErrorCount"

    # If you need to use the cleaned content and error count outside this function, consider returning a custom object
    return [PSCustomObject]@{
        CleanedContent = $CleanedContent
        ErrorCount = $ErrorCount
    }
}
