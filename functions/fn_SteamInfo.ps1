Function Test-output
    {
    #    Write-Host "`$global:server value: $global:server"
        Write-Host "You entered Name $global:server"
    #    Write-Host "`$global:AppID value: $global:AppID"
        Write-Host "You entered App ID $global:AppID"
    #    Write-Host "`$global:currentdir value: $global:currentdir"
        Write-Host "Current Directory $global:currentdir"
    }  


Function Set-SteamInfo 
    {
        $title    = 'Install Steam server with Anonymous login'
        $question = 'Use Anonymous Login?'
    
        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    
        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
        if ($decision -eq 1) {
        #fn_InstallServer
        Install-Anonserver
        Write-Host 'Entered Y'
    } else {
        Install-Server
        Write-Host 'Entered N'
    }
}
