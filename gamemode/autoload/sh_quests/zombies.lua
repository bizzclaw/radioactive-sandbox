
--// Find the loot quest

if CLIENT then

	GM:RegisterQuest( "Find and retrieve 3 zombie body parts.", "radbox/menu_loot" )
	
	return

end

local QUEST = {}

QUEST.Start = function( ply )
	
	local zombie = table.Random( ents.FindByClass( "npc_zombie*" ) )
	
	if IsValid( zombie ) then
	
		ply:SetRadarStaticTarget( zombie )
	
	end
	
	ply.QuestNum = 0
	ply:Notify( "The position of a zombie has been marked on your radar." )
	
end

QUEST.CanStart = function( ply )

	local canstart = #ents.FindByClass( "npc_zombie*" ) > 0
	
	if not canstart then
	
		ply:DialogueWindow( "This mission is not currently available." )
	
	end

	return canstart

end

QUEST.Cancel = function( ply )

	ply:SetInQuest( false, 0 )
	ply:SetRadarStaticTarget( NULL )
	ply.QuestNum = nil

end

QUEST.StatusThink = function( ply )

	local count = 0

	for k,v in pairs( item.GetByType( ITEM_QUEST_ZOMBIE ) ) do
	
		count = count + ply:GetItemCount( v.ID )
	
	end

	if count != ply.QuestNum then
	
		if count < ply.QuestNum then 
		
			ply.QuestNum = count
		
			return 
			
		end
	
		if count >= 3 then
		
			ply:Notify( "Bring the zombie body parts to me for your reward." )
			ply:SetRadarStaticTarget( ply:GetTeamTrader() )
		
		elseif count == 2 then
		
			ply:Notify( "You need 1 more zombie body part." )
			
		
		else
		
			ply:Notify( "You need " .. 3 - count .. " more zombie body parts." )
		
		end
		
		ply.QuestNum = count
	
	end
	
	if not IsValid( ply:GetRadarTarget() ) and ply.QuestNum < 3 then
	
		local tbl = ents.FindByClass( "npc_zombie*" )
		
		if #tbl < 1 then return end
	
		local zombie = table.Random( tbl )
	
		if IsValid( zombie ) then
	
			ply:SetRadarStaticTarget( zombie )
			ply:Notify( "Another zombie's position has been marked on your radar." )
	
		end
	
	end

end

QUEST.CanEnd = function( ply )

	if ply.QuestNum >= 3 then 
	
		return true
	
	end

	return false
	
end

QUEST.Dialogue = function( ply )

	ply:DialogueWindow( "You haven't retrieved three body parts." )

end

QUEST.End = function( ply )

	local cash = 300
	
	if ply:Team() == TEAM_BANDOLIERS then
	
		cash = 400
		
	end
	
	local count = 0
	
	for k,v in pairs( item.GetByType( ITEM_QUEST_ZOMBIE ) ) do
	
		if ply:HasItem( v.ID ) then
	
			for i=1, ply:GetItemCount( v.ID ) do
			
				if count < 3 then
				
					ply:RemoveFromInventory( v.ID )
					count = count + 1
				
				end
		
			end
			
		end
	
	end
	
	ply:AddCash( cash )
	ply:DialogueWindow( "You have earned $"..cash.."." )
	
	ply:SetInQuest( false, 0 )
	ply:SetRadarStaticTarget( NULL )
	ply.QuestNum = nil

end

GM:RegisterQuest( QUEST )
