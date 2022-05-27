# Gibt ein Kit, mit wichtigen items, um Worldedit, Brushes und Custom item nutzen zu können.
#
# Permission: crafatsy.denizen.commands.dkit.worldbuilder

command_dkit_worldbuilder:
    type: command
    debug: false
    name: dkit worldbuilder
    description: Gibt Anwender Worldbuilder Tools
    usage: /dkit worldbuilder
    permission: craftasy.denizen.commands.dkit.worldbuilder
    aliases:
    - worldbuilder
    - dkitwb
    script:
        - if <player.gamemode> != creative:
                - run chatsounds_standard
                - narrate format:c_warn "Dies ist ein Adminbefehl. Nur im Creative Mode anwendbar."
                - stop
        - else:
            - give wooden_axe
            - execute as_player "/wand"
            - wait 0.5s
            - give wooden_shovel
            - give golden_shovel
            - give leather
            - give light
            - give barrier
            - give debug_stick
            - give item_worldbuilder_duenger_waldboden


item_worldbuilder_duenger_handler:
    type: world
    debug: false
    events:
        on player right clicks !grass_block|podzol|dirt with:item_worldbuilder_duenger_*:
            - ratelimit <player> 15s
            - run chatsounds_standard
            - narrate format:c_warn "Ihr könnt den Dünger nur auf Gras, Podzol oder Dreck anwenden."
            - stop

#
item_worldbuilder_duenger_waldboden:
    type: item
    material: clay_ball
    display name: <&3><&l>Worldbuilder - Dünger Waldboden
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&c>Admintool
    - <&f><&m>----------
    - <&7>| Waldvariante 1 |
    - <&7>Farn, Gras, Pilze braun und Blumen
    - <empty>

# TODO: Error in Konsole fixen

item_worldbuilder_duenger_waldboden_handler:
    type: world
    debug: false
    events:
        on player right clicks grass_block|podzol|dirt with:item_worldbuilder_duenger_waldboden:
            - if <player.gamemode> != creative:
                - run chatsounds_standard
                - narrate format:c_warn "Dies ist ein Admintool. Nur im Creative Mode anwendbar."
                - stop
            - else:
                #
                # place blocks with coordinates from surface finder
                #
                - foreach <context.location.find.surface_blocks[grass_block|dirt|podzol|stone].within[15].random[200]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> grass
                - foreach <context.location.find.surface_blocks[grass_block|dirt|podzol|stone].within[15].random[200]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> fern
                - foreach <context.location.find.surface_blocks[grass_block|dirt|podzol|stone].within[15].random[15]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> brown_mushroom
                - foreach <context.location.find.surface_blocks[grass_block|dirt|podzol|stone].within[15].random[1]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> oxeye_daisy
                - foreach <context.location.find.surface_blocks[grass_block|dirt|podzol|stone].within[15].random[2]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> azure_bluet
                - foreach <context.location.find.surface_blocks[grass_block|dirt|podzol|stone].within[15].random[1]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> white_tulip
                - foreach <context.location.find.surface_blocks[grass_block|dirt|podzol|stone].within[15].random[1]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> blue_orchid
                - foreach <context.location.find.surface_blocks[grass_block|dirt|podzol|stone].within[15].random[2]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> cornflower
                - foreach <context.location.find.surface_blocks[grass_block|dirt|podzol|stone].within[15].random[1]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> allium