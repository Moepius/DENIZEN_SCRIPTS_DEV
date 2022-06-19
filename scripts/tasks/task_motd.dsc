task_motd:
    type: task
    definitions: player
    script:
    # TODO: add later, && <player.has_permission[craftasy.denizen.task.motd]> && !<[player].has_flag[player.flag.no_motd]>
        - if !<[player].has_flag[motd_gelesen]>:
            - run chatsounds_standard def:<[player]>
            - narrate format:headerMitText "Wichtige Information"
            - narrate <empty>
            - narrate "<&3>Wir arbeiten intensiv an neuen Features für den Server."
            - narrate "<&7>Es wird einige Veränderungen geben und es werden"
            - narrate "<&7>laufend neue Funktionen getestet und alte abgeschaltet."
            - narrate "<&7>Zum aktuellen Stand informieren wir auf Discord"
            - narrate "<&7>unter <&3>#changelog<&7> und <&3>#neuigkeiten<&7>."
            - narrate "<&c>Ab August werden große Resets erfolgen, sichert bis dahin"
            - narrate "<&c>Euer Inventar + Enderchest in Kisten!"
            - narrate <empty>
            - narrate format:footerOhneText <empty>
            - flag <[player]> motd_gelesen expire:12h
        - else:
            - stop
