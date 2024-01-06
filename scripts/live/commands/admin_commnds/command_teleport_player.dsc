# teleports the player to another player

command_teleport_player:
    type: command
    debug: false
    name: teleport_player
    description: teleport to a player location
    usage: /teleport_player
    aliases:
    - tpp
    tab completions:
        1: <server.online_players.exclude[<player>].parse[name]>
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.teleport_player]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst einen Spieler angeben."
            - stop
        - define player_matched <server.match_player[<context.args.first>].if_null[<player>]>
        - if !<[player_matched].is_truthy>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Kein gültiger Spieler oder nicht online."
            - stop
        - if <[player_matched]> == <player>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Nein"
            - stop
        - cast blindness duration:2s hide_particles no_ambient no_icon <player>
        - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
        - playeffect effect:SPELL_WITCH at:<player.location> visibility:500 quantity:120 offset:1.5
        - teleport <player> <[player_matched].location>