##########################################################################################
#                                                                                        #
#                                   Item Display Editor                                  #
#                         Place and adjust items in your world!                          #
#                Version: 1.0.1                            Author: Icecapade             #
#                                                                                        #
#                                     Documentation:                                     #
# https://github.com/Hydroxycobalamin/Denizen-Script-Collection/wiki/Item-Display-Editor #
#                                                                                        #
##########################################################################################

# TODO: add protection for worlds/ zones and permissions

item_display_editor_command:
    type: command
    debug: false
    description: Spawns item displays
    usage: /ide
    name: ide
    tab completions:
        1: spawn|gui|item
    permission: item_display_editor
    script:
    - define argument <context.args.first.if_null[null]>
    - if <[argument]> == spawn:
        - define item <player.item_in_hand>
        - if <[item]> matches *air:
            - stop
        - if <player.gamemode> != creative:
            - take slot:hand
        - define location <player.eye_location.ray_trace[range=5].if_null[null]>
        - if <[location]> == null:
            - narrate format:c_warn "Ihr könnt diesen Block hier nicht platzieren"
            - stop
        - spawn item_display_editor_entity[item=<[item]>] <[location]> save:entity
        - flag <entry[entity].spawned_entity> owner:<player>
    - else if <[argument]> == gui:
        - if <player.has_flag[item_display_editor.selected_display]>:
            - inject IDE_create_inventory
            - inventory open destination:<[inventory]>
        - inventory open destination:item_display_editor_gui
    - else if <[argument]> == item:
        - give item_display_editor_item
        - wait 1t
        - if <player.item_in_hand> matches item_display_editor_item:
            - flag <player> item_display_editor.in_selection
        - narrate format:c_info "Klickt F(items tauschen) nachdem Ihr ein Display Item ausgewählt habt."
    - else:
        - narrate format:c_warn "Syntax: /ide [spawn|gui|item]"
item_display_editor_entity:
    type: entity
    debug: false
    entity_type: item_display
    mechanisms:
        item: stone
item_display_editor_gui:
    type: inventory
    debug: false
    inventory: CHEST
    title: Item Display Editor
    size: 27
    gui: true
    definitions:
        y: iron_ingot[flag=item_display_editor.type:up-down;display=<white>HOCH/RUNTER]
        x: copper_ingot[flag=item_display_editor.type:east-west;display=<white>OST/WEST]
        z: gold_ingot[flag=item_display_editor.type:north-south;display=<white>NORD/SÜD]
        scale-up-down: iron_block[flag=item_display_editor.type:scale-up-down;display=<white>SKALIERUNG HOCH/RUNTER]
        scale-east-west: copper_block[flag=item_display_editor.type:scale-east-west;display=<white>SKALIERUNG OST/WEST]
        scale-north-south: gold_block[flag=item_display_editor.type:scale-north-south;display=<white>SKALIERUNG NORD/SÜD]
        item-transform: armor_stand[flag=item_display_editor.type:item-transform;display=<white>ITEM TRANSFORMIEREN]
        remove: barrier[flag=item_display_editor.type:remove;display=<red>ENTFERNEN]
        right-x: soul_torch[flag=item_display_editor.type:right-x;display=<white>RECHTSDREHUNG X]
        right-y: soul_lantern[flag=item_display_editor.type:right-y;display=<white>RECHTSDREHUNG Y]
        right-z: soul_campfire[flag=item_display_editor.type:right-z;display=<white>RECHTSDREHUNG Z]
        left-x: torch[flag=item_display_editor.type:left-x;display=<white>LINKSDREHUNG X]
        left-y: lantern[flag=item_display_editor.type:left-y;display=<white>LINKSDREHUNG Y]
        left-z: campfire[flag=item_display_editor.type:left-z;display=<white>LINKSDREHUNG Z]
        reset: light[block_material=light[level=1];flag=item_display_editor.type:reset;display=<aqua>ZURÜCKSETZEN]
        glowing: glowstone[flag=item_display_editor.type:glowing;display=<white>LEUCHTEND]
        glow_color: glow_berries[flag=item_display_editor.type:glow_color;display=<white>LEUCHTFARBE]
    slots:
    - [item-transform] [] [left-x] [right-x] [] [] [] [glowing] [glow_color]
    - [] [] [left-y] [right-y] [] [] [scale-east-west] [scale-up-down] [scale-north-south]
    - [remove] [] [left-z] [right-z] [reset] [] [x] [y] [z]
item_display_editor_gui_handler:
    type: world
    debug: false
    events:
        on player clicks item_flagged:item_display_editor.type in item_display_editor_gui:
        - define type <context.item.flag[item_display_editor.type]>
        - inventory flag slot:hand item_display_editor.type:<[type]>
        - inventory flag slot:hand item_display_editor.glow_color:!
        on player swaps items offhand:item_display_editor_item:
        - determine passively cancelled
        - define display_item <player.flag[item_display_editor.selected_display].if_null[null]>
        - if <[display_item]> == null:
            - narrate format:c_warn "Ihr habt kein Display Item ausgewählt."
            - stop
        - define data <[display_item].display_entity_data>
        - inject IDE_create_inventory
        - inventory open destination:<[inventory]>
        on player clicks block with:item_flagged:item_display_editor.type:
        - determine passively cancelled
        - define item_display <player.flag[item_display_editor.selected_display].if_null[null]>
        - if <[item_display]> == null:
            - narrate format:c_warn  "Ihr habt kein Display Item ausgewählt."
            - stop
        - define data <[item_display].display_entity_data>
        - if <player.is_sneaking>:
            - define value 0.03125
        - else:
            - define value 0.0625
        - define click_type <context.click_type.before[_]>
        - if <[click_type]> == RIGHT:
            - define value <[value].mul[-1]>
        - choose <context.item.flag[item_display_editor.type]>:
            # Move Y
            - case up-down:
                - define vector 0,<[value]>,0
                - inject IDE_set_location
            # Move X
            - case east-west:
                - define vector <[value]>,0,0
                - inject IDE_set_location
            # Move Z
            - case north-south:
                - define vector 0,0,<[value]>
                - inject IDE_set_location
            # Scale Y
            - case scale-up-down:
                - define vector <location[0,<[value]>,0]>
                - inject IDE_set_transformation_scale
            # Scale X
            - case scale-east-west:
                - define vector <location[<[value]>,0,0]>
                - inject IDE_set_transformation_scale
            # Scale Z
            - case scale-north-south:
                - define vector <location[0,0,<[value]>]>
                - inject IDE_set_transformation_scale
            # item_transform
            - case item-transform:
                - if <[click_type]> == LEFT:
                    - define add 1
                - else:
                    - define add -1
                - define ENUM_LIST:|:NONE|THIRDPERSON_LEFTHAND|THIRDPERSON_RIGHTHAND|FIRSTPERSON_LEFTHAND|FIRSTPERSON_RIGHTHAND|HEAD|GUI|GROUND|FIXED
                - define item_transform <[data.item_transform]>
                - define index <[ENUM_LIST].find[<[item_transform]>].add[<[add]>]>
                - if <[index]> == 0:
                    - define index 9
                - if <[index]> == 10:
                    - define index 1
                - define transform <[ENUM_LIST].get[<[index]>]>
                - adjust <[item_display]> display_entity_data:<[data].with[item_transform].as[<[transform]>]>
                - narrate format:c_info "Transformation auf <[transform].custom_color[emphasis]> gesetzt."
            # remove
            - case remove:
                - if <[item_display].flag[owner].if_null[null]> != <player> && !<player.is_op>:
                    - narrate "This item does not belong to you."
                    - stop
                - give <[item_display].item>
                - remove <[item_display]>
            - case right-x:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[1|0|0]> def.type:transformation_right_rotation def.click_type:<[click_type]>
            - case right-y:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[0|1|0]> def.type:transformation_right_rotation def.click_type:<[click_type]>
            - case right-z:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[0|0|1]> def.type:transformation_right_rotation def.click_type:<[click_type]>
            - case left-x:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[1|0|0]> def.type:transformation_left_rotation def.click_type:<[click_type]>
            - case left-y:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[0|1|0]> def.type:transformation_left_rotation def.click_type:<[click_type]>
            - case left-z:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[0|0|1]> def.type:transformation_left_rotation def.click_type:<[click_type]>
            - case reset:
                - adjust <[item_display]> display_entity_data:<[data].with[transformation_right_rotation].as[0|0|0|1].with[transformation_left_rotation].as[0|0|0|1]>
                - flag <[item_display]> item_display_editor.transformation_left_rotation:!
                - flag <[item_display]> item_display_editor.transformation_right_rotation:!
            - case glowing:
                - if <[item_display].has_flag[item_display_editor.glowing]>:
                    - adjust <[item_display]> glowing:false
                    - flag <[item_display]> item_display_editor.glowing:!
                    - narrate format:c_info "Display Item leuchtet nicht mehr."
                - else:
                    - adjust <[item_display]> glowing:true
                    - flag <[item_display]> item_display_editor.glowing
                    - narrate format:c_info "Display Item leuchtet nun."
            - case glow_color:
                - if <player.item_in_hand.has_flag[item_display_editor.glow_color]>:
                    - adjust <[item_display]> display_entity_data:<[data].with[glow_color].as[<player.item_in_hand.flag[item_display_editor.glow_color]>]>
                    - stop
                - flag <player> item_display_editor.chat_input expire:30s
                - narrate format:c_info "Schreibt einen HEX oder RGB Wert in den Chat. Beispiel: 255,255,255 oder #ffff00."
            - default:
                - stop
        on player chats flagged:item_display_editor.chat_input ignorecancelled:true priority:-100:
        - determine passively cancelled
        - if <player.item_in_hand> not matches item_display_editor_item:
            - narrate format:c_warn "Ihr müsst den Item Editor in der Hand halten."
            - flag <player> item_display_editor.chat_input:!
            - stop
        - define color <color[<context.message>].if_null[null]>
        - if <[color]> == null:
            - narrate format:c_warn "Dies ist kein valider Farbcode: <context.message.custom_color[emphasis]>."
            - flag <player> item_display_editor.chat_input:!
            - stop
        - flag <player> item_display_editor.chat_input:!
        - inventory flag slot:hand item_display_editor.glow_color:<[color]>
        - narrate format:c_info "Farbcode gesetzt. Schwingt den Stab, um ihn anzuwenden!"
        on player walks flagged:item_display_editor.in_selection:
        - ratelimit <player> 2t
        - if <player.item_in_hand> not matches item_display_editor_item:
            - stop
        - define location <player.eye_location.ray_trace[range=5;default=air]>
        - define list <[location].find_entities[item_display].within[5]>
        # If no display item is in range. Remove the glowing and the flag.
        - define display_item <player.flag[item_display_editor.selected_display].if_null[<player>]>
        - if <[list].is_empty>:
            - if <player.has_flag[item_display_editor.selected_display]>:
                - if !<[display_item].has_flag[item_display_editor.glowing]>:
                    - adjust <[display_item]> glowing:false
                - flag <player> item_display_editor.selected_display:!
            - stop
        - define item_display <[list].first>
        # If the player selected item is not equal the new item, remove the glowing from the old one and add it to the new one.
        - if <[display_item]> != <[item_display]> && !<[display_item].has_flag[item_display_editor.glowing]>:
            - adjust <[display_item]> glowing:false
            - flag <player> item_display_editor.selected_display:<[item_display]>
        - flag <player> item_display_editor.selected_display:<[item_display]>
        - adjust <[item_display]> glowing:true
        on player scrolls their hotbar item:item_display_editor_item:
        - flag <player> item_display_editor.in_selection
        on player scrolls their hotbar item:!item_display_editor_item flagged:item_display_editor.in_selection:
        - inject IDE_disable_selection
        on player quits flagged:item_display_editor.in_selection:
        - inject IDE_disable_selection
        after player drops item_display_editor_item:
        - inject IDE_disable_selection
        - remove <context.entity>
item_display_editor_item:
    type: item
    material: blaze_rod
    debug: false
    display name: <&c>Item Display Editor
    lore:
    - <gold>Items austauschen (F)
    - Mit ausgewähltem Item in der Hand, öffnet den Editor.
    - <gold>Linksklick
    - Appliziert einen Effekt, sofern vorhanden.
    - <gold>Rechtsklick
    - Macht einen Effekt rückgängig, sofern vorhanden.
    - <gold>Schleichen
    - Schleichen + Klick verdoppelt den ausgewählten Wert.
    - <empty>
    - <&f><&m>---------------------------
    - <&7>Zutat<&co> <&c><&chr[274C]> <&7>Herstellbar<&co> <&c><&chr[274C]>
    - <&f><&m>---------------------------
    - <&c>Admin
## Helper methods
IDE_create_inventory:
    type: task
    debug: false
    script:
    - define inventory <inventory[item_display_editor_gui]>
    - inventory adjust slot:1 destination:<[inventory]> "lore:<&[lore]>Transformation<&co> <[data.item_transform].custom_color[emphasis]>"
    - inventory adjust slot:3 destination:<[inventory]> "lore:<&[lore]>Rotation XL<&co> <[data.transformation_left_rotation].get[1].custom_color[emphasis]>"
    - inventory adjust slot:4 destination:<[inventory]> "lore:<&[lore]>Rotation XR<&co> <[data.transformation_right_rotation].get[1].custom_color[emphasis]>"
    - inventory adjust slot:8 destination:<[inventory]> "lore:<&[lore]>Glowing<&co> <[display_item].has_flag[item_display_editor.glowing].custom_color[emphasis]>"
    - inventory adjust slot:9 destination:<[inventory]> "lore:<&[lore]>Glow color<&co> <&color[<[data.glow_color].if_null[white]>]>COLOR"
    - inventory adjust slot:12 destination:<[inventory]> "lore:<&[lore]>Rotation YL<&co> <[data.transformation_left_rotation].get[2].custom_color[emphasis]>"
    - inventory adjust slot:13 destination:<[inventory]> "lore:<&[lore]>Rotation YR<&co> <[data.transformation_right_rotation].get[2].custom_color[emphasis]>"
    - inventory adjust slot:16 destination:<[inventory]> "lore:<&[lore]>Scale EW<&co> <[data.transformation_scale].x.custom_color[emphasis]>"
    - inventory adjust slot:17 destination:<[inventory]> "lore:<&[lore]>Scale UD<&co> <[data.transformation_scale].y.custom_color[emphasis]>"
    - inventory adjust slot:18 destination:<[inventory]> "lore:<&[lore]>Scale NS<&co> <[data.transformation_scale].z.custom_color[emphasis]>"
    - inventory adjust slot:21 destination:<[inventory]> "lore:<&[lore]>Rotation ZL<&co> <[data.transformation_left_rotation].get[3].custom_color[emphasis]>"
    - inventory adjust slot:22 destination:<[inventory]> "lore:<&[lore]>Rotation ZR<&co> <[data.transformation_right_rotation].get[3].custom_color[emphasis]>"
    - inventory adjust slot:25 destination:<[inventory]> "lore:<&[lore]>Location X <[display_item].location.x.round_to[4].custom_color[emphasis]>"
    - inventory adjust slot:26 destination:<[inventory]> "lore:<&[lore]>Location Y <[display_item].location.y.round_to[4].custom_color[emphasis]>"
    - inventory adjust slot:27 destination:<[inventory]> "lore:<&[lore]>Location Z <[display_item].location.z.round_to[4].custom_color[emphasis]>"
IDE_disable_selection:
    type: task
    debug: false
    script:
    - if <player.has_flag[item_display_editor.selected_display]>:
        - if !<player.flag[item_display_editor.selected_display].has_flag[item_display_editor.glowing]>:
            - adjust <player.flag[item_display_editor.selected_display]> glowing:false
    - flag <player> item_display_editor.selected_display:!
    - flag <player> item_display_editor.in_selection:!
IDE_set_transformation_scale:
    type: task
    debug: false
    script:
    - define transformation_scale <[data.transformation_scale]>
    - adjust <[item_display]> display_entity_data:<[data].with[transformation_scale].as[<[transformation_scale].add[<[vector]>]>]>
    - narrate format:c_info "Transformations-Skalierung wurd auf <[item_display].display_entity_data.get[transformation_scale].xyz.custom_color[emphasis]> gesetzt."
IDE_set_transformation_rotation:
    type: task
    debug: false
    definitions: item_display|data|axis|type|click_type
    script:
    - if <[click_type]> == LEFT:
        - flag <[item_display]> item_display_editor.<[type]>.angle:+:5
    - else:
        - flag <[item_display]> item_display_editor.<[type]>.angle:-:5
    - adjust <[item_display]> display_entity_data:<[data].with[<[type]>].as[<[axis].proc[IDE_quaternion].context[<[item_display].flag[item_display_editor.<[type]>.angle]>]>]>
IDE_set_location:
    type: task
    debug: false
    script:
    - teleport <[item_display]> <[item_display].location.add[<[vector]>].round_to_precision[0.03125]>
    - narrate format:c_info "Die Location des Display Items wurde auf <[item_display].location.format[sx sy sz world].custom_color[emphasis]> gesetzt."
## Quaternion math.
IDE_quaternion:
    type: procedure
    debug: false
    definitions: axis|angle
    script:
    - define angle <[angle].to_radians>
    - define angle_div <[angle].div[2].sin>
    - define x <[axis].get[1].mul[<[angle_div]>]>
    - define y <[axis].get[2].mul[<[angle_div]>]>
    - define z <[axis].get[3].mul[<[angle_div]>]>
    - define w <[angle].div[2].cos>
    - define axis <[x]>|<[y]>|<[z]>|<[w]>
    - determine <[axis]>