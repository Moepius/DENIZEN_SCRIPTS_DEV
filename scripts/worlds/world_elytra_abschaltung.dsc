# Schaltet die Nutzung von Rakten während dem Gleitflug mit Elytras ab
# Kann man entsprechender Permission umgangen werden
# permissions: craftasy.denizen.world.elytra_abschaltung_umgehen
# flags: elytra_abschaltung_error_gesehen

# TODO: weiter anpassen, flags hinzufügen/permissions für bypass etc.
# TODO: englisch Übersetzung, Config mit data script
# TODO: Umgehen mit Pfeil + Bogen oder Trident verhindern
# TODO: add bypasses for custom gamemodes

elytra_abschaltung:
    type: world
    debug: false
    events:
        on player right clicks block with:firework_rocket in:world|orbis|parallelwelt:
            - if <player.gliding> || <player.gamemode> == creative || <player.has_permission[player.core.gameplay_changes.bypass_elytra_disable]>:
                - stop
            - else:
                - determine passively cancelled
                - if !<player.has_flag[player.core.gameplay_changes.elytra_notice_watched]>:
                    - flag <player> player.core.gameplay_changes.elytra_notice_watched expire:15s
                    - narrate format:c_warn "Der Raketenantrieb für Elytras ist in dieser Welt abgeschaltet."
                - else:
                    - stop