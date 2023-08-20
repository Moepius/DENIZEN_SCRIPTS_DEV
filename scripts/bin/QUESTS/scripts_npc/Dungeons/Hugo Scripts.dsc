Hugo:
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
    - 0 HugoStandard
    - 5 Dungeon_Kuchencanyon_Hugo

HugoStandard:
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
        - NARRATE "<&b>Ihr fallt einem furchtbaren Gef<&uuml>hl anheim, als Ihr bemerkt, wie eine schattenhafte Kreatur Euch mit kalten, jedoch verspielten Augen mustert."
      Click Trigger:
        Script:
        - ENGAGE
        - CHAT "Huuuuuuh, ich bin ein Geist aus dem Jenseits! Wollen wir spielen? Verstecken?"
        - WAIT 3
        - CHAT "... Nicht? Och manno. Keiner will mit mir spielen. Dabei bin ich doch ganz lieb und nett..."
        - DISENGAGE