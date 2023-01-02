# handles all the things calculating and updating currency stuff


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


# Wenn Spieler ein Währungs Item verliert (droppt)

# Testen welche Items gedroppt wurden und deren jeweilige Anzahl
    # flag "Vermögen" oder so ähnlich um Anzahl der Items verringern
    # player.flag.currency.total_amount
    # player.flag.currency.inventory_amount


# Procedure Währung Amount Update, wird immer aufgerufen wenn sich was am Geld ändert

# calculate total currency money amount wih conversions (without gulden)
proc_calculate_currency:
    type: procedure
    definitions: groschen_amount|taler_amount
    script:
    - define taler_conv <[taler_amount].mul[64]>
    - define total_amount <[groschen_amount].add[<[taler_conv]>]>
    - determine <[total_amount]>

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

    # player.flag.currency.money_total
    # player.flag.currency.purse_total
    # player.flag.currency.inventory_total
    # player.flag.currency.bank_total
    # player.currency.bank.amount
    # player.currency.money.amount
    # player.currency.crystals.amount

# player picks up item_currency_*:

currency_handler:
    type: world
    debug: false
    enabled: true
    events:
        # interaction handling
        on player places item_currency_*:
        - determine cancelled
        on player breaks block with:item_currency_*:
        - determine cancelled
        on player right clicks block with:item_currency_*:
        - determine cancelled
        on player left clicks block with:item_currency_*:
        - determine cancelled
        # player picks up a currency item
        on player picks up item_currency_groschen:
        - if !<player.has_flag[player.flag.currency.groschen_total]>:
            - flag <player> player.flag.currency.groschen_total:0
        - flag <player> player.flag.currency.groschen_total:+:<context.item.quantity>
        on player picks up item_currency_taler:
        - if !<player.has_flag[player.flag.currency.taler_total]>:
            - flag <player> player.flag.currency.taler_total:0
        - flag <player> player.flag.currency.taler_total:+:<context.item.quantity>
        on player picks up item_currency_crystal:
        - if !<player.has_flag[player.flag.currency.crystal_total]>:
            - flag <player> player.flag.currency.crystal_total:0
        - flag <player> player.flag.currency.crystal_total:+:<context.item.quantity>
        on player picks up item_currency_gulden:
        - if !<player.has_flag[player.flag.currency.gulden_total]>:
            - flag <player> player.flag.currency.gulden_total:0
        - flag <player> player.flag.currency.gulden_total:+:<context.item.quantity>
        # player drops a currency item
        on player drops item_currency_groschen:
        - if !<player.has_flag[player.flag.currency.groschen_total]>:
            - flag <player> player.flag.currency.groschen_total:0
        - flag <player> player.flag.currency.groschen_total:-:<context.item.quantity>
        on player drops item_currency_taler:
        - if !<player.has_flag[player.flag.currency.taler_total]>:
            - flag <player> player.flag.currency.taler_total:0
        - flag <player> player.flag.currency.taler_total:-:<context.item.quantity>
        on player drops item_currency_crystal:
        - if !<player.has_flag[player.flag.currency.crystal_total]>:
            - flag <player> player.flag.currency.crystal_total:0
        - flag <player> player.flag.currency.crystal_total:-:<context.item.quantity>
        on player drops item_currency_gulden:
        - if !<player.has_flag[player.flag.currency.gulden_total]>:
            - flag <player> player.flag.currency.gulden_total:0
        - flag <player> player.flag.currency.gulden_total:-:<context.item.quantity>
        # currency amount listening
        on delta time secondly every:5000:
        - define player <server.online_players>

update_currency_task:
    type: task
    definitions: player
    script:
        - define groschen <[player].inventory.quantity_item[item_currency_groschen]>
        - define taler <[player].inventory.quantity_item[item_currency_taler]>
        - define crystal <[player].inventory.quantity_item[item_currency_energyfocus]>
        - define small_purse <[player].inventory.quantity_item[item_purse_small]>
        - define small_purse <[player].inventory.quantity_item[item_purse_medium]>
        - define small_purse <[player].inventory.quantity_item[item_purse_large]>

test_task:
    type: task
    definitions: amount
    script:
    - narrate format:c_info <proc[currency_parser].context[<[amount]>]>

# server main trade currencies

item_currency_groschen:
    type: item
    material: iron_nugget
    display name: <&f><&l>Φ Groschen
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
    material: gold_nugget
    display name: <&6>❖ <&e><&l>Taler
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
    material: gold_ingot
    display name: <&6><&l>ᛔ Gulden
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
    display name: <&d><&l>✦ Kristall
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




