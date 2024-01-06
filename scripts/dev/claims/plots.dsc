### everything here can be changed as seen fit or necessary to make stuff work

# task for handling players that switch their mode
task_plot_changemodes:
    type: task
    debug: false
    definitions: player|gamemode|plocation
    script:
        - if <[player].flag[player.status.gamemode]> == plot_creative:
            - flag <[player]> player.plots.plot_creative_lastloc:<[plocation]>
            - flag <[player]> player.status.gamemode:plot_survival
            - group remove plot_creative
            - group add plot_survival
            - flag <[player]> player.plots.creative_inventory:<[player].inventory.list_contents>
            - inventory clear
            - inventory set o:<player.flag[player.plots.survival_inventory]>
            - cast blindness duration:2s hide_particles no_ambient no_icon <[player]>
            - playsound <[player]> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
            - playeffect effect:SPELL_WITCH at:<[player].location> visibility:500 quantity:120 offset:1.5
            - teleport <[player]> <[player].flag[player.plots.plot_survival_lastloc]>
            - run chatsounds_standard def:<[player]>
            - narrate format:c_info "Ihr seid nun im Survivalmodus."
        - else:
            - flag <[player]> player.plots.plot_survival_lastloc:<[plocation]>
            - flag <[player]> player.status.gamemode:plot_creative
            - group remove plot_survival
            - group add plot_creative
            - flag <[player]> player.plots.survival_inventory:<[player].inventory.list_contents>
            - inventory clear
            - inventory set o:<player.flag[player.plots.creative_inventory]>
            - cast blindness duration:2s hide_particles no_ambient no_icon <[player]>
            - playsound <[player]> sound:ENTITY_ENDERMAN_TELEPORT pitch:1
            - playeffect effect:SPELL_WITCH at:<[player].location> visibility:500 quantity:120 offset:1.5
            - teleport <[player]> <[player].flag[player.plots.plot_creative_lastloc]>
            - run chatsounds_standard def:<[player]>
            - narrate format:c_info "Ihr seid nun im Kreativmodus."
# # custom item scripts for currencies
# currency_groschen:
#     type: item
#     material: iron_nugget
#     display name: <&f>Φ <&l>Groschen
#     mechanisms:
#         hides: <list[ENCHANTS|ITEM_DATA]>
#     enchantments:
#     - sharpness:1
#     lore:
#     - <empty>
#     - <&7>Fast überall akzeptiertes Zahlungs-
#     - <&7>mittel und bei Händlern erste Wahl.
#     - <empty>
#     - <&f><&m>----------------------------------
#     - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
#     - <&f><&m>----------------------------------
#     - <&2>Währung
# 
# currency_taler:
#     type: item
#     material: gold_nugget
#     display name: <&6>❖ <&e><&l>Taler
#     mechanisms:
#         hides: <list[ENCHANTS|ITEM_DATA]>
#     enchantments:
#     - sharpness:1
#     lore:
#     - <empty>
#     - <&7>Von höherem Wert und beim gut
#     - <&7>situierten Volke gerne gesehen.
#     - <empty>
#     - <&f><&m>----------------------------------
#     - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
#     - <&f><&m>----------------------------------
#     - <&2>Währung
# 
# currency_gulden:
#     type: item
#     material: gold_ingot
#     display name: <&6>ᛔ <&l>Gulden
#     mechanisms:
#         hides: <list[ENCHANTS|ITEM_DATA]>
#     enchantments:
#     - sharpness:1
#     lore:
#     - <empty>
#     - <&7>Von sehr hohem Wert. Zum Gebrauch
#     - <&7>beim Handel mit Bankhäusern.
#     - <empty>
#     - <&f><&m>----------------------------------
#     - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
#     - <&f><&m>----------------------------------
#     - <&2>Währung
# 
# currency_crystal:
#     type: item
#     material: amethyst_cluster
#     display name: <&d>✦ <&l>Kristall
#     mechanisms:
#         hides: <list[ENCHANTS|ITEM_DATA]>
#     enchantments:
#     - sharpness:1
#     lore:
#     - <empty>
#     - <&d>Selten und schwer zu beschaffen,
#     - <&d>können die mit thaumaturgischer Energie
#     - <&d>aufgeladenen Kristalle für viele
#     - <&d>Zwecke verwendet werden. Von hohem Wert
#     - <&d>und eine beliebte Ressource für
#     - <&d>den Handel mit Kennern.
#     - <empty>
#     - <&f><&m>----------------------------------
#     - <&7>Zutat: <&2><&chr[2714]> <&7>Herstellbar: <&2><&chr[2714]>
#     - <&f><&m>----------------------------------
#     - <&2>Währung
# 
# # add initial flags when claiming a survival plot
# task_plot_creation_first_survival:
#     type: task
#     debug: false
#     definitions: player|plocation
#     script:
#         - flag <[player]> player.plots.plot_survival_lastloc:<[plocation]>
#         - flag <[player]> player.plots.survival_inventory:<[player].inventory.list_contents>
#         - flag <[player]> player.status.gamemode:plot_survival
# # add initial flags when claiming a creative plot
# task_plot_creation_first_creative:
#     type: task
#     debug: false
#     definitions: player|plocation
#     script:
#         - flag <[player]> player.plots.plot_creative_lastloc:<[plocation]>
#         - flag <[player]> player.plots.creative_inventory:<[player].inventory.list_contents>
#         - flag <[player]> player.status.gamemode:plot_creative
# # chatsounds for different occasions
# chatsounds_standard:
#     type: task
#     definitions: player
#     script:
#         - playsound <[player]> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
# 
# chatsounds_important:
#     type: task
#     definitions: player
#     script:
#         - ratelimit <[player]> 10s
#         - playsound <[player]> sound:entity_arrow_shoot pitch:1
# 
# chatsounds_error:
#     type: task
#     definitions: player
#     script:
#         - ratelimit <[player]> 10s
#         - playsound <[player]> sound:item_shield_block pitch:1
# 
# chatsounds_settings:
#     type: task
#     definitions: player
#     script:
#         - ratelimit <[player]> 5s
#         - playsound <[player]> sound:block_sculk_sensor_clicking_stop pitch:1
# # message formatting
# c_info:
#   type: format
#   debug: false
#   format: "<&b><&l>[<&6><&l>i<&b><&l>]<&b> <[text]>"
# 
# c_warn:
#   type: format
#   debug: false
#   format: "<&c><&l>[<&f><&l>i<&c><&l>]<&c> <[text]>"
# 
# c_debug:
#   type: format
#   debug: false
#   format: "<&f>[<&6>⚡ Debug<&f>]<&e> <[text]>"
