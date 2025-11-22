<#
.SYNOPSIS
YouScan - A PowerShell script for keyword scanning inside .docx files.

.DESCRIPTION
This script provides a menu-driven interface to scan .docx files in a specified directory
for keywords, either provided via the console or loaded from a text file.
It ensures proper cleanup of the Microsoft Word COM object to prevent resource leaks.
#>

# --- Global Variables ---
$global:ResultPath = $null

# --- Helper Functions for COM Object Management ---

function New-WordApplication {
    # Creates and returns a new Microsoft Word Application object.
    try {
        $word = New-Object -ComObject Word.Application
        $word.Visible = $false # Run Word silently in the background
        return $word
    } catch {
        Write-Host -ForegroundColor Red "[!] Error: Could not create Word COM object. Is Microsoft Word installed?"
        exit 1
    }
}

function Cleanup-WordApplication($word) {
    # Quits the Word application and releases the COM object reference.
    if ($word -ne $null) {
        try {
            # Close any remaining documents first (just in case)
            $word.Documents | ForEach-Object { $_.Close($false) } # $false means don't save changes
            $word.Quit($false)
            
            # Explicitly release the COM object to prevent memory leaks
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
        } catch {
            Write-Host -ForegroundColor Red "[!] Warning: Could not properly quit or clean up Word application."
        }
    }
}


# --- UI Functions ---

function start_screen {

    Write-Host " "
    Write-Host -Foreground Cyan "
 __       __           _____                     
 \ \     / /          / ____|                    
  \ \/\_/ ___ _    _| (___  ___ __ _ _ __ 
   \  / _ \| | | |\___ \ / __/ _` | '_ \
    | | (_) | |_| |____) | (_| (_| | | | |
    |_|\___/ \__,_|_____/ \___\__,_|_| |_|
                                             
"

    $save_choice = Read-host -Prompt 'Press 1 to use an existing result file path, or 2 to create a new save file'

    if($save_choice -eq "1"){
        $save_file_path = Read-Host -Prompt 'Enter the FULL path to the results file (e.g., C:\Logs\results.txt)'
        
        if (Test-Path -Path $save_file_path -PathType Leaf) {
            $global:ResultPath = $save_file_path
            Write-Host -ForegroundColor Green "[-] Using existing file: $global:ResultPath"
        } else {
            Write-Host -ForegroundColor Red '[!] File not found or path is invalid.'
            start_screen
        }
    }
    elseif($save_choice -eq "2"){
        $save_directory = Read-Host -Prompt 'Enter the directory path where the new save file should be created (e.g., C:\NewFolder)'
        
        if (Test-Path -Path $save_directory -PathType Container) {
            $new_file = Join-Path -Path $save_directory -ChildPath "Scan_Results.txt"
            
            # Create the file (or overwrite if it exists)
            $null = New-Item -Path $new_file -ItemType File -Force
            $global:ResultPath = $new_file
            Write-Host -ForegroundColor Green "[-] Created new file: $global:ResultPath"
        } else {
            Write-Host -ForegroundColor Red '[!] Directory path is invalid. Cannot create file.'
            start_screen
        }
    }
    else {
        Write-Host -ForegroundColor Red '[!] Invalid input'
        start_screen
    }

    Write-Host -ForegroundColor Yellow "[!] Warning! Running the scan will first clear the contents of '$($global:ResultPath)'."

    $conf_input = Read-host -Prompt 'Are you sure you want to continue? (y/n) '
    if ($conf_input -eq 'y' -or $conf_input -eq 'yes') {
        Clear-Content $global:ResultPath

        "[-] Scan results below [-]`r`n[-] Thank you for using YouScan [-]`r`n" | Out-File $global:ResultPath -Append

        Start-sleep -s 1
        menu
    } elseif ($conf_input -eq 'n' -or $conf_input -eq 'no') {
        Write-Host -ForegroundColor Yellow '[*] Shutting down...'
        Start-sleep -s 1
        exit
    } else {
        Write-Host -ForegroundColor Red '[!] Invalid input'
        start_screen
    }
}

function menu() {
    Write-Output " "
    Write-Host -Background Black "[-] Please choose from the options below [-]"
    $choice = Read-host -Prompt "
[1] Scan files using input in shell
[2] Scan files using keyword text file
[3] Help
"

    if ($choice -eq '1') {
        input_script
    } elseif ($choice -eq '2') {
        keyword_file_script
    } elseif ($choice -eq '3') {
        Write-Output " "
        Write-Host -Background Black "[-] Help [-]"
        Write-Host "
Press '1' to enter keywords directly in the console.
Press '2' to provide a path to a text file containing keywords (one per line).
Type '-exit' to quit the program at any menu or prompt.
"
        Start-sleep -s 3
        menu
    } elseif ($choice -eq '-exit' -or $choice -eq '-quit') {
        Write-Host -Foreground Yellow "[*] Shutting down..."
        Start-sleep -s 1
        exit
    } else {
        Write-Host -Foreground Red '[!] Invalid input'
        menu
    }
}

function input_script { # user input script

    $FilePath = Read-Host -Prompt 'Enter the path containing the files to be scanned (e.g., C:\Docs)'
    $TestPath = Test-Path -Path $FilePath -PathType Container

    if ($FilePath -eq '-menu') {
        Write-Host -ForegroundColor Yellow '[*] Redirecting...'
        Start-Sleep -s 1
        return menu
    }

    if (-not $TestPath) {
        Write-Host -ForegroundColor Red '[!] Invalid path or path is not a directory.'
        return input_script
    }

    Write-Host -ForegroundColor Green '[-] Path exists!'

    $number_of_terms = $null
    while ($true) {
        $input = Read-host -Prompt 'How many terms do you want to scan for?'
        if ($input -match '^\d+$') {
            $number_of_terms = [int]$input
            break
        }
        Write-Host -ForegroundColor Red '[!] Invalid input. Please enter a number.'
    }

    $word = New-WordApplication # Initialize Word COM Object
    try {
        for ($i = 1; $i -le $number_of_terms; $i++) {
            $term_user_input = Read-Host -Prompt "Input term $i of $number_of_terms to search for: "
            
            Write-Host -ForegroundColor Yellow "Scanning for term: '$term_user_input'..."

            $docs = Get-ChildItem -Path $FilePath -Filter "*.docx" | Where-Object { -not $_.PSIsContainer }

            foreach ($doc in $docs) {
                try {
                    $doc_instance = $word.Documents.Open($doc.FullName, $false, $true) # Path, ConfirmConversions, ReadOnly
                    
                    # Word Find operation is case-sensitive by default. Use .Execute($FindText)
                    if ($doc_instance.Content.Find.Execute($term_user_input)) {
                        "$($doc.Name) contains the term '$term_user_input'" | Out-File $global:ResultPath -Append
                    } else {
                        "$($doc.Name) does not contain the term '$term_user_input'" | Out-File $global:ResultPath -Append
                    }
                    
                    $doc_instance.Close($false) # Close without saving
                } catch {
                    Write-Host -ForegroundColor Red "[!] Error processing $($doc.Name) for term '$term_user_input': $($_.Exception.Message)"
                    "$($doc.Name) failed to scan for term '$term_user_input' (Error: $($_.Exception.Message))" | Out-File $global:ResultPath -Append
                }
            }
        }
    } finally {
        Cleanup-WordApplication $word # Ensure Word is closed and COM object is released
    }

    Write-scan-complete-message
}

function keyword_file_script { # keyword file script

    $KeywordPath = Read-Host -Prompt 'Enter the FULL path to the text file containing the keywords (one per line): '
    
    if ($KeywordPath -eq '-menu') {
        Write-Host -ForegroundColor Yellow '[*] Redirecting...'
        Start-Sleep -s 1
        return menu
    }

    if (-not (Test-Path -Path $KeywordPath -PathType Leaf)) {
        Write-Host -ForegroundColor Red '[!] Invalid path or file not found.'
        return keyword_file_script
    }
    Write-Host -ForegroundColor Green '[-] Keyword file path exists!'

    $FilePath = Read-Host -Prompt 'Enter the path containing the .docx files to be scanned (e.g., C:\Docs): '
    
    if ($FilePath -eq '-menu') {
        Write-Host -ForegroundColor Yellow '[*] Redirecting...'
        Start-Sleep -s 1
        return menu
    }
    
    if (-not (Test-Path -Path $FilePath -PathType Container)) {
        Write-Host -ForegroundColor Red '[!] Invalid scan directory path.'
        return keyword_file_script
    }
    Write-Host -ForegroundColor Green '[-] Scan directory path exists!'

    $word = New-WordApplication # Initialize Word COM Object
    try {
        $keywords = Get-Content $KeywordPath | Where-Object { $_ -match '\S' } # Get non-empty lines
        
        foreach ($term in $keywords) {
            Write-Host -ForegroundColor Yellow "Scanning for term: '$term'..."

            $docs = Get-ChildItem -Path $FilePath -Filter "*.docx" | Where-Object { -not $_.PSIsContainer }

            foreach ($doc in $docs) {
                try {
                    $doc_instance = $word.Documents.Open($doc.FullName, $false, $true) # Path, ConfirmConversions, ReadOnly
                    
                    if ($doc_instance.Content.Find.Execute($term)) {
                        "$($doc.Name) contains the term '$term'" | Out-File $global:ResultPath -Append
                    } else {
                        "$($doc.Name) does not contain the term '$term'" | Out-File $global:ResultPath -Append
                    }
                    
                    $doc_instance.Close($false) # Close without saving
                } catch {
                    Write-Host -ForegroundColor Red "[!] Error processing $($doc.Name) for term '$term': $($_.Exception.Message)"
                    "$($doc.Name) failed to scan for term '$term' (Error: $($_.Exception.Message))" | Out-File $global:ResultPath -Append
                }
            }
        }
    } finally {
        Cleanup-WordApplication $word # Ensure Word is closed and COM object is released
    }

    Write-scan-complete-message
}

function Write-scan-complete-message {
    Write-Host " "
    Write-Host -ForegroundColor Green "[-] Scan complete. Results saved in $global:ResultPath"
    Write-Host "[-] Type '-exit' to shutdown console or '-menu' to go back to the main menu."
    $end_choice = Read-Host -Prompt " "

    if ($end_choice -eq '-exit' -or $end_choice -eq '-quit') {
        Write-Host -ForegroundColor Yellow "[*] Shutting down..."
        Start-sleep -s 1
        exit
    }
    elseif ($end_choice -eq '-menu') {
        Write-Host -ForegroundColor Yellow "[*] Redirecting..."
        Start-sleep -s 1
        menu
    }
    else {
        Write-Host -ForegroundColor Red '[!] Invalid input'
        menu
    }
}

# --- Execution Start ---
start_screen