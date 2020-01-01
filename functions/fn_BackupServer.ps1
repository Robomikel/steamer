
Function Get-ChecktaskDisable {
    Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    if ($?) {
    #write-host "True, last operation succeeded"
    Write-Host '*** disabling scheduled task *****' -ForegroundColor Magenta -BackgroundColor Black
    Disable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1}

    if (!$?) {
    #write-host "Not True, last operation failed"
    Write-Host "Scheduled Task does not exist" -ForegroundColor Yellow -BackgroundColor Black}
}

Function Get-ChecktaskEnable {
    Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
if ($?) {
    #write-host "True, last operation succeeded"
    Write-Host '*** Enabling scheduled task *****' -ForegroundColor Magenta -BackgroundColor Black
    Enable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1}
if (!$?) {
    #write-host "Not True, last operation failed"
    write-host "Scheduled Task does not exist" -ForegroundColor Yellow -BackgroundColor Black}
}
Function New-BackupFolder {
        $path = "$global:currentdir\backups" 
    If(Test-Path $path) { 
        Write-Host '***  Backup folder exists! ***' -ForegroundColor Yellow -BackgroundColor Black} 
    Else {  
        Write-Host '*** Creating backup folder *****' -ForegroundColor Magenta -BackgroundColor Black
        New-Item -Path "$global:currentdir\" -Name "backups" -ItemType "directory"}
}

Function New-BackupServer {
    #Set-Console  >$null 2>&1
    $BackupDate = get-date -Format yyyyMMdd
    Get-StopServer
    Get-ChecktaskDisable 
    New-BackupFolder
    Write-Host '*** Server Backup Started! *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\7za920\ 
    #./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\* -an > backup.log
    ./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\* > backup.log
    Get-ChecktaskEnable
    Write-Host '*** Server Backup is Done! *****' -ForegroundColor Yellow -BackgroundColor Black
    .\backup.log
    Set-Location $global:currentdir
    #Set-Steamer
}

Function Get-SevenZip {
        $path = "$global:currentdir\7za920\"
        $patha = "$global:currentdir\7za920\7za.exe"
        $pathb = "$global:currentdir\7za920.zip"
        Write-Host '*** Checking for 7ZIP *****' -ForegroundColor Yellow -BackgroundColor Black   
    If((Test-Path $path) -and (Test-Path $patha) -and (Test-Path $pathb)) { 
            Write-Host '*** 7Zip already downloaded! ****' -ForegroundColor Yellow -BackgroundColor Black}
        else {
            write-host "*** 7Zip not found!  ****" -ForegroundColor Yellow -BackgroundColor Black
            add-sevenzip
    }
    
}


Function add-sevenzip {
    Write-Host '*** Downloading 7ZIP *****' -ForegroundColor Magenta -BackgroundColor Black 
    (New-Object Net.WebClient).DownloadFile("$global:sevenzip", "$global:currentdir\7za920.zip")
    if (!$?) {write-host "*** 7Zip Download Failed ****" -ForegroundColor Yellow -BackgroundColor Black 
    New-Tryagain}
    if ($?) {write-host "*** 7Zip  Download succeeded ****" -ForegroundColor Yellow -BackgroundColor Black}
    Write-Host '***  Extracting 7ZIP *****' -ForegroundColor Magenta -BackgroundColor Black 
    Expand-Archive "$global:currentdir\7za920.zip" "$global:currentdir\7za920\" -Force
    if (!$?) {write-host "*** 7Zip files did not Failed  ****" -ForegroundColor Yellow -BackgroundColor Black
    New-Tryagain}
    if ($?) {write-host "*** 7Zip Extract succeeded ****" -ForegroundColor Yellow -BackgroundColor Black}
}

Function New-Tryagain {
    $title    = 'Try again?'
    $question = 'Download and Extract 7Zip?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
        #Get-SourceMetaMod
        Write-Host 'Entered Y'
        add-sevenzip} 
    else {
        Write-Host 'Entered N'
        exit}
}