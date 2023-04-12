messages:
    type: data
    # test section
    test:
        name: <&c>Sprachtest
        loreone: This ist the english lore one
        loretwo: This is the english lore two
        footer: <&7>Ingredient<&co> <&c><&chr[274C]> <&7>Produce<&co> <&c><&chr[274C]>
    # standard feedback messages
    info:
        feedback: Ihr habt folgende Angaben gemacht<&co>
        # example "Ihr habt <Wert> auf <Wert> gesetzt."
        change_pref: Ihr habt
        change_mid: auf
        change_end: gesetzt.
    # standard error messages
    error:
        # command errors
        no_player: Gebt einen gültigen Spieler an!
        no_args: Dieser Befehl benötigt keine Parameter!
        args_missing: Syntax<&co>
        no_permission: Ihr habt keine Berechtigung, diesen Befehl zu nutzen!
        input_int: Ihr müsst eine Ganzzahl angeben.
        input_string: Ihr müsst einen Text angeben.
        too_many_args: Ihr habt zu viele Parameter angegeben.
    # specific scripts
    # category: language
    command_language:
        wrong_language: Gebt entweder <&a>de <&c>oder <&a>en <&c>an.
        language_set_one: Eure Sprache wurde auf <&a>
        language_set_two: <&b>gesetzt.
    # category: teleport
    command_back:
        no_backlocations: Ihr habt keine Orte an welche Ihr zurückkehren könntet.
        location_not_valid: gebt einen gültigen Ort an zu dem Ihr Euch teleportieren wollt.