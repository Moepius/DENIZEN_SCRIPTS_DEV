# Lässt Glocken für Spieler klingen, die dem Server joinen/ihn verlassen
# Sendet Standard Nachrichten
# permissions: craftasy.denizen.task.messageoftheday
# Abhängigkeiten: Task-Script task_motd
#

# TODO: other message if the player logs in again after a long time not showing up (half a year)

spieler_joinandquit_standard:
    type: world
    debug: false
    events:
