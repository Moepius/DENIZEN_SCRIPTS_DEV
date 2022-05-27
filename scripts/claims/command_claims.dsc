# Commands, um neuen Claim zu erstellen und Kolonie zu gründen

# Event bei Platzieren des Claim Blocks

# flags: player.inarea.orbis.kolonie_sued
# permissions: craftasy.denizen.claims.koloniebanner_platzieren
# external tasks: task_player_error

# https://github.com/Hydroxycobalamin/dPrevention ... nutzen, um Zonen zu claimen

koloniebanner_placement:
    type: world
    debug: true
    events:
        on player places koloniebanner:
            # Permission test
            - if !<player.has_permission[craftasy.denizen.claims.koloniebanner_platzieren]>:
                - determine passively cancelled
                - run task_player_error "def:Dir fehlt die Genehmigung, um eine Flagge zu hissen!|<player>|<context.location>|stone"
                - stop
            # config, um Welt zu ändern und flag
            - if ( <context.location.world.name> != orbis ) || ( !<player.has_flag[player.inarea.orbis.kolonie_sued]> ):
                - determine passively cancelled
                - run task_player_error "def:Ihr könnt hier keine Flagge hissen!|<player>|<context.location>|stone"
                - stop
            # Berührt die gewünschte Location eine andere, bereits beanspruchte Zone?
            - note <context.location.add[-25,-100,-25].to_cuboid[<context.location.add[25,100,25]>]> as:player.claims.<player>
            - if <player.has_flag[player.claims.areaclaimed]>:
                - determine passively cancelled
                - run task_player_error "def:Ihr habt bereits eine Flagge gehisst!|<player>|<context.location>|stone"
                - stop
            - else:
                - flag <player> player.claims.areaclaimed
                - run task_kolonie_gruenden def:<player>|<context.location>

task_kolonie_gruenden:
    type: task
    definitions: player|location
    script:
        # Zone speichern
        # Erweiterte Zone setzen (für Partikeleffekte im Zentrum)
        # Flagge setzen, mit Interaktionsblock
        # Interaktionsblock flaggen mit Spielerdaten
        # Zone mit Spielerdaten flaggen
        # Erfolgsnachricht ausgeben


# TODO: Partikeleffekte im Zentrum von claims
# TOOO: GUI, um mit Claimblock zu interagieren
# TODO: Task, um Claim zu löschen
# TODO: Task, um Zone zu erweitern
# TODO: Mehr mögliche Exploits abfangen
# TODO: World Script/Task, um zu testen ob Claim noch genug Rohstoff hat (system time minutely)