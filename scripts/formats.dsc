##########################################################################
## FORMATE                                                              ##
##########################################################################


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
    - narrate format:c_info_2 Information
    - narrate format:c_warn Warnung
    - narrate format:c_warn_2 Warnung
    - narrate format:headerMitText "Info"
    - narrate format:headerOhneText <empty>
    - narrate format:footerOhneText <empty>
