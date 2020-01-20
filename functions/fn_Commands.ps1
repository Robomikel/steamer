
Function Select-Steamer {
    param(
    [string]
    [Parameter(Mandatory=$true,Position=0,HelpMessage=" CTL + C and ./steamer ?   ")]
     #[ValidatePattern('^[a-z,A-Z]$')]
    $global:command,
    [string[]]
    [Parameter(Mandatory = $false, Position=1)]
    #[ValidatePattern('^[a-z,A-Z]$')]
    $global:server)
    Set-Console  >$null 2>&1
    If (($global:command -eq "install") -and ($null -eq $global:server)){       
    Write-Host 'Input Server Folder Name make unique to instance [i.e. sdtdserver (No Spaces!)]: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Write-Host 'Input Steam Server App ID: ' -ForegroundColor Cyan -NoNewline 
    $global:AppID = Read-host
    Get-TestInterger
    Write-Host 'Add Argument?, -beta... or leave Blank for none: ' -ForegroundColor Cyan -NoNewline 
    $global:Branch = Read-host
    New-ServerFolder
    Get-Steam
    Set-SteamInfo
    Set-SteamInfoAppID
    New-CreateVariables
    Get-Finished
    }elseif($global:command -eq "install"){
    Get-TestString
    Write-Host 'Input Steam Server App ID: ' -ForegroundColor Cyan -NoNewline 
    $global:AppID = Read-host
    Get-TestInterger
    Write-Host 'Add Argument?, -beta... or leave Blank for none: ' -ForegroundColor Cyan -NoNewline 
    $global:Branch = Read-host
    New-ServerFolder
    Get-Steam
    Set-SteamInfo
    Set-SteamInfoAppID
    New-CreateVariables
    Get-Finished
    }elseif(($global:command -eq "update") -and ($null -eq $global:server)){   
    Write-Host 'Server FolderName for server updates: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    # Get-StopServer
     Get-UpdateServer 
    #Get-ServerBuildCheck
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}
    Get-Finished
    }elseif($global:command -eq "update"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    # Get-StopServer
     Get-UpdateServer
    #Get-ServerBuildCheck
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}
    Get-Finished
    }elseif(($global:command -eq "validate") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for server validate: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    Get-StopServer
    Get-ValidateServer
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}
    Get-Finished
    }elseif($global:command -eq "validate"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    Get-StopServer
    Get-ValidateServer
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}
    Get-Finished
    }elseif(($global:command -eq "start") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for server launch, warning stops running process!: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars    
    Get-CheckServer
    # Get-StopServer
    # Get-UpdateServer
    Get-ServerBuildCheck
    Select-launchServer
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "start"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars   
    Get-CheckServer
    # Get-UpdateServer
    Get-ServerBuildCheck
    Select-launchServer
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}
    Get-ClearVariables
    #Get-ClearVars
    }elseif(($global:command -eq "stop") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for server stop, warning stops running process!: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    Get-StopServer
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "stop"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    Get-StopServer
    Get-ClearVariables
    #Get-ClearVars
    }elseif(($global:command -eq "restart") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for server restart, warning stops running process!: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    Get-StopServer
    # Get-UpdateServer
    Get-ServerBuildCheck
    Get-RestartsServer
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "restart"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    Get-StopServer
    # Get-UpdateServer
    Get-ServerBuildCheck
    Get-RestartsServer
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}  
    Get-ClearVariables
    #Get-ClearVars
    }elseif(($global:command -eq "check") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for server check: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars 
    Get-CheckServer
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "check"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Get-CheckServer
    Get-ClearVariables
    #Get-ClearVars
    }elseif(($global:command -eq "backup") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for server backup: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars 
    Get-SevenZip
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    Get-StopServer
    New-BackupFolder
    New-BackupServer
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}
    Get-Finished
    }elseif($global:command -eq "backup"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Get-SevenZip
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskDisable}
    Get-StopServer
    New-BackupFolder  
    New-BackupServer
    if ($global:DisableChecktask  -eq "1") {Get-ChecktaskEnable}
    Get-Finished  
    }elseif(($global:command -eq "monitor") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for monitor: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Set-MonitorJob
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "monitor"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Set-MonitorJob
    Get-ClearVariables
    #Get-ClearVars
    }elseif(($global:command -eq "AutoRestart") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for AutoRestart: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars 
    Set-RestartJob
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "AutoRestart"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Set-RestartJob
    Get-ClearVariables
    #Get-ClearVars
    }elseif(($global:command -eq "gamedig") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for gamedig: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars 
    Get-NodeJS
    if(( $global:AppID -eq 581330) -or ($global:AppID -eq 376030) -or ($global:AppID -eq 443030)) {  
    Get-GamedigServerQ
    Get-ClearVariables
    #Get-ClearVars
    exit}
    Get-GamedigServer
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "gamedig"){
    Get-NodeJS
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    if(( $global:AppID -eq 581330) -or ($global:AppID -eq 376030) -or ($global:AppID -eq 443030)) {  
    Get-GamedigServerQ
    Get-ClearVariables
    #Get-ClearVars
    exit}
    Get-GamedigServer
    Get-ClearVariables
    #Get-ClearVars
    }elseif(($global:command -eq "gamedigPrivate") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for gamedig: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Get-NodeJS
    if(( $global:AppID -eq 581330) -or ($global:AppID -eq 376030) -or ($global:AppID -eq 443030)) {  
    Get-GamedigServerQPrivate
    Get-ClearVariables
    #Get-ClearVars
    exit}
    Get-GamedigServerPrivate
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "gamedigPrivate"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Get-NodeJS
    if(( $global:AppID -eq 581330) -or ($global:AppID -eq 376030) -or ($global:AppID -eq 443030)) {  
    Get-GamedigServerQPrivate
    Get-ClearVariables
    #Get-ClearVars
    exit}
    Get-GamedigServerPrivate
    Get-ClearVariables
    #Get-ClearVars
    }elseif(($global:command -eq "mcrcon") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for mcrcon: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Get-MCRcon 
    set-connectMCRcon
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "mcrcon"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Get-MCRcon
    set-connectMCRcon
    Get-ClearVariables
    #Get-ClearVars
    }elseif(($global:command -eq "mcrconPrivate") -and ($null -eq $global:server)){
    Write-Host 'Server FolderName for mcrcon: ' -ForegroundColor Cyan -NoNewline
    $global:server = Read-host
    Get-TestString
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Get-MCRcon 
    set-connectMCRconP
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "mcrconPrivate"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    Get-MCRcon
    set-connectMCRconP
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "discord"){
    Get-FolderNames
    Get-createdvaribles
    Get-CheckForVars
    New-DiscordAlert
    Get-ClearVariables
    #Get-ClearVars
    }elseif($global:command -eq "exit"){
    exit
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
    Write-Host "mcrcon"
    Write-Host "mcrconPrivate"
    Write-Host "AutoRestart"
    Write-Host "discord"
    Write-Host "steamer update"}
}
