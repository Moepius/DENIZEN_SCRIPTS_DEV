# Lässt Glocken für Spieler klingen, die dem Server joinen/ihn verlassen
# Sendet Standard Nachrichten
# permissions: craftasy.denizen.task.messageoftheday
# Abhängigkeiten: Task-Script messageOfTheDay
#

spieler_joinandquit_standard:
    type: world
    debug: false
    events:
      on player joins:
      - determine none passively
      - foreach <server.online_players>:
        - playsound <[value]> sound:BLOCK_NOTE_BLOCK_CHIME volume:1 pitch:1.5
        - playsound <[value]> sound:BLOCK_NOTE_BLOCK_BELL volume:1 pitch:1.5
        - narrate format:c_info targets:<[value]> "<&a><player.name> <&b>betritt den Server."
      - if <player.has_permission[craftasy.denizen.task.messageoftheday]>:
        - wait 3s
        - run messageOfTheDay
      on player quits:
      - determine none passively
      - foreach <server.online_players>:
        - playsound <[value]> sound:BLOCK_NOTE_BLOCK_CHIME volume:1 pitch:0.2
        - playsound <[value]> sound:BLOCK_NOTE_BLOCK_BELL volume:1 pitch:0.2
        - narrate format:c_info targets:<[value]> "<&a><player.name> <&b>hat den Server verlassen."