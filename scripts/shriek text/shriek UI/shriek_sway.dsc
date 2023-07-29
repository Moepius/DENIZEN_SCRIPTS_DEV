shriek_sway:
    type: inventory
    inventory: chest
    title: Sway Options
    size: 9
    gui: true
    procedural items:
        - define list <list>
        - foreach <script[shriek_sway_options].data_key[options]> as:i:
            - define item <item[<[i.material]>]>
            - adjust def:item display:<&f><[i.name]>
            - adjust def:item flag:ID:<[i.ID]>
            - define list:->:<[item]>
        - determine <[list]>
    slots:
        - [red_wool] [air] [air]

shriek_sway_interact:
    type: world
    debug: false
    events:
        on player clicks item in shriek_sway:
            - define location <player.flag[shriek_menu_location]>
            - if !<context.item.is_truthy>  :
                - stop
            - choose <context.item.flag[ID]>:
                - default:
                    - stop
                - case can_sway:
                    - if <[location].flag[shriek_menu.sway.can_sway].is_truthy>:
                        - flag <[location]> shriek_menu.sway.can_sway:false
                        - inventory adjust d:<player.open_inventory> slot:4 material:gray_dye
                        - inventory adjust d:<player.open_inventory> slot:4 display:<&8>DISABLED
                    - else:
                        - flag <[location]> shriek_menu.sway.can_sway:true
                        - inventory adjust d:<player.open_inventory> slot:4 material:lime_dye
                        - inventory adjust d:<player.open_inventory> slot:4 display:<&2>ENABLED
                - case speed:
                    - define name <context.item.display>
                    - define item <item[iron_axe]>
                    - define slot SWAY.SPEED
                    - if !<context.item.is_truthy>:
                        - stop
                    - inventory open d:shriek_generic_time
                    - adjust <player.open_inventory> contents:<list[<[item]>|<[item]>]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<[name]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<&f><player.flag[shriek_menu_location].flag[shriek_menu.sway.speed]>
                    - inventory adjust d:<player.open_inventory> slot:1 lore:<&b>Time<&nbsp>is<&nbsp>in<&nbsp>seconds.
                    - inventory adjust d:<player.open_inventory> slot:2 display:<[slot]>
                - case height:
                    - define name <context.item.display>
                    - define item <item[iron_axe]>
                    - define slot SWAY.HEIGHT
                    - if !<context.item.is_truthy>:
                        - stop
                    - inventory open d:shriek_generic_time
                    - adjust <player.open_inventory> contents:<list[<[item]>|<[item]>]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<[name]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<&f><player.flag[shriek_menu_location].flag[shriek_menu.sway.height]>
                    - inventory adjust d:<player.open_inventory> slot:1 lore:<&b>Time<&nbsp>is<&nbsp>in<&nbsp>seconds.
                    - inventory adjust d:<player.open_inventory> slot:2 display:<[slot]>
                - case reset:
                    - flag <[location]> shriek_menu.sway.can_sway:true
                    - flag <[location]> shriek_menu.sway.speed:10
                    - flag <[location]> shriek_menu.sway.height:0.5
                    - inventory open d:Shriek_inventory
                    - inventory adjust d:<player.open_inventory> slot:1 display:<&4>REMOVE
                    - inventory adjust d:<player.open_inventory> slot:1 flag:ID:RESET



shriek_sway_options:
    type: data
    options:
        can_sway:
            material: lime_dye
            name: Enabled
            ID: can_sway
        speed:
            material: clock
            name: Revolution Time
            ID: speed
        height:
            material: feather
            name: Sway Height
            ID: height