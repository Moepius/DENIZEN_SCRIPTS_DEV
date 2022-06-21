command_serverrestart:
    type: command
    debug: true
    name: serverrestart
    description: Kickt alle Spieler und startet den Server neu
    usage: /serverrestart
    aliases:
    - restart
    - sr
    script:
        - if !<player.has_permission[craftasy.denizen.commands.serverrestart]>:
            - playsound <player> sound:item_shield_block pitch:1
            - ratelimit <player> 10s
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu verwenden."
            - stop
        - else:
            - flag server restart_happening duration:8s
            - announce format:c_warn "<&c>Server wird jetzt neu gestartet!"
            - wait 2s
            - kick <server.online_players> "reason: Server wird gerade neu gestartet. Bitte einen Moment Geduld!"
            - wait 1s
            - adjust server restart