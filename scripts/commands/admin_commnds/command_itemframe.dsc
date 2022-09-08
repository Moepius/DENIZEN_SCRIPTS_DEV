# gives the player a stick to make itemframes invisible/visible
# TODO: Permissions

command_itemframe:
    type: command
    debug: false
    name: itemframe
    description: Gibt Anwender Itemframe Tool
    usage: /itemframe
    aliases:
    - frame
    - ifr
    script:
        - if <player.gamemode> != creative:
                - run chatsounds_error def:<player>
                - narrate format:c_warn "Dies ist ein Adminbefehl. Nur im Creative Mode anwendbar."
                - stop
        - else:
            - give itemframe_tool_item

itemframe_tool_item:
    type: item
    debug: false
    material: blaze_rod
    display name: <gold><bold>Item Frame Tool
    enchantments:
    - vanishing_curse:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <empty>
    - <&a>Rechtsklick: <&3>ItemFrame unsichtbar
    - <&a>Linksklick: <&3>ItemFrame sichtbar
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&c>Admin Tool



itemframe_tool_world:
    type: world
    debug: false
    events:
        # usage
        on player damages *_item_frame with:itemframe_tool_item:
        - determine passively cancelled
        - adjust <context.entity> visible:true
        on player right clicks *_item_frame with:itemframe_tool_item:
        - determine passively cancelled
        - adjust <context.entity> visible:false
        # prevention
        after player drops itemframe_tool_item:
        - remove <context.entity>
        on player clicks in inventory with:itemframe_tool_item:
        - inject itemframe_tool_world.abuse_prevention_click
        on player drags itemframe_tool_item in inventory:
        - inject itemframe_tool_world.abuse_prevention_click
    abuse_prevention_click:
    - if <context.inventory.inventory_type> == player:
        - stop
    - if <context.inventory.inventory_type> == crafting:
        - if <context.raw_slot||<context.raw_slots.numerical.first>> >= 6:
            - stop
    - determine passively cancelled
    - inventory update