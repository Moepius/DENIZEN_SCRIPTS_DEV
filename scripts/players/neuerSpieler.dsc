#neuer Spieler Script

NeuerSpielerJoin:
    type: world
    debug: false
    events:
        after player joins:
        - playsound <player> sound:ENTITY_EXPERIENCE_ORB_PICKUP pitch:1
        - if <player.has_flag[erstesMalgejoined]>:
          - stop
        - if <player.statistic[play_one_minute]> > 5:
          - flag <player> erstesMalgejoined
          - stop
        - wait 2s
        - playsound <player> sound:UI_TOAST_IN pitch:1
        - title "title:<green>Willkommen <player.name>!" "subtitle:<gold>Craftasy - die deutsche Minecraft-Community" stay:3s targets:<player>
        - wait 6s
        - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
        - narrate format:c_info "Damit du dich auf unserem Server zurechtfindest, lies' unser Handbuch aufmerksam"
        - give CraftasyHandbuch
        - wait 7s
        - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
        - narrate format:c_info "Weitere Infos findest du auf unserer Website <gold><bold>https://www.craftasy.de"
        - wait 7s
        - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
        - narrate format:c_info "Schau' gerne auf unserem Discord vorbei, unsere aktive Community hilft dir bei Fragen gerne weiter <gold><bold>https://discord.gg/GVHrmf9"
        #- flag <player> erstesMalgejoined
        - wait 7s
        - toast "Viel Spaß <player.name>!" icon:nether_star frame:goal




