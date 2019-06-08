
--// Find the loot quest

if CLIENT then

	GM:RegisterQuest( "Locate and retrieve an important item.", "radbox/menu_loot" )
	
	return

end

local QUEST = {}

QUEST.Start = function( ply )

	local pos = ply:GetPos()
	local maxdist = 500
	local spawns = {}
	
	for k,v in pairs( ents.FindByClass( "info_lootspawn" ) ) do
	
		local dist = v:GetPos():Distance( pos )
		
		if dist > maxdist then
		
			maxdist = dist
		
		end
	
	end
	
	maxdist = maxdist * 0.5
	
	for k,v in pairs( ents.FindByClass( "info_lootspawn" ) ) do
	
		if v:GetPos():Distance( pos ) > maxdist then
		
			table.insert( spawns, v:GetPos() + Vector(0,0,25) )
			
		end
	
	end
	
	if #spawns < 1 then
	
		spawns[1] = ents.FindByClass( "info_lootspawn" ) 
		
	end
	
	local spawn = table.Random( spawns )
	local tbl = table.Random( item.GetByType( ITEM_QUEST ) )
	
	local ent = ents.Create( "sent_lootbag" )
	ent:SetPos( spawn )
	ent:SetAngles( VectorRand():Angle() )
	ent:SetQuest( ply )
	ent:AddItem( tbl.ID )
	ent:Spawn()
	
	ply.QuestLoot = tbl.ID
	ply.QuestBag = ent
	ply:SetRadarStaticTarget( ent )
	ply:Notify( "The position of the item has been marked on your radar." )
	
end

QUEST.CanStart = function( ply )

	local canstart = #ents.FindByClass( "info_lootspawn" ) > 9
	
	if not canstart then
	
		ply:DialogueWindow( "This mission is not available." )
	
	end

	return canstart

end

QUEST.Cancel = function( ply )

	if ValidEntity( ply.QuestBag ) then
	
		ply.QuestBag:Remove()
	
	end
	
	ply:SetInQuest( false, 0 )
	ply:SetRadarStaticTarget( NULL )
	ply.QuestStatusChange = nil

end

QUEST.StatusThink = function( ply )

	if ply:HasItem( ply.QuestLoot ) and not ply.QuestStatusChange then
	
		ply:Notify( "You've found the item? Bring it to me as soon as possible." )
		ply:SetRadarStaticTarget( ply:GetTeamTrader() )
		ply.QuestStatusChange = true
	
	end

end

QUEST.CanEnd = function( ply )

	if ply:HasItem( ply.QuestLoot ) then 
	
		return true
	
	end

	return false
	
end

QUEST.Dialogue = function( ply )

	ply:DialogueWindow( "You haven't retrieved the item." )

end

QUEST.End = function( ply )

	local cash = 200
	
	if ply:Team() == TEAM_BANDOLIERS then
	
		cash = 300
		
	end

	ply:RemoveFromInventory( ply.QuestLoot )
	
	ply:AddCash( cash )
	ply:DialogueWindow( "You have earned $"..cash.."." )
	
	ply:SetInQuest( false, 0 )
	ply:SetRadarStaticTarget( NULL )
	ply.QuestStatusChange = nil

end

GM:RegisterQuest( QUEST )
