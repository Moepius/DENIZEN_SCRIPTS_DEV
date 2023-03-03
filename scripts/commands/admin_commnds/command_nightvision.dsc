#TODO: flags/permissions
#TODO: Verknüpfung verschiedene Spielwelten

command_nightvision:
    type: command
    debug: false
    name: nightvision
    description: Gibt dem Spieler Nachtsicht
    usage: /nightvision
    aliases:
    - nv
    script:
        - if !<player.has_permission[craftasy.denizen.commands.nightvision]>:
            - playsound <player> sound:item_shield_block pitch:1
            - ratelimit <player> 10s
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu verwenden."
            - stop
        - else:
            - if !<player.has_flag[player.command.nightvision.active]>:
                - flag <player> player.command.nightvision.active
                - playsound <player> sound:block_beacon_activate pitch:0.1
                - narrate format:c_info "Nightvision eingeschaltet"
                - cast night_vision duration:3y no_ambient no_icon hide_particles
            - else:
                - flag <player> player.command.nightvision.active:!
                - playsound <player> sound:block_beacon_deactivate pitch:0.1
                - narrate format:c_info "Nightvision abgeschaltet"
                - cast night_vision remove
