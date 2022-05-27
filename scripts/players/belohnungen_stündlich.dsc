#
# Craftasy dwarp
# author: Moepius
# version: 0.0.7
#
#

# READ ME
# Stündliche Belohnungen für Spieler mit der permission craftasy.denizen.hourlyrewards, zu vergeben ab Rang "Vagabund"
# Flags: n/a
# Permissions: craftasy.denizen.hourlyrewards (base permission),
# craftasy.denizen.hourlyrewards.vagabund (Basis Belohnungen)
# craftasy.denizen.hourlyrewards.entdecker (bessere Belohnung für Entdecker)
# Abhängigkeiten: chatsounds_standard.dsc
#
# TODO: Switch für besondere Events zB Weihnachten, restliche Ränge hinzufügen
#


belohnungen_stuendlich:
  type: world
  debug: false
  events:
    after system time hourly:
      - foreach <server.online_players> as:__player:
        - if <player.has_permission[craftasy.denizen.hourlyrewards]>:
          - playsound <player> sound:BLOCK_NOTE_BLOCK_CHIME volume:1 pitch:0.2
          - wait 0.5s
          - playsound <player> sound:BLOCK_NOTE_BLOCK_CHIME volume:1 pitch:1.5
          - playsound <player> sound:block_end_portal_frame_fill volume:1 pitch:0.2
          - wait 1s
          - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
        - if <player.has_permission[craftasy.denizen.hourlyrewards.vagabund]>:
          - random:
            - repeat 1:
              - narrate "<&f><&m>-------------<&6><&l> Stündliche Belohnung <&f><&m>-------------"
              - narrate <empty>
              - narrate "<&b>Ihr erhaltet <&a>10 Silberlinge<&b>! Immerhin."
              - narrate "<&7>Jede Stunde verteilen wir zufällige Belohnungen."
              - narrate "<&7>Je höher Euer Rang ist, desto besser werden die Belohnungen."
              - narrate <empty>
              - narrate "<&f><&m>-------------------------------------------------"
              - money give quantity:10 players:<player>
            - repeat 1:
              - narrate "<&f><&m>-------------<&6><&l> Stündliche Belohnung <&f><&m>-------------"
              - narrate <empty>
              - narrate "<&b>Ihr erhaltet <&a>25 Silberlinge<&b>! Nicht schlecht."
              - narrate "<&7>Jede Stunde verteilen wir zufällige Belohnungen."
              - narrate "<&7>Je höher Euer Rang ist, desto besser werden die Belohnungen."
              - narrate <empty>
              - narrate "<&f><&m>-------------------------------------------------"
              - money give quantity:25 players:<player>
            - repeat 1:
              - narrate "<&f><&m>-------------<&6><&l> Stündliche Belohnung <&f><&m>-------------"
              - narrate <empty>
              - narrate "<&b>Ihr erhaltet <&a>50 Silberlinge<&b>! Glück gehabt."
              - narrate "<&7>Jede Stunde verteilen wir zufällige Belohnungen."
              - narrate "<&7>Je höher Euer Rang ist, desto besser werden die Belohnungen."
              - narrate <empty>
              - narrate "<&f><&m>-------------------------------------------------"
              - money give quantity:50 players:<player>
              - experience give 100 player:<player>
