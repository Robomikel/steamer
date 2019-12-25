Function New-MontiorJob {

$Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument ".\$global:server\Monitor-$global:server.ps1" -WorkingDirectory ".\$global:server"
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
$Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName "$global:server montior" -InputObject $Task
}
