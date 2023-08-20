Gundalf:
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
    - 0 GundalfStandard
    - 5 Dungeon_Pilzhoehle_Gundalf

GundalfStandard:
  Type: Interact
  debug: false
  Requirements:
    Mode: All
    List:
    - -INGROUP Gast
    - -INGROUP Abgelehnt
  Steps:
    1:
      Proximity Trigger:
        Entry:
          Script:
          - NARRATE format:emote "mustert Euch eindringlich"
      Click Trigger:
        Script:
        - ENGAGE
        - CHAT "Oh hallo. Wollt Ihr mich besuchen?"
        - WAIT 2
        - CHAT "Das ist sehr freundlich von Euch, aber ich bin im Moment sehr besch<&auml>ftigt."
        - WAIT 5
        - CHAT "Hoffentlich erscheine ich Euch nicht unh<&ouml>flich... Auf Wiedersehen, junger Freund."
        - DISENGAGE
