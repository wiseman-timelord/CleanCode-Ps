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
        Write-Host "`n`n`n`n`n`n`n`n`n`n"
        Write-Host "                       1. Process Scripts,`n"
        Write-Host "                       2. Process Logs."
        Write-Host "`n`n`n`n`n`n`n`n`n`n"
        PrintProgramSeparator
        $choice = Read-Host "Select; Options = 1-2, Refresh = R, Exit = X"

        switch ($choice) {
            "r" {
                Write-Host "Refreshing Display..."
                Start-Sleep -Seconds 2
            }
            "1" {
                Write-Host "Processing Scripts..."
                CleanScriptFiles
                Start-Sleep -Seconds 2
            }
            "2" {
                Write-Host "Processing Logs..."
                CleanLogFiles
                Start-Sleep -Seconds 2
            }
            "x" {
                Write-Host "Exit Initiated..."
                Start-Sleep -Seconds 2
				$exitRequested = $true
                break
            }
            default {
                Write-Host "Invalid option, please try again."
                Start-Sleep -Seconds 2
            }
        }
    } while ($choice -ne 'X' -and $choice -ne '3')
}
