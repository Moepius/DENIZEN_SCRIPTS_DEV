# https://meta.denizenscript.com/Docs/Search/hotbar#player%20click_type%20clicks%20item%20in%20inventory

# https://meta.denizenscript.com/Docs/Commands/give

# check if item isn't air
# https://meta.denizenscript.com/Docs/Tags/playertag.inventory

# https://meta.denizenscript.com/Docs/Tags/itemtag.material

# https://meta.denizenscript.com/Docs/Tags/materialtag.name

command_gui_toggle:
    type: command
    debug: true
    name: gui
    description: Craftasy Menü Einschalten
    usage: /gui
    aliases:
    - menü
    - guis
    - menu
    - guitoggle
    script:
        - define item <player.inventory.slot[9]>
        - if <[item].material.name> != air:
            - if <[item].script.name> != craftasy_gui_item:
                - drop <[item]> <player.location>
                - take slot:9 quantity:64
        - if <[item].script.name> == craftasy_gui_item:
            - narrate format:c_info "Ihr habt das Menü bereits aktiviert."
        - else:
            - playsound <player> sound:block_sculk_sensor_clicking volume:1 pitch:1
            - narrate format:c_info "Menü Item erhalten.<&a> SCHLEICHEN + RECHTSKLICK<&b>, um es zu entfernen."
            - give craftasy_gui_item slot:9