
require( "datastream" )

GM.Name 		= "Radioactive Sandbox"  
GM.Author 		= "Rambo_6"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true

CreateConVar( "sv_radbox_team_dmg", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether teammates can hurt eachother. (def 0)" )
CreateConVar( "sv_radbox_dmg_scale", "1.0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls bullet damage scaling. (def 1.0)" )
CreateConVar( "sv_radbox_allow_build", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether players can spawn props and use the physics gun. (def 0)" )
CreateConVar( "sv_radbox_max_props", "10", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Maximum number of props that players can spawn if building is allowed. (def 10)" )
CreateConVar( "sv_radbox_allow_loners", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether players spawn initially as a loner. (def 0)" )
CreateConVar( "sv_radbox_custom_names", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether players can name themselves. (def 1)" )
CreateConVar( "sv_radbox_roleplay", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether the server uses RP chat commands. (def 1)" )
CreateConVar( "sv_radbox_daycycle", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether the server has day/night cycles enabled. (def 1)" )
CreateConVar( "sv_radbox_daycycle_speed", "2.0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the speed of the day/night cycle transitions. (def 2.0)" )
CreateConVar( "sv_radbox_daycycle_intensity", "1.0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the intensity of nighttime for day/night cycles. (def 1.0)" )

function GM:CreateTeams()
	
	team.SetUp( TEAM_ARMY, GAMEMODE.ArmyTeamName, Color( 255, 200, 80 ), true )
	team.SetSpawnPoint( TEAM_ARMY, "info_player_army" ) 
	
	team.SetUp( TEAM_BANDOLIERS, GAMEMODE.BandoliersTeamName, Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_BANDOLIERS, "info_player_bandoliers" ) 
	
	team.SetUp( TEAM_EXODUS, GAMEMODE.ExodusTeamName, Color( 80, 200, 255 ), true )
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