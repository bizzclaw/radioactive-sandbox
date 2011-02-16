
if CLIENT then

	GM.Quests = {}

	function GM:RegisterQuest( text, picture, id )
	
		table.insert( GM.Quests, { Text = text, Picture = picture, ID = id } )
	
	end
	
	return

end

function StartQuest( ply, cmg, args )

	if not ValidEntity( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc_trader" ) then return end
	
	ply.Stash:VoiceSound( ply.Stash.Goodbye )
	ply:ToggleStashMenu( ply.Stash, false, "StoreMenu", ply.Stash:GetBuybackScale() )
	
	local id = tonumber( args[1] )

	local quest = GAMEMODE:GetQuest( id )
	
	if quest then
	
		if quest.CanStart( ply ) then
	
			quest.Start( ply )
			ply:SetInQuest( true, id )
			
		end
		
	end

end
concommand.Add( "startquest", StartQuest )

function EndQuest( ply, cmd, args ) 

	if not ValidEntity( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc_trader" ) then return end
	
	local quest = GAMEMODE:GetQuest( ply:GetQuestID() )
	
	if quest then
	
		quest.Cancel( ply )
		
		ply:DialogueWindow( "You have cancelled your mission." )
	
	end
	
	ply:ToggleStashMenu( ply.Stash, false, "StoreMenu", ply.Stash:GetBuybackScale() )

end
concommand.Add( "cancelquest", EndQuest )

function EndQuest( ply, cmd, args ) 

	if not ValidEntity( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc_trader" ) then return end
	
	local quest = GAMEMODE:GetQuest( ply:GetQuestID() )
	
	if quest and quest.CanEnd( ply ) then
	
		quest.End( ply )
		
		ply.Stash:VoiceSound( ply.Stash.Thank )
		
	else
	
		quest.Dialogue( ply )
		
		ply.Stash:VoiceSound( ply.Stash.Goodbye )
	
	end
	
	ply:ToggleStashMenu( ply.Stash, false, "StoreMenu", ply.Stash:GetBuybackScale() )

end
concommand.Add( "endquest", EndQuest )

GM.Quests = {}

function GM:RegisterQuest( tbl )

	table.insert( self.Quests, tbl )

end

function GM:GetQuest( id )

	return self.Quests[ id ]

end
