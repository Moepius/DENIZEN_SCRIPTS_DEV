
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
        # flag player with default inv
        - if !<player.has_flag[player.commands.duenger.items_selected]>:
            - flag <player> player.commands.duenger.items_selected.slot12:duenger_leer
            - flag <player> player.commands.duenger.items_selected.slot13:duenger_leer
            - flag <player> player.commands.duenger.items_selected.slot14:duenger_leer
            - flag <player> player.commands.duenger.items_selected.slot15:duenger_leer
            - flag <player> player.commands.duenger.items_selected.slot16:duenger_leer
        - if !<player.has_flag[player.commands.duenger.mode_selected]>:
            - flag <player> player.commands.duenger.mode_selected:duenger_mode_air
        - inventory open d:duenger_inventory
        # <script[duenger_valid_items].data_key[items].as[list]>
        # <ListTag.replace[(regex:)<element>].with[<element>]>
        # Intensität konsistent indem Wiederholungen der PFlanzversuche mit Anzahl der gefunden Blöcke multipliziert wird, oder ein bestimmter Prozentsatz der gefundenen Blöcke durchgegangen wird

        # Modus
        # Intensität item item item item item
        # Radius

du_reset:
    type: command
    debug: false
    name: du_reset
    description: debug
    usage: /du_reset
    script:
        # reset flags
        - flag <player> player.commands.duenger.items_selected:!
        - flag <player> player.commands.duenger.mode_selected:!

duenger_inventory:
    type: inventory
    debug: true
    inventory: chest
    title: <&f><&l>Superdünger Einstellungen
    gui: true
    procedural items:
    - define items <player.flag[player.commands.duenger.items_selected].values>
    - define mode <player.flag[player.commands.duenger.mode_selected]>
    - determine <[items].include[<[mode]>]>
    slots:
    - [duenger_radius] [air] [air] [air] [air] [air] [air] [air] [air]
    - [duenger_intensity] [air] [] [] [] [] [] [air] [air]
    - [] [air] [air] [air] [air] [air] [air] [air] [gui_close]


duenger_handler:
    type: world
    debug: true
    enabled: true
    events:
        on player left clicks in duenger_inventory:
            - if <list[12|13|14|15|16].contains[<context.slot>]>:
                - if !<script[duenger_valid_items].data_key[items].as[list].contains[<context.cursor_item.material.name.if_null[air]>]>:
                    - stop
                - run core_settings "def:<player>|Auswahl geändert"
                - flag <player> player.commands.duenger.items_selected.slot<context.slot>:<context.cursor_item.material.name.if_null[duenger_leer]>
                - inventory set d:<player.open_inventory> o:<context.cursor_item.material.name.if_null[duenger_leer]> s:<context.slot>
        on player opens duenger_inventory:
            - narrate "Dünger Inventar geöffnet"

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
        - mangrove_sapling
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

#################### INVENTORY ITEMS ####################


duenger_leer:
    type: item
    material: gray_concrete
    display name: <&sp>
    mechanisms:
        hides: ITEM_DATA
    lore:
    - <empty>

duenger_item_1:
    type: item
    material: green_concrete
    display name: <&3><&l>[<&6><&l>Item 1<&3><&l>]
    mechanisms:
        hides: ITEM_DATA
    lore:
    - <&b>Radius einstellen (10 bis 100 Block)
    - <&f><&m>----------
    - <&3>➤ <&a>LINKSKLICK<&b>, um Intensität zu erhöhen (+10).
    - <&3>➤ <&a>RECHTSKLICK<&b>, um Intensität zu verringern (-10).

duenger_radius:
    type: item
    material: player_head
    display name: <&3><&l>[<&6><&l>Radius<&3><&l>]
    mechanisms:
        skull_skin: 22db6f45-8f8a-4192-936d-6a5d039279d7|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmRhNDgyNjcwYWQ3NDQ2NjA4MTg4M2ZlN2VkZDQ4ZGVjMjdhNjk4YTlhNTJjNGY4NzAzMTBiYTAzNWFjZjY5NiJ9fX0=
    lore:
    - <&b>Radius einstellen (10 bis 100 Block)
    - <&f><&m>----------
    - <&3>➤ <&a>LINKSKLICK<&b>, um Intensität zu erhöhen (+10).
    - <&3>➤ <&a>RECHTSKLICK<&b>, um Intensität zu verringern (-10).

duenger_intensity:
    type: item
    material: player_head
    display name: <&3><&l>[<&6><&l>Intensität<&3><&l>]
    mechanisms:
        skull_skin: 22db6f45-8f8a-4192-936d-6a5d039279d7|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmRhNDgyNjcwYWQ3NDQ2NjA4MTg4M2ZlN2VkZDQ4ZGVjMjdhNjk4YTlhNTJjNGY4NzAzMTBiYTAzNWFjZjY5NiJ9fX0=
    lore:
    - <&b>Intensität einstellen (0 bis 100)
    - <&f><&m>----------
    - <&3>➤ <&a>LINKSKLICK<&b>, um Intensität zu erhöhen (+10).
    - <&3>➤ <&a>RECHTSKLICK<&b>, um Intensität zu verringern (-10).

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
