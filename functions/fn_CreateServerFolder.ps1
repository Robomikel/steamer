#$global:currentdir = Get-Location
Function New-ServerFolder 
    {   
        ##-- Create Folder for Server -- In current folder
        if((!$global:server) -or ($global:server -eq " ")){
            Write-Host "You Entered a null or Empty" -ForegroundColor Red -BackgroundColor Black
            Select-Steamer
       }elseif (($global:AppID -eq "") -or ($global:AppID -eq " ")){
            Write-Host "You Entered a space or Empty" -ForegroundColor Red -BackgroundColor Black
            Select-Steamer
        }elseif(Test-Path ".\$global:server\" ){
            Write-Host 'Server Folder Already Created!' -ForegroundColor Yellow -BackgroundColor Black
        }else{
            New-Item -Path . -Name "$global:server" -ItemType "directory"
        }
    }
