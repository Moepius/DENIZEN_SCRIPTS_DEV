shriek_inventory:
    type: inventory
    inventory: chest
    title: Shrieker Text Options
    size: 9
    gui: true
    procedural items:
        - define list <list>
        - foreach <script[shriek_options].data_key[options]> as:i:
            - define item <item[<[i.material]>]>
            - adjust def:item display:<&f><[i.name]>
            - adjust def:item flag:ID:<[i.ID]>
            - define list:->:<[item]>
        - determine <[list]>
    slots:
        - [red_wool] [air]

shriek_inventory_interact:
    type: world
    debug: false
    events:
        on player clicks item in shriek_inventory:
            - define location <player.flag[shriek_menu_location]>
            - if !<context.item.is_truthy> || <context.item.material> == <material[gray_dye]>:
                - stop
            - choose <context.item.flag[ID]>:
                - default:
                    - stop
                - case TEXT:
                    - inventory open d:shriek_text
                    - inventory adjust d:<player.open_inventory> slot:1 display:<&4>RESET
                - case FADE_IN:
                    - define name <context.item.display>
                    - define item <item[iron_axe]>
                    - define slot FADE_IN
                    - if !<context.item.is_truthy>:
                        - stop
                    - inventory open d:shriek_generic_time
                    - adjust <player.open_inventory> contents:<list[<[item]>|<[item]>]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<[name]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<&f><player.flag[shriek_menu_location].flag[shriek_menu.fade_in]>
                    - inventory adjust d:<player.open_inventory> slot:1 lore:<&b>Time<&nbsp>is<&nbsp>in<&nbsp>seconds.
                    - inventory adjust d:<player.open_inventory> slot:2 display:<[slot]>
                - case DURATION:
                    - define name <context.item.display>
                    - define item <item[iron_axe]>
                    - define slot DURATION
                    - if !<context.item.is_truthy>:
                        - stop
                    - inventory open d:shriek_generic_time
                    - adjust <player.open_inventory> contents:<list[<[item]>|<[item]>]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<[name]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<&f><player.flag[shriek_menu_location].flag[shriek_menu.duration]>
                    - inventory adjust d:<player.open_inventory> slot:1 lore:<&b>Time<&nbsp>is<&nbsp>in<&nbsp>seconds.
                    - inventory adjust d:<player.open_inventory> slot:2 display:<[slot]>
                - case FADE_OUT:
                    - define name <context.item.display>
                    - define item <item[iron_axe]>
                    - define slot FADE_OUT
                    - if !<context.item.is_truthy>:
                        - stop
                    - inventory open d:shriek_generic_time
                    - adjust <player.open_inventory> contents:<list[<[item]>|<[item]>]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<[name]>
                    - inventory adjust d:<player.open_inventory> slot:1 display:<&f><player.flag[shriek_menu_location].flag[shriek_menu.fade_out]>
                    - inventory adjust d:<player.open_inventory> slot:1 lore:<&b>Time<&nbsp>is<&nbsp>in<&nbsp>seconds.
                    - inventory adjust d:<player.open_inventory> slot:2 display:<[slot]>
                - case SWAY:
                    - inventory open d:shriek_sway
                    - inventory adjust d:<player.open_inventory> slot:1 display:<&4>RESET
                    - inventory adjust d:<player.open_inventory> slot:1 flag:ID:RESET
                    - if <[location].flag[shriek_menu.sway.can_sway].is_truthy>:
                        - inventory adjust d:<player.open_inventory> slot:4 material:lime_dye
                        - inventory adjust d:<player.open_inventory> slot:4 display:<&2>ENABLED
                    - else:
                        - inventory adjust d:<player.open_inventory> slot:4 material:gray_dye
                        - inventory adjust d:<player.open_inventory> slot:4 display:<&8>DISABLED
                - case reset:
                    - flag <[location]> shriek_menu:!
                    - inventory close

shriek_options:
    type: data
    options:
        text:
            material: oak_sign
            name: Text
            ID: TEXT
        Fade_In:
            material: glow_ink_sac
            name: Fade In
            ID: FADE_IN
        duration:
            material: clock
            name: Duration
            ID: DURATION
        Fade_Out:
            material: ink_sac
            name: Fade Out
            ID: FADE_OUT
        sway:
            material: feather
            name: Sway
            ID: SWAY