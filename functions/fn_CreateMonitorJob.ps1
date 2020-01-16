
Function New-RestartJob {
    Write-Host "Run Task only when user is logged on"
    Write-Host "Input AutoRestart Time. ie 3am: " -ForegroundColor Cyan -NoNewline
    $restartTime = Read-Host
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "$global:currentdir\steamer.ps1 restart $global:server" -WorkingDirectory "$global:currentdir"
    #$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Hours $restartTime)
    $Trigger = New-ScheduledTaskTrigger -Daily -At $restartTime
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server AutoRestart" -InputObject $Task
}
Function New-RestartJobBG {
    $UserName = "$env:COMPUTERNAME\$env:UserName"
    Write-Host "Run Task Whether user is logged on or not"
    Write-Host "Input AutoRestart Time. ie 3am: " -ForegroundColor Cyan -NoNewline
    $restartTime = Read-Host
    Write-Host "Username: $env:COMPUTERNAME\$env:UserName"
    $SecurePassword = $password = Read-Host "Password:" -AsSecureString
    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
    $Password = $Credentials.GetNetworkCredential().Password  
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "$global:currentdir\steamer.ps1 restart $global:server" -WorkingDirectory "$global:currentdir"
    #$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes $restartTime)
    $Trigger = New-ScheduledTaskTrigger -Daily -At $restartTime
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server AutoRestart" -InputObject $Task -User "$UserName" -Password "$Password"
}
Function New-MontiorJob {
    Write-Host "Run Task only when user is logged on"
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "`"If (!(Get-Process '$global:process')) {$global:currentdir\steamer.ps1 start $global:server ;; $global:currentdir\steamer.ps1 discord $global:server }`"" -WorkingDirectory "$global:currentdir"
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server monitor" -InputObject $Task
}



Function New-MontiorJobBG {  
    $UserName = "$env:COMPUTERNAME\$env:UserName"
    Write-Host "Run Task Whether user is logged on or not"
    Write-Host "Username: $env:COMPUTERNAME\$env:UserName"
    $SecurePassword = $password = Read-Host "Password:" -AsSecureString
    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
    $Password = $Credentials.GetNetworkCredential().Password 
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "`"If (!(Get-Process '$global:process')) {$global:currentdir\steamer.ps1 start $global:server ;; $global:currentdir\steamer.ps1 discord $global:server }`"" -WorkingDirectory "$global:currentdir"
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server monitor" -InputObject $Task -User "$UserName" -Password "$Password"
}

Function Set-MonitorJob {
    $title    = 'Create Monitor Task Job'
    $question = 'Run Task Whether user is logged on or not?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    Get-ChecktaskUnreg
    New-MontiorJobBG
    } else {
    Write-Host 'Entered N'
    Get-ChecktaskUnreg
    New-MontiorJob}
}

Function Set-RestartJob {
    $title    = 'Create Restart Task Job'
    $question = 'Run Task Whether user is logged on or not?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    Get-ChecktaskUnreg
    New-RestartJobBG
    } else {
    Write-Host 'Entered N'
    Get-ChecktaskUnreg
    New-RestartJob}
} 

#Function New-MOTD {
#
#if(( "" -eq $global:RCONPORT) -or ( "" -eq $global:RANDOMPASSWORD)){
#    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
#    Write-Host "$global:DIAMOND $global:DIAMOND Missing Vars ! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
#    Write-Host "Try install command again or adding Rcon vars to Variables-$global:server.ps1" -ForegroundColor Yellow -BackgroundColor Black
#    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
#    }else{
#    set-location $global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32
#    .\mcrcon.exe -c -H $global:IP -P $global:RCONPORT -p $global:RCONPASSWORD "say Test MOTD Message"
#    set-location $global:currentdir
#}

#Function New-MOTDJob {
#    Write-Host "Run Task only when user is logged on"
#    Write-Host "Input MOTD -Minutes: " -ForegroundColor Cyan -NoNewline
#    $restartTime = Read-Host
#    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "`"$global:currentdir\steamer.ps1 New-MOTD `"" -WorkingDirectory "$global:currentdir"
#    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes $restartTime)
#    [X] $Trigger = New-ScheduledTaskTrigger -Daily -At $restartTime 
#    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
#    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
#    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
#    Register-ScheduledTask -TaskName "$global:server monitor" -InputObject $Task
#}