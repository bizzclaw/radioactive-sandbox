
function team.GetDescription( num )

	if num == TEAM_EXODUS then
	
		return "radbox/logo_exodus",
			   { GAMEMODE.ExodusTeamName .. " is a faction devoted to researching the landscape and collecting information.",
			   " Their scientific background gives them access to many useful utilities that would otherwise be difficult to obtain.",
			   " Though they are generally a peaceful faction, " .. GAMEMODE.ExodusTeamName .. " members will not hesitate to defend themselves when attacked."}
	
	elseif num == TEAM_ARMY then
	
		return "radbox/logo_nma",
			   {"The " .. GAMEMODE.ArmyTeamName .. " is a large group of mercenaries and ex-soldiers working together.",
			   " Their connections to various arms dealers gives them access to some especially powerful weapons.",
			   " The main goal of this faction is to eliminate any potential threats that get in their way and create a new world order."}
	
	else
	
		return "radbox/logo_bandoliers",
		       {"The " .. GAMEMODE.BandoliersTeamName .. " are a group of marauders and rebels focused on looting the remains of the wastelands.",
			   " Their network of black market dealers provides them with increased mission payoffs and better selling prices.",
			   " The " .. GAMEMODE.BandoliersTeamName .. " are notorious for their greedy and aggressive mindset."}
	
	end

end

function team.GetLeaderModel( num )

	return GAMEMODE.TeamLeaderModels[ num ]

end

function team.GetPlayerModel( num )

	return table.Random( GAMEMODE.TeamPlayerModels[ num ] )

end

function team.GetItemLoadout( num )

	if num == TEAM_EXODUS then
	
		return { ITEM_BUYABLE, ITEM_BUYABLE, ITEM_SUPPLY, ITEM_SUPPLY }
	
	elseif num == TEAM_ARMY then
	
		return { ITEM_BUYABLE, ITEM_BUYABLE, ITEM_SUPPLY, ITEM_FOOD }
	
	elseif num == TEAM_BANDOLIERS then
	
		return { ITEM_BUYABLE, ITEM_BUYABLE, ITEM_BUYABLE, ITEM_SUPPLY }
	
	else
	
		return { ITEM_BUYABLE, ITEM_BUYABLE, ITEM_BUYABLE, ITEM_SUPPLY, ITEM_SUPPLY }
	
	end

end

function team.GetTrader( num )

	if num == TEAM_EXODUS then
	
		return ents.FindByClass( "npc_trader_exodus" )[1]
	
	elseif num == TEAM_ARMY then
	
		return ents.FindByClass( "npc_trader_army" )[1]

	else
	
		return ents.FindByClass( "npc_trader_bandoliers" )[1]
	
	end
	
end

function team.ClassToName( ent )

	local tbl = {}
	tbl[ "npc_trader_army" ] = GAMEMODE.TraderNames[ TEAM_ARMY ]
	tbl[ "npc_trader_exodus" ] = GAMEMODE.TraderNames[ TEAM_EXODUS ]
	tbl[ "npc_trader_bandoliers" ] = GAMEMODE.TraderNames[ TEAM_BANDOLIERS ]
	
	return tbl[ ent:GetClass() ]

end

function team.GetTraderName( ent )
	
	if CLIENT then
	
		if IsValid( ent ) then
	
			return team.ClassToName( ent )
			
		else
		
			return GAMEMODE.TraderNames[ LocalPlayer():Team() ]
		
		end
	
	end
		
	if IsValid( ent ) then
	
		return team.ClassToName( ent )
	
	else
	
		return GAMEMODE.TraderNames[ TEAM_LONER ]
	
	end

end
