# main.ps1 - Initialization and Entry Point for CleanCode Program

# Import external scripts
. .\scripts\display.ps1
. .\scripts\utility.ps1

# Global variables
$global:backupPath = ".\Backup"
$global:sourcePath = ".\Dirty"
$global:cleanPath = ".\Clean"


# Initialize program
function script-InitializationCode {
	Clear-Host
	PrintProgramTitle
	Start-Sleep -Seconds 1
	Set-ConfigureDisplay
    Write-Host "Powershell Script Initialized...`n"
    Start-Sleep -Seconds 2
}

# Exit Program
function script-FinalizationCode {
    Clear-Host
	PrintProgramTitle
    Write-Host "`n....Powershell Script Exiting.`n"
    Start-Sleep -Seconds 2
}

# Main loop
function Main-Loop {
    Display-PrimaryMenu
}

# Entry point
script-InitializationCode
Main-Loop
script-FinalizationCode
