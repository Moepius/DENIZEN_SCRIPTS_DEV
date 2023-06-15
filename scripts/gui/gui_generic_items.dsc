gui_generic_events:
    type: world
    enabled: false
    events:
        on player clicks gui_close in inventory:
            - playsound <player> sound:block_sculk_sensor_clicking volume:1 pitch:0.1
            - inventory close


gui_close:
    type: item
    material: barrier
    display name: <&f><&l>[<&c><&l>Schließen<&f><&l>]
    lore:
    - <&f>Menü schließen

gui_filler:
    type: item
    material: gray_stained_glass_pane
    display name: <empty>
