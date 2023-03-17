

# TODO: rank handling for players who join for the first time and existing players who are not in the new system


rank_update_command:
    type: command
    debug: false
    name: rank_update
    description: Rang setzen
    usage: /rank_update
    aliases:
    - rup
    tab completions:
        1: <server.online_players.parse[name]>
        #TODO: insert all ranks in the list
        2: <list[Besucher|Veraltet|Vagabund]>
    script:
        # initial checks
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst einen Spieler angeben."
            - stop
        - if <context.args.size> < 2:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst einen Rang angeben."
            - stop
        - if !<player.has_permission[craftasy.denizen.comannd.rank_update]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        - flag <context.args.first> player.rank.data_name:<context.args.get[2]>
        - narrate format:c_info "Rang des Spielers gesetzt: <&a><context.args.get[2]><&b>"

