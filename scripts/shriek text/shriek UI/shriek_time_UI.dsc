shriek_generic_time:
    type: inventory
    inventory: anvil
    title: Duration
    debug: false
    gui: true

shriek_generic_time_interact:
    type: world
    debug: false
    events:
        on player clicks item in shriek_generic_time slot:RESULT:
            - define item <context.item>
            - if <[item].material> == <material[iron_axe]>:
                - define new_flag <[item].display>
                - define shriek_value <context.inventory.slot[2].display>
                - flag <player.flag[shriek_menu_location]> shriek_menu.<context.inventory.slot[2].display>:<[new_flag]>
                - if <[shriek_value].contains[sway]>:
                    - inventory open d:shriek_sway
                - else:
                    - inventory open d:shriek_inventory
                    - inventory adjust d:<player.open_inventory> slot:1 display:<&4>REMOVE
                    - inventory adjust d:<player.open_inventory> slot:1 flag:ID:RESET