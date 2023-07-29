

hologram_create_task:
    type: task
    debug: true
    script:
        - spawn hologram_text_entity <[location]>

hologram_text_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    scale: 1,1,1
    opacity: 25
    see_through: true
    text_shadowed: false
    translation: 0,0,0
    interpolation_duration: 2t
    interpolation_start: 0t
    view_range: 1
    pivot: center

######### hardcoded entities

hortusmanium_orbis_text_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    scale: 1,1,1
    text: <&f><&m>----------------------<&nl><&6>Spielwelt Orbis<&nl><&b>Kreativprojekte & Survival<&nl><&f><&m>----------------------
    see_through: true
    text_shadowed: false
    translation: 0,0,0
    view_range: 100
    pivot: fixed

## entities entfernen:
### remove <player.location.find_entities.within[1].exclude[<player>]>
### spawn hortusmanium_orbis_text_entity <player.location.round_down>
