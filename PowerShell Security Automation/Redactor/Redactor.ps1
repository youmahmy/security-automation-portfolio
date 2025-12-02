function mainmenu() {

    Clear-Host
    title_screen

    Write-Host "
 Select from the menu:
   
     1) Redact files
     2) Recover redacted files
     3) Help & About

    99) Exit Redactor

"
    Write-Host " " -NoNewline
    Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
    Write-Host " > " -NoNewLine
 
    $option = $Host.UI.ReadLine()

    if ($option -eq "1") {
        redact
        }

    elseif ($option -eq "2") {
        recover
        }

    elseif ($option -eq "3" -or $option -eq "?" -or $option -eq "help" -or $option -eq "about") {
        redactorhelp
        }

    elseif ($option -eq "99" -or $option -eq "exit" -or $option -eq "quit") {
        Clear-Host
        " "
        Write-Host " Are you sure you want to exit? [Y|N] > " -NoNewLine
        $ExitChoice = $Host.UI.ReadLine()
        if ($ExitChoice -eq "y") {
            " "
            Write-Host " (*)" -ForegroundColor DarkCyan -NoNewLine
            Write-Host " Shutting down..."
            Start-Sleep -s 1
            exit
            }

        else {
            mainmenu
            }
    }
       
    else {
        " "
        Write-Host " (X) Invalid input" -ForegroundColor Red
        Start-Sleep -s 2
        mainmenu
        }

}

function redact() {


    Clear-Host
    title_screen

    #Define Variables - These words get replaced in the log files
    $global:IPregex = "\d{1,3}(\.\d{1,3}){3}"
    $global:Domain = "domain.net"
    $global:ServerPrefix1 = "III-SSS"
    $global:ServerPrefix2 = "I-S2"
    $global:ServerPrefix3 = "I-S3"
    $global:ServerPrefix4 = "I-S4"
    $global:ServerPrefix5 = "I-S5"
    $global:ServerPrefix6 = "S-S6"
    $global:ServerPrefix7 = "N7"
    $global:ServerPrefix8 = "P8"
    $global:ServerPostfix1 = "A1"
    $global:ServerPostfix2 = "B2"
    $global:ServerPostfix3 = "O3"
    $global:ServerPostfix4 = "O4"
    $global:ServerPostfix5 = "S5"
    $global:ServerPostfix6 = "V6"
    $global:ServerPostfix7 = "W7"
    $global:ServerPostfix8 = "W8"
    $global:WorkstationPrefix1 = "S01"
    $global:WorkstationPrefix2 = "S12"
    $global:WorkstationHost1 = "T1"
    $global:WorkstationHost2 = "P2"
    $global:Keyword = "keying"
    $global:SSHKeyA = "KeyA"

    " "
    Write-Host " Enter the directory of log files to redact. Whenever prompted for input, enter " -ForegroundColor Cyan -NoNewLine
    Write-Host "99"  -NoNewLine
    Write-Host " to exit" -ForegroundColor Cyan -NoNewLine
    " "
    " "
    Write-Host " " -NoNewLine
    Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
    Write-Host " redact " -NoNewLine -BackgroundColor Magenta
    Write-Host " > " -NoNewLine
    $FilePath = $Host.UI.ReadLine()

    if ($FilePath -eq "99") {
        mainmenu
        }

    elseif ($FilePath -eq "" -or $FilePath -eq "/" -or $FilePath -eq "\") {

        " "
        Write-Host " (X)" -ForegroundColor Red -NoNewLine
        Write-Host " Invalid input"
        Start-Sleep -Seconds 2
        redact  
        }

    elseif ($FilePath -notmatch '\\$') {
        $FilePath = $FilePath +'\'
        }


    if ($FilePath -match '\\$' -and (Test-Path -Path $FilePath)) {
        " "
        Write-Host " PATH => $FilePath"
        Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
        Write-Host " Path exists"
       

        try {

            $NewDir = (Get-Item $FilePath).Parent.FullName

            Get-ChildItem $NewDir -Include *84732647364.txt -Recurse | Remove-Item

            }
        catch{
       
            $NewDir = (Get-Item $FilePath).Parent.FullName
           
            }


        $FileSize = "{0:N2} Gb" -f ((gci -force $FilePath -Recurse -ErrorAction SilentlyContinue | measure Length -s).Sum / 1Gb)
       
        Write-Host " (!)" -ForegroundColor Yellow -NoNewline
        Write-Host " The files in the directory provided are" -NoNewline
        Write-Host " $FileSize" -NoNewLine -ForegroundColor Cyan
        Write-Host "." -NoNewLine

        Write-Host " Depending on the file sizes and PC memory, this may take a while. Continue? [Y|N]"
        " "
        Write-Host " " -NoNewLine
        Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
        Write-Host " redact " -NoNewLine -BackgroundColor Magenta
        Write-Host " (" -NoNewLine
        Write-Host "$FilePath" -ForegroundColor Red -NoNewline
        Write-Host ") > " -NoNewLine
       
        $ContinueConfirm = $Host.UI.ReadLine()
       
       
        if ($ContinueConfirm -eq "y" -or $ContinueConfirm -eq "yes") {}

        elseif ($ContinueConfirm -eq "n" -or $ContinueConfirm -eq "no") {
            redact
            }
        elseif ($ContinueConfirm -eq "99") {
            mainmenu
            }
        else {
            Write-Host " (X) Invalid input" -ForegroundColor Red
            redact
            }

        " "
        Write-Host " (*)" -ForegroundColor Blue -NoNewLine
        Write-Host " Creating necessary files..."

        $TempFile = New-Item -Path $NewDir -Name "84732647364.txt"
        Write-Output " " | Out-File $TempFile -Append
        Write-Output " " | Out-File $TempFile -Append
        Write-Output " Detailed Redaction Info: " | Out-File $TempFile -Append

        #Define Variable - Creates an array of all files in the folder
        $FileList = Get-ChildItem -Path $FilePath -Recurse

        $FileList | ForEach-Object {
       
            $Content = (Get-Content -Path $_.FullName -ReadCount 1000) `
            #$file = New-Item -Path $BackupPath -Name "$_._backup.txt"
            $IP_Amount = ($Content | Select-String -Pattern $IPregex -AllMatches).Matches.Value.Count
            $Host_Amount = ($Content | Select-String -Pattern $ServerPrefix1, $ServerPrefix2, $ServerPrefix3, $ServerPrefix4, $ServerPrefix5, $ServerPrefix6, $ServerPrefix7, $ServerPrefix8, $WorkstationPrefix1, $WorkstationPrefix2, $WorkstationHost1, $WorkstationHost2 -AllMatches).Matches.Value.Count
            $Domain_Amount = ($Content | Select-String -Pattern $Domain, $Keyword -AllMatches).Matches.Value.Count


            #Write-Output " " | Out-File $TempFile -Append
            Write-Output " ________________________________________________________________" | Out-File $TempFile -Append
            Write-Output " Redacted $IP_Amount IP addresses, $Host_Amount hostnames and $Domain_Amount domainnames from: "(Get-Item -Path $_.FullName) | Out-File $TempFile -Append
            }

       
        Write-Host " (!) " -ForegroundColor Yellow -NonewLine
        Write-Host "Create backup of log files? [Y|N]"
        " "
        Write-Host " " -NoNewLine
        Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
        Write-Host " redact " -NoNewLine -BackgroundColor Magenta
        Write-Host " (" -NoNewLine
        Write-Host "$FilePath" -ForegroundColor Red -NoNewline
        Write-Host ") > " -NoNewLine
        $BackupChoice = $Host.UI.ReadLine()
           
        if ($BackupChoice -eq "y") {
            " "
            $BackupPath = Read-Host -Prompt " Enter path to store backup files >"
            " "
            if ($BackupPath -eq $FilePath) {
                " "
                Write-Host " (X) Backup path cannot be the same as log file path" -ForegroundColor Red
                start-sleep -s 2
                redact
                }

            if ($BackupPath -eq "99") {
                mainmenu
            }

            elseif ($BackupPath -eq "" -or $BackupPath -eq "/" -or $BackupPath -eq "\") {

                " "
                Write-Host " (X)" -ForegroundColor Red -NoNewLine
                Write-Host " Invalid input"
                Start-Sleep -Seconds 2
                redact  
                }

            elseif ($BackupPath -notmatch '\\$') {
                $BackupPath = $BackupPath +'\'
                }

            if ($BackupPath -match '\\$' -and (Test-Path -Path $BackupPath)) {

                Write-Host " (*) Writing backup information to files..." -ForegroundColor Yellow

                try {

                    $NewDir = (Get-Item $BackupPath).Parent.FullName

                    Get-ChildItem $NewDir -Include *327638483346.txt -Recurse | Remove-Item

                    }

                catch{}

                $TempFile2 = New-Item -Path $NewDir -Name "327638483346.txt" -Value $BackupPath | Out-Null

                try {
               
                    $FileList = Get-Childitem -Path $FilePath -Recurse

                    $FileList | ForEach-Object {

                        $Content = (Get-Content -Path $_.FullName) `
                        $file = New-Item -Path $BackupPath -Name "$_._backup.txt" -ErrorAction Stop;
                        $ip_data = ($Content | Select-String -Pattern $IPregex -AllMatches).Matches.Value | Out-File $file -Append
                        $host_data = ($Content | Select-String -Pattern $ServerPrefix1, $ServerPrefix2, $ServerPrefix3, $ServerPrefix4, $ServerPrefix5, $ServerPrefix6, $ServerPrefix7, $ServerPrefix8, $WorkstationPrefix1, $WorkstationPrefix2 -AllMatches).Matches.Value | Out-File $file -Append
                        $domain_data = ($Content | Select-String -Pattern $Domain, $Keyword -AllMatches).Matches.Value | Out-File $file -Append
                        }
                }

                catch {
                    " "
                    Write-Host " (X)" $Error[0] -ForegroundColor Red
                    Start-Sleep -s 2
                    redact
                    }
                   

            }

            elseif ($BackupPath -eq "99") {
                mainmenu
                }

            else {
                " "
                Write-Host " (X) Invalid path" -Foreground Red
                start-sleep -s 2
                redact
                }
        }
        elseif ($BackupChoice -eq "n") {}

        elseif ($BackupChoice -eq "99") {
            mainmenu
            }

        else{
            " "
            Write-Host " (X) Invalid input" -ForegroundColor Red
            Start-Sleep -s 2
            redact
            }

    " "
    Write-Host " (*)" -ForegroundColor Blue -NoNewLine
    Write-Host " Redaction started. This may take a while..."

    #Define Variable - Creates an array of all files in the folder
    $FileList = Get-Childitem -Path $FilePath -Recurse
    Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
    Write-Host " Childitems successfully obtained"

    Write-Host " (*)" -ForegroundColor Blue -NoNewLine
    Write-Host " Redacting information..."

    #Processes each file in the filelist, searching for the words listed in above variables and replaces them
    $FileList | ForEach-Object {
        (Get-Content -Path $_.FullName) `
            -replace "$IPregex",'{REMOVED_IPADDRESS}' -replace "$Domain",'{REMOVED_DOMAINNAME}' -replace "$ServerPrefix1",'{REMOVED_HOSTNAME}' -replace "$ServerPrefix2",'{REMOVED_HOSTNAME}' -replace "$ServerPrefix3",'{REMOVED_HOSTNAME}' -replace "$ServerPrefix4",'{REMOVED_HOSTNAME}' -replace "$ServerPrefix5",'{REMOVED_HOSTNAME}' -replace "$ServerPrefix6",'{REMOVED_HOSTNAME}' -replace "$ServerPrefix7",'{REMOVED_HOSTNAME}' -replace "$ServerPrefix8",'{REMOVED_HOSTNAME}' -replace "$ServerPostfix1",'***' -replace "$ServerPostfix2",'***' -replace "$ServerPostfix3",'***' -replace "$ServerPostfix4",'***' -replace "$ServerPostfix5",'***' -replace "$ServerPostfix6",'***' -replace "$ServerPostfix7",'***' -replace "$ServerPostfix8",'***' -replace "$WorkstationPrefix1",'{REMOVED_HOSTNAME}' -replace "$WorkstationPrefix2",'{REMOVED_HOSTNAME}' -replace "$WorkstationHost1",'***' -replace "$WorkstationHost2",'***' -replace "$Keyword",'{REMOVED_KEYWORD}' -replace "$SSHKeyA",'A' | Set-Content -path $_.FullName
    }
    Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
    Write-Host " Content redaction was OK"
    Write-Host " (*)" -ForegroundColor Blue -NoNewLine
    Write-Host " Getting final redaction information..."
 
    $ip_count = ($FileList | Select-String -Pattern "REMOVED_IPADDRESS").length
    $host_count = ($FileList | Select-String -Pattern "REMOVED_HOSTNAME").length
    $domain_count = ($FileList | Select-String -Pattern "REMOVED_DOMAINNAME").length

    Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
    Write-Host " Final redaction information obtained"
    Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
    Write-Host " Redaction complete"
    " "
    Write-Host " (!)" -ForegroundColor Yellow -NoNewline
    Write-Host " Save redaction results to text file? [Y|N]"
    " "
    Write-Host " " -NoNewLine
    Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
    Write-Host " redact " -NoNewLine -BackgroundColor Magenta
    Write-Host " (" -NoNewLine
    Write-Host "$FilePath" -ForegroundColor Red -NoNewline
    Write-Host ") > " -NoNewLine
    $SaveChoice = $Host.UI.ReadLine()
    " "
    if ($SaveChoice -eq "y") {
       
        $SavePath = Read-Host -Prompt " Enter path to save results to, or type 'custom' to write to an existing file >"
       
       
        if ($SavePath -match '\\$' -and (Test-Path -Path $SavePath)) {
            " "
            Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
            Write-Host " Path exists"

            $SaveName = Read-Host -Prompt " Type a name to save file as, or 'enter' to continue >"
            " "
            if ($SaveName -eq "") {

                $SaveFile = New-Item -Path $SavePath -Name "Redaction_Results.txt" #create new file with default name
               
                Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
                Write-Host " Redaction summary was saved to $SaveFile"
            }

        else {

            $SaveFile = New-Item -Path $SavePath -Name $SaveName #create new file with custom name
           
            Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
            Write-Host " Redaction summary was saved to $SaveFile"
            }
        }

   

        if ($SavePath -eq "custom") {

            $SaveFile = Read-Host -Prompt " Enter the path of the existing file you wish to save at >"
       
            if ((Test-Path $SaveFile) -and $SaveFile.Contains(".")) {
                " "
                Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
                Write-Host " Path exists"
               
                Clear-Content $SaveFile -Force
                Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
                Write-Host " Redaction summary was saved to $SaveFile"
            }

            else {
                " "
                Write-Host " (X) Invalid input." -ForegroundColor Red
                }
                 
               
        }

    }


    elseif ($SaveChoice -eq "n") {}
       
    else {
        " "
        Write-Host " (X) Invalid input" -ForegroundColor Red
        Start-Sleep -s 2

        }



    try {
        Write-Output "
 v21.10.1 - Youcef Mahmoudi

 █▀█ █▀▀ █▀▄ ▄▀█ █▀▀ ▀█▀ █▀█ █▀█
 █▀▄ ██▄ █▄▀ █▀█ █▄▄ ░█░ █▄█ █▀▄
 _______________________________

 Redaction Results
 ___________________________
" | Out-File $SaveFile -Append

        Write-Output " ["(Get-Date)"]" | Out-File $SaveFile -Append -NoNewline
        Write-Output "`n" | Out-File $SaveFile -Append

        }
       
    catch{}

    " "

    if ($ip_count -eq 0) {

        try {
            Write-Output " (-) Redacted no IP addresses" | Out-File $SaveFile -Append

            }
        catch{}

        Write-Host " (-)" -ForegroundColor Red -NoNewLine
        Write-Host " Redacted no hostnames"
    }

    else {

        try {
            Write-Output " (+) Redacted $ip_count IP addresses" | Out-File $SaveFile -Append

            }
        catch{}

        Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
        Write-Host " Redacted $ip_count IP address(es)"
    }

    if ($host_count -eq 0) {

        try {
            Write-Output " (-) Redacted no hostnames" | Out-File $SaveFile -Append

            }
        catch{}

        Write-Host " (-)" -ForegroundColor Red -NoNewLine
        Write-Host " Redacted no hostnames"
    }
       
    else {

        try {
            Write-Output " (+) Redacted $host_count hostname(s)" | Out-File $SaveFile -Append

            }
        catch{}

       Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
       Write-Host " Redacted $host_count hostname(s)"
    }
       

    if ($domain_count -eq 0) {

        try {
            Write-Output " (-) Redacted no domainnames" | Out-File $SaveFile -Append

            }
        catch{}

        Write-Host " (-)" -ForegroundColor Red -NoNewLine
        Write-Host " Redacted no domainnames"
    }


    else {

        try {
            Write-Output " (+) Redacted $domain_count domainnames" | Out-File $SaveFile -Append

            }
        catch{}

        Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
        Write-Host " Redacted $domain_count domainname(s)"
    }

    $file_data = Get-Content $TempFile

    try {
        $file_data | Out-File $SaveFile -Append
        }
    catch{}
    " "
    Write-Host " (!)" -Foreground Yellow -NoNewLine
    Write-Host " View detailed redaction info? [Y|N]"
    " "
    Write-Host " " -NoNewLine
    Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
    Write-Host " redact " -NoNewLine -BackgroundColor Magenta
    Write-Host " (" -NoNewLine
    Write-Host "$FilePath" -ForegroundColor Red -NoNewline
    Write-Host ") > " -NoNewLine
    $ViewMore = $Host.UI.ReadLine()

    if ($ViewMore -eq "y") {
       
        $file_data
        " "
        Write-Host " " -NoNewLine
        Write-Host "  rdtr " -NoNewLine -BackgroundColor DarkCyan
        Write-Host " redact" -NoNewLine
        Write-Host " > " -NoNewLine
        $ViewMoreOption = $Host.UI.ReadLine()

        if ($ViewMoreOption -eq "99") {
            mainmenu
            }

    }

    elseif ($ViewMore -eq "n") {
       
        if ($Host.Name -eq "Windows PowerShell ISE Host") {
            " "
            Write-Host " (*)" -NoNewLine -ForegroundColor DarkCyan
            Write-Host " Redirecting to the main menu in 5 seconds..." -NoNewline
            Start-sleep -s 5
            mainmenu
            }
       

        else {
       
            " "
            Write-Host " (*)" -NoNewLine -ForegroundColor DarkCyan
            Write-Host " Enter any key to go back to the main menu..."
            $counter = 0
            while (!$Host.UI.RawUI.KeyAvailable -and ($counter++ -lt 10)) {
                Start-Sleep -s 1
                }

            $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
            mainmenu
            }

        }
       
    }

    else {
        " "
        Write-Host " (X)" -ForegroundColor Red -NoNewLine
        Write-Host " Invalid input"
        Start-Sleep -Seconds 2
        redact  
        }
       
}


   

function recover() {
   
    Clear-host
    title_screen
   
    $ErrorActionPreference = "silentlycontinue"

    " "
    Write-Host " Enter the directory of log files to recover. Whenever prompted for input, enter " -ForegroundColor Cyan -NoNewLine
    Write-Host "99"  -NoNewLine
    Write-Host " to exit" -ForegroundColor Cyan -NoNewLine
    " "
    " "
    Write-Host " " -NoNewLine
    Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
    Write-Host " recover " -NoNewLine -BackgroundColor DarkGreen
    Write-Host " > " -NoNewLine
    $Redacted_FilePath = $Host.UI.ReadLine()

    if ($Redacted_FilePath -eq "99") {
        mainmenu
        }

    elseif ($Redacted_FilePath -eq "" -or $Redacted_FilePath -eq "/" -or $Redacted_FilePath -eq "\") {

        " "
        Write-Host " (X)" -ForegroundColor Red -NoNewLine
        Write-Host " Invalid input"
        Start-Sleep -Seconds 2
        recover  
        }

    elseif ($Redacted_FilePath -notmatch '\\$') {
        $Redacted_FilePath = $Redacted_FilePath +'\'
        }


    if ($Redacted_FilePath -match '\\$' -and (Test-Path -Path $Redacted_FilePath)) {
        " "
        Write-Host " PATH => $Redacted_FilePath"
        Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
        Write-Host " Path exists"
        }

    else {
        " "
        Write-Host " (X)" -ForegroundColor Red -NoNewLine
        Write-Host " Invalid input"
        Start-Sleep -Seconds 6
        recover
        }

    " "
    $files = Get-ChildItem -Path $Redacted_FilePath -Name

    foreach ($file in $files) {
        Write-Host "", $file
        }
    " "
    Write-Host " Enter the file you wish to recover" -ForegroundColor Cyan
    " "
    Write-Host " " -NoNewLine
    Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
    Write-Host " recover " -NoNewLine -BackgroundColor DarkGreen
    Write-Host " (" -NoNewLine
    Write-Host "$Redacted_FilePath" -ForegroundColor Red -NoNewline
    Write-Host ") > " -NoNewLine
    $File_to_recover = $Host.UI.ReadLine()

    $File_to_recover = $Redacted_FilePath + $File_to_recover

    if (Test-Path -Path $File_to_recover) {

        $Redacted_File_Path_Leaf = Split-Path $File_to_recover -leaf
        " "
        Write-Host " File to be recovered: '$File_to_recover'"

        $BackupData = Get-ChildItem $NewDir -Include *327638483346.txt -Recurse

        $NewBackupPath = Get-Content $BackupData

        if ($NewBackupPath -eq $null) {
            " "
            Write-Host " (X) Unable to locate backup for file path entered" -ForegroundColor Red
            Start-Sleep -s 4
            recover
            }

        else {
           
            Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
            Write-Host " Possible backup path found: $NewBackupPath" -NoNewline
            #$BackupFileList = Get-ChildItem -Path $NewBackupPath

            $BackupFileList = Get-ChildItem -Path $NewBackupPath -Recurse -Filter "$Redacted_File_Path_Leaf._backup.txt"
            Write-Host "`n" -NoNewLine
            Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
            Write-Host " Possible backup file found: $BackupFileList"
            " "
            Write-Host " Restoration may take a while. Continue with restoration using " -NoNewLine -ForegroundColor Cyan
            Write-Host $BackupFileList -NoNewLine
            Write-Host " ? [Y|N]" -ForegroundColor Cyan -NoNewLine
            " "
            " "
            Write-Host " " -NoNewLine
            Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
            Write-Host " recover " -NoNewLine -BackgroundColor DarkGreen
            Write-Host " (" -NoNewLine
            Write-Host "$Redacted_FilePath" -ForegroundColor Red -NoNewline
            Write-Host ") > " -NoNewLine
            $confirm = $Host.UI.ReadLine()

            if ($confirm -eq "y" -or $confirm -eq "yes") {

                $BackupContent = Get-Content "$NewBackupPath$BackupFileList"


                #IP RESTORATION

                Write-Host " (*)" -NoNewLine -ForegroundColor DarkCyan
                Write-Host " Restoring all IP addresses..."

                foreach ($line in $BackupContent) {
           
                    if ($BackupContent -match $IPregex) {

                        if ($line -match $regex) {

                            $RedactedContent = (Get-Content -Path $File_to_recover) -join "`n" `
                                ([regex]"{REMOVED_IPADDRESS}").Replace($RedactedContent, $line, 1) | Out-File $File_to_recover
                        }
                    }

                }
       

                #DOMAINNAME RESTORATION

                Write-Host " (*)" -NoNewLine -ForegroundColor DarkCyan
                Write-Host " Restoring all domainnames..."

                foreach ($line in $BackupContent -match $Domain) {

                    if ($line -match $regex) {

                        $RedactedContent = (Get-Content -Path $File_to_recover) -join "`n" `
                            ([regex]"{REMOVED_DOMAINNAME}").Replace($RedactedContent, $line, 1) | Out-File $File_to_recover
                    }
                }


                #HOSTNAME RESTORATION

                Write-Host " (*)" -NoNewLine -ForegroundColor DarkCyan
                Write-Host " Restoring all hostnames..."


                foreach ($line in $BackupContent -match $WorkstationPrefix1) {

                    if ($line -match $regex) {

                        $RedactedContent = (Get-Content -Path $File_to_recover) -join "`n"  `
                            ([regex]"{REMOVED_HOSTNAME}").Replace($RedactedContent, $line, 1) | Out-File $File_to_recover
                    }
                }
           

                #($BackupContent) -replace "$WorkstationPrefix1","" |  Set-Content -NoNewLine -Path $NewBackupPath$BackupFileList
                #($BackupContent) -replace "$Domain","" |  Set-Content -NoNewLine -Path $NewBackupPath$BackupFileList

                #Get-Content $Redacted_File
                " "
                Write-Host " (+)" -ForegroundColor Cyan -NoNewLine
                Write-Host " Restoration complete"
                Write-Host " (*)" -NoNewLine -ForegroundColor DarkCyan
                Write-Host " Redirecting to main menu in 10 seconds..."
                Start-Sleep -s 10
                mainmenu
             
            }

        elseif ($confirm -eq "99") {
            mainmenu
            }

        else {
            recover
            }

        }
    }
}
       

       
function redactorhelp() {

    Clear-Host

    Write-Host "

 Main Menu - Core Commands
 =========================

 Command Description
 ------- -----------
 1    Redaction process
 2    Redaction recovery process
 3/help/? Help Menu (this menu)
 99/exit End program



 Option 1 - Redact files
 =======================

 You should be greeted with a screen that asks you to enter the file directory of the log files you wish to redact.
 To do this, go to the directory location and right click the top portion to copy the address as text. After that, paste
 the copied address into the program like this:
 "

 Write-Host " C:\Users\youcef\Documents" -ForegroundColor Cyan

 "
 The program will then tell you the size of the files you wish to redact. This number is important because it determines
 how long the program will take and how much memory will be used up when it is redacting the information. Enter 'y' or 'n'
 corresponding to your choice.

 The program will then create the necessary files. If you wish to backup the log files, you can do so after the previous
 step is completed. Pressing y will prompt you for a file path to store the backup files. You can follow the same steps
 previously and copy the directory in the same layout.

 The program will then start the redaction process in a coherent fashion, starting with all IP addresses, then all hostnames
 and subsequently all domain names, alongside any other sensitive piece of information.

 Finally, you can choose to save a summary of the redaction results to a text file for maintenance purposes with the provided
 prompt, as well as view detailed data of the redaction.



 Option 2 - Recover redacted files
 =================================

 After entering the second option, you will be presented with the recovery function of the script. In a similar fashion to the
 redaction function, copy the address of the directory location of the file like this:
 "

 Write-Host " C:\Users\youcef\Documents\Redacted_Directory" -ForegroundColor Cyan

 "

 If a backup has been created, the program will alert the user that a possible backup path and file was found. The contents of
 this backup file will coagulate with the redacted file such that the original data is seamlessly resided.
 "

 Write-Host " The user must have previously opted in to ‘backup log files’ when asked for this step to work properly. Otherwise, no automatic recovery is possible." -ForegroundColor Cyan
 " "
 " "


    Write-Host " Enter " -ForegroundColor Cyan -NoNewLine
    Write-Host "99"  -NoNewLine
    Write-Host " to exit" -ForegroundColor Cyan -NoNewLine
    " "
    " "
    Write-Host " " -NoNewLine
    Write-Host " rdtr " -NoNewLine -BackgroundColor DarkCyan
    Write-Host " help " -NoNewLine -BackgroundColor Red
    Write-Host " > " -NoNewLine
    $help_option = $Host.UI.ReadLine()

    if ($help_option -eq "99" -or $help_option -eq "exit" -or $help_option -eq "quit") {
        mainmenu
        }

    else {
        " "
        Write-Host " (X) Invalid input" -ForegroundColor Red
        Start-Sleep -s 2
        help
        }

}