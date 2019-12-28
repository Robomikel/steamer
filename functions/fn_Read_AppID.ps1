
Function Set-SteamInfoAppID 
    {
        $title    = 'Launch Script create'
        $question = 'Create Launch Script?'
    
        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    
        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
        if ($decision -eq 0) {
        Read-AppID
        Write-Host 'Entered Y'
    } else {
        Write-Host 'Entered N'
        #Select-Steamer
    }
}
Function Read-AppID     
    {
        if($global:AppID -eq 302200){
            Set-Console
        New-LaunchScriptMiscreatedPS
        } elseif($global:AppID -eq 294420){
        $global:game="7d2d"
        Set-Console
        New-LaunchScriptSdtdserverPS
        } elseif($global:AppID -eq 237410){
        $global:game="insurgency"
        Set-Console
        New-LaunchScriptInsserverPS
        } elseif($global:AppID -eq 581330){
        $global:game="insurgencysandstorm"
        Set-Console
        New-LaunchScriptInssserverPS
        } elseif($global:AppID -eq 233780){
        $global:game="arma3"
        Set-Console
        New-LaunchScriptArma3serverPS
        } elseif($global:AppID -eq 258550){
        $global:game="rust"
        Set-Console
        New-LaunchScriptRustPS
        #} elseif($null -eq $global:AppID){
        ##Write-Host "you entered Null or blank"
        #} elseif($global:AppID -eq ""){
        #    Write-Host "space?"
        } else {
        Write-Host "No Launch Script Found for this server"
        exit
    }
}