#Gibt Spielern Rechte und Tools, um die Spielwelten zu verwalten
# TODO: safety checks ... abschalten bei ausloggen, kein zugriff auf enderchest, xp zuwachs, etc.
# TODO: dkit_worldbuilder hierher kopieren, alte version löschen
# TODO: Gib Spieler statt normalem Craftasy Menü Item das "Erbauermodus" Item mit Zugang zu kits und speziellen Einstellungen
# TODO: Dafür sorgen, dass es keine Überschneidungen mit Inventaren in anderen Spielwelten gibt
# TODO: Fehler, wenn Spieler versucht /adminmode zu nutzen während er im Buildermode ist


command_buildermode:
    type: command
    debug: false
    name: buildermode
    description: Stellt Anwender Werkzeuge und Rechte für Großprojekte zur Verfügung.
    usage: /buildermode
    permission: craftasy.denizen.commands.buildermode
    aliases:
    - buildmode
    - erbauermodus
    - erbauer
    - buim
    script:
        - if !<player.has_permission[craftasy.denizen.commands.buildermode]>:
            - playsound <player> sound:item_shield_block pitch:1
            - ratelimit <player> 10s
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu verwenden."
            - stop
        - else:
            - if !<player.has_flag[player_in_buildermode]>:
                - flag <player> player_in_buildermode
                - run task_buildermode_enable
            - else:
                - flag <player> player_in_buildermode:!
                - run task_buildermode_disable

task_buildermode_enable:
    type: task
    debug: false
    script:
        - if <player.gamemode> != creative:
            - adjust <player> gamemode:creative
        - group add builder
        - flag <player> buildermode_player_old_inventory:<player.inventory.list_contents>
        - inventory clear
        - wait 0.5s
        - run chatsounds_standard
        - narrate format:c_info "Ihr seid nun im Erbauermodus."
task_buildermode_disable:
    type: task
    debug: false
    script:
        - if <player.gamemode> == creative:
            - adjust <player> gamemode:survival
        - group remove builder
        - inventory set o:<player.flag[buildermode_player_old_inventory]>
        - flag <player> buildermode_player_old_inventory:!
        - wait 0.5s
        - run chatsounds_standard
        - narrate format:c_info "Ihr seid nicht mehr im Erbauermodus."