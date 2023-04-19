
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
            - run core_error def:<player>|<script.parsed_key[messages].data_key[error.no_permission]>
            - stop
        - if !<context.args.is_empty>::
            - run core_error def:<player>|<script.parsed_key[messages].data_key[error.no_args]>
            - stop
        - if !<player.has_flag[player.commands.duenger.items_selected]>:
            - flag <player> player.commands.duenger.items_selected:duenger_leer|duenger_leer|duenger_leer|duenger_leer|duenger_leer
        - inventory open d:duenger_inventory
        # <script[duenger_valid_items].data_key[items].as[list]>
        # <ListTag.replace[(regex:)<element>].with[<element>]>
        # Intensität konsistent indem Wiederholungen der PFlanzversuche mit Anzahl der gefunden Blöcke multipliziert wird, oder ein bestimmter Prozentsatz der gefundenen Blöcke durchgegangen wird

        # Modus
        # Intensität item item item item item
        # Radius

duenger_inventory:
    type: inventory
    debug: true
    inventory: chest
    title: <&f><&l>Superdünger
    gui: true
    procedural items:
    - define items <player.flag[player.commands.duenger.items_selected]>
    slots:
    - [air] [air] [air] [air] [air] [air] [air] [air] [air]
    - [air] [] [] [] [] [] [] [] [air]
    - [air] [air] [air] [air] [air] [air] [air] [air] [air]


duenger_handler:
    type: world
    debug: true
    enabled: true
    events:
        on player clicks !air in duenger_inventory:
            - narrate "Klick!"
            -
        on player opens duenger_inventory:
            - narrate "test"

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

duenger_leer:
    type: item
    material: gray_stained_glass_pane
    display name: <empty>
    mechanisms:
        hides: ITEM_DATA
    lore:
    - <empty>

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