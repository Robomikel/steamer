
Function Get-ChecktaskDisable {
    Get-ScheduledTask -TaskName "$global:server monitor"  >$null 2>&1
 # source:
# http://blogs.msdn.com/b/powershell/archive/2006/09/15/errorlevel-equivalent.aspx
if($?) {
    #write-host "True, last operation succeeded"
    Write-Host '*** disabling scheduled task *****' -ForegroundColor Yellow -BackgroundColor Black
    Disable-ScheduledTask -TaskName "$global:server monitor"
}

if (!$?) {
    #write-host "Not True, last operation failed"
    write-host "Scheduled Task does not exist" -ForegroundColor Yellow -BackgroundColor Black
    
}
    
}

Function Get-ChecktaskEnable {
    Get-ScheduledTask -TaskName "$global:server monitor"  >$null 2>&1
 # source:
# http://blogs.msdn.com/b/powershell/archive/2006/09/15/errorlevel-equivalent.aspx
if($?) {
    #write-host "True, last operation succeeded"
    Write-Host '*** Enabling scheduled task *****' -ForegroundColor Magenta -BackgroundColor Black
    Enable-ScheduledTask -TaskName "$global:server monitor"
}

if (!$?) {
    #write-host "Not True, last operation failed"
    write-host "Scheduled Task does not exist" -ForegroundColor Yellow -BackgroundColor Black
    
}
    
}
Function New-BackupFolder 
    {
        $path = "$global:currentdir\backups" 
    If(Test-Path $path) 
    { 
        Write-Host 'backup folder exists!' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else 
    {  
        Write-Host '*** Creating backup folder *****' -ForegroundColor Blue -BackgroundColor Black
        New-Item -Path "$global:currentdir\" -Name "backups" -ItemType "directory"  
    }
}

Function New-BackupServer {
    $BackupDate = get-date -Format yyyyMMdd
    Write-Host '*** Stopping Server Process *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Stops-*.ps1"
    #Write-Host '*** disabling scheduled task *****' -ForegroundColor Yellow -BackgroundColor Black
    Get-ChecktaskDisable 
    #Disable-ScheduledTask -TaskName "$global:server monitor"
    New-BackupFolder
    Write-Host '*** Server Backup Started *****' -ForegroundColor Yellow -BackgroundColor Black
    Set-Location $global:currentdir\7za920\ 
    ./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\*
    #Compress-Archive -Path $global:currentdir\$global:server\* -DestinationPath ("$global:currentdir\$global:server\Backup-$global:server" + (get-date -Format yyyyMMdd) + '.zip') -CompressionLevel Optimal
    #Compress-Archive -Path $global:currentdir\$global:server\* -DestinationPath $global:currentdir\$global:server\Backup-$global:server.zip
    Get-ChecktaskEnable
    #Enable-ScheduledTask -TaskName "$global:server monitor"
    Set-Location $global:currentdir
    #Set-Steamer
}
#$url = "https://www.7-zip.org/a/7za920.zip"
##$output = "7za920.zip"
#$start_time = Get-Date
Function Get-SevenZip 
    {
        $path = ".\7za920\" 
    If(Test-Path $path) 
    { 
        Write-Host '7Zip already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else 
    {  
        (New-Object Net.WebClient).DownloadFile("https://www.7-zip.org/a/7za920.zip", "7za920.zip")
        #####
        Write-Host '*** Downloading and Extracting 7ZIP *****' -ForegroundColor Blue -BackgroundColor Black  
        #Invoke-WebRequest -Uri $url -OutFile $output
        #Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
        Expand-Archive ".\7za920.zip" ".\7za920\"
    }
}
