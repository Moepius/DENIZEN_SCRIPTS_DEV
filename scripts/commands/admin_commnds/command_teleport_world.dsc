# teleports the player to it's location in a world or the spawn if no back-location is found

command_teleport_world:
    type: command
    debug: false
    name: teleport_world
    description: teleport to a player location
    usage: /teleport_world
    aliases:
    - tpw
    tab completions:
        # TODO: replace with server flag of enabled worlds
        1: <server.worlds.formatted>
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.teleport_world]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst eine Welt angeben."
            - stop
        - define worldname <context.args.first>
        - define world <world[<[worldname]>]>
        - define backlocation <player.flag[player.commands.teleport.backlocations.<[world]>]>
        - if !<player.has_flag[player.commands.teleport.backlocations.<[world]>]>:
            - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
            - teleport <player> <[world].spawn_location>
        - else:
            - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
            - teleport <player> <[backlocation]>