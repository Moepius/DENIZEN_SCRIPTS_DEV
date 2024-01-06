### MULTITOOL ###

# combine all craftasy admin tools under one
# Rightclicking item with opened inventory opens GUI to select mode
# events changed to sth. like this - on player right clicks with:craftasy_multitool flagged:player.command.multitool.Mmde_duenger

placeholder_command:
  type: command
  debug: false
  name: placeholder
  description: Chatdaten aktualisieren
  usage: /placeholder
  permission: chat.admin
  script:
    - narrate placeholder