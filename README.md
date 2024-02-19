# CleanCode-Ps

### Status
Alpha. The conversion has been done and now it requires...
- Is it actually cleaning the scripts/logs? Is it doing so in compliance with the original scripts.
- Further, Testing and bugfixing.
- remaining work from ScriptClean...
1) identification and processing of variables for `.Mq5` scripts.
2) identification of "while" as main loop in ".Ps1" scripts.

##

### Description
CleanCode-Ps is a utility designed for AI developers to optimize scripts, enhancing readability and efficiency. Supporting Python .py, PowerShell .ps1, Batch .bat, MQL5 .mql5, and now Logs .log, formats; it efficiently trims unnecessary comments and spaces, producing a streamlined script, additionally it now also removes Ansii codes from Logs. The tool retains only essential comments and spaces, typically at the beginning of functions, classes, or sections. CleanCode-Ps ensures reduction in, errors and time consumption, from manually cleaning scripts. The tool prioritizes comments for Imports, Variables, Maps, and Functions. While tailored for AI developers, other programmers. 

### Features
- **Script Identification**: Employs rules to ascertain the script type, supporting `.py`, `.ps1`, `.bat`, and `.mql5`, and now `.log`.
- **Directory Management**: Logically utilizing, "Dirty", "Backup", "Clean", "Reject"; relevantly, cleaned scripts are, backed up and moved, while unsupported files are rejected.
- **Interactive UI**: Showcases a numbered list of detected scripts for effortless selection.
- **Script Streamlining**: Excises specific comments and blank lines based on refined rules.
- **Insightful Statistics**: Offers a detailed breakdown of the cleaning process, highlighting the number of lines and comments modified.
- **Looping Interface**: Enables continuous cleaning operations with options to re-detect, clean anew, or gracefully exit.

### Output
- The Main Menu...
```
=========================( CleanCode-Ps )=========================











                       1. Process Scripts,
                            (3 Found)

                       2. Process Logs.
                            (1 Found)










------------------------------------------------------------------
Select; Options = 1-2, Refresh = R, Exit = X:

```
- Processing scripts (Alpha)..
```
=========================( CleanCode-Ps )=========================

Backing Up Scripts..
Backed Up: 3 Scripts
..Scripts Backed Up.

Cleaning Scripts...

Processing: display.ps1
State: Blanks=6, Comments=4, Lines=70
After: Blanks=6, Comments=4, Lines=70
Total Reduction=0.00%

Bypassing Log: Errors-Crash.Log

Processing: main.ps1
State: Blanks=8, Comments=7, Lines=46
After: Blanks=8, Comments=7, Lines=46
Total Reduction=0.00%

Processing: utility.ps1
State: Blanks=24, Comments=10, Lines=193
After: Blanks=24, Comments=10, Lines=193
Total Reduction=0.00%

...Scripts Cleaned.


```
##

### Usage - Windows
Un-Edited From ScriptClean...
1. Deposit the script files you wish to clean in the `.\Scripts` folder.
2. Double-click `CleanCode-Ps.bat` for easy launching.
3. Adhere to the on-screen prompts to select a file for cleaning.
4. Check folder ".\Cleaned" after processes complete, backups are in ".\Backup".

### Requirements
- Windows Environment - Scripting Host "Enabled" and Batch support.
- PowerShell or PowerShellCore - Compatibility ranges to be calculated.
- .Net - Supposedly either 2/3.5/4/5/6/7/8 will work.

##

### Notes
- This program was converted from the Python version of the program "ScriptClean", "ScriptClean" was the first "Ok" program by Wiseman-Timelord.
- The program had to use .Net, because the `Copy-Item` cmdlet corrupts the color theme, even when "things were done".

##

### DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
