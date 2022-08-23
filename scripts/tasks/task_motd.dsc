task_motd:
    type: task
    debug: false
    definitions: player
    script:
    # TODO: add later, && <player.has_permission[craftasy.denizen.task.motd]> && !<[player].has_flag[player.flag.no_motd]>
        - if !<[player].has_flag[motd_gelesen]>:
            - run chatsounds_standard def:<[player]>
            - narrate format:headerMitText "Wichtige Information"
            - narrate <empty>
            - narrate "<&3>Es wird aktiv am Server gearbeitet."
            - narrate "<&7>Aktuell kein technischer Support und"
            - narrate "<&7>Verlust von Bau-/ Fortschritten möglich!"
            - narrate <empty>
            - narrate format:footerOhneText <empty>
            - flag <[player]> motd_gelesen expire:12h
        - else:
            - stop
