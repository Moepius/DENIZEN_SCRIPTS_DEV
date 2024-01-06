

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
    text: <&f><&m>----------------------<&nl><&6>>> Orbis <<<&nl><&b>Kreativprojekte & Survival<&nl><&f><&m>----------------------
    see_through: true
    text_shadowed: false
    translation: 0,0,0
    view_range: 100
    pivot: fixed

hortusmanium_avarus_text_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    scale: 1,1,1
    text: <&f><&m>----------------------<&nl><&6>Spielwelt Avarus<&nl><&b>Survival Projektwelt<&nl><&f><&m>----------------------
    see_through: true
    text_shadowed: false
    translation: 0,0,0
    view_range: 100
    pivot: fixed
  
hortusmanium_zeitkapsel_text_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    scale: 1,1,1
    text: <&f><&m>----------------------<&nl><&6>Zeitkapsel<&nl><&b>Avarus - 2011 bis 2022<&nl><&f><&m>----------------------
    see_through: true
    text_shadowed: false
    translation: 0,0,0
    view_range: 100
    pivot: fixed

hortusmanium_arboretum_text_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    scale: 1,1,1
    text: <&f><&m>----------------------<&nl><&6>Arboretum<&nl><&b>Creative Freebuild- und Konzeptwelt<&nl><&f><&m>----------------------
    see_through: true
    text_shadowed: false
    translation: 0,0,0
    view_range: 100
    pivot: fixed

hortusmanium_orcus_text_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    scale: 1,1,1
    text: <&f><&m>----------------------<&nl><&6>Orcus<&nl><&b>Abbauwelt<&nl><&f><&m>----------------------
    see_through: true
    text_shadowed: false
    translation: 0,0,0
    view_range: 100
    pivot: fixed

hortusmanium_kaos_text_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    scale: 1,1,1
    text: <&f><&m>----------------------<&nl><&6>Kaos<&nl><&b>Abbauwelt<&nl><&f><&m>----------------------
    see_through: true
    text_shadowed: false
    translation: 0,0,0
    view_range: 100
    pivot: fixed

## entities entfernen:
### remove <player.location.find_entities.within[1].exclude[<player>]>
### spawn hortusmanium_orbis_text_entity <player.location.round_down>
### &f&m----------------------\n&6>> Zeitkapsel <<\n&bAvarus - 2011 bis 2022\n&f&m----------------------