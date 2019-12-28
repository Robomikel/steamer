
Function Get-NodeJS
    {
        #Set-Console
        $path = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64"
        $patha = "$global:currentdir\node-v$global:nodeversion-win-x64-validate\node-v$global:nodeversion-win-x64"
        $path2 = "node-v$global:nodeversion-win-x64-validate.zip"
        $pathb = "node-v$global:nodeversion-win-x64.zip"  
    If((Test-Path $path) -and (Test-Path $path2) -and (Test-Path $patha) -and (Test-Path $pathb)) 
    { 
        search-nodejs
            if (!$?) {
            #write-host "Not True, last operation failed"
            write-host "nodejs files did not validate" -ForegroundColor Yellow -BackgroundColor Black
            add-nodejs
            }
            Write-Host 'Nodejs already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
            } 
    Else 
    {
        add-nodejs
    }
}
Function search-nodejs {
Compare-Object $path $patha   >$null 2>&1
}
Function add-nodejs {
Write-Host '*** Downloading and Extracting Nodejs *****' -ForegroundColor Yellow -BackgroundColor Black  
    
(New-Object Net.WebClient).DownloadFile("https://nodejs.org/dist/v12.13.1/node-v12.13.1-win-x64.zip", "node-v12.13.1-win-x64.zip")
Copy-Item $global:currentdir\node-v$global:nodeversion-win-x64-validate.zip $global:currentdir\node-v$global:nodeversion-win-x64.zip
Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64-validate.zip" "$global:currentdir\node-v$global:nodeversion-win-x64-validate\" -Force
Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64.zip" "$global:currentdir\node-v$global:nodeversion-win-x64\" -Force
Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
Write-Host '*** Do not stop or cancel! Will need to delete nodejs files and start over! *****' -ForegroundColor Yellow -BackgroundColor Black  
.\npm install gamedig
.\npm install gamedig -g
Set-Location $global:currentdir
}
