# all language files for German

lang_test:
    type: task
    debug: false
    definitions: player
    script:
        - narrate "Error Text:"
        - narrate <empty>
        - run core_error def:<[player]>|<script[<player.flag[player.settings.language]>].data_key[error.no_player]>

de:
    type: data
    # standard feedback messages
    info:
        feedback: Ihr habt folgende Angaben gemacht<&co>
        # example "Ihr habt <Wert> auf <Wert> gesetzt."
        change_pref: Ihr habt
        change_mid: auf
        change_end: gesetzt.
    # standard error messages
    error:
        no_player: Gebt einen gültigen Spieler an!
        no_args: Dieser Befehl benötigt keine Parameter!
        args_missing: Syntax<&co>
        no_permission: Ihr habt keine Berechtigung, diesen Befehl zu nutzen!
        input_int: Ihr müsst eine Ganzzahl angeben.
        input_string: Ihr müsst einen Text angeben.