# https://meta.denizenscript.com/Docs/Search/hotbar#player%20click_type%20clicks%20item%20in%20inventory

# https://meta.denizenscript.com/Docs/Commands/give

# check if item isn't air
# https://meta.denizenscript.com/Docs/Tags/playertag.inventory

# https://meta.denizenscript.com/Docs/Tags/itemtag.material

# https://meta.denizenscript.com/Docs/Tags/materialtag.name


craftasy_gui_item:
  type: item
  material: player_head
  display name: <&3><&l>[<&6><&l>Craftasy Menü<&3><&l>]
  mechanisms:
    skull_skin: 22db6f45-8f8a-4192-936d-6a5d039279d7|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmRhNDgyNjcwYWQ3NDQ2NjA4MTg4M2ZlN2VkZDQ4ZGVjMjdhNjk4YTlhNTJjNGY4NzAzMTBiYTAzNWFjZjY5NiJ9fX0=
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&f><&m>----------
    - <&3>➤ <&a>RECHTSKLICK<&b>, um Menü zu öffnen.
    - <&3>➤ <&a>LINKSKLICK<&b>, um Servershop zu öffnen.
    - <&3>➤ <&a>SCHLEICHEN + RECHTSKLICK<&b>, um Menüitem abzuschalten.
    - <&b>Wenn Ihr das Menüitem abschaltet, könnt Ihr es Euch jederzeit
    - <&b>mit <&a>/gui<&b> wieder zurück ins Inventar holen.