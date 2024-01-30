# handling flags for the players language settings

language_handler:
    type: world
    debug: false
    enabled: false
    events:
        on player joins:
            - if !<player.has_flag[player.settings.language.initialsetup]>:
                - flag <player> player.settings.language.initialsetup
                - flag <player> player.settings.language:de
                - announce to_console "Sprache des Spielers <player.name> erstes mal gesetzt."

lang_test:
    type: task
    debug: false
    definitions: player
    script:
        - narrate "Error Text:"
        - narrate <empty>
        - run core_error def:<[player]>|<script[<player.flag[player.settings.language]>].data_key[error.no_player]>

lang_test_item:
    type: item
    material: string
    display name: test
    # <script[<player.flag[player.settings.language]>].data_key[test.name]>
    lore:
    - <empty>
    - <script[<player.flag[player.settings.language]>].data_key[test.loreone].parse_color>
    - <script[<player.flag[player.settings.language]>].data_key[test.loretwo].parse_color>
    - <empty>
    - <&f><&m>---------------------------
    - <script[<player.flag[player.settings.language]>].data_key[test.footer].parse_color>
    - <&f><&m>---------------------------
    - <&c>Admin


command_language:
    type: command
    debug: false
    name: language
    description: switch your language to german or English.
    usage: /language
    aliases:
    - lang
    - la
    tab completions:
        1: <list[de|en]>
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.language]>:
            - run core_error def:<player>|<script[<player.flag[player.settings.language]>].data_key[error.no_permission].parse_color>
            - stop
        - if <context.args.is_empty>:
            - run core_error "def:<player>|<script[<player.flag[player.settings.language]>].data_key[error.args_missing].parse_color> <&a>en/de<&c>."
            - stop
        - if !<context.args.get[1]> == en || !<context.args.get[1]> == de:
            - run core_error def:<player>|<script[<player.flag[player.settings.language]>].data_key[command_language.wrong_language].parse_color>
            - stop
        - if <context.args.size> > 1:
            - run core_error def:<player>|<script[<player.flag[player.settings.language]>].data_key[error.too_many_args].parse_color>
            - stop
        - flag <player> player.settings.language:<context.args.get[1]>
        - run core_info def:<player>|<script[<player.flag[player.settings.language]>].data_key[command_language.language_set_one].parse_color><context.args.get[1]><script[<player.flag[player.settings.language]>].data_key[command_language.language_set_two].parse_color>