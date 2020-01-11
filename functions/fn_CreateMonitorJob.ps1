Function New-MontiorJob {
Write-Host "Run Task only when user is logged on"
$Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-windowstyle hidden -file $global:currentdir\$global:server\Monitor-$global:server.ps1" -WorkingDirectory "$global:currentdir\$global:server"
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
    
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "$global:currentdir\$global:server\Monitor-$global:server.ps1" -WorkingDirectory "$global:currentdir\$global:server"
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server monitor" -InputObject $Task -User "$UserName" -Password "$Password"
    }

Function Set-MonitorJob
    {
        $title    = 'Create Monitor Task Job'
        $question = 'Run Task Whether user is logged on or not?'
    
        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    
        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
        if ($decision -eq 0) {
        Write-Host 'Entered Y'
        New-MontiorJobBG
    } else {
        Write-Host 'Entered N'
        New-MontiorJob
    }
}    