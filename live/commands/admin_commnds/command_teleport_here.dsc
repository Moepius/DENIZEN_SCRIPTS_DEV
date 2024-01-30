# teleports another player to the player
# TODO: protection against cheating ... player needs bo sent back to his original location where he came from automatically

command_teleport_here:
    type: command
    debug: false
    name: teleport_here
    description: teleport another player to your location
    usage: /teleport_here
    aliases:
    - tph
    tab completions:
        1: <server.online_players.exclude[<player>].parse[name]>
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.teleport_here]>:
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
        - narrate format:c_info "<&a><player.name> <&b>teleportiert Euch zu sich." targets:<[player_matched]>
        - wait 1.5s
        - cast blindness duration:2s hide_particles no_ambient no_icon <[player_matched]>
        - playsound <[player_matched]> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
        - playeffect effect:SPELL_WITCH at:<[player_matched].location> visibility:500 quantity:120 offset:1.5
        - teleport <[player_matched]> <player.location>