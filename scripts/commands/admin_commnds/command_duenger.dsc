# TODO: add undo argument

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
        # <script[duenger_valid_items].data_key[items].as[list]>
        # <ListTag.replace[(regex:)<element>].with[<element>]>

duenger_inventory:
    type: inventory
    debug: true
    inventory: chest
    title: <&f><&l>Superdünger Einstellungen
    gui: true
    data:
        plants_lore_1:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.plant_intensity.1]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze zurücksetzen (Gras)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>SCHLECHEN + LINKSKLICK<&b>, Intensität +10
        - <&3>➤ <&a>SCHLEICHEN + RECHTSKLICK<&b>, Intensität -10
        plants_lore_2:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.plant_intensity.2]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze zurücksetzen (Gras)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>SCHLECHEN + LINKSKLICK<&b>, Intensität +10
        - <&3>➤ <&a>SCHLEICHEN + RECHTSKLICK<&b>, Intensität -10
        plants_lore_3:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.plant_intensity.3]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze zurücksetzen (Gras)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>SCHLECHEN + LINKSKLICK<&b>, Intensität +10
        - <&3>➤ <&a>SCHLEICHEN + RECHTSKLICK<&b>, Intensität -10
        plants_lore_4:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.plant_intensity.4]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze zurücksetzen (Gras)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>SCHLECHEN + LINKSKLICK<&b>, Intensität +10
        - <&3>➤ <&a>SCHLEICHEN + RECHTSKLICK<&b>, Intensität -10
        plants_lore_5:
        - <&b>Aktuelle Intensität: <&a><player.flag[player.commands.duenger.plant_intensity.5]>
        - <&f><&m>----------
        - <&3>➤ <&a>LINKSKLICK<&b>, Pflanze zurücksetzen (Gras)
        - <&3>➤ <&a>RECHTSKLICK<&b>, Pflanze wählen (Quelle: Hand)
        - <&3>➤ <&a>SCHLECHEN + LINKSKLICK<&b>, Intensität +10
        - <&3>➤ <&a>SCHLEICHEN + RECHTSKLICK<&b>, Intensität -10
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
        slot1: <item[<player.flag[player.commands.duenger.items_selected.slot12]>].with[lore=<script.parsed_key[data.plants_lore_1]>]>
        slot2: <item[<player.flag[player.commands.duenger.items_selected.slot13]>].with[lore=<script.parsed_key[data.plants_lore_2]>]>
        slot3: <item[<player.flag[player.commands.duenger.items_selected.slot14]>].with[lore=<script.parsed_key[data.plants_lore_3]>]>
        slot4: <item[<player.flag[player.commands.duenger.items_selected.slot15]>].with[lore=<script.parsed_key[data.plants_lore_4]>]>
        slot5: <item[<player.flag[player.commands.duenger.items_selected.slot16]>].with[lore=<script.parsed_key[data.plants_lore_5]>]>
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
    # - flag <player> the_flag:<player.flag[the_flag].add[10].min[100]>
        on player left clicks in duenger_inventory:
            - if <list[12|13|14|15|16].contains[<context.slot>]>:
                - if !<script[duenger_valid_items].data_key[items].as[list].contains[<context.cursor_item.material.name.if_null[air]>]>:
                    - stop
                - run core_settings "def:<player>|Auswahl geändert"
                - flag <player> player.commands.duenger.items_selected.slot<context.slot>:<context.cursor_item.material.name.if_null[duenger_leer]>
                - inventory set d:<player.open_inventory> o:<context.cursor_item.material.name.if_null[duenger_leer]> s:<context.slot>
        on player opens duenger_inventory:
            - narrate "Dünger Inventar geöffnet"
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
        - if !<[valid_blocks].contains[<[clicked_block].material.name.if_null[air]>]>:
            - stop
        - foreach <[found_blocks]> as:block:
            - if !<util.random_chance[<[intensity]>]>:
                - foreach next
            - if <[block].above.material.name> == air:
                - define plant <[player].flag[player.commands.duenger.items_selected].values.random>
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

# leftclick action to open the GUI
# ex flag <player> player.commands.duenger.radius:30
superduenger_leftclick:
    type: task
    debug: true
    definitions: player
    script:
        # flag player with default values
        - narrate "leftclick action" targets:<[player]>
        - if !<[player].has_flag[player.commands.duenger.items_selected]>:
            # default plant
            - flag <[player]> player.commands.duenger.items_selected.slot12:grass
            - flag <[player]> player.commands.duenger.items_selected.slot13:grass
            - flag <[player]> player.commands.duenger.items_selected.slot14:grass
            - flag <[player]> player.commands.duenger.items_selected.slot15:grass
            - flag <[player]> player.commands.duenger.items_selected.slot16:grass
        - if !<[player].has_flag[player.commands.duenger.plant_intensity]>:
            # default plant intensity
            - flag <[player]> player.commands.duenger.plant_intensity.1:100
            - flag <[player]> player.commands.duenger.plant_intensity.2:100
            - flag <[player]> player.commands.duenger.plant_intensity.3:100
            - flag <[player]> player.commands.duenger.plant_intensity.4:100
            - flag <[player]> player.commands.duenger.plant_intensity.5:100
        - if !<[player].has_flag[player.commands.duenger.mode_selected]>:
            - flag <[player]> player.commands.duenger.mode_selected:duenger_mode_air
        - if !<[player].has_flag[player.commands.duenger.radius]>:
            - flag <[player]> player.commands.duenger.radius:30
        - if !<[player].has_flag[player.commands.duenger.intensity]>:
            - flag <[player]> player.commands.duenger.intensity:30
        # open settings menu
        - inventory open d:duenger_inventory

#################### DATA ####################

#TODO: make seperate list for valid sea and earth plants
duenger_valid_items:
    type: data
    items:
        - seagrass
        - sea_pickle
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
        - kelp
        - moss_carpet
        - big_dripleaf
        - small_dripleaf
        - bamboo
        - chorus_plant
        - chorus_flower
        - cactus

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
