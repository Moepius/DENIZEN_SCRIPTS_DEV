messageOfTheDay:
    type: task
    definitions: player|message
    script:
        - if !<player.has_flag[motd_gelesen]>:
            - wait 3s
            - run chatsounds_standard
            - narrate format:headerMitText "Wichtige Information"
            - narrate <empty>
            - narrate "<&3>Wir arbeiten intensiv an neuen Features für den Server."
            - narrate "<&7>Es wird einige Veränderungen geben und es werden"
            - narrate "<&7>laufend neue Funktionen getestet und alte abgeschaltet."
            - narrate "<&7>Zum aktuellen Stand informieren wir auf Discord"
            - narrate "<&7>unter <&3>#changelog<&7> und <&3>#neuigkeiten<&7>."
            - narrate <empty>
            - narrate format:footerOhneText <empty>
            - flag <player> motd_gelesen expire:12h
        - else:
            - stop
