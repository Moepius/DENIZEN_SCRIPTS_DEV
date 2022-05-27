# Herstellbar mit Soulsand in einer blast furnace

seelensplitter:
  type: item
  material: ghast_tear
  display name: <&3><&l>Seelensplitter
  mechanisms:
    hides: <list[ENCHANTS|ITEM_DATA]>
  enchantments:
  - sharpness:1
  lore:
    - <empty>
    - <&3>Ein leises Seufzen ist zu hören,
    - <&3>wenn Ihr genau hinhört.
    - <empty>
    - <&f><&m>----------
    - <&7>Ab Rang: <&a>Vagabund
    - <&7>Handelbar, Zutat, Herstellbar
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