# Craftasy Quest Handler
# Author: Moepius
# Version: 0.0.1
#
# flags:
# notes:
# permission:
#
#


# Tasks, die ausgeführt werden bei Annahme/Abschluss/Ablehenn von Quests.

# A) Flag dafür, dass eine Quest aktiv ist. Wird bei Abbruch, nach einigen Tagen automatisch oder bei Abschluss verworfen
#   Es kann immer nur eine Quest aktiv ausgewählt werden, alle anderen Quests werden automatisch abgebrochen, wenn eine
#   neue Quest angenommen wird.
#
# B) Flag, die den Namen der Quest beinhaltet
#   Dies soll als Platzhalter an verschiedenen Orten dienen, default Text wenn keine Quest ausgewählt ist
#
# C) Verschiedene Flags, um den Status der Quest zu prüfen
#   Bsp.: Quest abgeschlossn, Quest begonnen, Quest abgebrochen, Quest Fortschritt
#
# In einer GUI sollen alle Quests aufgelistet werden. Diese sind zunächst verborgen (zB mit Hinweis "noch nicht entdeckt")
# Einmal angenommene Quests werden markiert, solange diese aktiv sind. Wird eine Quest abgeschlossen, kann diese erneut begonnen
# werden. Abgebrochene oder abgeschlossene Quests werden ebenfalls als "freigeschaltet" markiert und können jederzeit begonnen werden.
# Sollte eine andere Quest aktiv sein, geht deren Fortschritt verloren, um kein Durcheinander zu erzeugen.

quests_events:
    type: world
    enabled: false
    events:
        on player joins:
        - if <player.has_flag[enabled_error]>:
            - narrate "Fehler! Script sollte ausgeschaltet sein"