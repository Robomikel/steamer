# Steamer
PowerShell Steam Server Scripter
- Install and Manage Steam Servers with Powershell.


Install Any location:
Download, Extract, and Open PowerShell and Change Directory to steamer.ps1

Run: 
open PowerShell as user NOT Admin
Steamer accepts 1 or 2 parameters. first param specifies steamer command and the second is server folder name. if server folder name does not exist it creates it.   ```.\steamer.ps1 install insserver```

```>_./steamer <command> <serverFolder>```
          
Install steam server ```>_./steamer install misserver```
 - Creates Server Folder Named ```<serverFolder>``` and starts install
 - Downloads and extract steamcmd
 - Asks and uses Steaminfo.db App ID -
 - uses anon or steam login for install         
 - Creates Launch Script - per App ID, if exists.
 - Creates custom default config for server- if available 
   * Miscreated Server (302200) - "misserver" (optional server folder name) 
   * 7 Days to Die server (294420) - "sdtdserver" (optional server folder name)  
   * Insurgency Server (237410) - "insserver" (optional server folder name) 
   * Insurgency: Sandstorm Server (581330) - "inssserver" (optional server folder name) 
   * Rust server (258550) - "rustserver" (optional server folder name) 
   * Arma3 Server (233780)- “arma3server" (optional server folder name)
   * ARK: Survival Evolved Dedicated Server (376030)- “arkserver" (optional server folder name)
   * Day of Infamy Dedicated Server (462310)- “doiserver" (optional server folder name)
   * Killing Floor 2 - Dedicated Server (232130) "kf2server" (optional server folder name)
   * Empyrion - Galactic Survival Dedicated Server (530870) "empserver" (optional server folder name)
   * Conan Exiles Dedicated Server (443030) "ceserver" (optional server folder name)
   * The Forest Dedicated Server (556450) "forestserver" (optional server folder name)
   * Counter-Strike Global Offensive - Dedicated Server (740) "csgoserver" (optional server folder name)
   * Left 4 Dead 2 - Dedicated Server (222860) "lfd2server" (optional server folder name)
   * Age of Chivalry Dedicated Server (17515)  "aocserver" (optional server folder name)
   # untested
   * Avorion - Dedicated Server (565060)
   * Boundel - Dedicated Server (454070)
   * Assetto Corsa Dedicated Server (302550)
   * Alien Swarm Dedicated Server (17515)
   -----
 - Creates Launch, Monitor, per serverfolder/instance variables, and Discord PS scripts.
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
   * Rcon to server 
   * Daily AutoRestart server process 
   * send discord alert 
   * run gamedig on hosted server 
   * update steamer PS scripts from github  
 # Commands:  
 - ```Start <serverFolder>``` - ```>_./steamer start missesrver```  - Starts miscreated server process          
 - ```Stop <serverFolder>``` - ```>_./steamer stop misserver``` - stop process for miscreated server
 - ```restart <serverFolder>``` - ```>_./steamer restart misserver``` - stops and starts process for miscreated server]
 - ```validate <serverFolder>``` - ```>_./steamer validate misserver``` - Validate App ID files
 - ```check <serverFolder>``` - ```>_./steamer check misserver``` - checks process for miscreated server
 - ```update <serverFolder>``` - ```>_./steamer update misserver``` - updates App ID
 - ```backup <serverFolder>``` - ```>_./steamer backup misserver``` - Creates zip folder of server files in backups folder (Downloads portable 7Zip)
 - ```monitor <serverFolder>``` - ```>_./steamer monitor misserver``` - Creates Scheduled Task to start server if off, with  Discord alert
 - ```discord <serverFolder>``` - ```>_./steamer discord misserver``` -  * Discord Alert * -command will send test alert. requires Discord webhook
 - ```AutoRestart <serverFolder>``` - ```>_./steamer AutoRestart misserver``` - Creates Scheduled Task for Daily Auto Restart
 - ```MCRcon <serverFolder>``` - ```>_./steamer mcrcon inssserver``` - Uses MCRcon. Rcon to server (Downloads MCRcon)
  - ```MCRconPrivate <serverFolder>``` - ```>_./steamer mcrconPrivate inssserver``` - Uses MCRcon. Rcon to server via Private IP (Downloads MCRcon)
 - ```gamedig <serverFolder>``` - ```>_./steamer gamedig sdtdserver``` * not supported for miscreated. although supported by several games. TBD (Downloads  NodeJS and installs Gamedig)
 - ```gamedigPrivate <serverFolder>``` - ```>_./steamer gamedigPrivate sdtdserver``` * Uses Private IP. not supported for miscreated. although supported by several games. TBD (Downloads  NodeJS and installs Gamedig)
 - ```Update Steamer``` - ```>_./steamer steamer update```  - Downloads and overwrites steamer github files 
 # Mod
 * Insurgency - option for sourcemod and Meta Mod install
 * Rust - option for Oxide install
 * Counter-Strike Global Offensive - option for sourcemod and Meta Mod install
 * Left 4 Dead 2 - Dedicated Server - option for sourcemod and Meta Mod install
  # MCRcon
 * MCRcon Download and Install
 * Use used to Rcon to servers.
 
- - - -

# Troubleshooting:
If something stops working after a steamer update. please re-run the install command and re-enter vars. You do not need to re-install the server. As long as you keep the same server folder name and App ID. Always make a backup before updating. You can also delete all the .ps1's and download current version from here. The install command will recreate them. I have been making a lot of changes. I am starting to get content with features. I am hoping to get to the point were updates will only introduce new games. Enjoy.
- - - - 
 When creating a Schedule task to run Monitor script.
- If using a user windows account. Will need to add user to the "log on as batch job" to run the task under that account
- - - - 
 Does not install Dependencies like Visual C++ Redistributable or Direct X
 
 Does not Forward ports or open ports on firewall
- - - - 
 # MCRCON
https://github.com/Tiiffi/mcrcon
# GameDig
https://github.com/sonicsnes/node-gamedig
# Game Server Managers (my inspiration)
Game server configs from
https://github.com/GameServerManagers
 "open source, open mind"

