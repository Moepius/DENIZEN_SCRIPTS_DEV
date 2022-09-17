# Prints errors and stacktraces to discord
# Does not handle setting up your discord bot for you, assumes that is already done
# Author: Mergu

# Requires the following Denizen config settings:
# Commands.File.Allow read: true
# Commands.File.Restrict path: ./
# OR
# Commands.File.Restrict path: none

error_handler_conf:
  type: data
  debug: false
  data:
    bot_id: craftasybot
    channel_id: 1020581895328776222
    # Shows errors that crop up in any scripts that get run
    show_script_errors: true
    # If you would like to turn off error reporting for things like the /ex command, set to false
    show_nonscript_errors: true
    # Shows full stacktraces that get thrown by any plugin
    show_stacktraces: true

# An example task with an error
#script_with_error_example:
#  type: task
#  debug: false
#  script:
#    # this is definitely broken
#    - define foo bar
#    - define long_def <util.list_numbers_to[100]>
#    - narrate <player.foobar>

#script_with_exception_example:
#  type: task
#  debug: false
#  script:
#    - debug exception "This is an example"

error_handlers:
  type: world
  debug: false
  show_script_error:
    - wait 1t
    - define error_messages <context.queue.flag[_script_errors.<[uniq]>].deduplicate>
    - flag <context.queue> _script_errors.<[uniq]>:!
    - define def_map <context.queue.definition_map.exclude[_script_errors]>
    - ~fileread path:<context.script.relative_filename> save:f
    - define full_script <entry[f].data.utf8_decode.replace_text[<&chr[000D]>].split[<n>]||null>
    - if <[full_script]> == null:
      - announce to_console "Error reading script in error_handler script. Make sure to set 'Commands.File.Allow read' to 'true' and 'Commands.File.Restrict path' to './' or 'none'"
      - stop
    - define "output:->:ERROR in script '<context.script.name>' in queue '<context.queue.id>'"
    - define "output:->:      while executing command '<[full_script].get[<context.line>].after[- ].before[ ].to_uppercase>' in file '<context.script.relative_filename>' on line '<context.line>'"
    - if <context.queue.player||null> != null:
      - define "attachments:->:player '<context.queue.player> (<context.queue.player.name>)'"
    - if <context.queue.npc||null> != null:
      - define "attachments:->:npc '<context.queue.npc> (<context.queue.npc.name>)'"
    - if <[attachments].exists>:
      - define "output:->:      with attached <[attachments].separated_by[ and ]>"
    - define output:->:<empty>
    - foreach <[error_messages]> as:error:
      - if <[loop_index]> == 1:
        - define "output:->:ERROR <[error]>"
      - else:
        - define "output:->:      <[error]>"

    - if !<[def_map].is_empty>:
      - define output:->:<empty>
      - define "output:->:=== Definitions ==="
      - define output:->:<empty>
      - foreach <[def_map]>:
        - define value <[value].as_element>
        - if <[value].length> > 50:
          - define value <[value].substring[0,50]>...
        - define "output:->:<&lt>[<[key]>]<&gt> == <[value]>"

    # Dump the script into the discord message
    - define output:->:<empty>
    - define "output:->:=== Full Script ==="
    - define output:->:<empty>
    - define in_script false
    - define comment_buffer <list>
    - foreach <[full_script]> as:line:
      # Check if we're in the script
      - if <[line].starts_with[<context.script.name><&co>]>:
        - define in_script true
        - if !<[comment_buffer].is_empty>:
          - define output:|:<[comment_buffer]>
      # If we're in the script and the script finishes, stop
      - else if <[in_script]> and <[line].substring[0,1].length> == 1 and <[line].substring[0,1]> != " ":
        - foreach stop
      # Buffer comments for display above the script
      - else if !<[in_script]> and <[line].starts_with[<&ns>]>:
        - define comment_buffer:->:<[line]>
      # Only allow a comment chain right above the script
      - else:
        - define comment_buffer <list>
      - if <[in_script]>:
        - if <context.line> == <[loop_index]>:
          - define "output:->:<&gt><[line].after[ ]>"
        - else:
          - define output:->:<[line]>

    - if <bungee.server||null> == null:
      - define message ":warning: Scripting error occurred, see below for details (Click expand for more info)"
    - else:
      - define message ":warning: **[<bungee.server>]** Scripting error occurred, see below for details (Click expand for more info)"
    - define message "<[message]><n>:scroll: <context.script.name>: <[error_messages].first>"
    - if <context.queue.player||null> != null:
      - define message "<[message]> -- Errored for <context.queue.player.name>"
    - define bot_id <script[error_handler_conf].parsed_key[data.bot_id]>
    - define channel <script[error_handler_conf].parsed_key[data.channel_id]>
    - ~discordmessage id:<[bot_id]> channel:<[channel]> <[message]> attach_file_name:error.txt attach_file_text:<[output].separated_by[<n>]>
  show_nonscript_error:
    - wait 1t
    - define error_messages <context.queue.flag[_script_errors.<[uniq]>].deduplicate>
    - flag <context.queue> _script_errors.<[uniq]>:!
    - define message ":clipboard:"
    - if <bungee.server||null> != null:
      - define message "<[message]> **[<bungee.server>]**"
    - if <context.queue.id.before[_]> == excommand:
      - define message "<[message]> Error in /ex command:<n>```"
    - else:
      - define message "<[message]> Error in non-script queue:<n>```"
    - define message "<[message]>ERROR in queue '<context.queue.id>'"
    - if <context.queue.player||null> != null:
      - define message "<[message]> with player '<context.queue.player> (<context.queue.player.name>)'"
    - if <context.queue.npc||null> != null:
      - define message "<[message]> with npc '<context.queue.npc> (<context.queue.npc.name>)'"
    - define message "<[message]><&co><n>      "
    - define message "<[message]><[error_messages].separated_by[<n>      ]>```"
    - define bot_id <script[error_handler_conf].parsed_key[data.bot_id]>
    - define channel <script[error_handler_conf].parsed_key[data.channel_id]>
    - ~discordmessage id:<[bot_id]> channel:<[channel]> <[message]>
  show_nonscript_nonqueue_error:
    - define message ":clipboard:"
    - if <bungee.server||null> != null:
      - define message "<[message]> **[<bungee.server>]**"
    - define message "<[message]> ERROR: <context.message>"
    - define bot_id <script[error_handler_conf].parsed_key[data.bot_id]>
    - define channel <script[error_handler_conf].parsed_key[data.channel_id]>
    - ~discordmessage id:<[bot_id]> channel:<[channel]> <[message]>
  events:
    on server generates exception:
      - ratelimit exception_lock 5t
      - define message ":bangbang:"
      - if <bungee.server||null> != null:
        - define message "<[message]> **[<bungee.server>]**"
      - define message "<[message]> SERVER GENERATED EXCEPTION -- <context.type><&co> <context.message>"

      - if <context.queue||null> != null:
        - define "output:->:ERROR in queue '<context.queue.id>'"
        - if <context.queue.script||null> != null:
          - define "output:->:      in script '<context.queue.script.name>' in file '<context.queue.script.relative_filename>'"
        - if <context.queue.player||null> != null:
          - define "attachments:->:with player '<context.queue.player> (<context.queue.player.name>)'"
        - if <context.queue.npc||null> != null:
          - define "attachments:->:with npc '<context.queue.npc> (<context.queue.npc.name>)'"
        - if !<[attachments].is_empty>:
          - define "output:->:      <[attachments].separated_by[ ]>"
        - define output:->:<empty>

      - define "output:->:[Error Message]   <context.full_trace.strip_color>"
      - define bot_id <script[error_handler_conf].parsed_key[data.bot_id]>
      - define channel <script[error_handler_conf].parsed_key[data.channel_id]>
      - ~discordmessage id:<[bot_id]> channel:<[channel]> <[message]> attach_file_name:exception.txt attach_file_text:<[output].separated_by[<n>]>
    on script generates error:
      - if <context.script.name||null> == <script.name||null>:
        - stop
      - if <context.queue||null> != null:
        # Track all of the errors that happen this tick, ratelimited so only the first fires a message
        - define uniq <context.queue.id>-<context.line||0>-<context.queue.player||null>-<context.queue.npc||null>
        - define uniq <[uniq].utf8_encode>
        # Queue flags make definitions
        - flag <context.queue> _script_errors.<[uniq]>:->:<context.message.strip_color>
        - ratelimit <[uniq]> 1t
      - if <context.queue||null> == null:
        - if <script[error_handler_conf].parsed_key[data.show_nonscript_errors]||false>:
          - inject <script> path:show_nonscript_nonqueue_error
      - else if <context.script||null> == null:
        - if <script[error_handler_conf].parsed_key[data.show_nonscript_errors]||false>:
          - inject <script> path:show_nonscript_error
      - else if <script[error_handler_conf].parsed_key[data.show_script_errors]||false>:
        - inject <script> path:show_script_error