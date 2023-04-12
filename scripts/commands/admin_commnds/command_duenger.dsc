
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