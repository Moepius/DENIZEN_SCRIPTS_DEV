Portalwache:
  Type: Assignment
  debug: false
  actions:
    on assignment:
      - trigger name:chat toggle:true
      - trigger name:click toggle:true
      - trigger name:proximity toggle:true
      - trigger name:damage toggle:true
    on enter proximity:
      - lookclose toggle:true
    on exit proximity:
      - lookclose toggle:false
      - zap 1 's@PortalwacheStandard'
  interact scripts:
    - 0 PortalwacheStandard
    - 5 Gast1
    - 10 Tutorial_Portalwache
    - 15 Knast_Portalwache

PortalwacheStandard:
  Type: Interact
  debug: false
  Requirements:
    Mode: None
  Steps:
    1:
      Click Trigger:
        Script:
        - CHAT "Ist etwas? Ich habe zu tun!"
      Damage Trigger:
        Script:
        - CHAT "Aua! Lasst das sein!"
        - ^ZAP 2
    2:
      Click Trigger:
        Script:
        - CHAT "Ich behalte euch im Auge!"
      Damage Trigger:
        Script:
        - CHAT "Autsch! Jetzt reicht es aber! Noch einmal und ich rufe die Stadtwache!"
        - ^ZAP 3
    3:
      Click Trigger:
        Script:
        - ENGAGE
        - CHAT "Vorsicht Freundchen, f<&uuml>r Unruhestifter haben wir in Ituria ein nettes <&Ouml>rtchen! Benehmt Euch lieber!"
        - WAIT 3
        - NARRATE "<&b>Die Portalwache scheint ver<&auml>rgert. Lasst sie besser in Ruhe!"
        - DISENGAGE
      Damage Trigger:
        Script:
        - ENGAGE
        - CHAT "<&c>WACHEEE!" no_target
        - Wait 2
        - TELEPORT <player> 75,61,-30,world
        - HURT 2
        - NARRATE "<&b>Ihr wurdet unsanft ins Gef<&auml>ngnis geworfen. Ihr solltet aus dieser Tat eine Lehre ziehen!"
        - FLAG PLAYER 'Sozialakte:->:Schl<&auml>gertyp'
        - FLAG PLAYER 'AktiveQuests:->:Raus aus dem Knast'
        - WAIT 2
        - NARRATE format:quest_given "Raus aus dem Knast"
        - ^ZAP 1
        - DISENGAGE

Knast_Portalwache:
  Type: Interact
  debug: false
  Requirements:
    Mode: All
    List:
    - FLAGGED PLAYER 'Sozialakte[<player.flag[Sozialakte].as_list.find[Schl<&auml>gertyp]>]:Schl<&auml>gertyp'
  Steps:
    1:
      Proximity Trigger:
        Entry:
          Script:
          - ENGAGE
          - CHAT "WAAAS?! Ich habe Euch eigenh<&auml>ndig ins Gef<&auml>ngnis geworfen! Und Ihr taucht hier einfach so wieder auf?"
          - WAIT 4
          - CHAT "Ihr m<&uuml>sst verdammt einflussreiche Freunde haben..."
          - WAIT 2
          - NARRATE format:emote "schnaubt w<&uuml>tend"
          - WAIT 2
          - NARRATE "<&b>Ihr solltet die Portalwache lieber in Ruhe lassen!"
          - DISENGAGE
      Damage Trigger:
        Script:
        - ENGAGE
        - CHAT "Autsch! Das darf doch wohl nicht wahr sein! <&c>WACHEEE!" no_target
        - Wait 2
        - TELEPORT <player> 75,61,-30,world
        - HURT 2
        - NARRATE "<&b>Ihr wurdet unsanft ins Gef<&auml>ngnis geworfen. Ihr solltet aus dieser Tat eine Lehre ziehen!"
        - FLAG PLAYER 'AktiveQuests:->:Raus aus dem Knast'
        - WAIT 3
        - NARRATE format:quest_given "Raus aus dem Knast"
        - DISENGAGE
