KSJ_Cookie:
  type: item
  debug: false
  material: cookie
  display name: <&2><&l>KSJ <&6>Spezialkeks
  lore:
    - Regionale Spezialität?
    - <&7>Mit extra viel Gra... äh Liebe!

drugs_world:
  type: world
  debug: false
  events:
    on player consumes KSJ_Cookie:
      - cast <player.name> minecraft:nausea 90
      - repeat 3:
        - wait 10
        - playsound <player> sound:ambient_cave volume:0.5 pitch:0.8
        - wait 10