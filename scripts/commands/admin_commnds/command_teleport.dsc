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
    tab completions:
        1: x
        2: y
        3: z
        4: <server.worlds.formatted>
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
            - narrate format:c_warn "Gebt folgende Parameter an: x y z Weltname(optional)"
            - stop
        - if !<context.args.get[1].is_integer> || !<context.args.get[2].is_integer> || !<context.args.get[3].is_integer>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst gültige Koordinaten eingeben."
            - stop
        - if <context.args.size> < 4:
            - teleport <player> <location[<context.args.get[1]>,<context.args.get[2]>,<context.args.get[3]>,<player.location.world>]>
        - else:
            - teleport <player> <location[<context.args.get[1]>,<context.args.get[2]>,<context.args.get[3]>,<world[<context.args.get[4]>]>]>