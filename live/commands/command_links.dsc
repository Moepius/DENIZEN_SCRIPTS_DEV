# TODO: use script to show fake book, or open a book custom item

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
    - wait 0.2s
    # TODO: Ersetzen durch Book Script
    - execute as_server "cmi openbook craftasy_cmi_links_customtext <player.name>"