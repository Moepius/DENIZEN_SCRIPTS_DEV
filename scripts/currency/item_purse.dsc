# purse items to store currency items in them (only currency items)

# Handling

# <InventoryTag.contains_item[<matcher>].quantity[<#>]>
# <InventoryTag.contains_item[<matcher>]>

purse_handler:
  type: world
  debug: true
  events:
    # TODO: more tests for many cases needed when players do stuff with the purse items
    # TODO: when player has a purse in inventory and collects currency items, automatically put them in the largest available purse
    # TODO: tests for creative/builder/adminmodes, cancel using purse when not in survival

    # open up purse inventory and fill it with flagged contents from item (if flag exists)
    on player right clicks block with:item_purse:
      - determine passively cancelled
      - ratelimit <player> 1t
      - define item <context.item.script.name>
      - narrate "Geldbeutel geöffnet"
      - flag <player> player.currency.purse.opena
      # has item a purse flag?
      # no: open empty dummy inventory
      - if !<context.item.has_flag[item.currency.purse.inventory_contents]>:
        - inventory open destination:purse_inventory
      # yes: get contents from item flag and display them in inventory
      - else:
        - define inventory <inventory[purse_inventory]>
        - adjust <[inventory]> contents:<context.item.flag[item.currency.purse.inventory_contents]>
        - inventory open destination:<[inventory]>
    # when player closes the purse, flag item with contents and currency amounts and the player too
    on player closes purse_inventory:
      - flag <player> player.currency.purse.open:!
      # get purse contents
      - define contents <context.inventory.list_contents>
      # get item
      - define item <player.item_in_hand.script.name>
      # count quantity of currency items in inventory
      - define groschen <context.inventory.quantity_item[item_currency_groschen]>
      - define taler <context.inventory.quantity_item[item_currency_taler]>
      - define crystal <context.inventory.quantity_item[item_currency_energyfocus]>
      # flag purse with contents, amount and uuid (for unique item data)
      - inventory flag slot:hand item.currency.purse.inventory_contents:<[contents]>
      - inventory flag slot:hand item.purse.randomm_uuid:<util.random_uuid>
      - inventory flag slot:hand item.purse.currency_amount.groschen:<context.inventory.quantity_item[item_currency_groschen]>
      - inventory flag slot:hand item.purse.currency_amount.taler:<context.inventory.quantity_item[item_currency_taler]>
      - inventory flag slot:hand item.purse.currency_amount.energyfocus:<context.inventory.quantity_item[item_currency_energyfocus]>
      # flag player with currency amounts per purse
      - flag <player> player.currency.purse.money_amount:+:<proc[proc_calculate_currency].context[<[groschen]>|<[taler]>]>
      - flag <player> player.currency.purse.crystals_amount:+:<[crystal]>
      - define purse_amount <proc[proc_calculate_currency_purse_total].context[<player.flag[player.currency.purse.money_amount]>|<player.flag[player.currency.purse_medium_amount]>|<player.flag[player.currency.purse_large_amount]>]>
      - run task_update_currency_amount def:<player>|<[purse_amount]>|<player.flag[player.flag.currency.inventory_total]>|<player.flag[player.flag.currency.bank_total]>
    on player drops item_purse:
      # placeholder
      - define item <context.item.script.name>
      - define groschen <context.item.flag[item.purse.currency_amount.groschen]>
      - define taler <context.item.flag[item.purse.currency_amount.taler]>
      - define crystal <context.item.flag[item.purse.currency_amount.energyfocus]>
      # flag player with purse contents and subtract them from his money amount
      # TODO: Nicht pro Geldbeutel flaggen ... nach jeder Interaktion ganzes Inventar durchsuchen und Items zählen und flaggen
      - flag <player> player.currency.purse.money_amount:+:<proc[proc_calculate_currency].context[<[groschen]>|<[taler]>]>
      - flag <player> player.currency.purse.crystals_amount:+:<[crystal]>
      - define purse_amount <proc[proc_calculate_currency_purse_total].context[<player.flag[player.currency.purse_small_amount]>|<player.flag[player.currency.purse_medium_amount]>|<player.flag[player.currency.purse_large_amount]>]>
      - run task_update_currency_amount def:<player>|<[purse_amount]>|<player.flag[player.flag.currency.inventory_total]>|<player.flag[player.flag.currency.bank_total]>
    on player picks up item_purse:
      - define item <context.item.script.name>
      - define groschen <context.item.flag[item.purse.currency_amount.groschen]>
      - define taler <context.item.flag[item.purse.currency_amount.taler]>
      - define crystal <context.item.flag[item.purse.currency_amount.energyfocus]>
      - if <player.inventory.contains_item[item_purse]>:
        - determine cancelled passively
        - remove <context.entity>
        # TODO: Test if current purse has enough space
        # TODO: add picked up money amount to purse
      # placeholder
      
      # flag player with purse contents and add them from his money amount
      - flag <player> player.currency.purse.money_amount:+:<proc[proc_calculate_currency].context[<[groschen]>|<[taler]>]>
      - flag <player> player.currency.purse.crystals_amount:+:<[crystal]>
      - define purse_amount <proc[proc_calculate_currency_purse_total].context[<player.flag[player.currency.purse_small_amount]>|<player.flag[player.currency.purse_medium_amount]>|<player.flag[player.currency.purse_large_amount]>]>
      - run task_update_currency_amount def:<player>|<[purse_amount]>|<player.flag[player.flag.currency.inventory_total]>|<player.flag[player.flag.currency.bank_total]>

    # handling player interactions
    on player breaks block with:item_purse:
      - determine cancelled
    on player left clicks block with:item_purse:
      - determine cancelled
    on player drags in inventory flagged:player.currency.purse.open:
      # if player has the purse currently open, don't let him drag the purse item around
      - narrate "event drag"
      - if <context.item.script.name.advanced_matches[item_currency_*]>:
        - narrate "Spieler drags item item_currency_* or air"
        - stop
      - else:
        - determine passively cancelled
        - narrate "Spieler drags anderes item als item_currency_*"

    on player clicks in inventory flagged:player.currency.purse.open:
      - narrate "event click"
      - if <context.item.script.name.advanced_matches[item_currency_*]> || <context.cursor_item.script.name.advanced_matches[item_currency_*]>:
        - narrate "Spieler clicks item item_currency_* or air"
        - stop
      - else:
        - determine passively cancelled
        - narrate "Spieler clicks anderes item als item_currency_*"

# Inventory Sizes

item_purse_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&3><&l>Geldbörse <&6>❖ <&5>✦
  size: 18

# Item Script Containers

item_purse:
  type: item
  material: player_head
  display name: <&3><&l>Geldbörse
  mechanisms:
    skull_skin: a7e64789-a18e-4f59-a304-c3a5ca8f8819|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODc1ZTc5NDg4ODQ3YmEwMmQ1ZTEyZTcwNDJkNzYyZTg3Y2UwOGZhODRmYjg5YzM1ZDZiNWNjY2I4YjlmNGJlZCJ9fX0=
  lore:
    - <empty>
    - <&3>Praktische Geldbörse mit
    - <&3>Platz für Eure Groschen, Taler
    - <&3>und Kristalle.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&7>Sonstiges

