# steamer
PowerShell Steam Server Scripter


Install:  
          
          place in C:\Users\%Username%\functions\*
          place in C:\Users\%Username%\steamer.ps1

Run: open Powershell
as user NOT Admin

Steamer accepts 1 or 2 parameters. first param specifies steamer command and the second is server folder name. if server folder name does not exists it creates it.

>_ ./steamer <command> <serverFolder>
          
Install steam server >_ ./steamer install misserver
 - Creates Server Folder Named misserver and starts install scripts
 - Downloads and extract steamcmd
 - uses Steaminfo.db App ID -
 - uses anon or steam login for install         
 - Creates Launch Script - per App ID, if exists.
 - Creates custom config for server- if avaible by steamer 
   * Miscreated Server (302200) - misserver 
   * 7 Days to Die server (294420) - sdtdserver  
   * Insurgency Server (237410) - insserver
   * Insugency: Sandstorm Server (581330) - inssserver
   * Rust server (258550) -  rustserver
   * Arma3 Server (233780)-  arma3server        
 - Creates Stop, Start, Update, Validate, Restart, Check, Monitor, gamedig, details, and Discord PS sctipts. 
 Commands:  
 - Start <serverFolder>  >_ ./steamer start missesrver  - Starts miscreated server process          
 - Stops <serverFolder> >_ ./steamer stops misserver - stop process for miscreated server
 - restart <serverFolder> >_ ./steamer restart misserver - stops and starts process for miscreated server]
 - validate <serverFolder> >_ ./steamer validate misserver - Validate App ID files
 - check <serverFolder> >_ ./steamer check misserver - checks process for miscreated server
 - update <serverFolder> >_ ./steamer update misserver - updates App ID
 - backup <serverFolder> >_ ./steamer backup misserver - Creates zip folder of serverfiles in backups folder (Downloads portable 7Zip)
 - monitor <serverFolder> >_ ./steamer monitor misserver - Creates Scehduled Task with monitor and Discord scripts 
 - gamedig <serverFolder> >_ ./steamer gamedig sdtdserver * not supported for miscreated. although supported by several games. TBD (Downloads  NodeJS and installs Gamedig)
 - details <serverFolder> >_ ./steamer details sdtdserver * not supported for miscreated. although supported by several games. TBD (Downloads  NodeJS and installs Gamedig)
 - Update Steamer >_ ./steamer steamer update  - Downloads and overwrites steamer github files
Other Functions:
 * Monitor * monitor script in server folder as scheduled task to check process and start if needed, Send Discord Alert
 * Discord Alert * Discord script in server folder. 
 
 

- - - -
 When creating a Schedule task to run Monitor script.
- If using a user windows account. Will need to add user to the "log on as batch job" to run the task under that account
- - - - 
 Does not install Dedpendencies like Visual C++ Redistributable or Direct X
 
 Does not Forward ports or open ports on firewall
