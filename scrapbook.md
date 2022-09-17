# TODO

- Add docs to every script
- Set all flag names to fit the flag name convention

# Notes

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

# Tag Collection

## Player Tags

### Statistics

- <duration[<player.statistic[PLAY_ONE_MINUTE]>t].formatted>
  shows players playtime

### Flag Stuff

- <player.flag[player.flag.currency.money_total].if_null[0]>
  Shows players total money amount (needs flag player.flag.currency.money_total)
- <player.flag[player.currency.bank.amount].if_null[0]>
  Shows players total money in bank amount (needs flag player.currency.bank.amount)
- <player.flag[player.currency.crystals.amount].if_null[0]>
  Shows players total crytsal amount (needs flag player.currency.crystals.amount)