
function Select-Steamer
    {
         param(
            [string]
             [Parameter(Mandatory=$true,Position=0)]
             $global:command,
             [string[]]
             [Parameter(Mandatory = $false, Position=1)]
             $global:server)
             #[string[]]
             #[Parameter(Position=1, ValueFromRemainingArguments)]
             #$Remaining)
            Set-Console
            If (($global:command -eq "install") -and ($null -eq $global:server)){
                Write-Host ".|||--##############################################--|||." -ForegroundColor Magenta -BackgroundColor Black
                Write-Host ".|||--WELCOME TO STEAMER THE WINDOWS STEAM SERVER INSTALLER--|||." -ForegroundColor Magenta -BackgroundColor Black
                Write-Host ".|||--##############################################--|||." -ForegroundColor Magenta -BackgroundColor Black
                $global:server = Read-host -Prompt 'Input Server Folder Name make unique to instance [i.e. sdtdserver (No Spaces!)]'
                $global:AppID = Read-host -Prompt 'Input Steam Server App ID'
                $global:Branch = Read-host -Prompt 'Add Argument?, -beta... or leave Blank for none'
                New-ServerFolder
                Get-Steam
                #Test-output 
                Set-SteamInfo
                #::::: Create Launch Script per AppID Version 4 update :::::::::::::
                Set-SteamInfoAppID
                #New-UpdateScript
                New-ValidateScriptPS
                New-StopsScript
                New-ServerStatusScript
                New-GameDigScript
                New-GameDigFullScript
                Set-CreateMonitorScript
                New-DiscordScript
                Select-Steamer
            }elseif($global:command -eq "install"){
                Write-Host ".|||--##############################################--|||." -ForegroundColor Magenta -BackgroundColor Black
                Write-Host ".|||--WELCOME TO STEAMER THE WINDOWS STEAM SERVER INSTALLER--|||." -ForegroundColor Magenta -BackgroundColor Black
                Write-Host ".|||--##############################################--|||." -ForegroundColor Magenta -BackgroundColor Black
                $global:AppID = Read-host -Prompt 'Input Steam Server App ID'
                $global:Branch = Read-host -Prompt 'Add Argument?, -beta... or leave Blank for none'
                New-ServerFolder
                Get-Steam
                #Test-output 
                Set-SteamInfo
                #::::: Create Launch Script per AppID Version 4 update :::::::::::::
                Set-SteamInfoAppID
                #New-UpdateScript
                New-ValidateScriptPS
                New-StopsScript
                New-ServerStatusScript
                New-GameDigScript
                New-GameDigFullScript
                Set-CreateMonitorScript
                New-DiscordScript
                Select-Steamer
            }elseif(($global:command -eq "update") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server updates'
                Select-UpdateServer
            }elseif($global:command -eq "update"){
                Select-UpdateServer
            }elseif(($global:command -eq "validate") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server validate'
                Select-ValidateServer
            }elseif($global:command -eq "validate"){
                Select-ValidateServer
            }elseif(($global:command -eq "start") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server launch, warning stops running process!'
                Select-launchServer
            }elseif($global:command -eq "start"){
                Select-launchServer
            }elseif(($global:command -eq "stop") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server stop, warning stops running process!'
                Select-StopsServer
            }elseif($global:command -eq "stop"){
                Select-StopsServer
            }elseif(($global:command -eq "restart") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server restart, warning stops running process!'
                Select-RestartsServer
            }elseif($global:command -eq "restart"){
                Select-RestartsServer
            }elseif(($global:command -eq "check") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server check'
                Select-CheckServer
            }elseif($global:command -eq "check"){
                Select-CheckServer
            }elseif(($global:command -eq "backup") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server backup'
                Get-SevenZip
                New-BackupServer
            }elseif($global:command -eq "backup"){
                Get-SevenZip
                New-BackupServer  
            }elseif(($global:command -eq "details") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for details'
                Get-NodeJS
                Select-GameDigServer
            }elseif($global:command -eq "details"){
                Get-NodeJS
                Select-GameDigServer
            }elseif(($global:command -eq "gamedig") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for gamedig'
                Get-NodeJS
                Select-GameDigFullServer
            }elseif($global:command -eq "gamedig"){
                Get-NodeJS
                Select-GameDigFullServer
            }elseif($global:command -eq "exit"){
                exit
            }elseif($global:command -eq "x"){
            }elseif(($global:command -eq "steamer") -and ($global:server -eq "update")){
                Get-UpdateSteamer
                # $global:server = Read-host -Prompt 'Server FolderName for gamedig'
                 #Get-NodeJS
                 #Select-GameDigFullServer

            } else {
                Write-Host "Command not found! Available Commands" -ForegroundColor Red -BackgroundColor Black
                Write-Host "install"
                Write-Host "update"
                Write-Host "validate"
                Write-Host "start"
                Write-Host "stop"
                Write-Host "restart"
                Write-Host "check"
                Write-Host "backup"
                Write-Host "exit"
                Write-Host "details"
                Write-Host "gamedig"
                Write-Host "steamer update"
                Select-Steamer
        }
    }
