# Karolus Standard-Begrüßung/Verabschioedung bei Betreten des Radius
# TaskScript "npc_interact_chatsounds" sorgt für einen Sound bei jeder Nachricht. Bitte vor jedem Chat-Befehl einfügen.

karolus_standard:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true radius:5
    interact scripts:
    - karolus_interact_standard

karolus_interact_standard:
    type: interact
    steps:
        1:
            proximity trigger:
                entry:
                    script:
                    - if <player.has_flag[karolus_interact_standard_enter]>:
                        - stop
                    - else:
                        - flag <player> karolus_interact_standard_enter expire:5m
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Schön Euch zu sehen, <player.name>!"
                                - wait 3s
                                - run npc_interact_chatsounds
                                - chat "Wenn Ihr Stein verkaufen wollt, mache ich einen guten Preis!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Thusundea zum Gruß, <player.name>!"
                                - wait 3s
                                - run npc_interact_chatsounds
                                - chat "Wollt Ihr etwas verkaufen?"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Willkommen bei Geiz & Gier, <player.name>!"
                                - wait 3s
                                - run npc_interact_chatsounds
                                - chat "Bei mir könnt Ihr euren Stein, Sand oder Bruchstein loswerden, gegen einen guten Preis."
                exit:
                    script:
                    - if <player.has_flag[karolus_interact_standard_exit]>:
                        - stop
                    - else:
                        - flag <player> karolus_interact_standard_exit expire:5m
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Auf ein baldiges Wiedersehen!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Bis zum nächsten Mal, <player.name>!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Meine Türen stehen Euch jederzeit offen."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - chat "Ihr geht schon, <player.name>?"