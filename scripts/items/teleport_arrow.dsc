# with left-clicking: teleport to the block you are looking at (up to 250 blocks away)
# right-clicking: clip through a wall you are looking at

item_teleport_arrow:
    type: item
    material: arrow
    display name: <&c><&l>Tolkiers Pfeil
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&a>Unbändige Kraft und Anmut
    - <&7>Rechtsklick<&co>
    - <&7>Teleportiert Euch durch eine Wand
    - <&7>Linksklick<&co>
    - <&7>Teleportiert Euch zum Block,
    - <&7>welchen Ihr anvisiert
    - <empty>
    - <&f><&m>---------------------------
    - <&7>Zutat<&co> <&c><&chr[274C]> <&7>Herstellbar<&co> <&c><&chr[274C]>
    - <&f><&m>---------------------------
    - <&c>Admin

item_teleport_arrow_handler:
    type: world
    debug: true
    events:
        on player right clicks block with:item_teleport_arrow:
            - determine cancelled passively
            - define targetblock <player.cursor_on[250]>
            - define targetbehindblock <[targetblock].backward>
            - if <[targetbehindblock].material.name> == air && <[targetbehindblock].above.material.name> == air:
                - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
                - playeffect effect:SPELL_WITCH at:<player.location> visibility:500 quantity:120 offset:1.5
                - teleport <player> <[targetbehindblock]> relative
            # test if the block behind the targeted block is air and also the block above that
                # yes: teleport the player to that location (clip through a wall)
                # no: error message
        on player left clicks block with:item_teleport_arrow:
            - determine cancelled passively
            - define targetblock <player.cursor_on[250]>
            - define targetlocation <[targetblock].forward>
            - if <[targetlocation].material.name> == air && <[targetlocation].above.material.name> == air:
                - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
                - playeffect effect:SPELL_WITCH at:<player.location> visibility:500 quantity:120 offset:1.5
                - teleport <player> <[targetlocation]> relative
            # teleport player to next air block near the block he is looking at when clicking (up to 250 blocks)
        #
        # handling use cases
        on player drops item_teleport_arrow:
            - determine cancelled passively
            - take item:<context.item>
        on player places item_teleport_arrow:
        - determine cancelled
        on player breaks block with:item_teleport_arrow:
        - determine cancelled

command_teleport_arrow:
    type: command
    debug: true
    name: tolkiers_pfeil
    description: Gives you <&dq>Tolkiers Pfeil<&dq>
    usage: /tolkiers_pfeil
    aliases:
    - tpf
    script:
        # initial checks
        - if !<player.has_permission[craftasy.denizen.command.tolkiers_pfeil]>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Ihr habt keine Berechtigung, diesen Befehl zu nutzen."
            - stop
        - if !<context.args.is_empty>:
            - run chatsounds_error def:<player>
            - narrate format:c_warn "Dieser Befehl benötigt keine Parameter."
            - stop
        # give player 1 item_teleport_arrow
        - narrate format:c_info "Ihr erhaltet die Kraft des Gottes <&a>Tolkier<&b>. Erzittert!"
        - give item_teleport_arrow