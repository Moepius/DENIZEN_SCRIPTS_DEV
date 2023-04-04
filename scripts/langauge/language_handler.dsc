# handling flags for the players language settings

language_handler:
    type: world
    debug: false
    events:
        on player joins:
            - if !<player.has_flag[player.settings.language.initialsetup]>:
                - flag <player> player.settings.language.initialsetup
                - flag <player> player.settings.language:de
                - announce to_console "Sprache des Spielers <player.name> erstes mal gesetzt."