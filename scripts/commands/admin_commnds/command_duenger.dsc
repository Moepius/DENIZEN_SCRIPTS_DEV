
command_duenger:
    type: command
    debug: false
    name: duenger
    description: teleport to your last location
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

duenger_leer:
    type: item
    material: gray_stained_glass_pane
    display name: <empty>
    mechanisms:
        hides: ITEM_DATA
    lore:
    - <empty>

duenger_handler:
    type: world
    debug: true
    enabled: true
    events:
        on player clicks !air in duenger_inventory:
            - narrate "Klick!"

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