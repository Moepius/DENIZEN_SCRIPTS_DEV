# velnias_standard-Begrüßung/Verabschioedung bei Betreten des Radius
# TaskScript "npc_interact_chatsounds" sorgt für einen Sound bei jeder Nachricht. Bitte vor jedem narrate format:npc_talk-Befehl einfügen.
# Flag "testmodus_gast" vergeben, um Skripte als Gast auszuführen.
# Notes:

velnias_assign_inactive:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true cooldown:2m
    interact scripts:
    - velnias_interact_inactive

velnias_interact_inactive:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - run chatsounds_standard def:<player>
                - narrate format:npc_god ...

# TODO: remake this whole interaction
velnias_standard:
    type: assignment
    actions:
        on assignment:
        - trigger name:proximity state:true cooldown:2m radius:10
        - trigger name:damage state:true cooldown:6s
        - trigger name:click state:true cooldown:30s
    interact scripts:
    - velnias_interact_standard

velnias_interact_standard:
    type: interact
    steps:
        1:
            proximity trigger:
                entry:
                    script:
                    - if <player.in_group[Gast]> || <player.has_flag[testmodus_gast]>:
                        - run npc_interact_chatsounds
                        - narrate format:c_info "Rechtsklickt auf den NPC, um mit ihm zu sprechen."
                    - else:
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:narrator "<npc.name> verhält sich auffallend unauffällig"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:narrator "<npc.name> scheint von Euch ignoriert werden zu wollen."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:narrator "<npc.name> besitzt keine Augen, scheint jedoch demonstrativ wegzusehen."
            click trigger:
                script:
                    - if <player.in_group[Gast]> || <player.has_flag[testmodus_gast]>:
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Willkommen in meiner Welt <player.name>. Habt Ihr eine Frage??"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Ich bin Velnias und wache über die Portalwelt. Stellt mir eine Frage.""
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Habt Ihr eine Frage?"
                        - wait 2s
                        - ratelimit <player> 10s
                        - narrate format:headerOhneText "<empty>"
                        - narrate <empty>
                        - narrate "<&3>➤ <&click[/velnias_antwort_werseidihr]><&hover[<&b>Klicken, um Antwort zu erhalten.]><&b>Wer seid Ihr?<&end_hover><&end_click>"
                        - narrate "<&3>➤ <&click[/velnias_antwort_waskannmanmachen]><&hover[<&b>Klicken, um Antwort zu erhalten.]><&b>Was kann man hier machen?<&end_hover><&end_click>"
                        - narrate "<&3>➤ <&click[/velnias_antwort_freischaltung]><&hover[<&b>Klicken, um Antwort zu erhalten.]><&b>Was kann man hier machen?<&end_hover><&end_click>"
                        - narrate "<&3>➤ <&click[/regeln].type[RUN_COMMAND]><&hover[<&b>Klicken, um Regeln aufzurufen.]><&b>Wo finde ich die Server Regeln?<&end_hover><&end_click>"
                        - narrate "<&3>➤ <&click[https://www.craftasy.de/news].type[OPEN_URL]><&hover[<&b>Klicken, um Website (craftasy.de/news) aufzurufen.]><&b>Gibt es Neuigkeiten?<&end_hover><&end_click>"
                        - narrate <empty>
                        - narrate format:footerOhneText "<empty>"
                    - else:
                        - random:
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Ihr schon wieder. Na los, stellt Eure Frage."
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Ich würde Euch gerne sagen ich habe zu tun, nun ... was ist?"
                            - repeat 1:
                                - run npc_interact_chatsounds
                                - narrate format:npc_talk "Ja?"
                        - wait 2s
                        - ratelimit <player> 10s
                        - narrate format:headerOhneText "<empty>"
                        - narrate <empty>
                        - narrate "<&3>➤ <&click[/velnias_antwort_werseidihr]><&hover[<&b>Klicken, um Antwort zu erhalten.]><&b>Wer seid Ihr?<&end_hover><&end_click>"
                        - narrate "<&3>➤ <&click[/velnias_antwort_waskannmanmachen]><&hover[<&b>Klicken, um Antwort zu erhalten.]><&b>Was kann man hier machen?<&end_hover><&end_click>"
                        - narrate "<&3>➤ <&click[/regeln].type[RUN_COMMAND]><&hover[<&b>Klicken, um Regeln aufzurufen.]><&b>Wo finde ich die Server Regeln?<&end_hover><&end_click>"
                        - narrate "<&3>➤ <&click[https://www.craftasy.de/news].type[OPEN_URL]><&hover[<&b>Klicken, um Website (craftasy.de/news) aufzurufen.]><&b>Gibt es Neuigkeiten?<&end_hover><&end_click>"
                        - narrate <empty>
                        - narrate format:footerOhneText "<empty>"
            damage trigger:
                    script:
                        - if <player.in_group[Gast]> || <player.has_flag[testmodus_gast]>:
                            - playsound <player> sound:PARTICLE_SOUL_ESCAPE
                            - playeffect effect:soul at:<npc.location.add[0,2,0]> quantity:5
                            - wait 2s
                            - run npc_interact_chatsounds
                            - actionbar format:actionbarStatus "Es fühlt sich kalt an."
                            - adjust <player> freeze_duration:3s
                        - else:
                            - random:
                                - repeat 1:
                                    - playsound <player> sound:PARTICLE_SOUL_ESCAPE
                                    - playeffect effect:soul at:<npc.location.add[0,2,0]> quantity:5
                                    - run npc_interact_chatsounds
                                    - actionbar format:actionbarStatus "Es fühlt sich kalt an."
                                    - wait 2s
                                    - adjust <player> freeze_duration:6s
                                - repeat 1:
                                    - playsound <player> sound:PARTICLE_SOUL_ESCAPE
                                    - playeffect effect:soul at:<npc.location.add[0,2,0]> quantity:5
                                    - run npc_interact_chatsounds
                                    - actionbar format:actionbarStatus "Euch wird klirrend kalt."
                                    - wait 2s
                                    - adjust <player> freeze_duration:15s
                                - repeat 1:
                                    - playsound <player> sound:PARTICLE_SOUL_ESCAPE
                                    - playeffect effect:soul at:<npc.location.add[0,2,0]> quantity:5
                                    - run npc_interact_chatsounds
                                    - actionbar format:actionbarStatus "Eure Hand scheint zu gefrieren."
                                    - wait 2s
                                    - adjust <player> freeze_duration:12s


# Commands, um Antworten für Velnias' Fragen aufzurufen

velnias_antwort_werseidihr:
    type: command
    debug: false
    name: velnias_antwort_werseidihr
    description: Velnias
    usage: /velnias_antwort_werseidihr
    script:
        - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
        ############## -------------------------------------------------
        - narrate <empty>
        - narrate "<&f>[<&a><&l>NPC<&f>] | <&a>Velnias<&f>:" <empty>
        - narrate "<&b>Ich bin Velnias, Gott der Toten, der Fruchtbarkeit und ..."
        - wait 1s
        - narrate "<&b>zumindest war ich das einmal."
        - wait 3s
        - narrate <empty>
        - narrate "<&b>Nun bin ich dazu verdammt hier in dieser Sphäre"
        - narrate "<&b>zwischen Leben und Tod, neue und alte Seelen auf"
        - narrate "<&b>ihrem Weg durch die Welten zu begleiten."
        - wait 5s
        - narrate <empty>
        - narrate "<&b>Man hat mich ausgetrickst, so etwas ist unter meiner Würde."
        - narrate "<&b>Nur zu, lacht mich aus."
        - narrate <empty>
        - narrate format:footerOhneText "<empty>"

velnias_antwort_waskannmanmachen:
    type: command
    debug: false
    name: velnias_antwort_waskannmanmachen
    description: Velnias
    usage: /velnias_antwort_waskannmanmachen
    script:
        - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
        ############## ----------------------------------------------------------
        - narrate <empty>
        - narrate "<&b>Wir sind ein Freebuild- und Projektserver mit Fokus auf"
        - narrate "<&b>das Erschaffen, sehenswerter und fantasievoller Bauwerke."
        - narrate <empty>
        - narrate "<&b>Unsere Community besteht zum größten Teil aus"
        - narrate "<&b>über 20-Jährigen, die bei uns entspannt, gemeinsame"
        - narrate "<&b>oder eigene Projekte realisieren und das in ihrem"
        - narrate "<&b>Lieblingsspiel Minecraft tun wollen."
        - narrate <empty>
        - narrate "<&b>Um den Spielspaß im Survival-Gameplay noch etwas"
        - narrate "<&b>zu vergrößern, gibt es bei uns allerlei Hilfestellungen"
        - narrate "<&b>und Zusatzfunktionen, die entdeckt werden wollen."
        - narrate <empty>
        - narrate "<&b>Mehr über uns erfahrt Ihr auf unserer <&click[https://www.craftasy.de].type[OPEN_URL]><&hover[<&b>Klicken, um Website (craftasy.de) aufzurufen.]><&a><&n>Website<&end_hover><&end_click>"
        - narrate "<&b>oder über unser <&click[/hilfe].type[RUN_COMMAND]><&hover[<&b>Klicken, um Hilfemenü aufzurufen.]><&a><&n>Hilfemenü<&end_hover><&end_click>."
        - narrate <empty>
        - narrate format:footerOhneText "<empty>"

velnias_antwort_freischaltung:
    type: command
    debug: false
    name: velnias_antwort_freischaltung
    description: Velnias
    usage: /velnias_antwort_freischaltung
    script:
        - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
        ############## -------------------------------------------------
        - narrate <empty>
        - narrate "<&b>Um Euch freizuschalten nutzt einfach jederzeit"
        - narrate "<&b>den Befehl <&click[/freischalten].type[SUGGEST_COMMAND]><&hover[<&b>Klicken, um Befehl zu nutzen]><&a><&n>/freischalten<&end_hover><&end_click>"
        - narrate <empty>
        - narrate "<&b>Nach der Freischaltung habt Ihr Zugang zu"
        - narrate "<&b>allen FUnktionen unseres Servers und dürft in"
        - narrate "<&b>unserem Freebuild <&dq>Terra Nova<&dq> bauen."
        - narrate "<&b>Besucher, die sich nur umsehen möchten sind"
        - narrate "<&b>aber jederzeit bei uns willkommen."
        - narrate <empty>
        - narrate format:footerOhneText "<empty>"