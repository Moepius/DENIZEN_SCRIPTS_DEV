# server trade currency interaction handling

currency_item_handler:
  type: world
  debug: false
  events:
    on player places item_currency_*:
        - determine cancelled
    on player breaks block with:item_currency_*:
        - determine cancelled
    on player right clicks block with:item_currency_*:
        - determine cancelled
    on player left clicks block with:item_currency_*:
        - determine cancelled

# convert currencies into other currencies
currency_parser:
    type: procedure
    debug: true
    data:
        currency:
            groschen: <&7>❖
            taler: <&7>❖
            gulden: <&6>❖
    definitions: amount
    script:
    - foreach <script.parsed_key[data.currency]> key:currency as:icon:
        #Do the math. Do not show icons if there's nothing to parse.
        - if <[amount]> == 0:
            - define amount <[amount].round_down.div[100]>
            - foreach next
        #If the it's the last item, don't divide it anymore.
        - if <[currency]> == gulden:
            - define currencies:->:<[icon]><[amount].mul[100]>
            - foreach next
        #Add .round to prevent decimals in the groschen value.
        - define currencies:->:<[icon]><[amount].mod[1].mul[100].round>
        - define amount <[amount].round_down.div[100]>
    - determine <[currencies].space_separated>

test_task:
    type: task
    definitions: amount
    script:
    - narrate format:c_info <proc[currency_parser].context[<[amount]>]>

# server main trade currencies

item_currency_groschen:
    type: item
    material: beetroot_seeds
    display name: <&f><&l>Groschen
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&7>Fast überall akzeptiertes Zahlungs-
    - <&7>mittel und bei Händlern erste Wahl.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&2>Währung

item_currency_taler:
    type: item
    material: iron_nugget
    display name: <&6><&l>Taler
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&7>Von höherem Wert und beim gut
    - <&7>situierten Volke gerne gesehen.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&2>Währung

item_currency_gulden:
    type: item
    material: gold_nugget
    display name: <&6><&l>Gulden
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    lore:
    - <empty>
    - <&7>Von sehr hohem Wert. Zum Gebrauch
    - <&7>beim Handel mit Bankhäusern.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&2>Währung

item_currency_crystal:
    type: item
    material: amethyst_cluster
    display name: <&d><&l>Kristall
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    lore:
    - <empty>
    - <&d>Selten und schwer zu beschaffen,
    - <&d>können die mit thaumaturgischer Energie
    - <&d>aufgeladenen Kristalle für viele
    - <&d>Zwecke verwendet werden. Von hohem Wert
    - <&d>und eine beliebte Ressource für
    - <&d>den Handel mit Kennern.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&2><&chr[2714]> <&7>Herstellbar: <&2><&chr[2714]>
    - <&f><&m>----------------------------------
    - <&2>Währung



