Nami:
  Type: Assignment
  debug: false
  actions:
    on assignment:
      - trigger name:chat toggle:true
      - trigger name:click toggle:true
      - trigger name:proximity toggle:true
    on enter proximity:
      - lookclose toggle:true
    on exit proximity:
      - lookclose toggle:false
      - FLAG npc trigger:!
  interact scripts:
    - 0 NamiStanadard
    - 5 Dungeon_Schrein_Nami

NamiStanadard:
  Type: Interact
  debug: false
  Requirements:
    Mode: All
    List:
    - -INGROUP Gast
    - -INGROUP Abgelehnt
  Steps:
    1:
      Click Trigger:
        Script:
        - ENGAGE
        - CHAT "Besuch! So eine <&Uuml>berraschung!"
        - WAIT 3
        - CHAT "Ihr habt den Tempel nicht entehrt... oder?"
        - DISENGAGE