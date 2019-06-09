# Radioactive Sandbox
### A Gamemode by Rambo_9
#### Fixed and tweaked by Bizz

This is a gamemode created for [Garrysmod]( https://store.steampowered.com/app/4000/Garrys_Mod/ ).

the `Gamemode Description` and `customizaing items` section have been copied from the [original facepunch thread]( https://forum.facepunch.com/f/gmodgd/ipuk/Radioactive-Sandbox/1/ ).

## Gamemode Description

---

Radioactive Sandbox a cross between a deathmatch and sandbox with a post-apocalyptic theme. You aren't forced to kill other people, but it is an option. If you aren't too keen about killing people then you can explore the map searching for valuable loot, or go on missions provided by your faction's trader. The whole point is that the gameplay is open ended and entirely up to the player.

You start off choosing a faction. There are 3 factions, each with their own strengths.
- Bandoliers: A group of misfits that travel the wastelands looking for valuables. This faction has better selling prices at their trader, as well as increased payoffs for missions.

- Exodus: A faction devoted to researching the environment and exploring dangerous areas looking for samples and stuff. This faction is the most scientifically advanced, and gives you access to various utilities including radiation filters, medication, flares and other things. These items are quite difficult to come across if you're in any other faction.

- W.M.A (Western Military Alliance): This faction is a group of militants seeking to dominate the wastelands. They have access to better weapons which no other faction can purchase.



Once you have chosen a faction, you are spawned in the faction base and left to do whatever you want. You can talk to your faction's NPC and go on a mission for him so that you may earn money to upgrade your weapons and buy more supplies, or you can go off on your own and explore the map, finding loot and attacking other factions.



Other features:
- Customizable item system. Create your own items unique to your server.

- Day/night cycles that are map-independent. All you need is an env_sun in your map.

- Item/spawnpoint placement gun for admins, so you can make the gamemode playable on any map.

- Weapon base that supports scoped and non-scoped weapons.

- Dynamic radar that detects various things.

- Random events, such as fallout storms which force players to take cover.

- Bleeding, radiation, and stamina system that directly affects the player.

---


## Installation
Clone/download the repository into your garrysmod/garrysmod/gamemodes folder.

in the gamemode's ``content`` folder, copy the data folder out and merge it with the one in your garrysmod/garrysmod folder if you want to get some of the built in map spawns.

Follow [this guide]( https://wiki.garrysmod.com/page/Downloading_a_Dedicated_Server ) if you're trying to set up a server.


---
## Map Support
The gamemode can support any map with some set up.

To start setting up a map, make yourself an admin on your server and enter the following command:

```
sv_radbox_dev_mode
```
This will give you two weapons in your 6th slot the `Item Placement Tool` and the `Prop Placement Tool`

### Item Placement Tool
The item placement tool is what allows you to place gameplay related entities on the map.

```
Priamry Fire - Will place an entity

Secondary Fire - Will cycle the entity you want to spawn

Use Key - Will delete the nearest instance of your selected item

Reload Key - Will delete all of the items in the map of a specific item type
```

#### Item Placement Types
- `info_player_loner` - player spawn for players not in a faction
- `info_player_bandolier` - player spawn for players in bandolier faction
- `info_player_army` - player spawn for players in the MWA faction
- `info_player_exodus` - player spawn for players in the exodus faction
- `npc_trader_bandolier` - Bandolier Trader
- `npc_trader_army` - Army Trader
- `npc_trader_exodus` - Exodus Trader
- `info_lootspawn` - This point will sometimes randomly spawn a loot bag containing some random items
- `info_npcspawn` - This point will be used for spawning hostile rogue/mutant NPCs in the map
- `point_stash` - this will create a "stash point". Which can be interacted with to be looted, best placed over container models
- `point_radioation` - This will create a deadly bubble of radiation which will randomly cycle on/off when radstorms hit.
- `point_skymarker` - Used for random spawning, Having a sky marker placed in the sky of the map will make random spawning of anomolies possible, otherwise they will use loot spawn points

### Prop Placer
The prop placer tool will allow you to spawn props that you can manipulate with your physgun.

You can use these to decorate the map 
```
Primary Fire - Spawn Prop
Secondary Fire - Open Prop Selection Menu
Use Key - Delete Nearest Prop
Reload Key - Delete all props

```

### Saving Changes
Once you're happy with how everything is placed on the map, simply run the following command:
```
sv_radbox_save_map_config
```
This will save a file in your data/radbox folder named after the map, which can be transferred to a server if you set the map up locally

### Custom Map
The map, `The Lonely Road` was made specifically for Radioactive sandbox
Download it [here]( https://garrysmods.org/download/15987/thelonelyroadzip ).

---
## Convars
- `sv_radbox_max_zombies` - Controls the amount of zombie NPCs that can spawn. (def 8)
- `sv_radbox_max_rogues` -  Controls the amount of rogue NPCs that can spawn. (def 6)
- `sv_radbox_max_artifacts` - Controls the amount of artifacts that can spawn. (def 3)
- `sv_radbox_max_anomalies` - Controls the amount of anomalies that can spawn. (def 30)
- `sv_radbox_team_dmg` -  Controls whether teammates can hurt eachother. (def 0)
- `sv_radbox_dmg_scale` - Controls bullet damage scaling. (def 1.0)
- `sv_radbox_allow_build` - Controls whether players can spawn props and use the physics gun. (def 0)
- `sv_radbox_max_props` - Maximum number of props that players can spawn if building is allowed. (def 10)
- `sv_radbox_allow_loners` - Controls whether players spawn initially as a loner. (def 0)
- `sv_radbox_custom_names` - Controls whether players can name themselves. (def 1)
- `sv_radbox_roleplay` - Controls whether the server uses RP chat commands. (def 1)
- `sv_radbox_daycycle` - Controls whether the server has day/night cycles enabled. (def 1)
- `sv_radbox_daycycle_speed` - Controls the speed of the day/night cycle transitions. (def 2.0)
- `sv_radbox_daycycle_intensity` - Controls the intensity of nighttime for day/night cycles. (def 1.0)
- `sv_radbox_daycycle_indoors_light` - Controls how much day/night affects you while indoors. (def 0.4)

---
## Customizing Items

1. Open items/misc.lua
2. Add something like this:

```LUA
function FUNC_TEST( ply, id, client )

	if client then return "Eat" end -- This is the name to show in the clientside menu
	
	ply:RemoveFromInventory( id ) -- Remove the item from the inventory when it's used
	ply:EmitSound( "npc/barnacle/barnacle_gulp1.wav" ) -- Make a sound
	ply:AddHealth( 10 ) -- Give the player some health or something

end

function FUNC_TESTPICKUP( ply, prop )

	ply:ChatPrint( "You just picked up my custom item!" )

	return true
	
end

function FUNC_TESTDROP( ply, prop )

	ply:ChatPrint( "You just dropped my custom item!" )
	
end

item.Register( { 
	Name = "My New Item", 
	Description = "My item is super special.",
	Stackable = true, -- can you stack them?
	Type = ITEM_MISC, -- can be found in loot and in stores... for loot only you'd use ITEM_LOOT and for stores only you'd use ITEM_BUYABLE
	Weight = 0.30, -- how heavy is it (lbs)?
	Price = 15, -- how much does it cost?
	Rarity = 0.50, -- how rare is it? 0.10 is common, 0.90 is very rare
	Model = "models/some_model.mdl",
	Functions = { FUNC_TEST }, -- a table of functions it can perform when used from the inventory menu
       PickupFunction = FUNC_TESTPICKUP, -- a function called when you pick it up
	DropFunction = FUNC_TESTDROP, -- a function called when you drop it
	CamPos = Vector(15,15,5), -- modify these positions/origins if the model looks funny in the inventory panel
	CamOrigin = Vector(0,0,5)	
} )
```
And there's your basic item. You can remove PickupFunction/DropFunction if you don't want your item to have any of those.

## Future Plans
I more or less fixed this up on a whim because I was feeling some nostalgia for this gamemode back when I missed with it years ago. I did my best to fix it up but there are still many issues seeing as this hasn't been touched for 8 years and was made on the last version of gmod.

Still whenever I have some free time I'd like to do the following:

- fix up more errors.

- Fix the font issues.

- Replace all CS:S dependencies with Half Life 2 or Custom assets so people won't see errors if they don't own CS:S.

- Improve Weapons

- Improve the Radstorm Effect

- Add a way for players to keep their items when they log out, but isn't abusable for combat logging. Maybe turn the player into an idle NPC when they log out that will hold on to their inventory until they rejoin.