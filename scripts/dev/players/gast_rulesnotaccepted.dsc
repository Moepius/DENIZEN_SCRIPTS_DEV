# Script für Spieler, die das erste mal dem Server joinen und jene, die die Regeln noch nicht akzeptiert haben
# locations: spawnportal_nopermissionteleport
# areas: area_note_spawnportal
# flags: firstjoin_infosangezeigt (wird gesetzt wenn Willkommensnachrichtem beim ersten join usw. einmal durchgelaufen sind, bevor irgendwelche anderen Chats ausgeführt werden sollten)
#

gast_rules_not_accepted:
    type: world
    debug: false
    enabled: false
    events:
        on player enters area_note_spawnportal:
            - run task_no_enter "def:craftasy.denizen.ranks.rules_accepted|Akzeptiert zunächst unsere Regeln!"