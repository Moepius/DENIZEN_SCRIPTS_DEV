# sets a new Denizen location at players spot


command_setlocation:
    type: command
    debug: true
    name: setlocation
    description: Setzt eine neue Denizen Location am Standort des Spielers
    usage: /setlocation <&lt>Name<&gt>
    aliases:
    - sl
    - setloc
    tab completions:
        1: Name
    script:
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst einen Name für die Location angeben"
            - stop
        - note <player.location> as:<context.args>
        - narrate format:c_info "Neue Location <&a><context.args> <&b>gesetzt."