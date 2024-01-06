turmderverlorenen_handler:
    type: world
    debug: false
    enabled: true
    events:
        #area: area_nether_sumpfdervergessenen
        on player enters area_nether_turmderverlorenen:
            - wait 5s
            - ratelimit <player> 10m
            - playsound <player> sound:block_bell_resonate pitch:0.8
            - playsound <player> sound:block_beacon_power_select pitch:0.2
            - title "title:<&6>Infernus" "subtitle:<&f>Turm der Verlorenen" stay:5s targets:<player>