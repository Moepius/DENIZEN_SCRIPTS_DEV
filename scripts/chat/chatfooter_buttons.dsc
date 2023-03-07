


chatfooter_buttons:
    type: world
    debug: true
    enabled: true
    # flags
    player_received_message: player.chat.received_message
    # event handling
    events:
        on player receives message:
            # flag player with received message
            - flag <player> <script.data_key[player_received_message]>:->:<context.message>
            # resend chat history with buttons added
            ####### will be stuck in a loop and crash the server, need to fix
            #- narrate <n.repeat[100]>
            #- narrate <script.data_key[player_received_message].get[-50].to[-1].separated_by[<n>]>
            #- narrate <element[Testbutton].on_hover[<&c>Nur ein Test!]>
        on player quits:
            # delete all messages in chat flag
            - flag <player> <script.data_key[player_received_message]>:!