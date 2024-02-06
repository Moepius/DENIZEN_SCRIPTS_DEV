# TODO: add undo argument
# TODO: add sea mode for sea plants
# TODO: add presets
# TODO: add farm mode (plant wheat and other farmplants on farmland block)
# TODO: add version for players, with protection for only planting plants on their plots etc.

#################### COMMAND ####################

command_duenger:
    type: command
    debug: false
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
        - run superduenger_flagging def:<player>
        - inventory open d:duenger_inventory

command_dundo:
    type: command
    debug: false
    name: dundo
    description: undo last dunger action
    usage: /dundo
    aliases:
    - duu
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.dundo]>:
            - run core_error def:<player>|<script[messages].parsed_key[error.no_permission]>
            - stop
        - if !<player.has_flag[player.commands.dundo.data]>:
            - run core_error "def:<player>|Keine Aktion im Cache vorhanden!"
            - stop
        # Have a list of lists that contain maps which contain the location and the material object of that location, before and after placing
        # # Pseudo script
        # - foreach <[locations]> as:location:
        #   - definemap data:
        #     location: <LocationTag>
        #     material_after: <MaterialTag>
        #     material: <MaterialTag>
        #   - define list:->:<[data]>
        # - define redundo:->:<[list]>
        # cylcing is per .get[index] from that first list (redundo)
        # which returns a list of maps, with data
        # if it's undo you can place <[data.material]>, if it's redo <[data.material_after]>
        # Icecapade — heute um 20:02 Uhr
        # you can get the index by the amount of undo/redo commands and save that in a flag

#################### GUI ####################

duenger_inventory:
    type: inventory
    debug: false
    inventory: chest
    title: <&f><&l>Superdünger Einstellungen
    gui: true
    data:
        plant_lore:
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK (mit Pflanze)<&b>, Pflanze wählen
        - <&3>➤ <&a>RECHTSKLICK<&b>, Intensität +1
        - <&3>➤ <&a>LINKSKLICK (ohne Pflanze)<&b>, Slot zurücksetzen
        radius_lore:
        - <&b>Radius einstellen (5 bis 50 Block)
        - <&b>Aktuell: <&a><player.flag[player.commands.duenger.data].get[radius]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, um Intensität zu erhöhen (+5).
        - <&3>➤ <&a>RECHTSKLICK<&b>, um Intensität zu verringern (-5).
        intensity_lore:
        - <&b>Intensität einstellen (0 bis 50)
        - <&b>Aktuell: <&a><player.flag[player.commands.duenger.data].get[intensity]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, um Intensität zu erhöhen (+1).
        - <&3>➤ <&a>RECHTSKLICK<&b>, um Intensität zu verringern (-1).
    definitions:
        # fill gui with non dynamic items/buttons
        mode: <item[<player.flag[player.commands.duenger.data].get[mode]>]>
        radius: <item[duenger_radius].with[lore=<script.parsed_key[data.radius_lore]>]>
        intensity: <item[duenger_intensity].with[lore=<script.parsed_key[data.intensity_lore]>]>
    procedural items:
        # fill gui with set plant items/buttons from flag
        - define plant <list>
        - define slots <list[12|13|14|15|16|21|22|23|24|25]>
        - define flag <player.flag[player.commands.duenger.data]>
        - define lore <script.parsed_key[data.plant_lore]>
        - foreach <[slots]> as:slot:
            - define intensity <[flag].deep_get[i.<[slot]>]>
            - define item <item[<[flag].deep_get[items.<[slot]>]>].with[lore=<list[<&b>Aktuelle Intensität: <[intensity]>].include[<[lore]>]>]>
            - if <[item].script.name.if_null[fallback]> == duenger_empty:
                - define item <item[duenger_empty].with[lore=<[lore]>]>
            - define plant:->:<[item]>
        - determine <[plant]>
    slots:
    - [radius] [air] [air] [air] [air] [air] [air] [air] [air]
    - [intensity] [air] [] [] [] [] [] [air] [air]
    - [mode] [air] [] [] [] [] [] [air] [gui_close]

#################### HANDLER ####################

duenger_handler:
    type: world
    debug: false
    enabled: true
    events:
        # left click action for plant slots (set plants to be placed)
        on player left clicks item in duenger_inventory:
            - if !<list[12|13|14|15|16|21|22|23|24|25].contains[<context.raw_slot>]>:
                - stop
            - define flag player.commands.duenger.data
            # reset plant and intensity to empty if player clicked with air
            # if clicked item is empty/air
            - if <context.cursor_item.material.name.if_null[air]> == air:
                # set item name at the clicked slot to placeholder item (duenger_empty)
                - flag <player> <[flag]>:<player.flag[<[flag]>].deep_with[items.<context.raw_slot>].as[duenger_empty]>
                # reset slot intensity to 1
                - define flagvaluezero <player.flag[<[flag]>].deep_with[i.<context.raw_slot>].as[1]>
                - flag <player> <[flag]>:<[flagvaluezero]>
                # define an item from player flag
                - define item <item[<player.flag[<[flag]>].deep_get[items.<context.raw_slot>]>].with[lore=<script[duenger_inventory].parsed_key[data.plant_lore]>]>
                - inventory set d:<player.open_inventory> o:<[item]> s:<context.raw_slot>
                - stop
            # set slot to item player is holding in his hand (if valid plant item from list)
            - if !<script[duenger_valid_items].data_key[items].contains[<context.cursor_item.material.name.if_null[air]>]>:
                - stop
            # replace current plant item with item player is clicking with
            - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
            - flag <player> <[flag]>:<player.flag[<[flag]>].deep_with[items.<context.raw_slot>].as[<context.cursor_item.material.name>]>
            - define intensity <player.flag[<[flag]>].deep_get[i.<context.raw_slot>]>
            - define item <item[<player.flag[<[flag]>].deep_get[items.<context.raw_slot>]>].with[lore=<list[<&b>Aktuelle Intensität: <[intensity]>].include[<script[duenger_inventory].parsed_key[data.plant_lore]>]>]>
            - inventory set d:<player.open_inventory> o:<[item]> s:<context.raw_slot>
        # right click action for plant slots (set plants individual intensity)
        on player right clicks item in duenger_inventory:
            # adjust plant item weights
            - if !<list[12|13|14|15|16|21|22|23|24|25].contains[<context.raw_slot>]>:
                - stop
            - if <context.item.script.name.if_null[fallback]> == duenger_empty:
                - stop
            - define flag player.commands.duenger.data
            - define intensity <player.flag[<[flag]>].deep_get[i.<context.raw_slot>]>
            - define newintensity <player.flag[<[flag]>].deep_with[i.<context.raw_slot>].as[<player.flag[<[flag]>].deep_get[i.<context.raw_slot>].add[1]>]>
            - if <[intensity]> >= 10:
                - define flagvaluezero <player.flag[<[flag]>].deep_with[i.<context.raw_slot>].as[0]>
                - flag <player> <[flag]>:<[flagvaluezero]>
                - define intensity <player.flag[<[flag]>].deep_get[i.<context.raw_slot>]>
                - define item <item[<player.flag[<[flag]>].deep_get[items.<context.raw_slot>]>].with[lore=<list[<&b>Aktuelle Intensität: <[intensity]>].include[<script[duenger_inventory].parsed_key[data.plant_lore]>]>]>
                - inventory set d:<player.open_inventory> o:<[item]> s:<context.slot>
                - playsound <player> sound:entity_glow_item_frame_remove_item pitch:1
                - stop
            - else:
                - flag <player> <[flag]>:<[newintensity]>
                - define intensity <player.flag[<[flag]>].deep_get[i.<context.raw_slot>]>
                - define item <item[<player.flag[<[flag]>].deep_get[items.<context.raw_slot>]>].with[lore=<list[<&b>Aktuelle Intensität: <[intensity]>].include[<script[duenger_inventory].parsed_key[data.plant_lore]>]>]>
                - inventory set d:<player.open_inventory> o:<[item]> s:<context.slot>
                - playsound <player> sound:entity_glow_item_frame_remove_item pitch:1
        # increase overall intensity
        on player left clicks duenger_intensity in duenger_inventory:
            - define flag player.commands.duenger.data
            - flag <player> <[flag]>:<player.flag[<[flag]>].with[intensity].as[<player.flag[<[flag]>].get[intensity].add[1].min[50]>]>
            - inventory set d:<player.open_inventory> o:<item[duenger_intensity].with[lore=<script[duenger_inventory].parsed_key[data.intensity_lore]>]> s:<context.slot>
        # decrease overall intensity
        on player right clicks duenger_intensity in duenger_inventory:
            - define flag player.commands.duenger.data
            - flag <player> <[flag]>:<player.flag[<[flag]>].with[intensity].as[<player.flag[<[flag]>].get[intensity].sub[1].max[1]>]>
            - inventory set d:<player.open_inventory> o:<item[duenger_intensity].with[lore=<script[duenger_inventory].parsed_key[data.intensity_lore]>]> s:<context.slot>
        # increase radius
        on player left clicks duenger_radius in duenger_inventory:
            - define flag player.commands.duenger.data
            - flag <player> <[flag]>:<player.flag[<[flag]>].with[radius].as[<player.flag[<[flag]>].get[radius].add[5].min[50]>]>
            - inventory set d:<player.open_inventory> o:<item[duenger_radius].with[lore=<script[duenger_inventory].parsed_key[data.radius_lore]>]> s:<context.slot>
        # decrease radius
        on player right clicks duenger_radius in duenger_inventory:
            - define flag player.commands.duenger.data
            - flag <player> <[flag]>:<player.flag[<[flag]>].with[radius].as[<player.flag[<[flag]>].get[radius].sub[5].max[5]>]>
            - inventory set d:<player.open_inventory> o:<item[duenger_radius].with[lore=<script[duenger_inventory].parsed_key[data.radius_lore]>]> s:<context.slot>
        # right click action for superduenger (planting plants or open settings gui)
        on player right clicks block with:superduenger:
            - determine cancelled passively
            - if <player.is_sneaking>:
                - run superduenger_flagging def:<player>
                - inventory open d:duenger_inventory
                - stop
            - if !<context.location.is_truthy>:
                - stop
            - run superduenger_flagging def:<player>
            - run superduenger_rightclick def:<player>|<context.location>
        # left click action (open settings gui)
        on player left clicks block with:superduenger:
            - determine cancelled passively
            - if <player.is_sneaking>:
                - run superduenger_flagging def:<player>
                - inventory open d:duenger_inventory
        # safety stuff
        after player drops superduenger:
            - remove <context.entity>
        on player breaks block with:superduenger:
            - determine cancelled

#################### PLANTING TASK ####################

superduenger_rightclick:
    type: task
    debug: false
    definitions: player|clicked_block
    script:
        - define valid_blocks <script[duenger_valid_blocks].data_key[blocks]>
        - define radius <[player].flag[player.commands.duenger.data].get[radius]>
        - define intensity <[player].flag[player.commands.duenger.data].get[intensity]>
        - define found_blocks <[clicked_block].find_blocks[<[valid_blocks]>].within[<[radius]>]>
        - define flag <[player].flag[player.commands.duenger.data]>
        # get all plants intensity that player has set in slots as map
        - definemap plant_intensity:
            12: <[flag].deep_get[i.12]>
            13: <[flag].deep_get[i.13]>
            14: <[flag].deep_get[i.14]>
            15: <[flag].deep_get[i.15]>
            16: <[flag].deep_get[i.16]>
            21: <[flag].deep_get[i.21]>
            22: <[flag].deep_get[i.22]>
            23: <[flag].deep_get[i.23]>
            24: <[flag].deep_get[i.24]>
            25: <[flag].deep_get[i.25]>
        - define weighted_list <list>
        - if !<[valid_blocks].contains[<[clicked_block].material.name.if_null[air]>]>:
            - stop
        # TODO: make weights more granular, so that a low value results in lower numbers of this plant planted than right now
        - foreach <[plant_intensity]>:
            # construct a weighted list from map, the higher the slot/plants intensity the more often it will be put into the list
            - flag <[player]> player.commands.duenger.weights:|:<[weighted_list].pad_left[<[value]>].with[<[key]>]>
        - foreach <[found_blocks]> as:block:
            # select random blocks in the set radius, more blocks will be chosen if overall intensity is higher
            - if !<util.random_chance[<[intensity]>]>:
                - foreach next
            # if air is above the found block
            - if <[block].above.material.name> == air:
                - define slot <[player].flag[player.commands.duenger.weights].random>
                - define plant <[player].flag[player.commands.duenger.data].deep_get[items.<[slot]>]>
                # test if found plant is an empty slot
                - if <item[<[plant]>].script.name.if_null[fallback]> == duenger_empty:
                    - foreach next
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
        - flag <[player]> player.commands.duenger.weights:!

#################### DEFAULT FLAGGING ####################

superduenger_flagging:
    type: task
    debug: false
    definitions: player
    script:
        - definemap duenger_data:
            # plants to be placed in slots, default is empty
            items:
                12: duenger_empty
                13: duenger_empty
                14: duenger_empty
                15: duenger_empty
                16: duenger_empty
                21: duenger_empty
                22: duenger_empty
                23: duenger_empty
                24: duenger_empty
                25: duenger_empty
            # individual intensity for each plant slot
            i:
                12: 1
                13: 1
                14: 1
                15: 1
                16: 1
                21: 1
                22: 1
                23: 1
                24: 1
                25: 1
            # settings
            mode: duenger_mode_air
            intensity: 10
            radius: 10
        - if !<[player].has_flag[player.commands.duenger.data]>:
            - flag <[player]> player.commands.duenger.data:<[duenger_data]>

#################### DATA ####################

duenger_valid_items:
    type: data
    debug: false
    items:
        - oak_sapling
        - spruce_sapling
        - birch_sapling
        - jungle_sapling
        - acacia_sapling
        - dark_oak_sapling
        - mangrove_propagule
        - short_grass
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
    debug: false
    items:
    - seagrass
    - sea_pickle
    - kelp

duenger_valid_blocks:
    type: data
    debug: false
    blocks:
    - grass_block
    - podzol
    - dirt
    - moss_block
    - crimson_nylium
    - warped_nylium
    - rooted_dirt
    - mud
    - muddy_mangrove_roots

duenger_large_items:
    type: data
    debug: false
    items:
    - tall_grass
    - large_fern
    - rose_bush
    - lilac
    - sunflower
    - peony

duenger_growing_items:
    type: data
    debug: false
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
    debug: false
    material: player_head
    display name: <&3><&l>[<&6><&l>Radius<&3><&l>]
    mechanisms:
        skull_skin: 22db6f45-8f8a-4192-936d-6a5d039279d7|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmRhNDgyNjcwYWQ3NDQ2NjA4MTg4M2ZlN2VkZDQ4ZGVjMjdhNjk4YTlhNTJjNGY4NzAzMTBiYTAzNWFjZjY5NiJ9fX0=

duenger_intensity:
    type: item
    debug: false
    material: player_head
    display name: <&3><&l>[<&6><&l>Intensität<&3><&l>]
    mechanisms:
        skull_skin: 22db6f45-8f8a-4192-936d-6a5d039279d7|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmRhNDgyNjcwYWQ3NDQ2NjA4MTg4M2ZlN2VkZDQ4ZGVjMjdhNjk4YTlhNTJjNGY4NzAzMTBiYTAzNWFjZjY5NiJ9fX0=

duenger_mode_water:
    type: item
    debug: false
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
    debug: false
    material: player_head
    display name: <&3><&l>[<&6><&l>Modus<&3><&l>]
    mechanisms:
        skull_skin: 0ff1bd99-7b14-48e8-98c5-868a5ce9494f|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjE0ODUzNDkwMDZlZDFjOTFiNzk1OWFmZjQ0ZjMzMGRkYWMzNWUzZDlhOTllNGE4MjA1MWY5ODZlY2RhNDc1NSJ9fX0=
    lore:
    - <&c> Noch nicht funktionsfähig!
    - <&b><&l>MODUS: <&a>NORMAL
    - <&f><&m>----------
    - <&3>➤ <&a>LINKSKLICK<&b>, um Modus zu wechseln.

duenger_empty:
    type: item
    debug: false
    material: gray_stained_glass_pane
    display name: <&c><&l>[<&f><&l>Leer<&c><&l>]
    lore:
    - <&f><&m>----------
    - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze wählen (Quelle: Hand)

superduenger:
    type: item
    debug: false
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
