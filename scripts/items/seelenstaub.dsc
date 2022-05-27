# Herstellbar mit Soulsand in einer blast furnace

seelenstaub:
  type: item
  material: firework_star
  display name: <&3><&l>Seelenstaub
  mechanisms:
    hides: <list[ENCHANTS|ITEM_DATA]>
    firework: true,false,BALL,0,0,0,0,0,0
  enchantments:
  - sharpness:1
  lore:
    - <empty>
    - <&3>Ein leises Seufzen ist zu hören,
    - <&3>wenn Ihr genau hinhört.
    - <empty>
    - <&f><&m>----------
    - <&7>Ab Rang: <&a>Vagabund
    - <&7>Zutat, Herstellbar
    - <&f><&m>----------
    - <&7>GEWÖHNLICH
    - <&6>★<&7>☆☆☆☆
  allow in material recipes: true
  recipes:
    1:
      type: blast
      group: craftasy_items
      cook_time: 60s
      experience: 5
      input: soul_sand