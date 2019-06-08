
--// kill player quest

if CLIENT then

	GM:RegisterQuest( "Hunt down a wanted man.", "radbox/menu_quest" )
	
	return

end

local QUEST = {}

QUEST.Start = function( ply )

	local enemy
	local maxkills = 0
	local tbl = player.GetAll()
	
	for k,v in pairs( tbl ) do
		
		if v:Frags() > maxkills and v:Alive() and v:Team() != ply:Team() then
		
			maxkills = v:Frags()
			enemy = v
		
		end
	
	end
	
	ply.QuestBounty = 100 + maxkills * 30
	
	if ply:Team() == TEAM_BANDOLIERS then
	
		ply.QuestBounty = ply.QuestBounty + 100
	
	end
	
	ply.QuestEnemy = enemy
	ply:SetRadarTarget( enemy )
	ply:Notify( "The position of the wanted man has been marked on your radar." )
	
	timer.Simple( 2, function( ply, enemy ) if IsValid( ply ) then ply:Notify( "Your target is " .. enemy:Name() .. "." ) end end, ply, ply.QuestEnemy )
	timer.Simple( 4, function( ply, amt ) if IsValid( ply ) then ply:Notify( "There is a bounty of $" .. amt .. " on your target's head." ) end end, ply, ply.QuestBounty )
	
end

QUEST.CanStart = function( ply )

	local enemy
	local maxkills = 0
	local tbl = player.GetAll()
	
	for k,v in pairs( tbl ) do
		
		if v:Frags() > maxkills and v:Alive() and v:Team() != ply:Team() then
		
			maxkills = v:Frags()
			enemy = v
		
		end
	
	end
	
	if not ( IsValid( enemy ) and maxkills > 0 ) then
	
		ply:DialogueWindow( "This mission is not currently available." )
	
	end

	return ( IsValid( enemy ) and maxkills > 0 )

end

QUEST.Cancel = function( ply )
	
	ply.QuestEnemy = nil
	ply.QuestBounty = nil
	ply:SetInQuest( false, 0 )
	ply:SetRadarTarget( NULL )
	ply.QuestStatusChange = nil

end

QUEST.StatusThink = function( ply )

	if IsValid( ply.QuestEnemy ) and not ply.QuestStatusChange then
	
		local bounty = 100 + ply.QuestEnemy:Frags() * 30
		
		if ply:Team() == TEAM_BANDOLIERS then
		
			bounty = bounty + 100
		
		end
		
		if bounty > ply.QuestBounty then
		
			ply.QuestBounty = bounty
			ply:Notify( "The bounty on your target's head is now $" .. bounty )
		
		end
	
	end

	if ( !IsValid( ply.QuestEnemy ) or !ply.QuestEnemy:Alive() ) and not ply.QuestStatusChange then
	
		ply:Notify( "The wanted man is dead? Good. Come see me as soon as possible." )
		ply:SetRadarTarget( ply:GetTeamTrader() )
		ply.QuestStatusChange = true
	
	end

end

QUEST.CanEnd = function( ply )

	return ply.QuestStatusChange 
	
end

QUEST.Dialogue = function( ply )

	ply:DialogueWindow( "The wanted man is still alive." )

end

QUEST.End = function( ply )

	local cash = ply.QuestBounty or 150
	
	ply:AddCash( cash )
	ply:DialogueWindow( "You have earned $"..cash.."." )
	
	ply:SetInQuest( false, 0 )
	ply:SetRadarTarget( NULL )
	ply.QuestStatusChange = nil
	ply.QuestEnemy = nil
	ply.QuestBounty = nil

end

GM:RegisterQuest( QUEST )
