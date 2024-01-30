# texts with server information, used in various situations
# TODO: mehr Texte
# TODO: Auch die Texte für das Tutorial hier einbauen

task_help_wiki_texts:
    type: task
    debug: false
    definitions: player
    subpaths:
        worlds:
            terra_nova:
                - playsound <[player]> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
                - narrate format:headerOhneText "<empty>" targets:<[player]>
                - narrate <empty> targets:<[player]>
                - narrate "<&3>➤ <&b>Terra Nova ist die Hauptspielwelt auf unserem Server." targets:<[player]>
                - narrate "<&b>Im Survival Gamemode könnt Ihr ein eigenes Stück Land beanspruchen." targets:<[player]>
                - narrate "<&b>Auf Eurem Land dürft Ihr nach Herzenslust bauen, sofern Ihr dabei" targets:<[player]>
                - narrate "<&b>stets unsere Bauregeln im Blick behaltet." targets:<[player]>
                - narrate "<&b>Stammspieler haben außerdem die Möglichkeit ein" targets:<[player]>
                - narrate "<&b>Creative-Projekt im Zentrum der Welt zu beantragen." targets:<[player]>
                - narrate "<&3>➤ <&click[https://www.craftasy.de/wiki/welten/#terra_nova].type[OPEN_URL]><&hover[<&b>Klicken, um Website (craftasy.de/wiki/welten/#terra_nova) aufzurufen.]><&b>Mehr Infos zu Terra Nova und den Bauregeln<&end_hover><&end_click>" targets:<[player]>
                - narrate <empty> targets:<[player]>
                - narrate format:footerOhneText "<empty>" targets:<[player]>
            terra_thusundea:
                - narrate format:headerOhneText "<empty>" targets:<[player]>
                - narrate <empty> targets:<[player]>
                - narrate "<&3>➤ <&b>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" targets:<[player]>
                - narrate "<&3>➤ <&b>Im Survival Gamemode könnt Ihr ein eigenes Stück Land beanspruchen." targets:<[player]>
                - narrate "<&3>➤ <&b>Auf Eurem Land dürft Ihr nach Herzenslust drauf losbauen, sofern Ihr dabei" targets:<[player]>
                - narrate "  <&b>stets unsere Bauregeln im Blick behaltet. Stammspieler haben außerdem die" targets:<[player]>
                - narrate "<&3>➤ <&b>Möglichkeit ein Creative-Projekt im Zentrum der Welt zu beantragen." targets:<[player]>
                - narrate "<&3>➤ <&click[https://www.craftasy.de/wiki/welten/#terra_thusundea].type[OPEN_URL]><&hover[<&b>Klicken, um Website (craftasy.de/wiki/welten/#terra_thusundea) aufzurufen.]><&b>Mehr Infos zu Terra Thusundea und Bauregeln<&end_hover><&end_click>" targets:<[player]>
                - narrate <empty> targets:<[player]>
                - narrate format:footerOhneText "<empty>" targets:<[player]>
            creative:
                - playsound <[player]> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
                - narrate format:headerOhneText "<empty>" targets:<[player]>
                - narrate <empty> targets:<[player]>
                - narrate "<&3>➤ <&b>In unserem Kreativlabor können Stammspieler" targets:<[player]>
                - narrate "<&b>ab dem Rang <&d>Meister <&b>Bauwerke für diverse Projekte" targets:<[player]>
                - narrate "<&b>vorbauen. Neben dem Creative Mode habt Ihr" targets:<[player]>
                - narrate "<&b>im Kreativlabor Zugang zu verschiedenen Tools," targets:<[player]>
                - narrate "<&b>die die Projektplanung erleichtern. Geschützte Zonen" targets:<[player]>
                - narrate "<&b>oder sonstiges gibt es hier nicht, wir vertrauen" targets:<[player]>
                - narrate "<&b>auf die Eigenverantwortung der Spieler." targets:<[player]>
                - narrate <empty> targets:<[player]>
                - narrate "<&3>➤ <&click[https://www.craftasy.de/wiki/welten/#creative].type[OPEN_URL]><&hover[<&b>Klicken, um Website (craftasy.de/wiki/welten/#kreativlabor) aufzurufen.]><&a><&n>Mehr Infos zum Kreativlabor und den Bauregeln<&end_hover><&end_click>" targets:<[player]>
                - narrate <empty> targets:<[player]>
                - narrate format:footerOhneText "<empty>" targets:<[player]>
        tutorial:
            allgemein:
                - playsound <[player]> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
                - narrate format:headerOhneText "<empty>" targets:<[player]>
    script:
        - narrate format:c_info "hier könnte Ihre Werbung stehen." targets:<[player]>

command_help_wiki_texts:
    type: command
    name: wiki
    debug: false
    permissions: craftasy.denizen.commands.wiki
    description: external plugin handle for wiki text task scripts
    usage: /wiki <&l>category<&gt> <&l>topic<&gt> <&l>target placeholder<&gt>
    script:
        - run task_help_wiki_texts.subpaths.<context.args.get[1]>.<context.args.get[2]> def:<context.args.get[3]>