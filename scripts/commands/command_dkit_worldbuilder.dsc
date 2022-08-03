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
                - run chatsounds_error def:<player>
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
            - give item_worldbuilder_duenger_seegras


############################################
# Worldbuilder Dünger - Waldboden
############################################

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

#TODO: Error in Konsole fixen
#TODO: SHIFT + LINKSKLICK Dichte erhöhen
#TODO: Testen ob unter tall_seagrass auch Wasser ist

item_worldbuilder_duenger_waldboden_handler:
    type: world
    debug: false
    events:
        on player right clicks !grass_block|podzol|dirt with:item_worldbuilder_duenger_waldboden:
            - ratelimit <player> 15s
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr könnt den Dünger nur auf Gras, Podzol oder Dreck anwenden."
            - stop
        on player right clicks grass_block|podzol|dirt with:item_worldbuilder_duenger_waldboden:
            - if <player.gamemode> != creative:
                - run chatsounds_error def:<player>
                - narrate format:c_warn "Dies ist ein Admintool. Nur im Creative Mode anwendbar."
                - stop
            - if <player.has_flag[player.flag.duenger.cooldown]>:
                - run chatsounds_error def:<player>
                - narrate format:c_warn "Wartet den Cooldown ab (2s)."
                - stop
            - else:
                #
                # place blocks with coordinates from surface finder
                #
                - foreach <context.location.find_blocks[grass_block|dirt|podzol|stone].within[15].random[200]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> grass no_physics
                - foreach <context.location.find_blocks[grass_block|dirt|podzol|stone].within[15].random[200]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> fern no_physics
                - foreach <context.location.find_blocks[grass_block|dirt|podzol|stone].within[15].random[15]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> brown_mushroom no_physics
                - foreach <context.location.find_blocks[grass_block|dirt|podzol|stone].within[15].random[1]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> oxeye_daisy no_physics
                - foreach <context.location.find_blocks[grass_block|dirt|podzol|stone].within[15].random[2]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> azure_bluet no_physics
                - foreach <context.location.find_blocks[grass_block|dirt|podzol|stone].within[15].random[1]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> white_tulip no_physics
                - foreach <context.location.find_blocks[grass_block|dirt|podzol|stone].within[15].random[1]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> blue_orchid no_physics
                - foreach <context.location.find_blocks[grass_block|dirt|podzol|stone].within[15].random[2]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> cornflower no_physics
                - foreach <context.location.find_blocks[grass_block|dirt|podzol|stone].within[15].random[1]> as:block:
                    - if <[block].above.material.name> == air:
                            - modifyblock <[block].above> allium no_physics

############################################
# Worldbuilder Dünger - Seegras
############################################

item_worldbuilder_duenger_seegras:
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
    - <&7>| Seegras Radius |
    - <&7>Radius mit <&a>SHIFT <&7>+ <&a>RECHTSKLICK <&7>einstellen
    - <empty>
#TODO: mehr Blöcke hinzufügen auf denen Seegras platziert werden kann
item_worldbuilder_duenger_seegras_handler:
    type: world
    debug: false
    events:

        # Set radius
        on player right clicks block with:item_worldbuilder_duenger_seegras:
        - if <player.is_sneaking>:
            - playsound chatsounds_settings def:<player>
            - if <player.flag[player.flag.item.seegrasradius]> == 50:
                - flag <player> player.flag.item.seegrasradius:10 expire:3h
            - else:
                - flag <player> player.flag.item.seegrasradius:+:10 expire:3h
            - narrate format:c_info "Der Dünger wurde auf den Radius <&a><player.flag[player.flag.item.seegrasradius]> <&b>eingestellt."
        # Set density
        on player left clicks block with:item_worldbuilder_duenger_seegras:
        - if <player.is_sneaking>:
            - playsound chatsounds_settings def:<player>
            - if <player.flag[player.flag.item.seegrasdichte]> == 50:
                - flag <player> player.flag.item.seegrasdichte:10 expire:3h
            - else:
                - flag <player> player.flag.item.seegrasdichte:+:10 expire:3h
            - narrate format:c_info "Der Dünger wurde auf die Dichte <&a><player.flag[player.flag.item.seegrasradius]><&pc> <&b>eingestellt."
        on player right clicks !gravel|sand|dirt|stone with:item_worldbuilder_duenger_seegras:
            - if <player.is_sneaking>:
                - stop
            - ratelimit <player> 15s
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr könnt den Dünger hier nicht anwenden."
            - stop
        on player right clicks gravel|sand|dirt|stone with:item_worldbuilder_duenger_seegras:
            - if <player.is_sneaking>:
                - stop
            - if <player.gamemode> != creative:
                - run chatsounds_error def:<player>
                - narrate format:c_warn "Dies ist ein Admintool. Nur im Creative Mode anwendbar."
                - stop
            - if <player.has_flag[player.flag.duenger.cooldown]>:
                - run chatsounds_error def:<player>
                - narrate format:c_warn "Wartet den Cooldown ab (2s)."
                - stop
            - if !<player.has_flag[player.flag.item.seegrasdichte]>:
                - flag <player> player.flag.item.seegrasdichte:10 expire:3h
            - if !<player.has_flag[player.flag.item.seegrasradius]>:
                - flag <player> player.flag.item.seegrasradius:30 expire:3h
            - flag <player> player.flag.duenger.cooldown expire:2s
            #
            # place blocks with coordinates from surface finder with radius 10, 20, 30, 40, 50
            #
            - if <player.flag[player.flag.item.seegrasradius]> == 10:
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[10].random[<player.flag[player.flag.item.seegrasdichte].mul[10]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> seagrass no_physics
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[10].random[<player.flag[player.flag.item.seegrasdichte].mul[5]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> tall_seagrass no_physics
                    - if <[block].add[0,2,0].material.name> == water:
                        - modifyblock <[block].add[0,2,0]> tall_seagrass[half=top] no_physics
            - if <player.flag[player.flag.item.seegrasradius]> == 20:
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[20].random[<player.flag[player.flag.item.seegrasdichte].mul[20]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> seagrass no_physics
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[20].random[<player.flag[player.flag.item.seegrasdichte].mul[10]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> tall_seagrass no_physics
                    - if <[block].add[0,2,0].material.name> == water:
                        - modifyblock <[block].add[0,2,0]> tall_seagrass[half=top] no_physics
            - if <player.flag[player.flag.item.seegrasradius]> == 30:
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[30].random[<player.flag[player.flag.item.seegrasdichte].mul[30]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> seagrass no_physics
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[30].random[<player.flag[player.flag.item.seegrasdichte].mul[15]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> tall_seagrass no_physics
                    - if <[block].add[0,2,0].material.name> == water:
                        - modifyblock <[block].add[0,2,0]> tall_seagrass[half=top] no_physics
            - if <player.flag[player.flag.item.seegrasradius]> == 40:
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[40].random[<player.flag[player.flag.item.seegrasdichte].mul[40]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> seagrass no_physics
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[40].random[<player.flag[player.flag.item.seegrasdichte].mul[20]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> tall_seagrass no_physics
                    - if <[block].add[0,2,0].material.name> == water:
                        - modifyblock <[block].add[0,2,0]> tall_seagrass[half=top] no_physics
            - if <player.flag[player.flag.item.seegrasradius]> == 50:
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[50].random[<player.flag[player.flag.item.seegrasdichte].mul[50]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> seagrass no_physics
                - foreach <context.location.find_blocks[gravel|sand|dirt|stone].within[50].random[<player.flag[player.flag.item.seegrasdichte].mul[25]>]> as:block:
                    - if <[block].above.material.name> == water:
                        - modifyblock <[block].above> tall_seagrass no_physics
                    - if <[block].add[0,2,0].material.name> == water:
                        - modifyblock <[block].add[0,2,0]> tall_seagrass[half=top] no_physics