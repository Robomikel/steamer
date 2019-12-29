# Steamer
PowerShell Steam Server Scripter


Install Any location:
Download, Extract, and Open PowerShell and Change Directory to steamer.ps1

Run: 
open PowerShell as user NOT Admin
Steamer accepts 1 or 2 parameters. first param specifies steamer command and the second is server folder name. if server folder name does not exist it creates it.   ```.\steamer.ps1 install insserver```

```>_./steamer <command> <serverFolder>```
          
Install steam server ```>_./steamer install misserver```
 - Creates Server Folder Named misserver and starts install
 - Downloads and extract steamcmd
 - Asks and uses Steaminfo.db App ID -
 - uses anon or steam login for install         
 - Creates Launch Script - per App ID, if exists.
 - Creates custom default config for server- if available by steamer 
   * Miscreated Server (302200) - "misserver" (optional server folder name) 
   * 7 Days to Die server (294420) - "sdtdserver" (optional server folder name)  
   * Insurgency Server (237410) - "insserver" (optional server folder name) 
   * Insurgency: Sandstorm Server (581330) - "inssserver" (optional server folder name) 
   * Rust server (258550) - "rustserver" (optional server folder name) 
   * Arma3 Server (233780)- “arma3server" (optional server folder name)         
 - Creates Launch, Monitor, gamedig, and Discord PS scripts.
 - Manage Steam server with features
   * install steam server
   * starting server 
   * stopping server 
   * restarting server 
   * check if running 
   * update server
   * validate server files 
   * backup server files 
   * monitor server process 
   * send discord alert 
   * run gamedig on hosted server 
   * update steamer PS scripts from github  
 # Commands:  
 - ```Start <serverFolder>``` - ```>_./steamer start missesrver```  - Starts miscreated server process          
 - ```Stops <serverFolder>``` - ```>_./steamer stops misserver``` - stop process for miscreated server
 - ```restart <serverFolder>``` - ```>_./steamer restart misserver``` - stops and starts process for miscreated server]
 - ```validate <serverFolder>``` - ```>_./steamer validate misserver``` - Validate App ID files
 - ```check <serverFolder>``` - ```>_./steamer check misserver``` - checks process for miscreated server
 - ```update <serverFolder>``` - ```>_./steamer update misserver``` - updates App ID
 - ```backup <serverFolder>``` - ```>_./steamer backup misserver``` - Creates zip folder of server files in backups folder (Downloads portable 7Zip)
 - ```monitor <serverFolder>``` - ```>_./steamer monitor misserver``` - Creates Scheduled Task with monitor and Discord scripts 
 - ```gamedig <serverFolder>``` - ```>_./steamer gamedig sdtdserver``` * not supported for miscreated. although supported by several games. TBD (Downloads  NodeJS and installs Gamedig)
 - ```gamedigPrivate <serverFolder>``` - ```>_./steamer gamedigPrivate sdtdserver``` * Uses Private IP. not supported for miscreated. although supported by several games. TBD (Downloads  NodeJS and installs Gamedig)
 - ```Update Steamer``` - ```>_./steamer steamer update```  - Downloads and overwrites steamer github files
# Other Functions:
 * Monitor * monitor script in server folder as scheduled task to check process and start if needed, Send Discord Alert
 * Discord Alert * Discord script in server folder. requires Discord webhook
 
 

- - - -
 When creating a Schedule task to run Monitor script.
- If using a user windows account. Will need to add user to the "log on as batch job" to run the task under that account
- - - - 
 Does not install Dependencies like Visual C++ Redistributable or Direct X
 
 Does not Forward ports or open ports on firewall

