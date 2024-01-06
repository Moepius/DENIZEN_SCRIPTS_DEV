# with left-clicking: teleport to the block you are looking at (up to 250 blocks away)
# right-clicking: clip through a wall you are looking at

item_teleport_stick:
    type: item
    material: blaze_rod
    display name: <&c><&l>Tolkiers Stab
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

item_teleport_stick_handler:
    type: world
    debug: true
    events:
        on player right clicks block with:item_teleport_stick:
            - determine cancelled passively
            - determine cancelled passively
            - run teleport_stick_rightclick def:<player>
        on player left clicks block with:item_teleport_stick:
            - determine cancelled passively
            - run teleport_stick_leftclick def:<player>
        after player drops item_teleport_stick:
            - remove <context.entity>
        on player breaks block with:item_teleport_stick:
            - determine cancelled

command_teleport_stick:
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
        # give player 1 item_teleport_stick
        - narrate format:c_info "Ihr erhaltet die Kraft des Gottes <&a>Tolkier<&b>. Erzittert!"
        - give item_teleport_stick

teleport_stick_leftclick:
    type: task
    debug: true
    definitions: player
    script:
        - define hit <[player].eye_location.ray_trace[range=150;entities=*;ignore=<player>;fluids=true;nonsolids=true]||null>
        - if <[hit]> != null:
            - playsound <[player]> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
            - playeffect effect:SPELL_WITCH at:<[player].location> visibility:500 quantity:120 offset:1.5
            - teleport <[player]> <[hit].forward[1].with_pose[<[player]>]> relative

teleport_stick_rightclick:
    type: task
    debug: true
    definitions: player
    script:
        - define hit <[player].eye_location.ray_trace[range=150;entities=*;ignore=<player>;fluids=true;nonsolids=true]||null>
        - if <[hit]> != null && <[hit].backward[1].material.name> == air:
            - playsound <[player]> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
            - playeffect effect:SPELL_WITCH at:<[player].location> visibility:500 quantity:120 offset:1.5
            - teleport <[player]> <[hit].backward[1].with_pose[<[player]>]> relative