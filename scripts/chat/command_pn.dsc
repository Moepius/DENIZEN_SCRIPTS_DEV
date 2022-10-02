# private messages

command_pn:
    type: command
    debug: true
    name: pn
    description: Private Nachricht an einen Spieler
    usage: /pn <&lt>Spieler<&gt> <&lt>Nachricht<&gt>
    aliases:
    - pm
    - msg
    - message
    tab completions:
        1: <server.online_players.parse[name]>
    script:
        ####################################
        # Handling cases
        ####################################
        - define target <server.match_player[<context.args.first>].if_null[null]>
        - if !<player.has_permission[craftasy.denizen.player.command.pn]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        - if <player.has_flag[player.flag.muted]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr wurdet stummgeschaltet."
            - stop
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst einen Spieler angeben."
            - stop
        - if <context.args[1]> == <player.name>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr könnt Euch selbst keine Nachricht senden."
            - stop
        - if !<[target].is_truthy>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Kein gültiger Spieler oder nicht online."
            - stop
        - if <[target].has_flag[player.core.afk.isafk]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Der Spieler ist <&a>AFK<&c>."
            - stop
        - if <[target]> == <player>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr könnt keine Nachricht an Euch selbst versenden."
            - stop
        - if <[target].has_flag[player.flag.muted]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Der Spieler ist stummgeschaltet."
            - stop
        - if <context.args.size> < 2:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst eine Nachricht angeben."
            - stop
        ####################################
        # Building the message
        ####################################
        - define message "<context.raw_args.after[<context.args.first> ]>"
        - run chatsounds_important def:<[target]>
        - narrate targets:<[target]> "<&b><&l>[<&6><&l>PN<&b><&l>] <&a><player.name.on_hover[<&b>Klicken, zum antworten].on_click[/pn <player.name> ].type[SUGGEST_COMMAND]> <&b>➤<&f><&co> <[message]>"
        - narrate "<&b><&l>[<&6><&l>PN<&b><&l>] <&b>Ihr zu <&a><[target].name.on_hover[<&b>Klicken, für weitere Nachricht].on_click[/pn <[target].name> ].type[SUGGEST_COMMAND]><&f><&co> <[message]>"

        # Sender <&b>➤ Empfänger