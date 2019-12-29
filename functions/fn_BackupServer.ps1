
Function Get-ChecktaskDisable {
    Get-ScheduledTask -TaskName "$global:server monitor"  >$null 2>&1
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
Function New-BackupFolder {
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
    Set-Console  >$null 2>&1
    $BackupDate = get-date -Format yyyyMMdd
    Get-StopServer
    Get-ChecktaskDisable 
    New-BackupFolder
    Write-Host '*** Server Backup Started *****' -ForegroundColor Yellow -BackgroundColor Black
    Set-Location $global:currentdir\7za920\ 
    #./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\* -an > backup.log
    ./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\* > backup.log
    Get-ChecktaskEnable
    Write-Host '*** Server Backup is Done *****' -ForegroundColor Yellow -BackgroundColor Black
    .\backup.log
    Set-Location $global:currentdir
    #Set-Steamer
}

Function Get-SevenZip {
        $path = "$global:currentdir\7za920\"
        $patha = "$global:currentdir\7za920-validate"
        $path2 = "$global:currentdir\7za920-validate.zip"
        $pathb = "$global:currentdir\7za920.zip"  
    If((Test-Path $path) -and (Test-Path $path2) -and (Test-Path $patha) -and (Test-Path $pathb)) 
    { 
        search-sevenzip
        if (!$?) {
            write-host "7Zip files did not validate" -ForegroundColor Yellow -BackgroundColor Black
            add-sevenzip
            }
        Write-Host '7Zip already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else 
    {  
        add-sevenzip
    }
}
Function search-sevenzip {
    Compare-Object $path $patha   >$null 2>&1
    }
Function add-sevenzip {
    (New-Object Net.WebClient).DownloadFile("$global:sevenzip", "$global:currentdir\7za920.zip")
    Copy-Item $global:currentdir\7za920.zip $global:currentdir\7za920-validate.zip -Force
    Write-Host '*** Downloading and Extracting 7ZIP *****' -ForegroundColor Blue -BackgroundColor Black  
    Expand-Archive "$global:currentdir\7za920-validate.zip" "$global:currentdir\7za920-validate" -Force
    Expand-Archive "$global:currentdir\7za920.zip" "$global:currentdir\7za920\" -Force
}    
#################
