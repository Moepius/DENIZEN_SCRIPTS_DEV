shriek_text:
    type: inventory
    inventory: chest
    title: Shrieker Text Options
    size: 9
    gui: false
    procedural items:
        - define list <list>
        - repeat 7 as:i:
            - if <player.flag[shriek_menu_location].flag[shriek_menu.text.<[i]>].is_truthy>:
                - define item <item[map]>
                - adjust def:item display:<&f><player.flag[shriek_menu_location].flag[shriek_menu.text.<[i]>]>
            - else:
                - define item <item[paper]>
                - adjust def:item display:<&f>Empty
            - define list:->:<[item]>
        - determine <[list]>

    slots:
        - [red_wool]

shriek_text_interact:
    type: world
    debug: false
    events:
        on player clicks item in shriek_text:
            - if <context.slot> > 10:
                - stop
            - define location <player.flag[shriek_menu_location]>
            - define name <context.item.display>
            - define item <item[iron_axe]>
            - define slot <context.slot.sub[1]>

            - if <context.item.material> == <material[red_wool]>:
                - flag <[location]> shriek_menu.text:!
                - flag <[location]> shriek_menu.text.1:<element[text here]>
                - flag <[location]> shriek_menu.text.2:<element[second line]>
                - inventory open d:Shriek_inventory
                - inventory adjust d:<player.open_inventory> slot:1 display:<&4>REMOVE
                - inventory adjust d:<player.open_inventory> slot:1 flag:ID:RESET
                - stop
            - if !<context.item.is_truthy>:
                - stop
            - inventory open d:shriek_text_rename save:inventory
            - adjust <player.open_inventory> contents:<list[<[item]>|<[item]>]>
            - inventory adjust d:<player.open_inventory> slot:1 display:<[name]>
            - inventory adjust d:<player.open_inventory> slot:2 display:<[slot]>
            - inventory adjust d:<player.open_inventory> slot:2 lore:<&6><element[Line to be Changed]>

shriek_text_rename:
    type: inventory
    inventory: anvil
    title: Text
    debug: false
    gui: true

shriek_text_rename_interact:
    type: world
    debug: false
    events:
        on player clicks item in shriek_text_rename slot:RESULT:
            - define item <context.item>
            - if <[item].material> == <material[iron_axe]>:
                - define text <[item].display>
                - if <[text]> == BLANK_SPACE:
                    - define text " "
                - flag <player.flag[shriek_menu_location]> shriek_menu.text.<context.inventory.slot[2].display>:<[text]>
                - inventory open d:shriek_text
                - inventory adjust d:<player.open_inventory> slot:1 display:<&4>RESET