
Function Set-SteamInfo 
    {
        $title    = 'Install Steam server with Anonymous login'
        $question = 'Use Anonymous Login?'
    
        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    
        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
        if ($decision -eq 1) {
        Install-Anonserver
        Write-Host 'Entered Y'
    } else {
        Install-Server
        Write-Host 'Entered N'
    }
}
