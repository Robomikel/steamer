
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
    }
}
Function Read-AppID     
{
    if($global:AppID -eq 302200){
    Set-Console  >$null 2>&1
    New-LaunchScriptMiscreatedPS
    } elseif($global:AppID -eq 294420){
    Set-Console  >$null 2>&1
    New-LaunchScriptSdtdserverPS
    } elseif($global:AppID -eq 237410){
    Set-Console  >$null 2>&1
    New-LaunchScriptInsserverPS
    } elseif($global:AppID -eq 581330){
    Set-Console  >$null 2>&1
    New-LaunchScriptInssserverPS
    } elseif($global:AppID -eq 233780){
    Set-Console  >$null 2>&1
    New-LaunchScriptArma3serverPS
    } elseif($global:AppID -eq 258550){
    Set-Console  >$null 2>&1
    New-LaunchScriptRustPS
    } elseif($global:AppID -eq 376030){
    Set-Console  >$null 2>&1
    New-LaunchScriptArkPS
    } elseif($global:AppID -eq 462310){
    Set-Console  >$null 2>&1
    New-LaunchScriptdoiserverPS
    } elseif($global:AppID -eq 740){
    Set-Console  >$null 2>&1
    New-LaunchScriptcsgoserverPS
    } elseif($global:AppID -eq 530870){
    Set-Console  >$null 2>&1
    New-LaunchScriptempserverPS
    } elseif($global:AppID -eq 443030){
    Set-Console  >$null 2>&1
    New-LaunchScriptceserverPS
    } elseif($global:AppID -eq 565060){
    Set-Console  >$null 2>&1
    New-LaunchScriptavserverPS
    } elseif($global:AppID -eq 232130){
    Set-Console  >$null 2>&1
    New-LaunchScriptKF2serverPS
    } elseif($global:AppID -eq 222860){
    Set-Console  >$null 2>&1
    New-LaunchScriptLFD2serverPS
    } elseif($global:AppID -eq 454070){
    Set-Console  >$null 2>&1
    New-LaunchScriptboundelserverPS
    } else {
    Write-Host "No Launch Script Found for this server" -ForegroundColor Yellow -BackgroundColor Black
    exit
    }
}