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
proc_calculate_currency_purse_total:
    type: procedure
    definitions: purse_small|purse_medium|purse_large
    script:
    - define total <[purse_small].add[<[purse_medium]>].add[<[purse_large]>]>
    - determine <[total]>

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

update_currency_events:
    type: world
    debug: true
    events:
        on delta time secondly every:5:
        - define player <server.online_players>
        - foreach <[player]> as:player:
            - run 

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



