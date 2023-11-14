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