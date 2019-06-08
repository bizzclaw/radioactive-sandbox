
require( "glon" ) 

include( 'resource.lua' )
include( 'moddable.lua' )
include( 'items.lua' )
include( 'quests.lua' )
include( 'shared.lua' )
include( 'ply_extension.lua' )
include( 'team.lua' )
include( 'tables.lua' )
include( 'enums.lua' )
include( 'daycycle.lua' )
include( 'db.lua' )
include( 'lib/animationsapi/boneanimlib.lua' )

AddCSLuaFile( 'ply_anims.lua' )
AddCSLuaFile( 'quests.lua' )
AddCSLuaFile( 'moddable.lua' )
AddCSLuaFile( 'shared.lua' )
AddCSLuaFile( 'team.lua' )
AddCSLuaFile( 'items.lua' )
AddCSLuaFile( 'daycycle.lua' )
AddCSLuaFile( 'cl_targetid.lua' )
AddCSLuaFile( 'cl_spawnmenu.lua' )
AddCSLuaFile( 'cl_inventory.lua' )
AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'cl_postprocess.lua' )
AddCSLuaFile( 'cl_scoreboard.lua' )
AddCSLuaFile( 'vgui/vgui_panelbase.lua' )
AddCSLuaFile( 'vgui/vgui_dialogue.lua' )
AddCSLuaFile( 'vgui/vgui_teampicker.lua' )
AddCSLuaFile( 'vgui/vgui_itempanel.lua' )
AddCSLuaFile( 'vgui/vgui_npcmenu.lua' )
AddCSLuaFile( 'vgui/vgui_quickslot.lua' )
AddCSLuaFile( 'vgui/vgui_targetid.lua' )
AddCSLuaFile( 'vgui/vgui_helpmenu.lua' )
AddCSLuaFile( 'vgui/vgui_itemdisplay.lua' )
AddCSLuaFile( 'vgui/vgui_playerdisplay.lua' )
AddCSLuaFile( 'vgui/vgui_panelsheet.lua' )
AddCSLuaFile( 'vgui/vgui_goodmodelpanel.lua' )
AddCSLuaFile( 'vgui/vgui_animlist.lua' )

function GM:Initialize( )

	GAMEMODE.NextEvent = CurTime() + math.random( GAMEMODE.MinEventDelay, GAMEMODE.MaxEventDelay )
	
	db.Initialize()

end

function GM:InitPostEntity( )	

	local badshit = ents.FindByClass( "npc_zomb*" )
	badshit = table.Add( badshit, ents.FindByClass( "npc_ant*" ) )
	badshit = table.Add( badshit, ents.FindByClass( "npc_spawn*" ) )
	badshit = table.Add( badshit, ents.FindByClass( "npc_make*" ) )
	badshit = table.Add( badshit, ents.FindByClass( "prop_ragdoll" ) )

	for k,v in pairs( badshit ) do
	
		v:Remove()
	
	end
	
	GAMEMODE:LoadAllEnts()
	
	local num = #ents.FindByClass( "point_radiation" )
	
	for i=1, math.floor( num * GAMEMODE.RadiationAmount ) do
	
		local rad = table.Random( ents.FindByClass( "point_radiation" ) )
		
		while !rad:IsActive() do
		
			rad = table.Random( ents.FindByClass( "point_radiation" ) )
		
		end
		
		rad:SetActive( false )
	
	end
	
end

function GM:ShutDown()

	MsgN( "Erasing empty radbox player profiles..." )

	for k,v in pairs( GAMEMODE.PlayerInventories ) do
			
		if not v.Tbl or not v.Tbl[1] then
		
			db.DeleteInventory( k )
		
		end
	
	end

end

function GM:SaveAllEnts()

	MsgN( "Saving radbox entity data..." )

	local enttbl = {
		info_player_bandoliers = {},
		info_player_army = {},
		info_player_exodus = {},
		info_player_loner = {},
		npc_trader_bandoliers = {},
		npc_trader_army = {},
		npc_trader_exodus = {},
		info_lootspawn = {},
		info_npcspawn = {},
		point_stash = {},
		point_radiation = {},
		point_skymarker = {},
		prop_physics = {}
	}
	
	for k,v in pairs( enttbl ) do
	
		for c,d in pairs( ents.FindByClass( k ) ) do
		
			if k == "prop_physics" then
			
				if d.AdminPlaced then
				
					local phys = d:GetPhysicsObject()
					
					if IsValid( phys ) then
				
						table.insert( enttbl[k], { d:GetPos(), d:GetModel(), d:GetAngles(), phys:IsMoveable() } )
						
					end
				
				end
			
			else
		
				table.insert( enttbl[k], d:GetPos() )
				
			end
		
		end
		
	end
	
	file.Write( "radbox/" .. string.lower( game.GetMap() ) .. ".txt", glon.encode( enttbl ) )

end

function GM:LoadAllEnts()

	MsgN( "Loading radbox entity data..." )

	local glondry = glon.decode( file.Read( "radbox/" .. string.lower( game.GetMap() ) .. ".txt" ) )
	
	if not glondry then return end
	
	for k,v in pairs( glondry ) do
	
		if v[1] then
		
			if k == "prop_physics" then
			
				for c,d in pairs( v ) do
				
					local function spawnent()
					
						local ent = ents.Create( k )
						ent:SetPos( d[1] )
						ent:SetModel( d[2] )
						ent:SetAngles( d[3] )
						ent:SetSkin( math.random( 0, 6 ) )
						ent:Spawn()
						ent.AdminPlaced = true
						
						local phys = ent:GetPhysicsObject()
						
						if IsValid( phys ) and not d[4] then
						
							phys:EnableMotion( false )
						
						end
						
					end
					
					timer.Simple( c * 0.1, spawnent )
					
				end
			
			else
			
				for c,d in pairs( ents.FindByClass( k ) ) do
					
					d:Remove()
					
				end

				for c,d in pairs( v ) do
				
					if k != "point_radiation" then
				
						local function spawnent()
						
							local ent = ents.Create( k )
							ent:SetPos( d )
							ent:Spawn()
						
						end
					
						timer.Simple( c * 0.1, spawnent )
						
					else
					
						local ent = ents.Create( k )
						ent:SetPos( d )
						ent:Spawn()
				
					end

				end
				
			end
			
		end
		
	end

end

function GM:SaveInventory( ply, tbl, money )

	local str
	
	for k,v in pairs( tbl ) do
	
		if not str then
		
			str = v
			
		else
		
			str = str .. "@" .. v
			
		end
		
	end
	
	GAMEMODE.PlayerInventories[ string.lower( ply:SteamID() ) ] = { Tbl = tbl, Money = money or 0 }
	
	if str then
	
		db.SetInventory( ply, str, money )
	
	end

end

function GM:LoadInventory( pl )

	local inv, money = db.GetInventory( pl )

	if inv then
		
		local tbl = string.Explode( "@", inv )
			
		for c,d in pairs( tbl ) do
			
			tbl[c] = tonumber( d )
			
		end
		
		GAMEMODE.PlayerInventories[ string.lower( pl:SteamID() ) ] = { Tbl = tbl, Money = money or 0 }
	
	end
	
end 

function GM:LootThink()

	for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
	
		if v.Removal and v.Removal < CurTime() and IsValid( v ) then
		
			v:Remove()
		
		end
	
	end

	if #ents.FindByClass( "info_lootspawn" ) < 10 then return end

	local amt = math.floor( GAMEMODE.MaxLoot * #ents.FindByClass( "info_lootspawn" ) )
	local total = 0
	
	for k,v in pairs( ents.FindByClass( "sent_lootbag" ) ) do
	
		if v.RandomLoot then
		
			total = total + 1
		
		end
	
	end
	
	local num = amt - total
	local tbl = { ITEM_FOOD, ITEM_SUPPLY, ITEM_LOOT, ITEM_AMMO, ITEM_MISC, ITEM_EXODUS, ITEM_WPN_COMMON }
	local chancetbl = { 1.00,    0.80,        0.20,      0.40,     0.60,       0.05,          0.05 }
	
	if num > 0 then
	
		for i=1, num do
		
			local ent = table.Random( ents.FindByClass( "info_lootspawn" ) )
			local pos = ent:GetPos()
		
			local loot = ents.Create( "sent_lootbag" )
			loot:SetPos( pos + Vector(0,0,5) )
			
			for j=1, math.random(2,5) do
			
				local num = math.Rand(0,1)
				local choice = math.random(1,7)
				
				while num > chancetbl[ choice ] do
				
					num = math.Rand(0,1)
					choice = math.random(1,7)
				
				end
			
				local rand = item.RandomItem( tbl[choice] )
			
				loot:AddItem( rand.ID )
			
			end
			
			loot.RandomLoot = true
			loot:Spawn()
		
		end
	
	end

end

function GM:NPCThink()
	
	if #ents.FindByClass( "npc_rogue" ) < math.Round( GAMEMODE.MaxRoguesScale * #player.GetAll() ) and #ents.FindByClass( "npc_rogue" ) < GetConVar( "sv_radbox_max_rogues" ):GetInt() then
	
		local tbl = ents.FindByClass( "info_npcspawn" )
		
		if #tbl < 1 then return end
		
		local spawn
		local blocked = true 
		local count = 0
		
		while blocked and count < 20 do
		
			spawn = table.Random( tbl )
			blocked = false
			count = count + 1
		
			for k,v in pairs( player.GetAll() ) do
			
				if v:GetPos():Distance( spawn:GetPos() ) < 800 then 
				
					blocked = true
				
				end
			
			end
		
		end
		
		local ent = ents.Create( "npc_rogue" )
		ent:SetPos( spawn:GetPos() )
		ent:Spawn()
	
	end
	
	if #ents.FindByClass( "npc_zombie*" ) < math.Round( GAMEMODE.MaxZombiesScale * #player.GetAll() ) and #ents.FindByClass( "npc_zombie*" ) < GetConVar( "sv_radbox_max_zombies" ):GetInt() then
	
		local tbl = ents.FindByClass( "info_npcspawn" )
		
		if #tbl < 1 then return end
		
		local spawn
		local blocked = true 
		local count = 0
		
		while blocked and count < 20 do
		
			spawn = table.Random( tbl )
			blocked = false
			count = count + 1
		
			for k,v in pairs( player.GetAll() ) do
			
				if v:GetPos():Distance( spawn:GetPos() ) < 800 then 
				
					blocked = true
				
				end
			
			end
		
		end
		
		local zomb = table.Random{ "npc_zombie_normal", "npc_zombie_fast", "npc_zombie_poison" }
		local ent = ents.Create( zomb )
		ent:SetPos( spawn:GetPos() )
		ent:Spawn()
	
	end

end

function GM:VehicleThink()

	if #ents.FindByClass( "info_lootspawn" ) < 10 then return end

	if #ents.FindByClass( "prop_vehicle_jeep" ) < 1 then
		
		local pos = table.Random( ents.FindByClass( "info_lootspawn" ) ):GetPos() 
		
		local trace = {}
		trace.start = pos
		trace.endpos = pos + Vector(0,0,90000)

		local tr = util.TraceLine( trace )
		
		while not tr.HitSky do
		
			pos = table.Random( ents.FindByClass( "info_lootspawn" ) ):GetPos() 
			
			trace = {}
			trace.start = pos
			trace.endpos = pos + Vector(0,0,90000)

			tr = util.TraceLine( trace )
		
		end
		
		local jeep = ents.Create( "prop_vehicle_jeep" )
		jeep:SetKeyValue( "vehiclescript", "scripts/vehicles/jeep_test.txt" )
		jeep:SetModel( "models/buggy.mdl" )
		jeep:SetPos( trace.start + Vector(0,0,2500) )
		jeep:Spawn()
	
	end

end

function GM:GetRandomSpawnPos()

	if #ents.FindByClass( "point_skymarker" ) > 0 then
	
		local marker = table.Random( ents.FindByClass( "point_skymarker" ) )
		local min, max = marker:GetBounds()
		
		local occ = true
		local pos = Vector(0,0,0)
		
		while occ do
			
			local trace = {}
			trace.start = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z )
			trace.endpos = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z - 90000 )
		
			local tr = util.TraceLine( trace )
			
			occ = self:CheckPos( tr.HitPos )
			pos = tr.HitPos
			
		end
		
		return pos
	
	else
	
		for k,v in pairs( ents.FindByClass( "info_lootspawn" ) ) do
	
			local trace = {}
			trace.start = v:GetPos()
			trace.endpos = trace.start + Vector(0,0,90000)
			trace.filter = v
			
			local tr = util.TraceLine( trace )
		
			if tr.HitSky then 
			
				local left = {}
				left.start = tr.HitPos
				left.endpos = left.start + Vector( 90000, 0, 0 )
				
				local right = {}
				right.start = tr.HitPos
				right.endpos = right.start + Vector( -90000, 0, 0 )
				
				local ltr = util.TraceLine( left )
				local rtr = util.TraceLine( right )
				
				local north = {}
				north.start = ltr.HitPos
				north.endpos = north.start + Vector( 0, 90000, 0 )
				
				local south = {}
				south.start = rtr.HitPos
				south.endpos = south.start + Vector( 0, -90000, 0 )
				
				local ntr = util.TraceLine( north )
				local str = util.TraceLine( south )
				
				local max = Vector( ltr.HitPos.x, ntr.HitPos.y, tr.HitPos.z - 5 )
				local min = Vector( rtr.HitPos.x, str.HitPos.y, tr.HitPos.z - 5 )
				
				local occ = true
				local pos = Vector(0,0,0)
			
				while occ do
				
					local trace = {}
					trace.start = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z )
					trace.endpos = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z - 90000 )
				
					local tr = util.TraceLine( trace )
					
					occ = GAMEMODE:CheckPos( tr.HitPos )
					pos = tr.HitPos
				
				end
				
				return pos
				
			end
			
		end
	
	end

end

function GM:CheckPos( pos )

	local tbl = player.GetAll()
	tbl = table.Add( tbl, ents.FindByClass( "anomaly*" ) )
	tbl = table.Add( tbl, ents.FindByClass( "info_player*" ) )
	tbl = table.Add( tbl, ents.FindByClass( "npc_trader*" ) )

	for k,v in pairs( tbl ) do
	
		if v:GetPos():Distance( pos ) < 500 then
		
			return true
		
		end
	
	end
	
	return false

end

function GM:GetArtifacts()
	
	return #ents.FindByClass( "artifact*" )

end

function GM:ArtifactThink()
	
	if GAMEMODE:GetArtifacts() >= GetConVar( "sv_radbox_max_artifacts" ):GetInt() then return end

	local tbl = ents.FindByClass( "point_radiation" )
	tbl = table.Add( tbl, ents.FindByClass( "anomaly_cooker" ) )
	tbl = table.Add( tbl, ents.FindByClass( "anomaly_electro" ) )
	tbl = table.Add( tbl, ents.FindByClass( "anomaly_warp" ) )
	
	local link = {}
	link[ "point_radiation" ] = "artifact_moss"
	link[ "anomaly_cooker" ] = "artifact_scaldstone"
	link[ "anomaly_electro" ] = "artifact_porcupine"
	link[ "anomaly_warp" ] = "artifact_blink"
	
	for k,v in pairs( tbl ) do
	
		local chance = math.Rand(0,1)
		
		if chance < GAMEMODE.ArtifactRarity[ v:GetClass() ] and GAMEMODE:GetArtifacts() < GetConVar( "sv_radbox_max_artifacts" ):GetInt() and not IsValid( v:GetArtifact() ) then
		
			local ent = ents.Create( link[ v:GetClass() ] )
			ent:SetPos( v:GetPos() )
			ent:Spawn()
			
			local phys = ent:GetPhysicsObject()
			
			if IsValid( phys ) then
			
				if v:GetClass() == "point_radiation" or v:GetClass() == "anomaly_electro" then
				
					phys:Wake()
					phys:ApplyForceCenter( VectorRand() * 50 )
				
				else
				
					phys:EnableMotion( false )
				
				end
			
			end
			
			v:SetArtifact( ent )
		
		end
	
	end

end

function GM:Think( )

	GAMEMODE:EventThink()
	
	if ( GAMEMODE.NextArtifactThink or 0 ) < CurTime() then
		
		GAMEMODE:ArtifactThink()
		GAMEMODE.NextArtifactThink = CurTime() + 200
			
	end

	if ( GAMEMODE.NextItemThink or 0 ) < CurTime() then

		GAMEMODE:NPCThink()
		GAMEMODE:LootThink()
		GAMEMODE:VehicleThink()
		GAMEMODE.NextItemThink = CurTime() + 5
		
	end

	for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != TEAM_UNASSIGNED then
		
			v:Think()
		
		end
	
	end

end

function GM:EventThink()

	if GAMEMODE.NextEvent < CurTime() then
	
		GAMEMODE.NextEvent = CurTime() + math.random( GAMEMODE.MinEventDelay, GAMEMODE.MaxEventDelay )  
	
		local rand = event.GetRandom()
		GAMEMODE:SetEvent( rand )
	
	end
	
	if GAMEMODE.Event then
	
		GAMEMODE.Event:Think()
		GAMEMODE.Event:EndThink()
	
	end

end

function GM:GetEvent()

	return GAMEMODE.Event

end

function GM:SetEvent( ev )

	if GAMEMODE.Event then
		
		GAMEMODE.Event:End()
		
	end
		
	GAMEMODE.Event = ev
	
	if not ev then return end

	ev:Start()

end

function GM:PhysgunPickup( ply, ent )

	if ply:IsAdmin() or ply:IsSuperAdmin() then return true end

	if ent:IsPlayer() then return false end
	
	if not ent.Placer or ent.Placer != ply then return false end
	
	return true 

end

function GM:PlayerDisconnected( pl )

	if pl:Alive() then
	
		pl:DropLoot()
	
		if IsValid( pl:GetVehicle() ) then
		
			pl:GetVehicle():Remove()
		
		end
		
	end
	
end

function GM:PlayerInitialSpawn( pl )

	GAMEMODE:LoadInventory( pl )
	
	if not GetConVar( "sv_radbox_allow_loners" ):GetBool() then 
	
		pl:SetTeam( TEAM_UNASSIGNED )
		pl:Spectate( OBS_MODE_ROAMING )
		
	else
	
		pl:SetTeam( TEAM_LONER )
	
	end
	
end

function GM:PlayerSpawn( pl )

	if pl:Team() == TEAM_UNASSIGNED and not GetConVar( "sv_radbox_allow_loners" ):GetBool() then
	
		pl:Spectate( OBS_MODE_ROAMING )
		pl:SetPos( pl:GetPos() + Vector( 0, 0, 50 ) )
		
		return
		
	end
	
	umsg.Start( "Drunk", pl )
	umsg.Short( -20 )
	umsg.End()
	
	pl:SetDSP( 0, false )

	GAMEMODE:PlayerLoadout( pl )
	GAMEMODE:PlayerSetModel( pl )
	pl:OnSpawn()

end

function GM:PlayerSetModel( pl )

	for k,v in pairs( team.GetPlayers( pl:Team() ) ) do
	
		if ( v:GetModel() == team.GetLeaderModel( pl:Team() ) and v:Alive() ) or pl:Team() == TEAM_LONER then
		
			pl:SetModel( team.GetPlayerModel( pl:Team() ) )
			
			return
		
		end
	
	end

	pl:SetModel( team.GetLeaderModel( pl:Team() ) )

end

function GM:PlayerLoadout( pl )

	pl:InitializeInventory()
	pl:OnLoadout()
	
end

function GM:PlayerJoinTeam( ply, teamid )
	
	local oldteam = ply:Team()
	
	if ply:Alive() and ply:Team() != TEAM_UNASSIGNED then return end

	if ( !GetConVar( "sv_radbox_allow_loners" ):GetBool() and teamid == TEAM_LONER ) or ply:Team() == TEAM_LONER then return end
	
	if teamid != TEAM_UNASSIGNED then
	
		ply:UnSpectate()
	
	end
	
	if teamid == TEAM_SPECTATOR then
	
		teamid = table.Random{ TEAM_EXODUS, TEAM_BANDOLIERS, TEAM_ARMY }
	
	end
	
	ply:SetTeam( teamid )
	
	if ply.NextSpawn and ply.NextSpawn > CurTime() then
	
		ply.NextSpawn = CurTime() + 5
	
	else
	
		ply:Spawn()
	
	end
	
end

function GM:PlayerSwitchFlashlight( ply, on )

	return not ply.NVG
	
end

function GM:GetFallDamage( ply, speed )

	local pain = speed * 0.12
	
	ply:AddStamina( math.floor( pain * -0.25 ) )

	return pain
	
end

function GM:PlayerDeathSound()

	return true
	
end

function GM:CanPlayerSuicide( ply )

	return false
	
end

function GM:KeyRelease( ply, key )

	if key == IN_JUMP then
	
		ply:AddStamina( -2 )
	
	end

	if key != IN_USE then return end

	local trace = {}
	trace.start = ply:GetShootPos()
	trace.endpos = trace.start + ply:GetAimVector() * 80
	trace.filter = ply
	
	local tr = util.TraceLine( trace )

	if IsValid( tr.Entity ) and tr.Entity:GetClass() == "prop_physics" then
	
		if IsValid( ply.Stash ) then
		
			ply.Stash:OnExit( ply )
			
			return true
		
		end
	
		ply:AddToInventory( tr.Entity )
		return true
		
	elseif IsValid( tr.Entity ) and table.HasValue( { "info_storage", "sent_lootbag", "point_stash", "npc_trader_army", "npc_trader_exodus", "npc_trader_bandoliers" }, tr.Entity:GetClass() ) then
	
		if IsValid( ply.Stash ) then
		
			ply.Stash:OnExit( ply )
		
		else
		
			tr.Entity:OnUsed( ply )
		
		end
	
	elseif not IsValid( tr.Entity ) then
	
		if IsValid( ply.Stash ) then
		
			ply.Stash:OnExit( ply )
		
		end
	
	end
	
	return true

end

function GM:EntityTakeDamage( ent, dmginfo )
	local inflictor, attacker, amount = dmginfo:GetInflictor(), dmginfo:GetAttacker(), dmginfo:GetDamage()

	if not ent:IsPlayer() and ent.IsItem then 

		dmginfo:ScaleDamage( 0 )
		return
		
	end
end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )

	if hitgroup == HITGROUP_HEAD then
	
		dmginfo:ScaleDamage( 2.50 ) 
		
    elseif hitgroup == HITGROUP_CHEST then
	
		dmginfo:ScaleDamage( 2.00 ) 
		
	elseif hitgroup == HITGROUP_STOMACH then
	
		dmginfo:ScaleDamage( 1.25 ) 
		
	else
	
		dmginfo:ScaleDamage( 0.75 )
		
	end
	
	return dmginfo

end 

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if IsValid( ply.Stash ) and ( string.find( ply.Stash:GetClass(), "npc" ) or ply.Stash:GetClass() == "info_storage" ) then
	
		dmginfo:ScaleDamage( 0 )
		
		return
	
	end

	if hitgroup == HITGROUP_HEAD then
	
		ply:EmitSound( "Player.DamageHeadShot" )
		ply:ViewBounce( 20 )
		
		dmginfo:ScaleDamage( 1.75 * GetConVar( "sv_radbox_dmg_scale" ):GetFloat() ) 
		
		if math.random(1,3) == 1 and dmginfo:GetAttacker():IsPlayer() and ( dmginfo:GetAttacker():Team() != ply:Team() or GetConVar( "sv_radbox_team_dmg" ):GetBool() ) then
		
			ply:SetBleeding( true )

		end
		
		return
		
    elseif hitgroup == HITGROUP_CHEST then
	
		ply:EmitSound( "Player.DamageKevlar" )
		ply:ViewBounce( 15 )
	
		dmginfo:ScaleDamage( 0.50 * GetConVar( "sv_radbox_dmg_scale" ):GetFloat() ) 
		
		if math.random(1,15) == 1 and dmginfo:GetAttacker():IsPlayer() and ( dmginfo:GetAttacker():Team() != ply:Team() or GetConVar( "sv_radbox_team_dmg" ):GetBool() ) then
		
			ply:SetBleeding( true )
			
		end
		
		return
		
	elseif hitgroup == HITGROUP_STOMACH then
	
		dmginfo:ScaleDamage( 0.25 * GetConVar( "sv_radbox_dmg_scale" ):GetFloat() ) 
		
	else
	
		dmginfo:ScaleDamage( 0.10 * GetConVar( "sv_radbox_dmg_scale" ):GetFloat() )
		
	end
		
	ply:ViewBounce( ( dmginfo:GetDamage() / 20 ) * 10 )

end 

function GM:PlayerShouldTakeDamage( ply, attacker )

	if ply:Team() == TEAM_UNASSIGNED then return false end
	
	if IsValid( ply.Stash ) and ( string.find( ply.Stash:GetClass(), "npc" ) or ply.Stash:GetClass() == "info_storage" ) then return false end --// player using a stash, dont let them die

	if string.find( attacker:GetClass(), "npc" ) then return true end
	
	if IsValid( attacker ) and ply == attacker then return true end
	
	if IsValid( attacker ) and attacker:IsPlayer() then return ( ply:Team() != attacker:Team() or GetConVar( "sv_radbox_team_dmg" ):GetBool() ) end --// team damage is convar controlled

	return true
	
end

function GM:OnDamagedByExplosion( ply, dmginfo )

	ply:SetBleeding( true )

	ply:SetDSP( 35, false )
	
	umsg.Start( "GrenadeHit", ply )
	umsg.End()
	
end

function GM:PlayerDeathThink( pl )

	if pl.NextSpawn and pl.NextSpawn > CurTime() then return end
	
	if pl:KeyDown( IN_JUMP ) or pl:KeyDown( IN_ATTACK ) or pl:KeyDown( IN_ATTACK2 ) then

		pl:Spawn()
		
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if dmginfo:IsExplosionDamage() then
	
		ply:SetModel( table.Random( GAMEMODE.Corpses ) )
	
	end

	if attacker:IsPlayer() then
	
		attacker:AddFrags( 1 )
	
	end

	ply:CreateRagdoll()
	ply:OnDeath()
	ply:AddDeaths( 1 )
	ply:SetFrags( 0 )
	
end

function GM:PlayerSay( ply, text, nonteam )

	if nonteam then
	
		return ( ply.ChatMode or "" ) .. text
	
	else
	
		return text
	
	end

end 

function GetChatMode( ply, cmd, args )

	ply.ChatMode = args[1]

end

concommand.Add( "cl_radbox_chatmode", GetChatMode )

function SetPlayerAnimPose( ply, cmd, args )

	if not IsValid( ply ) or not IsValid( ply:GetActiveWeapon() ) then return end
	
	if not ply:GetActiveWeapon():GetClass() == "rad_hands" then return end
	
	if ply:IsAdmin() and args[1] == "secret" then
	
		if ply.CurrentPose then
			
			ply:StopLuaAnimation( ply.CurrentPose )
			
		end
	
		ply:SetLuaAnimation( args[1] )
		ply.CurrentPose = args[1]
		
		return
	
	end

	if not args[1] or args[1] == "" then
	
		ply:StopAllLuaAnimations( 0.5 )
		
		return
	
	end

	for k,v in pairs( GAMEMODE.PoseList ) do
	
		if v.Pose == args[1] then
		
			if ply.CurrentPose then
			
				ply:StopLuaAnimation( ply.CurrentPose )
			
			end

			ply:SetLuaAnimation( v.Pose )
			ply.CurrentPose = v.Pose
			
			return
			
		end
		
	end

end

concommand.Add( "cl_radbox_pose", SetPlayerAnimPose )

function GM:ShowHelp( ply )

	ply:SendLua( "GAMEMODE:ShowHelp()" )

end

function GM:ShowTeam( ply )
	
	if ply:Alive() and ply:Team() != TEAM_UNASSIGNED then return end
	
	if GetConVar( "sv_radbox_allow_loners" ):GetBool() and ply:Team() == TEAM_UNASSIGNED then return end
	
	ply:SendLua( "GAMEMODE:ShowTeam()" )

end

function GM:ShowSpare1( ply )

	if not ply.QuickBind1 then return end
	
	if ply:HasItem( ply.QuickBind1[1] ) then
	
		local tbl = item.GetByID( ply.QuickBind1[1] )
		
		if not tbl.Functions[ ply.QuickBind1[2] ] then return end
		
		tbl.Functions[ ply.QuickBind1[2] ]( ply, ply.QuickBind1[1] )
	
	end

end

function GM:ShowSpare2( ply )

	if not ply.QuickBind2 then return end
	
	if ply:HasItem( ply.QuickBind2[1] ) then
	
		local tbl = item.GetByID( ply.QuickBind2[1] )
		
		if not tbl.Functions[ ply.QuickBind2[2] ] then return end
		
		tbl.Functions[ ply.QuickBind2[2] ]( ply, ply.QuickBind2[1] )
	
	end

end

function QuickBind1( ply, cmd, args )

	local id = tonumber( args[1] )
	local pos = tonumber( args[2] )
	
	if not ply:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	
	if not tbl.Functions[pos] then return end
	
	ply.QuickBind1 = { id, pos }

end

concommand.Add( "inv_assignf3", QuickBind1 )

function QuickBind2( ply, cmd, args )

	local id = tonumber( args[1] )
	local pos = tonumber( args[2] )
	
	if not ply:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	
	if not tbl.Functions[pos] then return end
	
	ply.QuickBind2 = { id, pos }

end

concommand.Add( "inv_assignf4", QuickBind2 )

function DropItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not ply:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then
	
		if ply:HasItem( id ) then
		
			local makeprop = true
		
			if tbl.DropFunction then
			
				makeprop = tbl.DropFunction( ply, id, true )
			
			end
			
			if makeprop then
		
				local prop = ents.Create( "prop_physics" )
				prop:SetPos( ply:GetItemDropPos() )
				prop:SetAngles( ply:GetAimVector():Angle() )
				prop:SetModel( tbl.Model ) 
				prop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				prop:Spawn()
				prop.IsItem = true
				prop.Removal = CurTime() + 5 * 60
				
			end
			
			ply:RemoveFromInventory( id, true )
			ply:EmitSound( Sound( "items/ammopickup.wav" ) )
		
		end
		
		return
	
	end
	
	local items = {}
	
	for i=1, count do
	
		if ply:HasItem( id ) then
		
			table.insert( items, id )
		
		end
		
	end
	
	local loot = ents.Create( "sent_lootbag" )
	
	for k,v in pairs( items ) do
	
		loot:AddItem( v )
	
	end
	
	loot:SetAngles( ply:GetAimVector():Angle() )
	loot:SetPos( ply:GetItemDropPos() )
	loot:SetRemoval( 60 * 5 )
	loot:Spawn()
	
	ply:EmitSound( Sound( "items/ammopickup.wav" ) )
	ply:RemoveMultipleFromInventory( items )
	
	if tbl.DropFunction then
		
		tbl.DropFunction( ply, id )
		
	end

end

concommand.Add( "inv_drop", DropItem )

function UseItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local pos = tonumber( args[2] )
	
	if ply:HasItem( id ) then
	
		local tbl = item.GetByID( id )
		
		if not tbl.Functions[pos] then return end
		
		tbl.Functions[pos]( ply, id )
	
	end

end

concommand.Add( "inv_action", UseItem )

function TakeItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not IsValid( ply.Stash ) or not table.HasValue( ply.Stash:GetItems(), id ) or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then
		
		ply:AddIDToInventory( id )
		ply.Stash:RemoveItem( id )
		
		return
	
	end
	
	local items = {}
	
	if IsValid( ply.Stash ) then
	
		for i=1, count do
	
			if table.HasValue( ply.Stash:GetItems(), id ) then
			
				table.insert( items, id )
				ply.Stash:RemoveItem( id )
			
			end
			
		end
		
		ply:AddMultipleToInventory( items )
		ply:EmitSound( Sound( "items/itempickup.wav" ) )
	
	end

end

concommand.Add( "inv_take", TakeItem )

function StoreItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not IsValid( ply.Stash ) or not ply:HasItem( id ) or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then

		ply.Stash:AddItem( id )
		
		ply:RemoveFromInventory( id )
		ply:EmitSound( Sound( "c4.disarmfinish" ) )
		
		if tbl.DropFunction then
			
			tbl.DropFunction( ply, id )
			
		end
		
		return
	
	end
	
	local items = {}
	
	for i=1, count do
	
		if ply:HasItem( id ) then
	
			table.insert( items, id )
			ply.Stash:AddItem( id )
			
		end
	
	end
	
	ply:RemoveMultipleFromInventory( items )
	ply:EmitSound( Sound( "c4.disarmfinish" ) )
	
	if tbl.DropFunction then
		
		tbl.DropFunction( ply, id )
		
	end

end

concommand.Add( "inv_store", StoreItem )

function SellItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not IsValid( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc" ) or not ply:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	local cash = math.Round( ply.Stash:GetBuybackScale() * tbl.Price )
	
	if count == 1 then
	
		ply:RemoveFromInventory( id )
		ply:AddCash( cash )
		
		if tbl.DropFunction then
			
			tbl.DropFunction( ply, id )
			
		end
		
		return
	
	end
	
	local items = {}
	local cashamt = 0
	
	for i=1, math.Clamp( count, 1, ply:GetItemCount( id ) ) do
	
		if ply:HasItem( id ) then
			
			table.insert( items, id )
			cashamt = cashamt + cash
			
		end
	
	end
	
	ply:AddCash( cashamt )
	ply:RemoveMultipleFromInventory( items )
	
	if tbl.DropFunction then
		
		tbl.DropFunction( ply, id )
		
	end

end

concommand.Add( "inv_sell", SellItem )

function BuyItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = tonumber( args[2] )
	
	if not IsValid( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc" ) or not table.HasValue( ply.Stash:GetItems(), id ) then return end
	
	local tbl = item.GetByID( id )
	
	if tbl.Price > ply:GetCash() then 
		
		ply:DialogueWindow( "You don't have enough money!" )
		
		return 
		
	end 
	
	if count == 1 then
		
		ply:AddIDToInventory( id )
		ply:AddCash( -tbl.Price )
		
		return
	
	end
	
	if ( tbl.Price * count ) > ply:GetCash() then 
		
		ply:DialogueWindow( "You don't have enough money!" ) 
		
		return 
		
	end 
	
	local items = {}
	
	for i=1, count do
		
		table.insert( items, id )
	
	end
	
	ply:AddMultipleToInventory( items )
	ply:AddCash( -tbl.Price * count )
	
end

concommand.Add( "inv_buy", BuyItem )

function OpenStorageMenu( ply, cmd, args )

	if not IsValid( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc_trader" ) then return end

	if not IsValid( ply.StorageBox ) then
	
		ply.StorageBox = ents.Create( "info_storage" )
		ply.StorageBox:SetPos( ply:GetPos() )
		ply.StorageBox:SetupItems( ply )
		ply.StorageBox:SetUser( ply )
		ply.StorageBox:Spawn() 
	
	else
	
		ply:SynchCash( ply.StorageBox:GetCash() )
		
	end
	
	ply:ToggleStashMenu( ply.StorageBox, true, "StashMenu", ply.Stash:GetBuybackScale(), true )

end

concommand.Add( "inv_save", OpenStorageMenu )

function DropCash( ply, cmd, args )

	local amt = tonumber( args[1] )
	
	if amt > ply:GetCash() or amt < 5 then return end
	
	ply:AddCash( -amt )
	
	local money = ents.Create( "sent_cash" )
	money:SetPos( ply:GetItemDropPos() )
	money:Spawn()
	money:SetCash( amt )

end

concommand.Add( "cash_drop", DropCash )

function StashCash( ply, cmd, args )

	local amt = tonumber( args[1] )
	
	if not IsValid( ply.Stash ) or amt > ply:GetCash() or amt < 5 or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	ply:AddCash( -amt )
	ply:SynchCash( ply.Stash:GetCash() + amt )
	ply.Stash:SetCash( ply.Stash:GetCash() + amt )

end

concommand.Add( "cash_stash", StashCash )

function TakeCash( ply, cmd, args )

	local amt = tonumber( args[1] )
	
	if not IsValid( ply.Stash ) or amt > ply.Stash:GetCash() or amt < 5 or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	ply:AddCash( amt )
	ply:SynchCash( ply.Stash:GetCash() - amt )
	ply.Stash:SetCash( ply.Stash:GetCash() - amt )

end

concommand.Add( "cash_take", TakeCash )

function OpenNPCMenu( ply, cmd, args )

	if not IsValid( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc_trader" ) then return end

	ply:ToggleStashMenu( ply.Stash, true, "StoreMenu", ply.Stash:GetBuybackScale() )

end

concommand.Add( "tradermenu", OpenNPCMenu )

function CloseNPCMenu( ply, cmd, args )

	if not IsValid( ply.Stash ) then return end

	ply.Stash:VoiceSound( ply.Stash.Goodbye )
	ply:ToggleStashMenu( ply.Stash, false, "StoreMenu", ply.Stash:GetBuybackScale() )

end

concommand.Add( "closetradermenu", CloseNPCMenu )

function SetGayName( ply, cmd, args )

	local name = ""
	
	for k,v in pairs( args ) do
	
		name = name .. " " .. v
		
	end

	ply:SetNWString( "GayName", name )

end

concommand.Add( "cl_radbox_character_name", SetGayName )

function SaveGameItems( ply, cmd, args )

	if ( !ply:IsAdmin() or !ply:IsSuperAdmin() ) then return end
	
	GAMEMODE:SaveAllEnts()
	
end

concommand.Add( "sv_radbox_save_map_config", SaveGameItems )

function MapSetupMode( ply, cmd, args )

	if not IsValid( ply ) then 
	
		for k, ply in pairs( player.GetAll() ) do
		
			if ply:IsAdmin() or ply:IsSuperAdmin() then
	
				ply:Give( "rad_itemplacer" )
				ply:Give( "rad_propplacer" )
				ply:Give( "weapon_physgun" )
			
			end
		
		end
		
		return
		
	end

	if ply:IsAdmin() or ply:IsSuperAdmin() then
	
		ply:Give( "rad_itemplacer" )
		ply:Give( "rad_propplacer" )
		ply:Give( "weapon_physgun" )
	
	end

end

concommand.Add( "sv_radbox_dev_mode", MapSetupMode )

function WipeDatabase( ply, cmd, args )

	if not ply or ( IsValid( ply ) and ( ply:IsAdmin() or ply:IsSuperAdmin() ) ) then
	
		db.Wipe()
		db.Initialize()
	
	end

end

concommand.Add( "sv_radbox_reset_db", WipeDatabase )