# TODO: add undo argument
# TODO: add sea mode for sea plants
command_duenger:
    type: command
    debug: true
    name: duenger
    description: open the duenger GUI
    usage: /duenger
    aliases:
    - du
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.duenger]>:
            - run core_error def:<player>|<script[messages].parsed_key[error.no_permission]>
            - stop
        - if !<context.args.is_empty>:
            - run core_error def:<player>|<script[messages].parsed_key[error.no_args]>
            - stop
        # give item, if not already in inv
        - if <player.inventory.quantity_item[superduenger]> == 0:
            - give superduenger
        - run superduenger_leftclick def:<player>

duenger_inventory:
    type: inventory
    debug: true
    inventory: chest
    title: <&f><&l>Superdünger Einstellungen
    gui: true
    data:
        plants_lore_12:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.items_selected.slot12].get[2]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Intensität +1
        plants_lore_13:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.items_selected.slot13].get[2]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Intensität +1
        plants_lore_14:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.items_selected.slot14].get[2]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Intensität +1
        plants_lore_15:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.items_selected.slot15].get[2]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze auswählen
        - <&3>➤ <&a>RECHTSKLICK<&b>, Intensität +1
        plants_lore_16:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.items_selected.slot16].get[2]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Intensität +1
        radius_lore:
        - <&b>Radius einstellen (5 bis 50 Block)
        - <&b>Aktuell: <&a><player.flag[player.commands.duenger.radius]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, um Intensität zu erhöhen (+5).
        - <&3>➤ <&a>RECHTSKLICK<&b>, um Intensität zu verringern (-5).
        intensity_lore:
        - <&b>Intensität einstellen (0 bis 100 Prozent)
        - <&b>Aktuell: <&a><player.flag[player.commands.duenger.intensity]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, um Intensität zu erhöhen (+10).
        - <&3>➤ <&a>RECHTSKLICK<&b>, um Intensität zu verringern (-10).
    definitions:
        slot1: <item[<player.flag[player.commands.duenger.items_selected.slot12].as[list].get[1]>].with[lore=<script.parsed_key[data.plants_lore_12]>]>
        slot2: <item[<player.flag[player.commands.duenger.items_selected.slot13].as[list].get[1]>].with[lore=<script.parsed_key[data.plants_lore_13]>]>
        slot3: <item[<player.flag[player.commands.duenger.items_selected.slot14].as[list].get[1]>].with[lore=<script.parsed_key[data.plants_lore_14]>]>
        slot4: <item[<player.flag[player.commands.duenger.items_selected.slot15].as[list].get[1]>].with[lore=<script.parsed_key[data.plants_lore_15]>]>
        slot5: <item[<player.flag[player.commands.duenger.items_selected.slot16].as[list].get[1]>].with[lore=<script.parsed_key[data.plants_lore_16]>]>
        mode: <item[<player.flag[player.commands.duenger.mode_selected]>]>
        radius: <item[duenger_radius].with[lore=<script.parsed_key[data.radius_lore]>]>
        intensity: <item[duenger_intensity].with[lore=<script.parsed_key[data.intensity_lore]>]>
    slots:
    - [radius] [air] [air] [air] [air] [air] [air] [air] [air]
    - [intensity] [air] [slot1] [slot2] [slot3] [slot4] [slot5] [air] [air]
    - [mode] [air] [air] [air] [air] [air] [air] [air] [gui_close]

duenger_handler:
    type: world
    debug: true
    enabled: true
    events:
        on player left clicks item in duenger_inventory:
            # set slot to item player is holding in his hand (if valid plant item from list)
            - if !<list[12|13|14|15|16].contains[<context.raw_slot>]>:
                - stop
            - if !<script[duenger_valid_items].data_key[items].as[list].contains[<context.cursor_item.material.name.if_null[air]>]>:
                - stop
            - define weight <player.flag[player.commands.duenger.items_selected.slot<context.raw_slot>].get[2]>
            # replace current plant item with item player is clicking with
            - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
            - flag <player> player.commands.duenger.items_selected.slot<context.raw_slot>:<list[<context.cursor_item.material.name.if_null[grass]>|<[weight]>]>
            - define item <item[<player.flag[player.commands.duenger.items_selected.slot<context.slot>].get[1]>].with[lore=<script[duenger_inventory].parsed_key[data.plants_lore_<context.raw_slot>]>]>
            - inventory set d:<player.open_inventory> o:<[item]> s:<context.raw_slot>
        on player right clicks item in duenger_inventory:
            # adjust plant item weights
            - if !<list[12|13|14|15|16].contains[<context.slot>]>:
                - stop
            - define weight <player.flag[player.commands.duenger.items_selected.slot<context.slot>].get[2]>
            - define material <player.flag[player.commands.duenger.items_selected.slot<context.slot>].get[1]>
            - define weight <player.flag[player.commands.duenger.items_selected.slot<context.slot>].get[2]>
            - if <[weight]> == 10:
                - flag <player> player.commands.duenger.items_selected.slot<context.slot>:<list[<[material]>|0]>
                - define item <item[<player.flag[player.commands.duenger.items_selected.slot<context.slot>].get[1]>].with[lore=<script[duenger_inventory].parsed_key[data.plants_lore_<context.slot>]>]>
                - inventory set d:<player.open_inventory> o:<[item]> s:<context.slot>
                - playsound <player> sound:entity_glow_item_frame_remove_item pitch:1
                - stop
            - else:
                - define newweight <player.flag[player.commands.duenger.items_selected.slot<context.slot>].get[2].add[1]>
                - flag <player> player.commands.duenger.items_selected.slot<context.slot>:<list[<[material]>|<[newweight]>]>
                - define item <item[<player.flag[player.commands.duenger.items_selected.slot<context.slot>].get[1]>].with[lore=<script[duenger_inventory].parsed_key[data.plants_lore_<context.slot>]>]>
                - inventory set d:<player.open_inventory> o:<[item]> s:<context.slot>
                - playsound <player> sound:entity_glow_item_frame_remove_item pitch:1
        on player left clicks duenger_intensity in duenger_inventory:
            - flag <player> player.commands.duenger.intensity:<player.flag[player.commands.duenger.intensity].add[10].min[100]>
            - inventory set d:<player.open_inventory> o:<item[duenger_intensity].with[lore=<script[duenger_inventory].parsed_key[data.intensity_lore]>]> s:<context.slot>
        on player right clicks duenger_intensity in duenger_inventory:
            - flag <player> player.commands.duenger.intensity:<player.flag[player.commands.duenger.intensity].sub[10].max[0]>
            - inventory set d:<player.open_inventory> o:<item[duenger_intensity].with[lore=<script[duenger_inventory].parsed_key[data.intensity_lore]>]> s:<context.slot>
        on player left clicks duenger_radius in duenger_inventory:
            - flag <player> player.commands.duenger.radius:<player.flag[player.commands.duenger.radius].add[5].min[50]>
            - inventory set d:<player.open_inventory> o:<item[duenger_radius].with[lore=<script[duenger_inventory].parsed_key[data.radius_lore]>]> s:<context.slot>
        on player right clicks duenger_radius in duenger_inventory:
            - flag <player> player.commands.duenger.radius:<player.flag[player.commands.duenger.radius].sub[5].max[0]>
            - inventory set d:<player.open_inventory> o:<item[duenger_radius].with[lore=<script[duenger_inventory].parsed_key[data.radius_lore]>]> s:<context.slot>
        on player right clicks block with:superduenger:
            - determine cancelled passively
            - if !<context.location.is_truthy>:
                - stop
            - run superduenger_rightclick def:<player>|<context.location>
        on player left clicks block with:superduenger:
            - determine cancelled passively
            - if <player.is_sneaking>:
                - run superduenger_leftclick def:<player>
        after player drops superduenger:
            - remove <context.entity>
        on player breaks block with:superduenger:
            - determine cancelled

# rightclick action for planting in the set radius with set intensity
superduenger_rightclick:
    type: task
    debug: true
    definitions: player|clicked_block
    script:
        - define valid_blocks <script[duenger_valid_blocks].data_key[blocks].as[list]>
        - define radius <[player].flag[player.commands.duenger.radius]>
        - define intensity <[player].flag[player.commands.duenger.intensity]>
        - define found_blocks <[clicked_block].find_blocks[<[valid_blocks]>].within[<[radius]>]>
        # returns a map like slot12=grass|100;slot13=poppy|50 ... taken from player flag
        - define map <[player].flag[player.commands.duenger.items_selected]>
        - define weighted_list <list>
        - foreach <[map]>:
            - flag <[player]> player.commands.duenger.items_selected.weights:|:<[weighted_list].pad_left[<[value].get[2]>].with[<[key]>]>
        - if !<[valid_blocks].contains[<[clicked_block].material.name.if_null[air]>]>:
            - stop
        - foreach <[found_blocks]> as:block:
            - if !<util.random_chance[<[intensity]>]>:
                - foreach next
            - if <[block].above.material.name> == air:
                - define slot <[player].flag[player.commands.duenger.items_selected.weights].random>
                - define plant <[player].flag[player.commands.duenger.items_selected.<[slot]>].get[1]>
                # test if plant is 2 blocks tall
                - if <script[duenger_large_items].data_key[items].contains[<[plant]>]>:
                    - modifyblock <[block].above> <[plant]>[half=bottom] no_physics
                    - modifyblock <[block].add[0,2,0]> <[plant]>[half=top] no_physics
                    - foreach next
                # test if plant is a sapling or anything else that grows into sth. large
                - if <script[duenger_growing_items].data_key[items].contains[<[plant]>]>:
                    - modifyblock <[block].above> <[plant]> no_physics
                    - modifyblock <[block].add[0,2,0]> tripwire no_physics
                    - foreach next
                - modifyblock <[block].above> <[plant]> no_physics
        - flag <[player]> player.commands.duenger.items_selected.weights:!

# leftclick action to open the GUI
superduenger_leftclick:
    type: task
    debug: true
    definitions: player
    script:
        # flag player with default values
        - if !<[player].has_flag[player.commands.duenger.items_selected]>:
            # default plant
            - flag <[player]> player.commands.duenger.items_selected.slot12:<list[grass|10]>
            - flag <[player]> player.commands.duenger.items_selected.slot13:<list[grass|10]>
            - flag <[player]> player.commands.duenger.items_selected.slot14:<list[grass|10]>
            - flag <[player]> player.commands.duenger.items_selected.slot15:<list[grass|10]>
            - flag <[player]> player.commands.duenger.items_selected.slot16:<list[grass|10]>
        - if !<[player].has_flag[player.commands.duenger.mode_selected]>:
            - flag <[player]> player.commands.duenger.mode_selected:duenger_mode_air
        - if !<[player].has_flag[player.commands.duenger.radius]>:
            - flag <[player]> player.commands.duenger.radius:30
        - if !<[player].has_flag[player.commands.duenger.intensity]>:
            - flag <[player]> player.commands.duenger.intensity:30
        # open settings menu
        - inventory open d:duenger_inventory

#################### DATA ####################

duenger_valid_items:
    type: data
    items:
        - oak_sapling
        - spruce_sapling
        - birch_sapling
        - jungle_sapling
        - acacia_sapling
        - dark_oak_sapling
        - mangrove_propagule
        - grass
        - tall_grass
        - fern
        - large_fern
        - azalea
        - flowering_azalea
        - dead_bush
        - dandelion
        - poppy
        - blue_orchid
        - allium
        - azure_bluet
        - red_tulip
        - orange_tulip
        - white_tulip
        - pink_tulip
        - oxeye_daisy
        - cornflower
        - lily_of_the_valley
        - sunflower
        - lilac
        - rose_bush
        - peony
        - wither_rose
        - spore_blossom
        - brown_mushroom
        - red_mushroom
        - crimson_fungus
        - warped_fungus
        - crimson_roots
        - warped_roots
        - nether_sprouts
        - weeping_vines
        - twisting_vines
        - sugar_cane
        - moss_carpet
        - big_dripleaf
        - small_dripleaf
        - bamboo
        - chorus_plant
        - chorus_flower
        - cactus

duenger_valid_seaitems:
    type: data
    items:
    - seagrass
    - sea_pickle
    - kelp

duenger_valid_blocks:
    type: data
    blocks:
    - grass_block
    - podzol
    - dirt
    - coarse_dirt
    - gravel
    - moss_block
    - crimson_nylium
    - warped_nylium
    - rooted_dirt
    - mud
    - muddy_mangrove_roots
    - mycelium

duenger_large_items:
    type: data
    items:
    - tall_grass
    - large_fern
    - rose_bush
    - lilac
    - sunflower
    - peony

duenger_growing_items:
    type: data
    items:
    - oak_sapling
    - spruce_sapling
    - birch_sapling
    - jungle_sapling
    - acacia_sapling
    - dark_oak_sapling
    - mangrove_propagule

#################### INVENTORY ITEMS ####################

duenger_radius:
    type: item
    material: player_head
    display name: <&3><&l>[<&6><&l>Radius<&3><&l>]
    mechanisms:
        skull_skin: 22db6f45-8f8a-4192-936d-6a5d039279d7|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmRhNDgyNjcwYWQ3NDQ2NjA4MTg4M2ZlN2VkZDQ4ZGVjMjdhNjk4YTlhNTJjNGY4NzAzMTBiYTAzNWFjZjY5NiJ9fX0=

duenger_intensity:
    type: item
    material: player_head
    display name: <&3><&l>[<&6><&l>Intensität<&3><&l>]
    mechanisms:
        skull_skin: 22db6f45-8f8a-4192-936d-6a5d039279d7|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmRhNDgyNjcwYWQ3NDQ2NjA4MTg4M2ZlN2VkZDQ4ZGVjMjdhNjk4YTlhNTJjNGY4NzAzMTBiYTAzNWFjZjY5NiJ9fX0=

duenger_mode_water:
    type: item
    material: player_head
    display name: <&3><&l>[<&6><&l>Modus<&3><&l>]
    mechanisms:
        skull_skin: 041b4e25-2cec-4506-9a3c-92495a847454|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODhhMGY3YmQzZDU4YzU4ZmI5NWU0OGIyYjQ0OTIzZjVlYWEyYzFkNTRkY2Q3MmZhN2NlZmNiYmMxZDRjODFhZCJ9fX0=
    lore:
    - <&b><&l>MODUS: <&a>WASSER
    - <&f><&m>----------
    - <&3>➤ <&a>LINKSKLICK<&b>, um Modus zu wechseln.

duenger_mode_air:
    type: item
    material: player_head
    display name: <&3><&l>[<&6><&l>Modus<&3><&l>]
    mechanisms:
        skull_skin: 0ff1bd99-7b14-48e8-98c5-868a5ce9494f|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjE0ODUzNDkwMDZlZDFjOTFiNzk1OWFmZjQ0ZjMzMGRkYWMzNWUzZDlhOTllNGE4MjA1MWY5ODZlY2RhNDc1NSJ9fX0=
    lore:
    - <&c> Noch nicht funktionsfähig!
    - <&b><&l>MODUS: <&a>NORMAL
    - <&f><&m>----------
    - <&3>➤ <&a>LINKSKLICK<&b>, um Modus zu wechseln.

superduenger:
    type: item
    material: bone_meal
    display name: <gold><bold>Superdünger
    enchantments:
    - vanishing_curse:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <empty>
    - <&a>Rechtsklick: <&3>Pflanzen
    - <&a>Linksklick + Schleichen: <&3>Menü öffnen
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&c>Admin Tool
