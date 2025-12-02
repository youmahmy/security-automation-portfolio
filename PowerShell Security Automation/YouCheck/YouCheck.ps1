
function global:prompt {"`nYouCheck➔ "}

#Initial config
$BaselineFile = "$PSScriptRoot\baseline.txt"

# Create a baseline file in the users directory if one is missing
Clear-Host
Write-Output "ℹ Checking for baseline file..."
Start-Sleep -Milliseconds 500
if (!(Test-Path $BaselineFile)) {
    Write-Warning "⚠ Unable to locate baseline file. Creating..."
    New-Item $BaselineFile -ItemType File | Out-Null
    Start-Sleep -s 1
    Write-Host "ℹ Baseline file saved as $BaselineFile"
    Start-Sleep -s 3
}

#Hash function
function Get-DirectoryHash {
    param($Path)

    # Get hash of all file contents and names
    $files = Get-ChildItem -Path $Path -Recurse -File | Sort-Object FullName
    $hashInput = ""

    foreach ($f in $files) {
        $hashInput += $f.FullName
        $hashInput += (Get-FileHash $f.FullName -Algorithm SHA256).Hash
    }

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($hashInput)
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    return ($sha256.ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""
}

#MONITOR FUNCTION
function monitor {
    param($Path)

    if (!(Test-Path $Path)) {
        ""
        Write-Warning "⚠ Directory does not exist."
        return
    }

    $hash = Get-DirectoryHash $Path
    $timestamp = Get-Date

    # Entry number = line count + 1
    $num = (Get-Content $BaselineFile).Count + 1

    "$num|$Path|$hash|$timestamp" | Out-File $BaselineFile -Append

    Write-Host "`nℹ Directory added as entry #$num"
    Start-Sleep -s 1.5
    main
}

    
#CHECK FUNCTION
function check {
    param($EntryNumber)

    $lines = Get-Content $BaselineFile
    $entry = $lines | Where-Object { $_.StartsWith("$EntryNumber|") }

    if (!$entry) {
        ""
        Write-Warning "⚠ Entry number $EntryNumber not found."
        return
    }

    # Split stored data
    $parts = $entry -split "\|"
    $storedPath = $parts[1]
    $storedHash = $parts[2]
    $baselineTime = [datetime]$parts[3]

    Write-Host "`nℹ Checking: $storedPath..."
    Start-Sleep -s 1
    #Write-Host "Baseline created:  $baselineTime"

    if (!(Test-Path $storedPath)) {
        Write-Warning "> Directory missing! Integrity FAIL."
        return
    }

    $actualHash = Get-DirectoryHash $storedPath


    #INTEGRITY PASSES:
    if ($actualHash -eq $storedHash) {
        Write-Host "`n✓ Integrity PASS — No changes detected." -ForegroundColor Green
    }

    #INTEGRITY FAILS:
    else {
        " "
        Write-Warning "⚠ Integrity FAIL — Directory has been modified."
        $modifiedFiles = Get-ChildItem $storedPath -Recurse -File | Where-Object { $_.LastWriteTime -gt $baselineTime }
        if ($modifiedFiles) {
            Write-Host "`nFiles modified since baseline ($baselineTime)`n" -ForegroundColor Gray
            foreach ($file in $modifiedFiles) {
                #Write-Host "$($file.FullName) — Modified: $($file.LastWriteTime)"
                Write-Host "• $($file) — Modified: $($file.LastWriteTime)"
            }
        }
    }

}

#UNMONITOR FUNCTION
function unmonitor {
    param($EntryNumber)
        
    

    $lines = Get-Content $BaselineFile
    $entry = $lines | Where-Object { $_.StartsWith("$EntryNumber|") }

    if (!$entry) {
        ""
        Write-Warning "⚠ Entry number $EntryNumber not found."
        return
    }

    # split stored data
    $parts = $entry -split "\|"
    $storedPath = $parts[1]

    
    ""
    Write-Warning "⚠ You Are about to stop monitoring $storedPath. This cannot be undone."

    $Confirm = Read-Host -Prompt "`nType 'confirm' to proceed, or any key to go back"

    if ($Confirm -eq "confirm"){

        # Remove selected entry
        $newLines = $lines | Where-Object { ($_ -split "\|")[0] -ne $EntryNumber }

        #Renumber the lines after deletion
        $renumbered = 1
        $finalLines = $newLines | ForEach-Object {
            $p = $_ -split "\|"
            "$renumbered|$($p[1])|$($p[2])|$($p[3])"
            $renumbered++
        }


        $finalLines | Out-File $BaselineFile -Force

        Write-Host "`nℹ Directory entry #$EntryNumber has been unmonitored."
        Start-sleep -s 1.5
        main
    }
    
}




function help() {
    Write-Host "

Currently monitoring - shows the directories currently being monitored. Separated by entry number, directory name, hash value, time created.

    
'check'     -  Checks directory 1's integrity and lists the files within it that were changed (e.g 'check 1'). You can find the directory number on the far left-hand side of the main menu section.
            
'monitor'   -  Adds the directory to the baseline file to be checked against (e.g 'monitor C:\MyFolder').

'unmonitor' -  Removes the directory from the baseline file to be checked against (e.g 'unmonitor C:\MyFolder').

'main'      -  Go back to the main menu.

" -ForegroundColor Gray
}


function main() {
    Clear-Host
    Write-Host "
--------
YouCheck
--------
V1.0 - Created by Youcef Mahmoudi
" -ForegroundColor Cyan
    
    if(!(Get-Content $BaselineFile)) {
        Write-Host "Not monitoring any directories."
    }
    else{
        Write-Host "____________________"
        Write-Host "Currently monitoring`n"
        
     

        foreach ($_ in (Get-Content $BaselineFile)){
            Write-Host $_
        }
    }

" "
" "
Write-Host "Type 'help' for options" -ForegroundColor Gray

}

main