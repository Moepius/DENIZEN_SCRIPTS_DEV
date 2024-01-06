# portalwache Standard-Begrüßung/Verabschioedung bei Betreten des Radius
# TaskScript "npc_interact_chatsounds" sorgt für einen Sound bei jeder Nachricht. Bitte vor jedem narrate format:npc_talk-Befehl einfügen.
# Flag "testmodus_gast" vergeben, um Skripte als Gast auszuführen.

portalwache_standard:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true cooldown:2m radius:5
        - trigger name:damage state:true cooldown:6s
        - trigger name:click state:true cooldown:10s
    interact scripts:
    - portalwache_interact_standard

portalwache_interact_standard:
    type: interact
    steps:
        1:
            proximity trigger:
                entry:
                    script:
                    - if <player.in_group[Gast]> || <player.has_flag[testmodus_gast]>:
                        - run npc_interact_chatsounds
                        - narrate format:npc_talk "Thusundea zum Gruße!"
                        - run npc_interact_chatsounds
                        - narrate format:npc_talk "Geht jederzeit durch das Portal hinter mir und sprecht mit <&1>Carlos<&7>, wenn Ihr euch <&a><&hover[Freigeschaltete Spieler, dürfen in unserem Freebuild bauen uvm.].type[SHOW_TEXT]>freischalten<&end_hover> <&7>lassen wollt."
                    - else:
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Thusundea zum Gruße!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Möge die Göttin Thusundea Euch sets wohlgesonnen sein."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Einen Guten Tag <player.name>!"
            click trigger:
                script:
                    - if <player.in_group[Gast]> || <player.has_flag[testmodus_gast]>:
                        - run npc_interact_chatsounds
                        - narrate format:npc_talk "Das Portal, um euch <&a><&hover[Freigeschaltete Spieler, dürfen in unserem Freebuild bauen uvm.].type[SHOW_TEXT]>freizuschalten<&end_hover> <&7>findet Ihr direkt hinter mir. Einfach hindurchlaufen."
                    - else:
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Wache stehen ist langweilig könnte man meinen, doch man begegnet dabei den spannendsten Leuten."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Das Portal in andere Welten darf nicht ohne Weiteres betreten werden, deshalb stehe ich hier Wache."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Solltet Ihr Probleme mit gesetzlosem Pack haben, wendet Euch jederzeit an mich."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Durch das Portal, das ich bewache könnt Ihr fremde Welten betreten. Das ist aber nichts für mich, man weiß ja nie ob man wieder heraus findet."
            damage trigger:
                    script:
                        - if <player.in_group[Gast]> || <player.has_flag[testmodus_gast]>:
                            - run npc_interact_chatsounds
                            - narrate format:npc_talk "<&c>Aua! Lasst das bitte."
                        - else:
                            - random:
                                - repeat 1:
                                    - run npc_interact_chatsounds
                                    - narrate format:npc_talk "<&c>Was fällt euch ein? Lasst das!"
                                - repeat 1:
                                    - run npc_interact_chatsounds
                                    - narrate format:npc_talk "<&c>Aua! Hat man Euch keine Manieren beigebracht?"
                                - repeat 1:
                                    - run npc_interact_chatsounds
                                    - narrate format:npc_talk "<&c>Das tut weh, lasst das!"
                            - zap 2 duration:10m
        2:
            proximity trigger:
                entry:
                    script:
                    - if <player.in_group[Gast]> || <player.has_flag[testmodus_gast]>:
                        - run npc_interact_chatsounds
                        - narrate format:npc_talk "Thusundea zum Gruße!"
                        - run npc_interact_chatsounds
                        - narrate format:npc_talk "Geht jederzeit durch das Portal hinter mir und sprecht mit <&1>Carlos<&7>, wenn Ihr euch <&a><&hover[Freigeschaltete Spieler, dürfen in unserem Freebuild bauen uvm.].type[SHOW_TEXT]>freischalten<&end_hover> <&7>lassen wollt."
                    - else:
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Thusundea zum Gruße!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Möge die Göttin Thusundea Euch sets wohlgesonnen sein."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Einen Guten Tag <player.name>!"
            click trigger:
                script:
                    - if <player.in_group[Gast]> || <player.has_flag[testmodus_gast]>:
                        - run npc_interact_chatsounds
                        - narrate format:npc_talk "Das Portal, um euch <&a><&hover[Freigeschaltete Spieler, dürfen in unserem Freebuild bauen uvm.].type[SHOW_TEXT]>freizuschalten<&end_hover> <&7>findet Ihr direkt hinter mir. Einfach hindurchlaufen."
                    - else:
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Wache stehen ist langweilig könnte man meinen, doch man begegnet dabei den spannendsten Leuten."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Das Portal in andere Welten darf nicht ohne Weiteres betreten werden, deshalb stehe ich hier Wache."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Solltet Ihr Probleme mit gesetzlosem Pack haben, wendet Euch jederzeit an mich."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Durch das Portal, das ich bewache könnt Ihr fremde Welten betreten. Das ist aber nichts für mich, man weiß ja nie ob man wieder heraus findet."
            damage trigger:
                script:
                    - random:
                        - repeat 1:
                            - run npc_interact_chatsounds
                            - narrate format:npc_talk "<&c>Seid Ihr noch bei Sinnen? Hört sofort auf!"
                            - wait 2s
                            - narrate format:c_info "Ihr solltet die Portalwache besser in Frieden lassen."
                        - repeat 1:
                            - run npc_interact_chatsounds
                            - narrate format:npc_talk "<&c>Ihr wagt es eine Wache anzugreifen? Passt auf mit wem Ihr euch anlegt!"
                            - wait 2s
                            - narrate format:c_info "Ihr solltet die Portalwache besser in Frieden lassen."
                        - repeat 1:
                            - run npc_interact_chatsounds
                            - narrate format:npc_talk "<&c>Legt Euch besser nicht mit mir an. Einen Wicht wie euch erledige ich im Nu."
                            - wait 2s
                            - narrate format:c_info "Ihr solltet die Portalwache besser in Frieden lassen."
                    - zap 3 duration:4h
        3:
            click trigger:
                script:
                    - narrate "<&c>Die Tempelwache möchte nicht mit Euch sprechen."
            proximity trigger:
                entry:
                    script:
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "<&c>Haltet Euch fern von mir!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "<&c>Ich behalte Euch im Auge!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "<&c>Pfui!"
            damage trigger:
                script:
                    - random:
                        - repeat 1:
                            - run npc_interact_chatsounds
                            - narrate format:npc_talk "<&c>Ihr WAGT es?"
                            - wait 3s
                            - hurt 7 <player>
                            - cast blindness duration:5s
                            - wait 3s
                            - narrate "<&c>Ihr wurdet heftig vermöbelt. Noch einmal solltet Ihr das besser nicht tun."
                            - wait 2s
                            - cast confusion duration:6s
                            - cast slow duration:300s
                        - repeat 1:
                            - run npc_interact_chatsounds
                            - narrate format:npc_talk "<&c>Pah, das lasse ich mir nicht gefallen!"
                            - wait 3s
                            - hurt 7 <player>
                            - cast blindness duration:5s
                            - wait 3s
                            - narrate "<&c>Ihr wurdet heftig vermöbelt. Noch einmal solltet Ihr das besser nicht tun."
                            - wait 2s
                            - cast confusion duration:6s
                            - cast slow duration:300s
                    - zap 4 duration:24h
        4:
            click trigger:
                script:
                    - run npc_interact_chatsounds
                    - narrate format:npc_talk "<&c>Haut ab!"
                    - wait 1s
                    - hurt 3 <player>
                    - wait 2s
                    - narrate "<&c>Die Tempelwache möchte nicht mit Euch sprechen."
            proximity trigger:
                entry:
                    script:
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "<&c>Geht mir schleunigst aus den Augen, bevor ich mich vergesse!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "<&c>Bis jetzt hatte ich einen schönen Tag. Verschwindet!"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "<&c>In diesen Zeiten darf sich selbst der größte Abschaum noch frei bewegen ... Pah!"
            damage trigger:
                script:
                    - random:
                        - repeat 1:
                            - run npc_interact_chatsounds
                            - narrate format:npc_talk "<&c>Na wartet, mit Gesocks wie Euch mach ich kurzen Prozess."
                            - wait 3s
                            - hurt 5 <player>
                            - cast blindness duration:7s
                            - wait 3s
                            - narrate "<&4>Dieses mal kommt Ihr nicht mit einem blauen Auge davon."
                            - wait 3s
                            - hurt 5 <player>
                            - wait 2s
                            - hurt 3 <player>
                            - wait 2s
                            - hurt 500
                            - wait 3s
                            - cast confusion duration:6s
                            - cast slow duration:600s
                        - repeat 1:
                            - run npc_interact_chatsounds
                            - narrate format:npc_talk "<&c>Ihr habt immernoch nicht genug? Na gut, Gesindel Eures Formats lernt es wohl nicht anders."
                            - wait 3s
                            - hurt 5 <player>
                            - cast blindness duration:7s
                            - wait 3s
                            - narrate "<&4>Dieses mal kommt Ihr nicht mit einem blauen Auge davon."
                            - wait 3s
                            - hurt 5 <player>
                            - wait 2s
                            - hurt 3 <player>
                            - wait 2s
                            - hurt 500 <player>
                            - wait 3s
                            - cast confusion duration:6s
                            - cast slow duration:600s