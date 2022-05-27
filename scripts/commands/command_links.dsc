command_links:
    type: command
    debug: false
    name: links
    description: Craftasy Linkübersicht
    usage: /links
    aliases:
    - link
    - website
    - seite
    - youtube
    - discord
    script:
    - playsound <player> sound:item_book_page_turn volume:1 pitch:1
    - wait 0.5s
    - execute as_server "cmi openbook craftasy_cmi_links_customtext <player.name>"