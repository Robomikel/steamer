Function New-BackupServer {
    $BackupDate = get-date -Format yyyyMMdd
    Write-Host '*** Stopping Server Process *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Stops-*.ps1"
    Write-Host '*** Server Backup Started *****' -ForegroundColor Yellow -BackgroundColor Black
    Set-Location $global:currentdir\7za920\ 
    ./7za a $global:currentdir\$global:server\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\*
    #Compress-Archive -Path $global:currentdir\$global:server\* -DestinationPath ("$global:currentdir\$global:server\Backup-$global:server" + (get-date -Format yyyyMMdd) + '.zip') -CompressionLevel Optimal
    #Compress-Archive -Path $global:currentdir\$global:server\* -DestinationPath $global:currentdir\$global:server\Backup-$global:server.zip
    Set-Location $global:currentdir
    #Set-Steamer
}
$url = "https://www.7-zip.org/a/7za920.zip"
$output = "7za920.zip"
$start_time = Get-Date
Function Get-SevenZip 
    {
        $path = ".\7za920\" 
    If(Test-Path $path) 
    { 
        Write-Host '7Zip already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else 
    {  
        #(New-Object Net.WebClient).DownloadFile("https://www.7-zip.org/a/7za920.zip", "7za920.zip")
        #####
        Write-Host '*** Downloading and Extracting 7ZIP *****' -ForegroundColor Blue -BackgroundColor Black  
        Invoke-WebRequest -Uri $url -OutFile $output
        Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
        Expand-Archive ".\7za920.zip" ".\7za920\"
    }
}