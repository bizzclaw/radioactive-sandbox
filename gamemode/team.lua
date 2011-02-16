
function team.GetDescription( num )

	if num == TEAM_EXODUS then
	
		return "radbox/logo_exodus",
			   {"Exodus is a faction devoted to researching the landscape and collecting samples.",
			   " Their scientific background gives them access to many useful utilities that would otherwise be difficult to obtain.",
			   " Though they are generally a peaceful faction, Exodus members will not hesitate to defend themselves when attacked."}
	
	elseif num == TEAM_ARMY then
	
		return "radbox/logo_nma",
			   {"When society fell apart, a large group of mercenaries and ex-soldiers banded together to form the Western Military Alliance.",
			   " Their connections to various arms dealers gives them access to some especially powerful weapons.",
			   " The main goal of this faction is to eliminate any potential threats that get in their way and create a new world order."}
	
	else
	
		return "radbox/logo_bandoliers",
		       {"The Bandoliers are a group of bandits and rebels focused on looting the remains of what once was society.",
			   " Their network of black market dealers provides them with increased mission payoffs and better selling prices.",
			   " The Bandoliers are notorious for their greedy and aggressive mindset."}
	
	end

end

function team.GetPlayerModel( num )

	if num == TEAM_EXODUS then
	
		return "models/player/gasmask.mdl"
	
	elseif num == TEAM_ARMY then
	
		return "models/player/phoenix.mdl"
	
	else
	
		return table.Random({"models/player/Group03/male_01.mdl", 
							"models/player/Group03/male_02.mdl", 
							"models/player/Group03/male_03.mdl", 
							"models/player/Group03/male_04.mdl", 
							"models/player/Group03/male_05.mdl", 
							"models/player/Group03/male_06.mdl"})
	
	end

end

function team.GetItemLoadout( num )

	if num == TEAM_EXODUS then
	
		return { ITEM_BUYABLE, ITEM_SUPPLY, ITEM_SUPPLY }
	
	elseif num == TEAM_ARMY then
	
		return { ITEM_BUYABLE, ITEM_SUPPLY, ITEM_FOOD }
	
	else
	
		return { ITEM_BUYABLE, ITEM_BUYABLE, ITEM_SUPPLY }
	
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

function team.GetTraderName( ent )
	
	if not ent and CLIENT then

		if LocalPlayer():Team() == TEAM_EXODUS then
		
			return "Dr. Kleisner"
			
		elseif LocalPlayer():Team() == TEAM_ARMY then
		
			return "Bishop"
		
		else
		
			return "Grigorovich"
		
		end
	
	end

	if ent:GetClass() == "npc_trader_exodus" then
	
		return "Dr. Kleisner"
	
	elseif ent:GetClass() == "npc_trader_army" then
	
		return "Bishop"
	
	else
	
		return "Grigorovich"
	
	end

end
