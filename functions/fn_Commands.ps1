
function Select-Steamer
    {
         param(
            [string]
             [Parameter(Mandatory=$true,Position=0,HelpMessage=" CTL + C and ./steamer ?   ")]
             $global:command,
             [string[]]
             [Parameter(Mandatory = $false, Position=1)]
             $global:server)
             #[string[]]
             #[Parameter(Position=1, ValueFromRemainingArguments)]
             #$Remaining)
            Set-Console  >$null 2>&1
            If (($global:command -eq "install") -and ($null -eq $global:server)){
                Write-Host "                
                                  _________  __                                           
                                 /   _____/_/  |_   ____  _____     _____    ____ _______ 
                                 \_____  \ \   __\_/ __ \ \__  \   /     \ _/ __ \\_  __ \
                                 /        \ |  |  \  ___/  / __ \_|  Y Y  \\  ___/ |  | \/
                                /_______  / |__|   \___  >(____  /|__|_|  / \___  >|__|   
                                        \/             \/      \/       \/      \/        
                "
                #Write-Host ".|||--##############################################--|||." -ForegroundColor Magenta -BackgroundColor Black
                #Write-Host ".|||--WELCOME TO STEAMER THE WINDOWS STEAM SERVER INSTALLER--|||." -ForegroundColor Magenta -BackgroundColor Black
                #Write-Host ".|||--##############################################--|||." -ForegroundColor Magenta -BackgroundColor Black
                $global:server = Read-host -Prompt 'Input Server Folder Name make unique to instance [i.e. sdtdserver (No Spaces!)]'
                $global:AppID = Read-host -Prompt 'Input Steam Server App ID'
                $global:Branch = Read-host -Prompt 'Add Argument?, -beta... or leave Blank for none'
                New-ServerFolder
                Get-Steam
                #Test-output 
                Set-SteamInfo
                Set-SteamInfoAppID
                New-CreateVariables
                Set-CreateMonitorScript
                New-DiscordScript
                #Select-Steamer
            }elseif($global:command -eq "install"){
                Write-Host " 
                                  _________  __                                           
                                 /   _____/_/  |_   ____  _____     _____    ____ _______ 
                                 \_____  \ \   __\_/ __ \ \__  \   /     \ _/ __ \\_  __ \
                                 /        \ |  |  \  ___/  / __ \_|  Y Y  \\  ___/ |  | \/
                                /_______  / |__|   \___  >(____  /|__|_|  / \___  >|__|   
                                        \/             \/      \/       \/      \/        
                "
                $global:AppID = Read-host -Prompt 'Input Steam Server App ID'
                $global:Branch = Read-host -Prompt 'Add Argument?, -beta... or leave Blank for none'
                New-ServerFolder
                Get-Steam
                #Test-output 
                Set-SteamInfo
                Set-SteamInfoAppID
                New-CreateVariables
                Set-CreateMonitorScript
                New-DiscordScript
            }elseif(($global:command -eq "update") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server updates'
                Get-createdvaribles
                Get-UpdateServer
            }elseif($global:command -eq "update"){
                Get-createdvaribles
                Get-UpdateServer
            }elseif(($global:command -eq "validate") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server validate'
                Get-createdvaribles
                Get-ValidateServer
            }elseif($global:command -eq "validate"){
                Get-createdvaribles
                Get-ValidateServer
            }elseif(($global:command -eq "start") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server launch, warning stops running process!'
                Select-launchServer
                Get-ChecktaskEnable
            }elseif($global:command -eq "start"){
                Select-launchServer
                Get-ChecktaskEnable
            }elseif(($global:command -eq "stop") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server stop, warning stops running process!'
                Get-createdvaribles
                Get-StopServer
            }elseif($global:command -eq "stop"){
                Get-createdvaribles
                Get-StopServer
            }elseif(($global:command -eq "restart") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server restart, warning stops running process!'
                Get-createdvaribles
                Get-RestartsServer
            }elseif($global:command -eq "restart"){
                Get-createdvaribles
                Get-RestartsServer   
            }elseif(($global:command -eq "check") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server check'
                Get-createdvaribles
                Get-CheckServer
            }elseif($global:command -eq "check"){
                Get-createdvaribles
                Get-CheckServer
            }elseif(($global:command -eq "backup") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for server backup'
                Get-SevenZip
                Get-createdvaribles
                New-BackupServer
            }elseif($global:command -eq "backup"){
                Get-SevenZip
                Get-createdvaribles
                New-BackupServer  
            }elseif(($global:command -eq "monitor") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for monitor'
                Set-MonitorJob
            }elseif($global:command -eq "monitor"){
                Set-MonitorJob
            }elseif(($global:command -eq "gamedig") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for gamedig'
                Get-NodeJS
                Get-createdvaribles
                if( $global:AppID -eq 581330) {  
                    Get-GamedigServerQ
                    exit
                    }
                Get-GamedigServer
                #Select-Steamer
            }elseif($global:command -eq "gamedig"){
                Get-NodeJS
                Get-createdvaribles
                if( $global:AppID -eq 581330) {  
                    Get-GamedigServerQ
                    exit
                    }
                Get-GamedigServer
                #Select-Steamer
            }elseif(($global:command -eq "gamedigPrivate") -and ($null -eq $global:server)){
                $global:server = Read-host -Prompt 'Server FolderName for gamedig'
                Get-NodeJS
                Get-createdvaribles
                if( $global:AppID -eq 581330) {  
                    Get-GamedigServerQPrivate
                    exit
                    }
                Get-GamedigServerPrivate
                #Select-Steamer
            }elseif($global:command -eq "gamedigPrivate"){
                Get-NodeJS
                Get-createdvaribles
                if( $global:AppID -eq 581330) {  
                    Get-GamedigServerQPrivate
                    exit
                    }
                Get-GamedigServerPrivate
                #Select-Steamer
            }elseif($global:command -eq "exit"){
                exit
            }elseif($global:command -eq "x"){
            }elseif(($global:command -eq "steamer") -and ($global:server -eq "update")){
                Get-UpdateSteamer
            } else {
                Write-Host "Format:  ./steamer <Command> <serverFolderName>" -ForegroundColor Yellow -BackgroundColor Black
                Write-Host "IE:      ./steamer install  insserver" -ForegroundColor Yellow -BackgroundColor Black
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
                Write-Host "gamedig"
                Write-Host "gamedigPrivate"
                Write-Host "monitor"
                Write-Host "steamer update"
                #Select-Steamer
        }
    }
