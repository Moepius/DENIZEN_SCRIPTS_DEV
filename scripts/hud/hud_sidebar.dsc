# displays a sidebar fo every player with info (toggable)

# nur freigeschaltete Spieler haben Zugriff auf die sidebar
# Command, um sidebar ein- auszuschalten, auch über gui /sidebar on|off
# 


# ------------------------- Begin configuration -------------------------
magic_sidebar_config:
    type: data
    # How many updates per second (acceptable values: 1, 2, 4, 5, 10)
    per_second: 2
    # Set this to your sidebar title.
    title: "<&f><&m>----------------"
    # Set this to the list of sidebar lines you want to display.
    # Start a line with "[scroll:#/#]" to make it automatically scroll
    # with a specified width and scroll speed (characters shifted per second).
    # Note that width must always be less than the line's actual length.
    # There should also be at least one normal line that's as wide as the width, to prevent the sidebar resizing constantly.
    lines:
    - "<&2>⊚ <&a><player.location.simple.before_last[,].replace[,].with[<&2>,<&a>]>"
    - "<&6>❖ <&e><player.flag[player.flag.currency.money_total].if_null[0]> <&6>ᛔ <&e><player.flag[player.currency.bank.amount].if_null[0]> <&5>✦ <&d><player.flag[player.currency.crystals.amount].if_null[0]>"
    - "<&3>⛏ <&b><player.flag[player.skill.level.total].if_null[0]>"
    - "<&f><&m>----------------"
# ------------------------- End of configuration -------------------------

magic_sidebar_world:
    type: world
    debug: false
    events:
        on delta time secondly:
        - define per_second <script[magic_sidebar_config].data_key[per_second]>
        - define wait_time <element[1].div[<[per_second]>]>s
        - define players <server.online_players.filter[has_flag[sidebar_disabled].not]>
        - define title <script[magic_sidebar_config].data_key[title]>
        - repeat <[per_second]>:
            - sidebar title:<[title].parsed> values:<proc[magic_sidebar_lines_proc]> players:<[players]> per_player
            - wait <[wait_time]>

magic_sidebar_lines_proc:
    type: procedure
    debug: false
    script:
    - define list <script[magic_sidebar_config].data_key[lines]>
    - foreach <[list]> as:line:
        - define list_index <[loop_index]>
        - define line <[line].parsed>
        - if <[line].starts_with[<&lb>scroll<&co>]>:
            - define width <[line].after[<&co>].before[/]>
            - define rate <[line].after[/].before[<&rb>]>
            - define line <[line].after[<&rb>]>
            - define index <server.current_time_millis.div[1000].mul[<[rate]>].round.mod[<[line].strip_color.length>].add[1]>
            - define end <[index].add[<[width]>]>
            - repeat <[line].length> as:charpos:
                - if <[line].char_at[<[charpos]>]> == <&ss>:
                    - define index <[index].add[2]>
                - if <[index]> <= <[charpos]>:
                    - repeat stop
            - define start_color <[line].substring[0,<[index]>].last_color>
            - if <[end]> > <[line].strip_color.length>:
                - define end <[end].sub[<[line].strip_color.length>]>
                - repeat <[line].length> as:charpos:
                    - if <[line].char_at[<[charpos]>]> == <&ss>:
                        - define end <[end].add[2]>
                    - if <[end]> < <[charpos]>:
                        - repeat stop
                - define line "<[start_color]><[line].substring[<[index]>]> <&f><[line].substring[0,<[end]>]>"
            - else:
                - repeat <[line].length> as:charpos:
                    - if <[line].char_at[<[charpos]>]> == <&ss>:
                        - define end <[end].add[2]>
                    - if <[end]> < <[charpos]>:
                        - repeat stop
                - define line <[start_color]><[line].substring[<[index]>,<[end]>]>
        - define list <[list].set[<[line]>].at[<[list_index]>]>
    - determine <[list]>

magic_sidebar_command:
    type: command
    debug: false
    name: sidebar
    usage: /sidebar
    description: Toggles your sidebar on or off.
    script:
    - if <player.has_flag[sidebar_disabled]>:
        - flag player sidebar_disabled:!
        - run chatsounds_standard def:<player>
        - narrate format:c_info "Seitenleiste eingeschaltet."
    - else:
        - flag player sidebar_disabled
        - run chatsounds_standard def:<player>
        - narrate format:c_info "Seitenleiste ausgeschaltet."
        - wait 1
        - sidebar remove players:<player>
