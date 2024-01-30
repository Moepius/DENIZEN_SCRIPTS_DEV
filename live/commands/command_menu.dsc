# Spielermenü, über Chat aufrufbar oder command

##### FUNKTIONEN #####

# Einstellungen:

# aktuelle Spielwelt mit Position anzeigen und anderen Infos
# aktuelle Position merken (zeigt die letzte gemerkte Position im Menü an), Button könnte ein kompass sein

command_menu:
    type: command
    debug: false
    name: menu
    description: open the main menu
    usage: /menu
    permission: craftasy.denizen.command.menu
    aliases:
    - m
    script:
        # open menu
        - playsound <player> sound:block_sculk_sensor_clicking volume:1 pitch:1
        - inventory open d:mainmenu_gui

mainmenu_gui:
    type: inventory
    debug: false
    inventory: chest
    title: <&3><&l>Hauptmenü
    gui: true
    slots:
    - [air] [air] [air] [air] [air] [air] [air] [air] [air]
    - [air] [air] [air] [air] [air [air] [air] [air] [air]
    - [air] [air] [air] [air] [air] [air] [air] [air] [gui_close]