
require( "datastream" )

GM.Name 		= "Radioactive Sandbox"
GM.Author 		= "Rambo_6"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true

TEAM_ARMY = 1
TEAM_BANDOLIERS = 2
TEAM_EXODUS = 3
TEAM_LONER = 4

function GM:CreateTeams()
	
	team.SetUp( TEAM_ARMY, "Western Military Alliance", Color( 255, 200, 80 ), true )
	team.SetSpawnPoint( TEAM_ARMY, "info_player_army" ) 
	
	team.SetUp( TEAM_BANDOLIERS, "Bandoliers", Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_BANDOLIERS, "info_player_bandoliers" ) 
	
	team.SetUp( TEAM_EXODUS, "Exodus", Color( 80, 200, 255 ), true )
	team.SetSpawnPoint( TEAM_EXODUS, "info_player_exodus" ) 
	
	team.SetUp( TEAM_LONER, "Loners", Color( 80, 200, 80 ), true )
	team.SetSpawnPoint( TEAM_LONER, "info_player_loner" ) 

end

function GM:PlayerTraceAttack( ply, dmginfo, dir, trace )

	if SERVER then
	
		GAMEMODE:ScaleBulletDamage( ply, trace.HitGroup, dmginfo )
	
	end
	
	return false

end

function GM:Move( ply, mv )

	if ply:GetNWFloat( "Weight", 0 ) > GAMEMODE.MaxWeight then
	
		local scale = 1 - ( math.Clamp( ply:GetNWFloat( "Weight", 0 ), GAMEMODE.MaxWeight, GAMEMODE.WeightCap ) - GAMEMODE.MaxWeight ) / ( GAMEMODE.WeightCap - GAMEMODE.MaxWeight )
		
		mv:SetMaxSpeed( 100 + math.Round( scale * 100 ) )
		
		return self.BaseClass:Move( ply, mv )
			
	end
	
	if ply:GetNWFloat( "Stamina", 0 ) < 5 then
	
		mv:SetMaxSpeed( 125 )
	
	end
	
	return self.BaseClass:Move( ply, mv )

end

function GM:PlayerNoClip( pl, on )
	
	if ( SinglePlayer() ) then return true end
	
	if pl:IsAdmin() or pl:IsSuperAdmin() then return true end
	
	return false
	
end

function IncludeItems()

	local folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.FindInLua( folder.."/gamemode/items/*.lua" ) ) do
	
		include( folder.."/gamemode/items/"..d )
		
		if SERVER then
		
			AddCSLuaFile( folder.."/gamemode/items/"..d )
			
		end
		
	end

end

IncludeItems()

function IncludeQuests()

	local folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.FindInLua( folder.."/gamemode/quests/*.lua" ) ) do
	
		include( folder.."/gamemode/quests/"..d )
		
		if SERVER then
		
			AddCSLuaFile( folder.."/gamemode/quests/"..d )
			
		end
		
	end

end

IncludeQuests()