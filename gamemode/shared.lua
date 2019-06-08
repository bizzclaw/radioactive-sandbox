GM.Name 		= "Radioactive Sandbox"  
GM.Author 		= "Rambo_6"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true
RADBOX_PATH = "radbox/"

CreateConVar( "sv_radbox_max_zombies", "8", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the amount of zombie NPCs that can spawn. (def 8)" )
CreateConVar( "sv_radbox_max_rogues", "6", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the amount of rogue NPCs that can spawn. (def 6)" )
CreateConVar( "sv_radbox_max_artifacts", "3", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the amount of artifacts that can spawn. (def 3)" )
CreateConVar( "sv_radbox_max_anomalies", "30", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the amount of anomalies that can spawn. (def 30)" )
CreateConVar( "sv_radbox_team_dmg", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether teammates can hurt eachother. (def 0)" )
CreateConVar( "sv_radbox_dmg_scale", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls bullet damage scaling. (def 1.0)" )
CreateConVar( "sv_radbox_allow_build", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether players can spawn props and use the physics gun. (def 0)" )
CreateConVar( "sv_radbox_max_props", "10", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Maximum number of props that players can spawn if building is allowed. (def 10)" )
CreateConVar( "sv_radbox_allow_loners", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether players spawn initially as a loner. (def 0)" )
CreateConVar( "sv_radbox_custom_names", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether players can name themselves. (def 1)" )
CreateConVar( "sv_radbox_roleplay", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether the server uses RP chat commands. (def 1)" )
CreateConVar( "sv_radbox_daycycle", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether the server has day/night cycles enabled. (def 1)" )
CreateConVar( "sv_radbox_daycycle_speed", "2.0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the speed of the day/night cycle transitions. (def 2.0)" )
CreateConVar( "sv_radbox_daycycle_intensity", "1.0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the intensity of nighttime for day/night cycles. (def 1.0)" )
CreateConVar( "sv_radbox_daycycle_indoors_light", "0.4", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls how much day/night affects you while indoors. (def 0.4)" )

if SERVER then
	include( 'events.lua' )
end

include( 'ply_anims.lua' )

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
	
	if ( game.SinglePlayer() ) then return true end
	
	if pl:IsAdmin() or pl:IsSuperAdmin() then return true end
	
	return false
	
end

local filecount_sv = 0
local filecount_cl = 0

REALM_SH = 0
REALM_CL = 1
REALM_SV = 2

local function getRealm(dir)
	local sub = string.lower(string.sub(dir, 0, 3))
	local realm = (sub == "cl_" and REALM_CL) or (sub == "sv_" and REALM_SV) or REALM_SH
	return realm
end

local function InitFiles(dir, realm)
	realm = realm or getRealm(dir)
	local fil, fol = file.Find(dir.."/*", "LUA")
	for _, v in ipairs(fil) do
		local fileRealm = realm and realm != REALM_SH and realm or getRealm(v)
		if string.sub(v, 0, 1) == "#" then continue end
		if fileRealm != REALM_SV then -- Only cl_ files will pass this check and is loaded only on the client
			AddCSLuaFile(dir.."/"..v)
			if CLIENT then
				include(dir.."/"..v)
			end
			print("Loading "..dir.."/"..v.." on the CLIENT...")
		end
		if SERVER and fileRealm != REALM_CL then -- Only sv_ files will pass this check and is loaded only on the server.
			include(dir.."/"..v)
			print("Loading "..dir.."/"..v.." on the server...")
		end --Everytihng else, such as sh_, will pass both checks and is shared.
	end

	for _, folder in ipairs(fol) do
		-- print(folder)
		local folderRealm = getRealm(folder)
		if folder == "noload" then continue end

		-- if SERVER and folderRealm == REALM_CL then continue end
		-- if CLIENT and folderRealm == REALM_SV then continue end

		print("Mounting Folder: "..dir.." on "..(SERVER and "server" or "client"))
		InitFiles(dir.."/"..folder, folderRealm)
	end
end

InitFiles(RADBOX_PATH.."gamemode/autoload")