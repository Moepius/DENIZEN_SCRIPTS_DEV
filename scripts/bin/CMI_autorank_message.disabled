CMI_autorank_message:
  type: task
  debug: false
  definitions: playtime|rank_number_prev|rank_color_prev|rank_prev|rank_color|rank|boni
  script:
    - playsound <player> sound:UI_TOAST_CHALLENGE_COMPLETE
    - title "title:<green><&l>Gruppenaufstieg!" stay:3s targets:<player>
    - wait 5s
    - playsound <player> sound:ENTITY_GLOW_ITEM_FRAME_ADD_ITEM pitch:1
    - narrate "<&b>Ihr habt <&e><[playtime]><&b> auf <&3><&l>Craftasy<&b> gespielt, <&e><player.name><&b>.""
    - narrate "[{"text":"<&e><[rank_color_prev]><&chr[2749]> <&l><[rank_prev]>","hoverEvent":{"action":"show_text","value":"Zeige Info zu dieser Gruppe"},"clickEvent":{"action":"suggest_command","value":"/<[rank_prev]> "}},{"text":" <&b><&m>--<&b><&l><&gt> "},{"text":"<&e>[rank_color]<&chr[2749]> <&l><[rank]>","hoverEvent":{"action":"show_text","value":"Zeige Info zu dieser Gruppe"},"clickEvent":{"action":"suggest_command","value":"/<[rank]> "}}]"
    - narrate t:<player>
    - narrate t:<player> <&2><&l>Boni<&2><&co> <[boni]>
    - narrate t:<player> <&3><&m>--------------------------------------------<&l>-<&3><&m>--------
    - execute as_server "lp user <player.name> parent remove free_<[rank_number_prev]>"
