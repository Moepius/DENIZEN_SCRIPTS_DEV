command_support:
    type: command
    debug: true
    name: support
    description: open the support menu
    usage: /support
    permission: craftasy.denizen.command.support
    aliases:
    - su
    script:
        # open menu
        - playsound <player> sound:block_sculk_sensor_clicking volume:1 pitch:1
        - flag <player> player.chat.support:!
        - inventory open d:support_gui


support_handler:
    type: world
    debug: true
    enabled: true
    events:
        # button handling
        on player clicks support_report in support_gui:
            - flag <player> player.chat.support.report expire:5m
            - flag <player> player.chat.busy expire:5m
            - inventory close d:support_gui
            - narrate format:c_info "Schreibt <&a>stop<&b>, um abzubrechen."
            - title "title:<red>Gebt einen Spielernamen an" "subtitle:<white>in den Chat schreiben ..." stay:5m
            - flag <player> player.chat.support.reason:Meldung
        on player clicks support_emergency in support_gui:
            - flag <player> player.chat.support.emergency expire:5m
            - flag <player> player.chat.busy expire:5m
            - inventory close d:support_gui
            - narrate format:c_info "Schreibt <&a>stop<&b>, um abzubrechen."
            - title "title:<red>Beschreibt den Fehler ausführlich" "subtitle:<white>in den Chat schreiben ..." stay:5m
            - flag <player> player.chat.support.reason:Notfall
        on player clicks support_bug in support_gui:
            - flag <player> player.chat.support.bug expire:5m
            - flag <player> player.chat.busy expire:5m
            - inventory close d:support_gui
            - narrate format:c_info "Schreibt <&a>stop<&b>, um abzubrechen."
            - title "title:<red>Beschreibt den Fehler ausführlich" "subtitle:<white>in den Chat schreiben ..." stay:5m
            - flag <player> player.chat.support.reason:Bugreport
        on player chats flagged:player.chat.busy bukkit_priority:lowest:
            - determine cancelled passively
            - if <context.message> == stop:
                - narrate format:c_info "Aktion abgebrochen."
                - title "title:<red>Abgebrochen" stay:3s
                - flag <player> player.chat.support:!
                - flag <player> player.chat.busy:!
            - if <player.has_flag[player.chat.support.report]>:
                - run support def:<player>|<context.message>
            - if <player.has_flag[player.chat.support.emergency]>:
                - run emergency def:<player>|<context.message>
            - if <player.has_flag[player.chat.support.bug]>:
                - run bugreport def:<player>|<context.message>
        on player quits flagged:player.chat.busy:
            - flag <player> player.chat.support:!
            - flag <player> player.chat.busy:!

support:
    type: task
    debug: true
    definitions: p|message
    script:
        # message 1 - name
        - define length <[message].length>
        - if !<player.has_flag[player.chat.support.report_message2]>:
            - if <[length]> == 0 || <[length]> < 3 || <[length]> > 30:
                - narrate format:c_warn "Gebt den Namen eines Spielers an!" targets:<player>
                - stop
            - narrate format:c_info "Ihr habt folgenden Spieler angegeben: <&a><[message]>"
            - title "title:<red>Gebt einen Grund an" "subtitle:<white>in den Chat schreiben ..." stay:5m
            - flag <player> "player.chat.support.report_message1:Gemeldeter Spieler: <[message]>"
            - flag <player> player.chat.support.report_message2 expire:5m
            - stop
        # message 2 - reason
        - if <player.has_flag[player.chat.support.report_message2]>:
            - if <[length]> == 0 || <[length]> < 40:
                - narrate format:c_warn "Formuliert Eure Begründung ausführlicher!" targets:<player>
                - stop
            - narrate format:c_info "Ihr habt folgenden Grund angegeben: <&a><[message]>"
            - title "title:<green>Meldung gesendet" stay:3s
            - flag <player> "player.chat.support.report_message2:Begründung: <[message]>"
            - define name <player.flag[player.chat.support.report_message1]>
            - define reason <player.flag[player.chat.support.report_message2]>
            - define subject <player.flag[player.chat.support.reason]>
            # send discordmessage
            - run support_discord def:<[p]>|<[name]>|<[reason]>|<[subject]>
            # clean flags
            - flag <player> player.chat.support:!
            - flag <player> player.chat.busy:!
emergency:
    type: task
    debug: true
    definitions: p|message
    script:
        - define length <[message].length>
        # message 2 - reason
        - if <[length]> == 0 || <[length]> < 40:
            - narrate format:c_warn "Formuliert das Problem ausführlicher!" targets:<player>
            - stop
        - flag <player> "player.chat.support.emergency_message:Beschreibung: <[message]>"
        - flag <player> "player.chat.support.emergency_coords:Standort: <[p].location.simple>"
        - narrate format:c_info "Ihr habt folgende Angaben gemacht: <&a><[message]>"
        - title "title:<green>abgesendet" stay:3s
        - define subject <player.flag[player.chat.support.reason]>
        - define reason <player.flag[player.chat.support.emergency_message]>
        - define coords <player.flag[player.chat.support.emergency_coords]>
        # send discordmessage
        - run support_discord def:<[p]>|<[coords]>|<[reason]>|<[subject]>
        # clean flags
        - flag <player> player.chat.support:!
        - flag <player> player.chat.busy:!
bugreport:
    type: task
    debug: true
    definitions: p|message
    script:
        # message 1 - name
        - define length <[message].length>
        - if !<player.has_flag[player.chat.support.bug_message2]>:
            - if <[length]> == 0 || <[length]> < 60:
                - narrate format:c_warn "Beschreibt den Fehler ausführlich!" targets:<player>
                - stop
            - narrate format:c_info "Ihr habt folgende Fehlerbeschreibung angegeben: <&a><[message]>"
            - narrate <empty>
            - narrate format:c_info "Beschreibt ausführlich wie der Fehler reproduziert werden kann, ggf. mit Link zu Videos oder Fotos!" targets:<player>
            - title "title:<red>Welche Schritte für den Fehler?" "subtitle:<white>in den Chat schreiben ..." stay:5m
            - flag <player> "player.chat.support.bug_message1:Beschreibung: <[message]>"
            - flag <player> player.chat.support.bug_message2 expire:5m
            - stop
        # message 2 - reason
        - if <player.has_flag[player.chat.support.bug_message2]>:
            - if <[length]> == 0 || <[length]> < 60:
                - narrate format:c_warn "Formuliert die notwendigen Schritte ausführlicher!" targets:<player>
                - stop
            - narrate format:c_info "Ihr habt folgende Schritte angegeben: <&a><[message]>"
            - title "title:<green>Bugreport gesendet" stay:3s
            - flag <player> "player.chat.support.bug_message2:Reproduzierung: <[message]>"
            - define description <player.flag[player.chat.support.bug_message1]>
            - define recreate <player.flag[player.chat.support.bug_message2]>
            - define subject <player.flag[player.chat.support.reason]>
            # send discordmessage
            - run support_discord def:<[p]>|<[description]>|<[recreate]>|<[subject]>
            # clean flags
            - flag <player> player.chat.support:!
            - flag <player> player.chat.busy:!

support_discord:
    type: task
    debug: true
    definitions: p|line1|line2|subject
    script:
        - ~discordmessage id:craftasybot channel:930090832281890818 "@here"
        - ~discordmessage id:craftasybot channel:930090832281890818 "embed:<discord_embed[title=:triangular_flag_on_post: Neue Supportanfrage<n>Grund: <[subject]><n>Von: <[p].name>;description=**Daten**<n><[line1]><n><[line2]>]>"
        # aaa

support_gui:
    type: inventory
    debug: true
    inventory: chest
    title: <&c><&l>Wählt Euer Anliegen
    gui: true
    slots:
    - [air] [air] [air] [air] [air] [air] [air] [air] [air]
    - [air] [air] [support_report] [air] [support_emergency] [air] [support_bug] [air] [air]
    - [air] [air] [air] [air] [air] [air] [air] [air] [gui_close]


support_report:
    type: item
    material: player_head
    display name: <&c><&l>[<&f><&l>Spieler melden<&c><&l>]
    mechanisms:
        skull_skin: 07c44e24-b8f5-4b9c-beff-ab4b9ab84d97|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTdmOWM2ZmVmMmFkOTZiM2E1NDY1NjQyYmE5NTQ2NzFiZTFjNDU0M2UyZTI1ZTU2YWVmMGE0N2Q1ZjFmIn19fQ==
    lore:
    - <&c><&l>Meldet einen Spieler
    - <&f><&m>----------
    - <&3>➤ <&a>Gebt den Namen des Spielers an.
    - <&3>➤ <&a>Gebt eine genaue Beschreibung des Grunds bzw.
    - <&a>   welche Regel gebrochen wurde und
    - <&a>   ggf. Links zu Fotos oder Videos an.
    - <&f><&m>----------
    - <&c>Wir sind keine Pädagogen, um private
    - <&c>Streitereien kümmern wir uns nicht.
    - <empty>
    - <&c>unsere Zeit ist kostbar, Missbrauch
    - <&c>kann Euch einen Permabann einhandeln!

support_emergency:
    type: item
    material: player_head
    display name: <&c><&l>[<&f><&l>Hilfe!<&c><&l>]
    mechanisms:
        skull_skin: 769e0aa3-e39c-4b23-a6cb-3926940c58df|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYWM3MzFjM2M3MjNmNjdkMmNmYjFhMTE5MmI5NDcwODZmYmEzMmFlYTQ3MmQzNDdhNWVkNWQ3NjQyZjczYiJ9fX0=
    lore:
    - <&c><&l>Hilfe anfordern
    - <&f><&m>----------
    - <&3>➤ <&a>Ihr steckt unverschuldet in einem Loch fest oder.
    - <&3>➤ <&a>könnt Euch aus einer Situation nicht selbstständig
    - <&3>➤ <&a>befreien? Wir helfen Euch, sobald wir können.
    - <empty>
    - <&3>➤ <&a>Gebt an, welches Problem aufgetreten ist.
    - <&f><&m>----------
    - <&c>unsere Zeit ist kostbar, Missbrauch
    - <&c>kann Euch einen Permabann einhandeln!

support_bug:
    type: item
    material: player_head
    display name: <&c><&l>[<&f><&l>Fehler melden<&c><&l>]
    mechanisms:
        skull_skin: 54e1a95a-028f-435a-ae78-e6cec64af80c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzRkZmQ5NjYzYzNlZTRkMzQxZDk3ZmFhYzVmYTcwZDIxM2VhZmIxNDgxM2FmMjBkNGE0MjUzNDIyNDIxNDJmIn19fQ==
    lore:
    - <&c><&l>Fehler. Bugs oder sonstige Probleme melden
    - <&f><&m>----------
    - <&3>➤ <&a>Welcher Fehler ist aufgetreten (genaue Beschreibung)
    - <&3>➤ <&a>Welche Schritte sind notwendig, um den Fehler zu erzeugen?
    - <empty>
    - <&3>➤ <&6>Gemeldete und dann behobene Fehler werden reichlich belohnt!
    - <&f><&m>----------
    - <&c>unsere Zeit ist kostbar, Missbrauch
    - <&c>kann Euch einen Permabann einhandeln!

