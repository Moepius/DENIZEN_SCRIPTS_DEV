# handles all the things calculating and updating currency stuff

# flags:
# player.flag.currency.currency_groschen_total
# player.flag.currency.currency_taler_total
# player.flag.currency.currency_gulden_total
# player.flag.currency.currency_crystal_total


# TODO: nicht freigeschaltete Spieler können Silberlinge und Co. nicht aufnehmen, selbiges für Geldbeutel
# TODO: 

# wenn ein Spieler ein Silberling Item aufnimmt
 # Testen welche Items aufgenommen wurden (Silberlinge, Kupfer, Kristalle) und deren jeweilige Anzahl

# teste ob Spieler einen Geldbeutel im Inventar hat

# wenn ja: testen ob Platz im Geldbeutel ist
    # ja: Items in den Geldbeutel, flag "Vermögen" oder so ähnlich um Anzahl der Items erhöhen
    # nein: Items in das Inventar, flag "Vermögen" oder so ähnlich um Anzahl der Items erhöhen, Hinweis, dass Geldbeutel voll ist

# wenn nein: Items in das Inventar, flag "Vermögen" oder so ähnlich um Anzahl der Items erhöhen, Hinweis, dass Geldbeutel voll ist
# Testen ob Inventar voll ist sollte eigentlich nicht nötig sein, da die Items sonst sowieso nicht aufgenommen werden könnten

# calculate total money amount stored in purses

task_update_currency_amount:
    type: task
    # get every currency item amounts from purses of all sizes, from player inventory and bank depot
    # names example: pss - purse small copper
    definitions: player|purse_amount|inventory_amount|bank_amount
    script:
        # calculate total money amounts
        - define total <[purse_amount].add[<[inventory_amount]>].add[<[bank_amount]>]>
        # flag player with total amount
        - flag <[player]> player.flag.currency.money_total:<[total]>

currency_handler:
    type: world
    debug: false
    enabled: true
    events:
        # interaction handling
        on player places currency_*:
        - determine cancelled
        on player breaks block with:currency_*:
        - determine cancelled
        on player right clicks block with:currency_*:
        - determine cancelled
        on player left clicks block with:currency_*:
        - determine cancelled
        # player picks up a currency item
        # flags are named like this: player.flag.currency.nameofitemscriptcontainer_total
        on player picks up currency_*:
        - if !<player.has_flag[player.flag.currency.<context.item.script.name>_total]>:
            - flag <player> player.flag.currency.<context.item.script.name>_total:0
        - flag <player> player.flag.currency.<context.item.script.name>_total:+:<context.item.quantity>
        # player drops a currency item
        on player drops currency_*:
        - if !<player.has_flag[player.flag.currency.<context.item.script.name>_total]>:
            - flag <player> player.flag.currency.<context.item.script.name>_total:0
        - flag <player> player.flag.currency.<context.item.script.name>_total:-:<context.item.quantity>
        # currency amount listening
        on delta time secondly every:5000:
        - define player <server.online_players>


# server main trade currencies

currency_groschen:
    type: item
    material: iron_nugget
    display name: <&f>Φ <&l>Groschen
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    flags:
        no_crafting: no_crafting
    lore:
    - <empty>
    - <&7>Fast überall akzeptiertes Zahlungs-
    - <&7>mittel und bei Händlern erste Wahl.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&2>Währung

currency_taler:
    type: item
    material: gold_nugget
    display name: <&6>❖ <&e><&l>Taler
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    flags:
        no_crafting: no_crafting
    lore:
    - <empty>
    - <&7>Von höherem Wert und beim gut
    - <&7>situierten Volke gerne gesehen.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&2>Währung

currency_gulden:
    type: item
    material: gold_ingot
    display name: <&6>ᛔ <&l>Gulden
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
    flags:
        no_crafting: no_crafting
    lore:
    - <empty>
    - <&7>Von sehr hohem Wert. Zum Gebrauch
    - <&7>beim Handel mit Bankhäusern.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&2>Währung

currency_crystal:
    type: item
    material: amethyst_cluster
    display name: <&d>✦ <&l>Kristall
    mechanisms:
        hides: <list[ENCHANTS|ITEM_DATA]>
    enchantments:
    - sharpness:1
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




