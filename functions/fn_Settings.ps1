# .::::::.::::::::::::.,::::::   :::.     .        :  .,:::::: :::::::..   
# ;;;`    `;;;;;;;;'''';;;;''''   ;;`;;    ;;,.    ;;; ;;;;'''' ;;;;``;;;;  
# '[==/[[[[,    [[      [[cccc   ,[[ '[[,  [[[[, ,[[[[, [[cccc   [[[,/[[['  
#   '''    $    $$      $$""""  c$$$cc$$$c $$$$$$$$"$$$ $$""""   $$$$$$c    
#  88b    dP    88,     888oo,__ 888   888,888 Y88" 888o888oo,__ 888b "88bo,
#   "YMmMY"     MMM     """"YUMMMYMM   ""` MMM  M'  "MMM""""YUMMMMMMM   "W" 
Function Set-SteamerSetting {
    #####  Steamer Settings #######
    #   disable backup log open 0
    $global:backuplog = "1"
    #   disable app data backup log open 0
    $global:appdatabackuplog = "1"
    #   disable app data backup 0
    $global:appdatabackup = "1"
    #   disable Admin message 0
    $global:admincheckmessage = "1"
    #   disable Auto update in check 1
    $global:AutoUpdate = "0"
    #   disable  check Task 0
    $global:DisableChecktask = "1"
    # max backups   2
    $global:backupcount = "2"

}





