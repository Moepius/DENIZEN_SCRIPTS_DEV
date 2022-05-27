# item: craftasy_gui_item
# permission: none
# flag: none
# note: none

craftasy_gui_actions:
  type: world
  debug: false
  events:
    # cancel interacting with custom item in inventory
    on player clicks craftasy_gui_item in inventory:
        - determine cancelled
    on player drags craftasy_gui_item in inventory:
        - determine passively cancelled
        - ratelimit <player> 2s
        - run chatsounds_standard
        - narrate format:c_warn "Menü Item mit <&a>SCHLEICHEN + RECHTSKLICK<&c> entfernen."
    on player drops craftasy_gui_item:
        - determine passively cancelled
        - ratelimit <player> 2s
        - run chatsounds_standard
        - narrate format:c_warn "Menü Item mit <&a>SCHLEICHEN + RECHTSKLICK<&c> entfernen."
    on player places craftasy_gui_item:
        - determine cancelled
    on player breaks block with:craftasy_gui_item:
        - determine cancelled
    # open GUI when right/left clicking, remove it when shift + right click
    on player right clicks block with:craftasy_gui_item:
        - if <player.is_sneaking>:
            - playsound <player> sound:block_sculk_sensor_clicking_stop volume:1 pitch:1
            - narrate format:c_info "Menü Item entfernt. Befehl <&a>/gui<&b> nutzen, um es wieder zu aktivieren."
            - take item:craftasy_gui_item quantity:500
        - else:
            - playsound <player> sound:ui_toast_in volume:1 pitch:1
            - wait 0.5s
            - execute as_op "interface CraftasyAdminGUI"
    on player left clicks block with:craftasy_gui_item:
        - playsound <player> sound:ui_toast_in volume:1 pitch:1
        - wait 0.5s
        - execute as_op "interface Servershop"