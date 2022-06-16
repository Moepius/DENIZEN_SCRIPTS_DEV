# item_duenger_handler
# author: Moepius
# version: 0.7.0
#
# READ ME
# Handler, um den Verzauberten Dünger zu nutzen. Platziert Blöcke (Pflanzen wie Gras und Co.)
# im Umfeld des mit dem Verzauberten Düngers angeklickten Blockes.
#
# items: item_Duenger_LVLI
# permission: craftasy.denizen.items.duengerlvl1 (ab Rang Abenteurer)
# notes: n/a
# flags: n/a
#

# TODO: Script verbessern und ergänzen
# TODO: Cooldown einbauen

# Item, um Schematics zu platzieren
# Zugehöriges World Script, das die Schematics bei Rechtsklick platziert unter World Scripts "item_duenger_handler.dsc" auffindbar.


item_duenger_handler:
    type: world
    debug: false
    events:
        on player right clicks !grass_block|podzol|dirt with:item_Duenger_*:
            - ratelimit <player> 15s
            - run chatsounds_standard
            - narrate format:c_warn "Ihr könnt den Dünger nur auf Gras, Podzol oder Dreck anwenden."
            - stop

# Dünger LVLI, ab Rang Vagabund
# platziert normales Gras und hohes Gras in einem kleinen Umkreis
item_Duenger_LVLI:
    type: item
    material: black_dye
    display name: <&3><&l>Verzauberter Dünger <&7>[<&f>I<&7>]
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&3>Dieser besondere Dünger
    - <&3>lässt Gras im Nu wachsen.
    - <empty>
    - <&7>Nur auf Gras, Podzol
    - <&7>und Dreck anwendbar.
    - <empty>
    - <&f><&m>----------
    - <&7>Ab Rang: <&a>Vagabund
    - <&7>Handelbar, Herstellbar
    - <&f><&m>----------
    - <&7>GEWÖHNLICH
    - <&6>★<&7>☆☆☆☆
    allow in material recipes: true
    recipes:
        1:
            type: shaped
            group: craftasy_items
            output_quantity: 6
            input:
            - seelenstaub|air|seelenstaub
            - air|bone_meal|air
            - seelenstaub|air|seelenstaub

item_duenger_handler_lvlI:
    type: world
    debug: false
    events:
        on player right clicks grass_block|podzol|dirt with:item_Duenger_LVLI:
            - if !<player.has_permission[craftasy.denizen.items.duengerlvl1]>:
                - run chatsounds_standard
                - narrate format:c_warn "Euer Rang ist zu niedrig. Minimun: <&2>Abenteurer"
                - stop
            - else:
                - if <player.gamemode> != creative:
                    - take iteminhand
                - playeffect effect:SOUL at:<context.location.add[0,1,0]> quantity:20 offset:2.0 targets:<player>
                - playeffect effect:CRIT_MAGIC at:<context.location.add[0,1,0]> quantity:20 offset:2.0 targets:<player>
                - playsound <player> sound:PARTICLE_SOUL_ESCAPE
                # define block location one above
                - define blab <context.location.above>
                #
                # place blocks with coordinates from data container
                #
                - foreach <script[item_duenger_data].data_key[grass_pos].random[16]> as:cord_data:
                    - foreach <[blab].add[<[cord_data]>]> as:block:
                        - if <[block].below.material.advanced_matches[grass_block|podzol|dirt]> && <[block].material.name> == air:
                            - modifyblock <[block]> grass
                - foreach <script[item_duenger_data].data_key[grass_pos].random[4]> as:cord_data:
                    - foreach <[blab].add[<[cord_data]>]> as:block:
                        - if <[block].below.material.advanced_matches[grass_block|podzol|dirt]> && <[block].material.name> == air:
                            - modifyblock <[block]> tall_grass
                            - modifyblock <[block].above> tall_grass[half=top] no_physics

#
# data conatiner with coordinates of possible locations
#
item_duenger_data:
    type: data
    grass_pos:
    - 0,0,0
    - 0,0,1
    - 1,0,0
    - 1,0,1
    - 0,0,-1
    - -1,0,0
    - -1,0,-1
    - 0,0,2
    - 2,0,0
    - 2,0,2
    - 0,0,-2
    - -2,0,0
    - -2,0,-2
    - 0,0,3
    - 3,0,0
    - 3,0,3
    - 0,0,-3
    - -3,0,0
    - -3,0,-3
    - 0,0,4
    - 4,0,0
    - 4,0,4
    - 0,0,-4
    - -4,0,0
    - -4,0,-4
    - 1,0,2
    - 2,0,1
    - 3,0,0
    - 1,0,3
    - 4,0,-1
    - -1,0,4
    - -1,0,-2

    tgrass_pos:
    - 0,0,1
    - 0,0,-1
    - 1,0,-1
    - 1,0,2
    - -1,0,-2
    - -3,0,1
    - 4,0,-1
    - 1,0,-3
    - 0,0,0
    - -1,0,1
    - -3,0,2
    - -1,0,4
    - 1,0,3


item_Duenger_LVLII:
    type: item
    material: gray_dye
    display name: <&3><&l>Verzauberter Dünger <&7>[<&f>II<&7>]
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&3>Dieser besondere Dünger lässt
    - <&3>Gras und Farn im Nu wachsen.
    - <empty>
    - <&7>Nur auf Gras, Podzol
    - <&7>und Dreck anwendbar.
    - <empty>
    - <&f><&m>----------
    - <&7>Ab Rang: <&2>Abenteurer
    - <&7>Handelbar, Herstellbar
    - <&f><&m>----------
    - <&7>GEWÖHNLICH
    - <&6>★★<&7>☆☆☆
    allow in material recipes: true
    recipes:
        1:
            type: shaped
            group: craftasy_items
            output_quantity: 12
            input:
            - seelenstaub|bone_meal|seelenstaub
            - seelenstaub|item_Duenger_LVLI|seelenstaub
            - seelenstaub|bone_meal|seelenstaub

item_Duenger_LVLIII:
    type: item
    material: cyan_dye
    display name: <&3><&l>Verzauberter Dünger <&7>[<&f>III<&7>]
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&3>Dieser besondere Dünger lässt
    - <&3>Gras und Blumen im Nu wachsen.
    - <empty>
    - <&7>Nur auf Gras, Podzol
    - <&7>und Dreck anwendbar.
    - <empty>
    - <&f><&m>----------
    - <&7>Ab Rang: <&2>Abenteurer
    - <&7>Handelbar, Herstellbar
    - <&f><&m>----------
    - <&a>SELTEN
    - <&6>★★★<&7>☆☆
    allow in material recipes: true
    recipes:
        1:
            type: shaped
            group: craftasy_items
            output_quantity: 12
            input:
            - seelenstaub|seelensplitter|seelenstaub
            - seelenstaub|item_Duenger_LVLII|seelenstaub
            - seelenstaub|seelensplitter|seelenstaub

item_Duenger_LVLIV:
    type: item
    material: lime_dye
    display name: <&3><&l>Verzauberter Dünger <&7>[<&f>IV<&7>]
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&3>Dieser besondere Dünger lässt
    - <&3>Büsche und Waldboden im Nu wachsen.
    - <empty>
    - <&7>Nur auf Gras, Podzol
    - <&7>und Dreck anwendbar.
    - <&7>Nur auf ebenem Boden verwenden!
    - <empty>
    - <&f><&m>----------
    - <&7>Ab Rang: <&2>Abenteurer
    - <&7>Handelbar, Herstellbar
    - <&f><&m>----------
    - <&d>SEHR SELTEN
    - <&6>★★★★<&7>☆
    allow in material recipes: true
    recipes:
        1:
            type: shaped
            group: craftasy_items
            output_quantity: 24
            input:
            - seelenstaub|seelensplitter|seelenstaub
            - seelensplitter|item_Duenger_LVLIII|seelensplitter
            - seelenstaub|seelensplitter|seelenstaub

# sehr teures Rezpet, als Zutat für mächtige Items verwendbar
item_Duenger_LVLV:
    type: item
    material: green_dye
    display name: <&3><&l>Verzauberter Dünger <&7>[<&f>V<&7>]
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&3>Dieser besondere Dünger lässt
    - <&3>Waldboden und Bäume im Nu wachsen.
    - <empty>
    - <&7>Nur auf Gras, Podzol
    - <&7>und Dreck anwendbar.
    - <&7>Nur auf ebenem Boden verwenden!
    - <empty>
    - <&f><&m>----------
    - <&7>Ab Rang: <&2>Abenteurer
    - <&7>Herstellbar, Zutat
    - <&f><&m>----------
    - <&e>LEGENDÄR
    - <&6>★★★★★
    allow in material recipes: true
    recipes:
        1:
            type: shaped
            group: craftasy_items
            output_quantity: 24
            input:
            - seelensplitter|seelensplitter|seelensplitter
            - seelensplitter|item_Duenger_LVLIV|seelensplitter
            - seelensplitter|seelensplitter|seelensplitter