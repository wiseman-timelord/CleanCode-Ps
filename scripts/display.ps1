# Script: display.ps1

# Print the program's title
function PrintProgramTitle {
    Write-Host "`n=========================( CleanCode-Ps )=========================`n"
}

# Print a separator for the menu items
function PrintProgramSeparator {
    Write-Host "------------------------------------------------------------------"
}

# Sets the window title, size, and console properties for display configuration
function Set-ConfigureDisplay {
    Write-Host "Display Configuration.."
    [Console]::ForegroundColor = [ConsoleColor]::White
    [Console]::BackgroundColor = [ConsoleColor]::DarkGray
	[Console]::Clear()
    PrintProgramTitle
    Write-Host "Display Configuration.."
	Write-Host "..Display Configured.`n"
}

function Display-PrimaryMenu {
    do {
        Clear-Host
        PrintProgramTitle
        Write-Host "`n`n`n`n`n`n`n"
        Write-Host "                   1. Process Scripts`n"
        Write-Host "                   2. Debug/Clean Scripts`n"
        Write-Host "                   3. Debug/Clean Logs"
        Write-Host "`n`n`n`n`n`n`n"
        PrintProgramSeparator
        $choice = Read-Host "Select, Options = 1-3, Exit = X"
        HandleMenuChoice $choice
    } while ($choice -ne 'X' -and $choice -ne '3')
}

function HandleMenuChoice {
    param (
        [string]$choice
    )
    switch ($choice) {
        "1" {
            Write-Host "Processing Scripts..."
            CleanScripts
            Start-Sleep -Seconds 2
        }
        "2" {
            Write-Host "Debugging/Cleaning Scripts..."
            DebugCleanScripts
            Start-Sleep -Seconds 2
        }
        "3" {
            Write-Host "Debugging/Cleaning Logs..."
            DebugCleanLogs
            Start-Sleep -Seconds 2
        }
        "X" {
            Write-Host "Exiting..."
            Start-Sleep -Seconds 2
            exit
        }
        default {
            Write-Host "Invalid option, please try again."
            Start-Sleep -Seconds 2
        }
    }
}

