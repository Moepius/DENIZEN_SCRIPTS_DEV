##########################################################################
## FORMATS                                                              ##
##########################################################################

##========================================================================
## NPC Formats
##========================================================================

npc_talk:
  type: format
  format: "<&f>[<&a><&l>NPC<&f>] | <&a><npc.name><&f> | <&b><[text]>"
npc_talk_absatz:
  type: format
  format: "<&f>[<&a><&l>NPC<&f>] | <&a><npc.name><&f>:"

##========================================================================
## Information Formats
##========================================================================

c_info:
  type: format
  debug: false
  format: "<&b><&l>[<&6><&l>i<&b><&l>]<&b> <[text]>"

c_warn:
  type: format
  debug: false
  format: "<&c><&l>[<&f><&l>i<&c><&l>]<&c> <[text]>"

##========================================================================
## Layout Formats
##========================================================================

headerMitText:
  type: format
  debug: false
  format: "<&f><&m>-------------------------------------------------<&nl><&3>➤ <&6><&l><[text]>"

headerOhneText:
  type: format
  debug: false
  format: "<&f><&m>-------------------------------------------------"

footerOhneText:
  type: format
  debug: false
  format: "<&f><&m>-------------------------------------------------"

##========================================================================
## Actionbar Formats
##========================================================================

# Texte in der Actionbar müssen kurz gehalten werden!
actionbarStatus:
  type: format
  debug: false
  format: "<&e><&l><[text]>"


##========================================================================
## Test-task
##========================================================================
task_format:
  type: task
  debug: false
  script:

#   Information Formats
    - narrate format:c_info Information
    - narrate format:c_warn Warnung
    - narrate format:headerMitText "Info"
    - narrate format:headerOhneText <empty>
    - narrate format:footerOhneText <empty>
