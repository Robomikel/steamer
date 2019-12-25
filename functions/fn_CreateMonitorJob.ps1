Function New-MontiorJob {

$Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "$global:currentdir\$global:server\Monitor-$global:server.ps1" -WorkingDirectory "$global:currentdir\$global:server"
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
$Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName "$global:server monitor" -InputObject $Task
}



Function New-MontiorJobBG {
    
    $UserName = Read-Host "Enter Username for Windows user to create task to run in background"
    $SecurePassword = $password = Read-Host "Enter Password for Windows user to create task to run in background" -AsSecureString
    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
    $Password = $Credentials.GetNetworkCredential().Password 
    
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "$global:currentdir\$global:server\Monitor-$global:server.ps1" -WorkingDirectory "$global:currentdir\$global:server"
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Register-ScheduledTask -TaskName "$global:server montior" -InputObject $Task -User "$UserName" -Password "$Password"
    }

Function Set-MonitorJob
    {
        $title    = 'Create Monitor job'
        $question = 'Create monitor job to run in background?'
    
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
        #Select-Steamer
    }
}    