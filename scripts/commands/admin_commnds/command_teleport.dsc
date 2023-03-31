# teleports the player to a specific location
# TODO: tpworld command, tpplayer command, back command
# TODO: "Tolkiers Pfeil" Tool, siehe Discord

command_teleport:
    type: command
    debug: false
    name: teleport
    description: teleport to a location
    usage: /teleport
    aliases:
    - tp
    - tppos
    tab completions:
        1: x
        2: y
        3: z
        4: <list[<server.flag[server.worlds.enabled_worlds]>]>
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.teleport]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst ein Ziel angeben."
            - stop
        - if <context.args.size> < 3:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst gültige Koordinaten eingeben."
            - stop
        - if <context.args.size> > 4:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Gebt folgende Parameter an: x y z (Weltname)"
            - stop
        - if !<context.args.get[1].is_integer> || !<context.args.get[2].is_integer> || !<context.args.get[3].is_integer>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst gültige Koordinaten eingeben."
            - stop
        - if <context.args.size> < 4:
            - cast blindness duration:2s hide_particles no_ambient no_icon <player>
            - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
            - playeffect effect:SPELL_WITCH at:<player.location> visibility:500 quantity:120 offset:1.5
            - teleport <player> <location[<context.args.get[1]>,<context.args.get[2]>,<context.args.get[3]>,<player.location.world>]>
        - else:
            - cast blindness duration:2s hide_particles no_ambient no_icon <player>
            - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
            - playeffect effect:SPELL_WITCH at:<player.location> visibility:500 quantity:120 offset:1.5
            - teleport <player> <location[<context.args.get[1]>,<context.args.get[2]>,<context.args.get[3]>,<world[<context.args.get[4]>]>]>