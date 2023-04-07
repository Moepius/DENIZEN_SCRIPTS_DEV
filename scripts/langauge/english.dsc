

en:
    type: data
    # test section
    test:
        name: <&c>Language Test
        loreone: This ist the english lore one
        loretwo: This is the english lore two
        footer: <&7>Ingredient<&co> <&c><&chr[274C]> <&7>Produce<&co> <&c><&chr[274C]>
    # standard feedback messages
    info:
        feedback: You have provided the following inputs<&co>
        # example "Ihr habt <Wert> auf <Wert> gesetzt."
        change_pref: You have set
        change_mid: to
        change_end: .
    
    # standard error messages
    error:
        # command errors
        no_player: Specify a valid player!
        no_args: This command needs no arguments!
        args_missing: Syntax<&co>
        no_permission: You have no permission to use this command!
        input_int: Specifiy an integer value.
        input_string: Specifiy a text value.
        too_many_args: You have given too many pramaters.

    # specific scripts
    # category: language
    command_language:
        wrong_language: Please use either <&a>de <&c>or <&a>en <&c>as input.
        language_set_one: You have set your language settings to <&a>
        language_set_two:  <&b>.
    # category: teleport
    command_back:
        no_backlocations: You have no locations to go back to.
        location_not_valid: Please provide a valid location to teleport back to.
