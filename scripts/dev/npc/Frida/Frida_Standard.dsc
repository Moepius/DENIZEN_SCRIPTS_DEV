# Frida Standard-Begrüßung/Verabschioedung bei Betreten des Radius
# TaskScript "npc_interact_chatsounds" sorgt für einen Sound bei jeder Nachricht. Bitte vor jedem Chat-Befehl einfügen.

frida_standard:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
    interact scripts:
    - frida_interact_standard

frida_interact_standard:
    type: interact
    steps:
        1:
            proximity trigger:
                entry:
                    script:
                    # TODO: Script für ersten Besuch mit flag
                    - if <player.has_flag[frida_interact_standard_enter]>:
                        - stop
                    - else:
                        - flag <player> frida_interact_standard_enter expire:5m
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Willkommen in meiner Bäckerei, <player.name>!"
                                - wait 3s
                                - run npc_interact_chatsounds
                                - chat "Für kleines Geld, bekommt Ihr bei mir leckere Backwaren!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Schön, dass Ihr bei mir vorbeischaut, <player.name>!"
                                - wait 3s
                                - run npc_interact_chatsounds
                                - chat "Ich hoffe Ihr seid gekommen, um von meinen leckeren Backwaren zu probieren?"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Willkommen, <player.name>!"
                                - wait 3s
                                - run npc_interact_chatsounds
                                - chat "Die besten und frischesten Backwaren in ganz Ituria, gibt es nur bei mir."
                exit:
                    script:
                    - if <player.has_flag[frida_interact_standard_exit]>:
                        - stop
                    - else:
                        - flag <player> frida_interact_standard_exit expire:5m
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Danke, dass Ihr vorbeigeschaut habt!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Bis zu Eurem nächsten Besuch, <player.name>!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Auf Wiedersehen, <player.name>!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Tüdelü!"