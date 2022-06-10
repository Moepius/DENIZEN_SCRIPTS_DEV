#
#
#
#
# flags:
#  rank flags: player.rank
#
#
#

# chat_handler:
#     type: world
#     debug: false
#     events:
#         on player chats:
#         - determine passively cancelled
#         # TODO: instert spam protection (count times player chats, if > x, then cancel)
#         ####################################
#         # Handling cases
#         ####################################
#         - if <player.has_flag[player.flag.muted]>:
#             - ratelimit <player> 10s
#             - narrate format:c_warn "Ihr wurdet stummgeschaltet."
#             - stop
#         - if !<player.has_flag[player.flag.rules_accepted]>:
#             - ratelimit <player> 10s
#             - narrate format:c_warn "Akzeptiert zunächst unsere Regeln, damit ihr den Chat nutzen könnt."
#             - stop
#         - if <player.has_flag[player.flag.spammed]>:
#             - ratelimit <player> 10s
#             - narrate format:c_warn "Ihr schreibt zu viel, bitte warten."
#             - stop
#         ###################################
#         # Building the message
#         ####################################
#         - definemap player_format:
#             prefix: <element[Testpräfix].on_hover[Infos zum Präfix]>
#             name: <player.name.on_hover[<&b>Klicken, für Privatnachricht].on_click[pn <player.name> ].type[SUGGEST_COMMAND]>
#             suffix: <&b>Testsuffix
#         - announce "<&f>[<[player_format.prefix]><&f>] <[player_format.name]> <[player_format.suffix]> <&f><&co><context.message.parse_color>"


command_pn:
    type: command
    debug: true
    name: pn
    description: "Private Nachricht an einen Spieler"
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
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        - if <player.has_flag[player.flag.muted]>:
            - ratelimit <player> 10s
            - narrate format:c_warn "Ihr wurdet stummgeschaltet."
            - stop
        - if <context.args.is_empty>:
            - narrate format:c_warn "Ihr müsst einen Spieler angeben."
            - stop
        - if <context.args[1]> == <context.player.name>:
            - narrate format:c_warn "Ihr könnt Euch selbst keine Nachricht senden."
            - stop
        - if !<[target].is_truthy>:
            - narrate format:c_warn "Kein gültiger Spieler oder nicht online."
            - stop
        - if !<[target].has_flag[player.flag.muted]>:
            - narrate format:c_warn "Der Spieler ist stummgeschaltet."
            - stop
        - if <context.args.size> < 2:
            - narrate format:c_warn "Ihr müsst eine Nachricht angeben."
            - stop
        ####################################
        # Building the message
        ####################################
        - define message "<context.raw_args.after[<context.args.first> ]>"
        - narrate targets:<[target]> "<&a><player.name> <&b>zu Euch<&f><&co> <[message]>"
        - narrate "<&b>Ihr zu <&a><[target].name><&f><&co> <[message]>"