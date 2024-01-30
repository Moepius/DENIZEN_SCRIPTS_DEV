# Bookshelf Lore
# Author: Moepius
# Version: 0.0.1
#
# flags:
# notes:
# permission:
#
# Displays random citations from books and some lore if a player right clicks any bookshelf, or take a random book.
#

world_bookshelf_lore:
    type: world
    debug: false
    events:
        on player right clicks bookshelf with:air|book:
            - random:
                - repeat 1:
                    - ratelimit <player> 1t
                    - playsound <player> sound:item_book_page_turn pitch:1
                    - narrate format:headerOhneText ""
                    - narrate <empty>
                    - narrate "<&b>“<&f>Facilis descensus Averno Noctes atque dies patet atri ianua Ditis Sed revocare gradum superasque evadere ad auras Hoc opus labor est.<&b>”"
                    - narrate "<&6><&o>Cassandra Clare, City of Glass"
                    - narrate <empty>
                    - narrate format:footerOhneText ""
                - repeat 1:
                    - ratelimit <player> 1t
                    - playsound <player> sound:item_book_page_turn pitch:1
                    - narrate format:headerOhneText ""
                    - narrate <empty>
                    - narrate "<&b>“<&f>Haec ego non multis (scribo), sed tibi: satis enim magnum alter alteri theatrum sumus.<&b>”"
                    - narrate "<&6><&o>Epicurus"
                    - narrate <empty>
                    - narrate format:footerOhneText ""
                - repeat 1:
                    - ratelimit <player> 1t
                    - playsound <player> sound:item_book_page_turn pitch:1
                    - narrate format:headerOhneText ""
                    - narrate <empty>
                    - narrate "<&b>“<&f>Non est ad astra mollis e terris via.<&b>”"
                    - narrate "<&6><&o>Seneca"
                    - narrate <empty>
                    - narrate format:footerOhneText ""
                - repeat 1:
                    - ratelimit <player> 1t
                    - playsound <player> sound:item_book_page_turn pitch:1
                    - narrate format:headerOhneText ""
                    - narrate <empty>
                    - narrate "<&b>“<&f>Leere Seiten<&b>”"
                    - narrate "<&6><&o>Nichts"
                    - narrate <empty>
                    - narrate format:footerOhneText ""
                - repeat 1:
                    - ratelimit <player> 1t
                    - playsound <player> sound:item_book_page_turn pitch:1
                    - narrate format:headerOhneText ""
                    - narrate <empty>
                    - narrate "<&b>“<&f>Jedes hinreichend mächtige, rekursiv aufzählbare formale System ist entweder widersprüchlich oder unvollständig.<&b>”"
                    - narrate "<&6><&o>Kurt Gödel"
                    - narrate <empty>
                    - narrate format:footerOhneText ""
                - repeat 1:
                    - ratelimit <player> 1t
                    - playsound <player> sound:item_book_page_turn pitch:1
                    - narrate format:headerOhneText ""
                    - narrate <empty>
                    - narrate "<&b>“<&f>Jedes hinreichend mächtige konsistente System kann die eigene Konsistenz nicht beweisen.<&b>”"
                    - narrate "<&6><&o>Kurt Gödel"
                    - narrate <empty>
                    - narrate format:footerOhneText ""

        #TODO: Buch "the egg"
        # TODO: zu manchen Zitaten bissige Kommentare von Velnias oder dem Magier
        # TODO: Buch mit Zitaten aus der Volxbibel