# TODO

- Add docs to every script
- Set all flag names to fit the flag name convention

# Notes

### Claiming System (Colonies)

- teleport scrolls have expensive crafting recipes, with a higher skill in crafting and upgraded claim they get cheaper

#### unicode symbols

⚔, 🗡, ☠, ⊚, ❖, ⌛, ᛔ, ✦, ⛏, 🔥, ⚡, ✺

### Protection
- Locking Skills: when a player joins and is in survival/not another game mode he gets a flag like `player.core.experience.enabled`  
which allows him to level up in skills etc.
- Otherwise he gets the flag `player.core.experience.disabled` and some events will be cancelled with flagged argument  
example:  
`player absorbs experience flagged:player.core.experience.disabled:  
  - determine cancelled`

### teleport Pillars

- Teleport to fixed destinations that have a monument (pillars) using advanced soul magic
- Monuments mostly ruined
- Player gets burned when touching blocks of ruined monuments (which are not working anymore)

### colonies

- leveling colonies up can only be done once a day
- firework effects when leveling up and colonizing

**Stuff to disable**:

- gaining experience (orbs)
- eating
- healing
- opening enderchest
- dropping items
- trading
- picking up items
- gainig/loosing money
- gaining skill experience
- killing mobs (without command)
- entering survival gameplay zones (kolonie, avarus)
- ...

## flag scaffold

targets (object where flag is stored):
- player
- server
- item
- location
- inventory
- npc

categories (based on script folders):
- core
- command
- items
- currency
- rank
- world
- chat
- claims
- skill
- quest
- npc

**<flag_target>.<flag_category>.[<flag_subcategory/ies>].<flag_usecase/name>**

## flags

player.core.chat_interaction.interactionmode - used to disable chat controlling when player interacts with the chat (using search through chat, submitting reports, etc.)

# Tag Collection

## Player Tags

### Statistics

- <duration[<player.statistic[PLAY_ONE_MINUTE]>t].formatted>
  shows players playtime (measured by server)

### Flag Stuff

- <player.flag[player.flag.currency.money_total].if_null[0]>
  Shows players total money amount (needs flag player.flag.currency.money_total)
- <player.flag[player.currency.bank.amount].if_null[0]>
  Shows players total money in bank amount (needs flag player.currency.bank.amount)
- <player.flag[player.currency.crystals.amount].if_null[0]>
  Shows players total crytsal amount (needs flag player.currency.crystals.amount)