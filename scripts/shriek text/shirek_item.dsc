shriek_item:
    type: item
    material: echo_shard
    display name: <&r>Shriek Text Creator
    debug: false
    flags:
        shriek_item: <util.random_uuid>
    lore:
        - <&b>Right click on a Sculk Shrieker
        - <&b>to give it the ability to spawn
        - <&b>text above when it becomes active.

shriek_item_ability:
    type: world
    debug: false
    events:
        on player right clicks sculk_shrieker with:shriek_item:
            - if !<player.has_permission[craftasy.denizen.items.shriek_item]>:
                - narrate "<&4> You do not have permission to use this."
                - stop
            - define location <context.location>
            - if !<[location].has_flag[shriek_menu]>:
                - flag <[location]> shriek_menu
                - flag <[location]> shriek_menu.duration:3
                - flag <[location]> shriek_menu.text.1:<element[text here]>
                - flag <[location]> shriek_menu.text.2:<element[second line]>
                - flag <[location]> shriek_menu.fade_in:1
                - flag <[location]> shriek_menu.fade_out:1
                - flag <[location]> shriek_menu.sway.can_sway:true
                - flag <[location]> shriek_menu.sway.speed:10
                - flag <[location]> shriek_menu.sway.height:0.5

            - determine passively cancelled
            - flag <player> shriek_menu_location:<[location]>
            - inventory open d:Shriek_inventory
            - inventory adjust d:<player.open_inventory> slot:1 display:<&4>REMOVE
            - inventory adjust d:<player.open_inventory> slot:1 flag:ID:RESET