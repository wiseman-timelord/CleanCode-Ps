# main.ps1 - Initialization and Entry Point for CleanCode Program

# Import external scripts
. .\scripts\display.ps1
. .\scripts\utility.ps1
. .\scripts\cleaner.ps1

# Global variables
$global:FilePath_c2l = ""
$global:ScriptType_x6s = ""
$global:CurrentContent_o4s = ""

# Initialize program
function script-InitializationCode {
	Clear-Host
	PrintProgramTitle
	Start-Sleep -Seconds 1
	Set-ConfigureDisplay
	Start-Sleep -Seconds 1
    Run-OldFilesMaintenance
	Start-Sleep -Seconds 1
	Run-RemoveUnsupportedFiles
	Start-Sleep -Seconds 1
	Write-Host "Powershell Script Initialized...`n"
    Start-Sleep -Seconds 2
}

# Exit Program
function script-FinalizationCode {
    Clear-Host
	PrintProgramTitle
    Write-Host "`n....Powershell Script Exiting.`n"
    Start-Sleep -Seconds 2
	exit
}

# Main loop
function Main-Loop {
    Display-PrimaryMenu
}

# Entry point
script-InitializationCode
Main-Loop
script-FinalizationCode
