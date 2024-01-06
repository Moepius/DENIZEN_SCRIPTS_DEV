
item_chorus_placer:
    type: item
    material: clay_ball
    display name: <&3><&l>Worldbuilder - Chorus Placer
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&c>Admintool
    - <&f><&m>----------
    - <empty>

item_chorus_placer_handler:
    type: world
    debug: false
    events:
        on player right clicks end_stone with:item_chorus_placer:
            - if <player.gamemode> != creative:
                - run chatsounds_error def:<player>
                - narrate format:c_warn "Dies ist ein Admintool. Nur im Creative Mode anwendbar."
                - stop
            - else:
                #
                # place blocks with coordinates from surface finder
                #
                - foreach <context.location.find_blocks[end_stone].within[30].random[400]> as:block:
                    - if <[block].above.material.name> == air:
                        - modifyblock <[block].above> chorus_flower no_physics