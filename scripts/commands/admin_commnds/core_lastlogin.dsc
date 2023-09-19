# check players last login

#TODO: also check for offline player matching
#TODO: better formating of time, no duration, just login and logout times

lastlogin_command:
    type: command
    debug: true
    name: ll
    description: get a players last login
    usage: /ll
    aliases:
    - lastlogin
    tab completions:
        1: <server.online_players.parse[name]>
    script:
        # initial checks
        - if <context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr müsst einen Spieler angeben."
            - stop
        - if !<player.has_permission[craftasy.denizen.comannd.ll]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        # player matching checks
        - define player_matched <server.match_offline_player[<context.args.first>].if_null[null]>
        - if <[player_matched]> == null:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Kein gültiger Spieler."
            - stop
        - if !<[player_matched].has_flag[player.core.lastlogin.timestamp]> || !<[player_matched].has_flag[player.core.lastquit.timestamp]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Für den angegebenen Spieler sind keine Daten vorhanden."
            - stop
        # narrate playtime
        - define lastlogin <[player_matched].flag[player.core.lastlogin.timestamp].format[dd/MM/yyyy HH:mm]>
        #- define session_duration <[player_matched].flag[player.core.lastlogin.timestamp].duration_since[<[player_matched].flag[player.core.lastquit.timestamp]>].formatted>
        - narrate format:c_info "Der Spieler <&a><[player_matched].name><&b> wurde zuletzt am <&a><[lastlogin]><&b> gesehen."