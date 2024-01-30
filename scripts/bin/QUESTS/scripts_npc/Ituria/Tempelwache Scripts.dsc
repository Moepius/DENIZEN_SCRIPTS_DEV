Tempelwache:
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
      - zap 1 's@TempelwacheStandard'
  interact scripts:
    - 0 TempelwacheStandard
    - 5 Dungeon_Pilzhoehle_Tempelwache
    - 10 Tutorial_Tempelwache

TempelwacheStandard:
  Type: Interact   
  debug: false
  Requirements:
    Mode: None
  Steps:
    1:
      Proximity Trigger:
        Entry:
          Script:
          - CHAT "Hey!"
      Click Trigger:
        Script:
        - ENGAGE
        - CHAT "Hallo <player.name>! Schön Euch wiederzusehen!"
        - WAIT 3
        - CHAT "Gibt es Neuigkeiten aus Terra Thusundea? Wisst Ihr, ich komme nicht weit rum..."
        - WAIT 4
        - FLAG npc trigger:!
        - FLAG npc 'trigger:|:Ja|Nein'
        - NARRATE format:trigger ""
        - DISENGAGE
        - ^ZAP 2
    2:
      Click Trigger:
        Script:
        - FLAG npc trigger:!
        - FLAG npc 'trigger:|:Ja|Nein'
        - NARRATE format:trigger ""
      Chat Trigger:
        1:
          Trigger: "/Ja/ klar, und ob es die gibt! Habt Ihr schon gehört, dass..."
          Script:
          - ENGAGE
          - WAIT 3
          - CHAT "Nein, so etwas?! Das hätte ich nie vermutet!"
          - DISENGAGE
          - ^ZAP 1
        2:
          Trigger: "/Nein/, nicht wirklich. Ziemlich ruhig zur Zeit und bei Euch?"
          Script:
          - ENGAGE
          - WAIT 3
          - NARRATE format:emote "stößt einen tiefen Seufzer aus"
          - WAIT 2
          - CHAT "Na dann..."
          - DISENGAGE
          - ^ZAP 1
