
Function Get-UpdateSteamer {
    $start_time = Get-Date
    Write-Host '*** Downloading Steamer github files *****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:steamerurl", "$global:currentdir\steamer.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:steamerurl -OutFile $global:currentdir\steamer.zip
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black 
    Expand-Archive "$global:currentdir\steamer.zip" "$global:currentdir\steamer" -Force

    Copy-Item -Path "$global:currentdir\steamer\steamer-*\*" -Destination "$global:currentdir\" -Recurse -Force
    Write-Host '*** Steamer github files Updated *****' -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '*** Press Enter to Close this session *****' -ForegroundColor Yellow -BackgroundColor Black
    Pause  
    stop-process -Id $PID
}


Function Get-logo {
    Write-Host " 
    _________  __                                           
   /   _____/_/  |_   ____  _____     _____    ____ _______ 
   \_____  \ \   __\_/ __ \ \__  \   /     \ _/ __ \\_  __ \
   /        \ |  |  \  ___/  / __ \_|  Y Y  \\  ___/ |  | \/
  /_______  / |__|   \___  >(____  /|__|_|  / \___  >|__|   
          \/             \/      \/       \/      \/        
"
}