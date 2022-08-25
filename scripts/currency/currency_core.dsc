# handles all the things happening when a player is receiving or dropping currency items


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

# Testen welche Items gedroppt wurden (Silberlinge, Kupfer, Kristalle) und deren jeweilige Anzahl
    # flag "Vermögen" oder so ähnlich um Anzahl der Items verringern
    # player.flag.currency.total_amount
    # player.flag.currency.inventory_amount


# Procedure Währung Amount Update, wird immer aufgerufen wenn sich was am Geld ändert


proc_calculate_currency:
    type: procedure
    definitions: copperling_amount|silverling_amount|goldling_amount
    script:
    - define silverling_mul <[silverling_amount].mul[64]>
    - define goldling_mul <[silverling_mul].mul[64]>
    - define total_amount <[copperling_amount].add[<[silverling_mul]>].add[<[goldling_mul]>]>
    - determine <[total_amount]>

task_update_currency_amount:
    type: task
    # get every currency item amounts from purses of all sizes, from player inventory and bank depot
    # names example: pss - purse small copper
    definitions: player|psc|pss|psg|pmc|pms|pmg|plc|pls|plg|inv_copper|inv_silver|inv_gold|bank_amount
    script:
        # calculate total money amounts with conversions
        - define purse_small_total <proc[proc_calculate_currency].context[<[psc]>|<[pss]>|<[psg]>]>
        - define purse_medium_total <proc[proc_calculate_currency].context[<[pmc]>|<[pms]>|<[pmg]>]>
        - define purse_large_total <proc[proc_calculate_currency].context[<[plc]>|<[pls]>|<[plg]>]>
        - define inventory_total <[inv_copper].add[<[inv_silver]>].add[<[inv_gold]>]>
        - define total <[purse_small_total].add[<[purse_medium_total]>].add[<[purse_large_total]>].add[<[inventory_total]>].add[<[bank_amount]>]>
        # flag player with total amount
        - flag <[player]> player.flag.currency.money_total:<[total]>

    # player.flag.currency.money_total
    # player.flag.currency.purse_total
    # 

