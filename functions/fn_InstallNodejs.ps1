
Function Get-NodeJS
    {
        #Set-Console
        $path = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64"
        $patha = "$global:currentdir\node-v$global:nodeversion-win-x64-validate\node-v$global:nodeversion-win-x64"
        $path2 = "node-v$global:nodeversion-win-x64-validate.zip"
        $pathb = "node-v$global:nodeversion-win-x64.zip"
        write-host "Checking for Nodejs" -ForegroundColor Magenta -BackgroundColor Black     
    If((Test-Path $path) -and (Test-Path $path2) -and (Test-Path $patha) -and (Test-Path $pathb)) 
    { 
        search-nodejs
            if (!$?) {
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
Write-Host '*** Downloading  Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black  
(New-Object Net.WebClient).DownloadFile("$global:nodejsurl", "$global:currentdir\node-v$global:nodeversion-win-x64-validate.zip")
Write-Host '*** Copying Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black
Copy-Item $global:currentdir\node-v$global:nodeversion-win-x64-validate.zip $global:currentdir\node-v$global:nodeversion-win-x64.zip
Write-Host '***  Extracting Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black
Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64-validate.zip" "$global:currentdir\node-v$global:nodeversion-win-x64-validate\" -Force
Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64.zip" "$global:currentdir\node-v$global:nodeversion-win-x64\" -Force
Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
Write-Host '*** Installing gamedig in Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black
Write-Host '*** Do not stop or cancel! Will need to delete nodejs files and start over! *****' -ForegroundColor Yellow -BackgroundColor Black  
.\npm install gamedig
.\npm install gamedig -g
Set-Location $global:currentdir
}
