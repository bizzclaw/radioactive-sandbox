
// kill npc quest

if CLIENT then

	GM:RegisterQuest( "Kill a rogue faction member.", "radbox/menu_quest" )
	
	return

end

local QUEST = {}

QUEST.Start = function( ply )

	local pos = ply:GetPos()
	local maxdist = 500
	local spawns = {}
	local tbl = ents.FindByClass( "info_npcspawn" )
	
	for k,v in pairs( tbl ) do
	
		local dist = v:GetPos():Distance( pos )
		
		if dist > maxdist then
		
			maxdist = dist
		
		end
	
	end
	
	maxdist = maxdist * 0.5
	
	for k,v in pairs( tbl ) do
	
		if v:GetPos():Distance( pos ) > maxdist then
		
			table.insert( spawns, v )
			
		end
	
	end
	
	if #spawns < 1 then
	
		spawns = ents.FindByClass( "info_npcspawn" )
		
	end
	
	local spawn = table.Random( spawns )
	local tbl = item.RandomItem( ITEM_FOOD )
	
	local ent = ents.Create( "sent_lootbag" )
	ent:SetPos( spawn:GetPos() + Vector(0,0,10) )
	ent:SetAngles( VectorRand():Angle() )
	ent:SetQuest( ply )
	ent:AddItem( tbl.ID )
	ent:Spawn()
	
	ply.QuestLoot = ent
	ply.QuestPos = spawn:GetPos()
	ply:SetRadarStaticTarget( ent )
	ply:Notify( "The position of the rogue has been marked on your radar." )
	
end

QUEST.CanStart = function( ply )

	local canstart = #ents.FindByClass( "info_npcspawn" ) > 3
	
	if not canstart then
	
		ply:DialogueWindow( "This mission is not available." )
	
	end

	return canstart

end

QUEST.Cancel = function( ply )

	if ValidEntity( ply.QuestLoot ) then
	
		ply.QuestLoot:Remove()
	
	end
	
	ply.QuestNPC = nil
	ply.QuestLoot = nil
	ply.QuestPos = nil
	ply:SetInQuest( false, 0 )
	ply:SetRadarStaticTarget( NULL )
	ply.QuestStatusChange = nil

end

QUEST.StatusThink = function( ply )

	if ply.QuestPos and ply:GetPos():Distance( ply.QuestPos ) < 2000 then
	
		local ent = ents.Create( "npc_rogue" )
		ent:SetPos( ply.QuestPos + Vector(0,0,10) )
		ent:Spawn()
	
		ply:Notify( "The rogue faction member should be nearby. Eliminate him." )
		ply:SetRadarStaticTarget( ent )
	
		ply.QuestNPC = ent
		ply.QuestPos = nil
		
		if ValidEntity( ply.QuestLoot ) then
	
			ply.QuestLoot:Remove()
	
		end
		
		ply.QuestLoot = nil
	
	elseif ply.QuestPos then
	
		return
	
	end

	if not ValidEntity( ply.QuestNPC ) and not ply.QuestStatusChange then
	
		ply:Notify( "The rogue is dead? Good. Come see me as soon as possible." )
		ply:SetRadarStaticTarget( ply:GetTeamTrader() )
		ply.QuestStatusChange = true
	
	end

end

QUEST.CanEnd = function( ply )

	if not ValidEntity( ply.QuestNPC ) and not ply.QuestPos then 
	
		return true
	
	end

	return false
	
end

QUEST.Dialogue = function( ply )

	ply:DialogueWindow( "The rogue faction member is still alive." )

end

QUEST.End = function( ply )

	local cash = 250
	
	if ply:Team() == TEAM_BANDOLIERS then
	
		cash = 350
		
	end
	
	ply:AddCash( cash )
	ply:DialogueWindow( "You have earned $"..cash.."." )
	
	ply:SetInQuest( false, 0 )
	ply:SetRadarStaticTarget( NULL )
	ply.QuestStatusChange = nil
	ply.QuestPos = nil
	ply.QuestLoot = nil

end

GM:RegisterQuest( QUEST )
