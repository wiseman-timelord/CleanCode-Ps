# CleanCode-Ps

### Status
Beta. The conversion has been done and now it requires...
- Testing
- Improvement
<br> remaining work from CleanCode-Ps...
1) identification and processing of variables for `.Mq5` scripts.
2) identification of "while" as main loop in ".Ps1" scripts.

##

### Description
CleanCode-Ps is a utility designed for AI developers to optimize scripts, enhancing readability and efficiency. Supporting Python .py, PowerShell .ps1, Batch .bat, and MQL5 .mql5 formats, it efficiently trims unnecessary comments and spaces, producing a streamlined script. Its user-friendly interface, highlighted with colored text and ASCII art, guarantees a smooth experience. The tool retains only essential comments and spaces, typically at the beginning of functions, classes, or sections. CleanCode-Ps ensures reduction in, errors and time consumption, from manually cleaning scripts. The tool prioritizes comments for Imports, Variables, Maps, and Functions. While tailored for AI developers, other programmers. 

### Features
- **Script Identification**: Employs rules to ascertain the script type, supporting `.py`, `.ps1`, `.bat`, and `.mql5`, and now `.log`.
- **Directory Management**: Logically utilizing, "Dirty", "Backup", "Clean"; cleaned scripts are, backed up and moved, relevantly.
- **Interactive UI**: Showcases a numbered list of detected scripts for effortless selection.
- **Script Streamlining**: Excises specific comments and blank lines based on refined rules.
- **Insightful Statistics**: Offers a detailed breakdown of the cleaning process, highlighting the number of lines and comments modified.
- **Looping Interface**: Enables continuous cleaning operations with options to re-detect, clean anew, or gracefully exit.

### Output
- To be done
```
To be done..
```
##

### Usage - Windows
Un-Edited From ScriptClean...
1. Deposit the script files you wish to clean in the `.\Scripts` folder.
2. Double-click `CleanCode-Ps.bat` for easy launching.
3. Adhere to the on-screen prompts to select a file for cleaning.
4. Check folder ".\Cleaned" after processes complete, backups are in ".\Backup".

### Requirements
- Windows Environment with Scripting Host Enabled.
- PowerShell or PowerShellCore, compatibility ranges to be calculated.

### Notes
- To be Detailed

##

### DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
