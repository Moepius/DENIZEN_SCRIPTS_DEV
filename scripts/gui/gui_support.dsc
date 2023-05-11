gui_support_events:
    type: world
    enabled: false
    events:
        on player joins:
        - if <player.has_flag[enabled_error]>:
            - narrate "Fehler! Script sollte ausgeschaltet sein"
