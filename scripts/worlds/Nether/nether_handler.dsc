nether_handler:
    type: world
    debug: false
    events:
        on player breaks block in:world_nether:
            - if !<player.has_flag[player.worlds.nether.can_break_blocks]>:
                - determine cancelled passively
                - playeffect effect:smoke at:<context.location.above> visibility:100 quantity:7 velocity:0,0.1,0 offset:2.0
                - playeffect effect:soul at:<context.location.above> visibility:100 quantity:15 velocity:0,0.1,0 offset:2.0
                - playsound <player> sound:particle_soul_escape volume:5
            - else:
                - stop
        on player places block in:world_nether:
            - if !<player.has_flag[player.worlds.nether.can_place_blocks]>:
                - determine cancelled passively
                - playeffect effect:smoke at:<context.location> visibility:100 quantity:7 velocity:0,0.1,0 offset:2.0
                - playeffect effect:soul at:<context.location> visibility:100 quantity:15 velocity:0,0.1,0 offset:2.0
                - playsound <player> sound:particle_soul_escape volume:5
            - else:
                - stop

                #TODO: also prevent placement of item frames etc

        


#################### Nether Ebenen #############################

## Sumpf der Vergessenen ##

# zu Anfang keine Mobs
# toxische Atmosphäre, die langsam tötet (Effekt kann mit Trank aus letzter Ebene der Erdenmutter negiert werden)
# Blöcke bauen nur langsam ab, gesetzte Blöcke verschwinden schnell
# Berührung von Wasser löst Wither Effekt aus
# Boot kann benutzt werden
# Drei Säulen am Rand verteilt, die als Siegel für den AUfzug im zentrum fungieren
# bei jedem der Siegel muss ein Block abgebaut werden, der sehr langsam abbaut. Während man den Siegelblock zerstört spawnen extrem starke Mobs gegen welche man sich schützen muss mit Resistenz
# Mobs lösen ebenfalls Effekte aus, die mit Trank aus Sphäre der Erdenmutter negiert werden kann
# nach jdem bruch eines Siegels spawnen Mobs für eine Stunde in der Ebene und das Siegel bleibt für eine Studne gebrochen
# sobald alle Siegel gebrochen sind wird der Aufzug aktiviert, wenn der Spieler mit Rechtsklick Bruchstücke im zentrum einsetzt
# Spieler können dann den Aufzug nutzen, um zur nächsten Ebene zu springen (GUI verwenden, um auch einzelne Ebenen anzusteuern)
# Aufzug auch weiterhin nutzbar nachdem die Siegel zurückgesetzt wurden (jeder SPieler muss drei Siegel brechen)