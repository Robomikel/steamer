# steamer
PowerShell Steam Server Scripter


Install:  
          
          place in C:\Users\%Username%\functions\*
          place in C:\Users\%Username%\steamer.ps1

Run: open Powershell or Win+X , I
as user NOT Admin

Steamer accepts 1 or 2 parameters. first param specifies steamer command and the second is server folder name. if server folder name does not exists it creates it.

Install steam server >_ ./steamer install misserver
 - Creates Server Folder Named misserver and starts install scripts
 - uses Steam.db App ID - 
 - Creates Launch Script  >_ ./steamer start missesrver  - Starts miscreated server process
   * Miscreated Server App ID 302200 (Downloads and extract steamcmd)
   * 7 Days to Die server (294420)- sdtdserver  
   * Insurgency Server (237410)- insserver
   * Insugency: Sandstorm Server (581330) - inssserver
   * Rust server (258550) -  rustserver
   * Arma3 Server (233780)-  arma3server
 - Stops server >_ ./steamer stops misserver - stop process for miscreated server
 - restart server >_ ./steamer restart misserver - stops and starts process for miscreated server]
 - validate server >_ ./steamer validate misserver - Validate App ID files
 - check server >_ ./steamer check misserver - checks process for miscreated server
 - update server >_ ./steamer update misserver - updates App ID
 - backup server >_ ./steamer backup steamer - Creates zip folder of serverfiles in server folder (Downloads portable 7Zip)
 - Monitor server * run monitor script in server folder as scheduled task to check process and start if needed
 - Discord Alert * run Discord script in server folder to send discord alert with Monitor script
 - Gamedig >_ ./steamer gamedig sdtdserver * not supported for miscreated. although supported by several games. TBD (Downloads  NodeJS and installs Gamedig)
 - Details >_ ./steamer details sdtdserver * not supported for miscreated. although supported by several games. TBD (Downloads  NodeJS and installs Gamedig)
 - Update Steamer >_ ./steamer steamer update  - Downloads and overwrites steamer github files
 
 

- - - -
 When creating a Schedule task to run Monitor script.
- If using a user windows account. Will need to add user to the "log on as batch job" to run the task under that account
- - - - 
 Does not install Dedpendencies like Visual C++ Redistributable or Direct X
 
 Does not Forward ports or open ports on firewall
