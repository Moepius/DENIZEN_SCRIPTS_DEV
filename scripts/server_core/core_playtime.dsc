# for every player online, who is not AFK count playtime on the server

playtime_handler:
    type: world
    debug: true
    enabled: true
    events:
        on system time secondly:
        - define online_player <server.online_players>
        - foreach <[online_player]> as:player:
            - if <[player].has_flag[player.core.afk.isafk]>:
                - stop
            - else:
                - flag <[player]> player.core.playtime.total:+:1

playtime_command:
    type: command
    debug: true
    name: pt
    description: get a players playtime
    usage: /pt
    aliases:
    - playt
    - ptime
    tab completions:
        1: <server.online_players.parse[name]>
    script:
        # initial checks
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst einen Spieler angeben."
            - stop
        - if !<player.has_permission[craftasy.denizen.comannd.pt]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        # player matching checks
        - define player_matched <server.match_offline_player[<context.args.first>].if_null[null]>
        - if !<[player_matched].has_flag[player.core.playtime.total]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Der angegebene Spieler hat keine gültige Spielzeit."
            - stop
        - if !<[player_matched].is_truthy>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Kein gültiger Spieler oder nicht online."
            - stop
        # narrate playtime
        - define playtime <duration[<[player_matched].flag[player.core.playtime.total]>s].formatted>
        - narrate format:c_info "Gesamtspielzeit von <&a><[player_matched].name><&b>: <[playtime]>"

playtime_set_command:
    type: command
    debug: true
    name: ptset
    description: set a players playtime
    usage: /ptset
    aliases:
    - playtset
    - ptimeset
    tab completions:
        1: <server.online_players.parse[name]>
        2: int(seconds)
    script:
        # initial checks
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst einen Spieler angeben."
            - stop
        - if <context.args.size> < 2:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst eine Spielzeit angeben (in Sekunden)."
            - stop
        - if !<context.args.get[2].is_integer>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst eine Spielzeit angeben (in Sekunden)."
            - stop
        - if !<player.has_permission[craftasy.denizen.comannd.ptset]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        # player matching checks
        - define player_matched <server.match_offline_player[<context.args.first>].if_null[null]>
        - if !<[player_matched].is_truthy>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Kein gültiger Spieler oder nicht online."
            - stop
        # set playtime
        - flag <[player_matched]> player.core.playtime.total:<context.args.get[2]>
        - narrate format:c_info "Spielzeit von <&a><[player_matched].name><&b> auf <&a><duration[<context.args.get[2]>s].formatted><&b> gesetzt."