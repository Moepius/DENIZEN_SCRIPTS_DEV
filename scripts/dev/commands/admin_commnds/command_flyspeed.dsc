# adjusts flyspeed

command_flyspeed:
    type: command
    debug: false
    name: flyspeed
    description: adjust your flyspeed
    usage: /flyspeed
    aliases:
    - fs
    tab completions:
        1: Ganzzahl zwischen 1 und 9, Standard: 2
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.flyspeed]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst eine Ganzzahl angeben"
            - stop
        - if !<context.args.get[1].is_integer>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst eine Ganzzahl angeben."
            - stop
        - if <context.args.get[1]> < 1 || <context.args.get[1]> > 9:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst eine Ganzzahl zwischen 1 und 9 angeben."
            - stop
        - adjust <player> fly_speed:0.<context.args.get[1]>
        - narrate format:c_info "Geschwindigkeit auf <&a><context.args.get[1]><&b> gesetzt."