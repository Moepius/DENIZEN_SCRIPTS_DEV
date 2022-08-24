# TODO: add mechanics and gui to store money into bags

# Items for storing money

# Spieler kann immer nur einen Geldbeutel im Inventar haben
# Items im Geldbeutel sind an den Geldbeutel geknüpft, nicht den Spieler
# Wenn Spieler einen Geldbeutel droppt, dessen Inhalt zählen und flag mit Vermögen entsprechend verringern
#

# Handling

purse_handler:
  type: world
  debug: true
  events:
    on player right clicks block with:item_purse_*:
      - determine passively cancelled
      - ratelimit <player> 1t
      - define item <context.item.script.name>
      - if !<context.item.has_flag[item.purse.inventory]>:
        - choose <[item]>:
          - case item_purse_small:
            - inventory open destination:small_purse_inventory
          - case item_purse_medium:
            - inventory open destination:medium_purse_inventory
          - case item_purse_large:
            - inventory open destination:large_purse_inventory
      - else:
        - choose <[item]>:
          - case item_purse_small:
            - define inventory <inventory[small_purse_inventory]>
          - case item_purse_medium:
            - define inventory <inventory[medium_purse_inventory]>
          - case item_purse_large:
            - define inventory <inventory[large_purse_inventory]>
        - adjust <[inventory]> contents:<context.item.flag[item.purse.inventory]>
        - inventory open destination:<[inventory]>
    on player closes *_purse_inventory:
      - define contents <context.inventory.list_contents>
      - inventory flag slot:hand item.purse.inventory:<[contents]>
      - inventory flag slot:hand item.purse.randomm_uuid:<util.random_uuid>
      - define item <player.item_in_hand.script.name>
      # count quantity of currency items in inventory
      - define copperling <context.inventory.quantity_item[item_copperling]>
      - define silverling <context.inventory.quantity_item[item_silverling]>
      - define goldling <context.inventory.quantity_item[item_goldling]>
      - define crystal <context.inventory.quantity_item[item_energyfocus]>
      - choose <[item]>:
          - case item_purse_small:
            - narrate "Geld: <[copperling]> <[silverling]> <[goldling]> <[crystal]>"
            #- flag <player> player.currency.purse_small_amount_copperling:<[money]>
            #- flag <player> player.currency.crystals.amount
            #<script[item_copperling].name>
          - case item_purse_medium:
            - flag <player> player.currency.purse_medium_amount
            - flag <player> player.currency.crystals.amount
          - case item_purse_large:
            - flag <player> player.currency.purse_large_amount
            - flag <player> player.currency.crystals.amount

# Inventory Sizes

small_purse_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&b><&l>Kleine Geldbörse <&6>❖
  size: 9

medium_purse_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&b><&l>Mittlere Geldbörse <&6>❖ <&5>✦
  size: 18

large_purse_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&b><&l>Große Geldbörse <&6>❖ <&5>✦
  size: 27


# Item Script Containers

item_purse_small:
  type: item
  material: player_head
  display name: <&b><&l>Kleiner Geldbeutel
  mechanisms:
    skull_skin: a7e64789-a18e-4f59-a304-c3a5ca8f8819|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODc1ZTc5NDg4ODQ3YmEwMmQ1ZTEyZTcwNDJkNzYyZTg3Y2UwOGZhODRmYjg5YzM1ZDZiNWNjY2I4YjlmNGJlZCJ9fX0=
  lore:
    - <empty>
    - <&3>Praktischer Geldbeutel mit etwas
    - <&3>Platz für Silberlinge und Kupferstücke.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&7>Sonstiges

item_purse_medium:
  type: item
  material: player_head
  display name: <&b><&l>Mittlerer Geldbeutel
  mechanisms:
    skull_skin: 822fce13-5e8b-48b4-910b-b2da9b13f4c3|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjM0MzQ4ZDMzOWE3YmRiYjRkYzNlYTM5YzM0NDQ3Y2E3NjM4NDZiMjllMDZmNTY4ZTBjOGM1MjE5MjAzZGY5ZiJ9fX0=
  lore:
    - <empty>
    - <&3>Praktischer Geldbeutel mit
    - <&3>ausreichend Platz für Silberlinge,
    - <&3>Kupferstücke und Kristalle.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&7>Sonstiges

item_purse_large:
  type: item
  material: player_head
  display name: <&b><&l>Großer Geldbeutel
  mechanisms:
    skull_skin: 6d7e0d6b-ba29-440a-84b3-3a9f1189ff3a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzkyNzRhMmFjNTQxZTQwNGMwYWE4ODg3OWIwYzhiMTBmNTAyYmMyZDdlOWE2MWIzYjRiZjMzNjBiYzE1OTdhMiJ9fX0=
  lore:
    - <empty>
    - <&3>Praktischer Geldbeutel mit
    - <&3>sehr viel Platz für Goldstücke,
    - <&3>Silberlinge, Kupferstücke
    - <&3>und Kristalle.
    - <empty>
    - <&f><&m>----------------------------------
    - <&7>Zutat: <&c><&chr[274C]><&7> Herstellbar: <&c><&chr[274C]><&7>
    - <&f><&m>----------------------------------
    - <&7>Sonstiges