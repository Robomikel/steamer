$global:nodeversion="12.13.1"
Function Get-NodeJS
    {
        $path = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64" 
    If(Test-Path $path) 
    { 
        Write-Host 'Nodejs already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else 
    {
    Write-Host '*** Downloading and Extracting Nodejs *****' -ForegroundColor Yellow -BackgroundColor Black  
    (New-Object Net.WebClient).DownloadFile("https://nodejs.org/dist/v$global:nodeversion/node-v$global:nodeversion-win-x64.zip", "node-v$global:nodeversion-win-x64.zip")
    Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64.zip" "$global:currentdir\node-v$global:nodeversion-win-x64\"
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\npm install gamedig
    .\npm install gamedig -g
    Set-Location $global:currentdir
    }
}