
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
include( 'events.lua' )
include( 'db.lua' )

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

CreateConVar( "sv_radbox_team_dmg", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether teammates can hurt eachother." )
CreateConVar( "sv_radbox_dmg_scale", "1.0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls bullet damage scaling." )
CreateConVar( "sv_radbox_allow_build", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether players can spawn props and use the physics gun." )
CreateConVar( "sv_radbox_max_props", "10", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Maximum number of props that players can spawn if building is allowed." )
CreateConVar( "sv_radbox_allow_loners", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether players spawn initially as a loner." )
CreateConVar( "sv_radbox_custom_names", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether players can name themselves." )
CreateConVar( "sv_radbox_daycycle", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether the server has day/night enabled." )

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
			
		if !v[1] then
		
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
		prop_physics = {}
	}
	
	for k,v in pairs( enttbl ) do
	
		for c,d in pairs( ents.FindByClass( k ) ) do
		
			if k == "prop_physics" then
			
				if d.AdminPlaced then
				
					local phys = d:GetPhysicsObject()
					
					if ValidEntity( phys ) then
				
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
						
						if ValidEntity( phys ) and not d[4] then
						
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

function GM:SaveInventory( ply, tbl )

	local str
	
	for k,v in pairs( tbl ) do
	
		if not str then
		
			str = v
			
		else
		
			str = str .. "@" .. v
			
		end
		
	end
	
	GAMEMODE.PlayerInventories[ string.lower( ply:SteamID() ) ] = tbl
	
	if str then
	
		db.SetInventory( ply, str )
	
	end

end

function GM:LoadInventory( pl )

	local inv = db.GetInventory( pl )

	if inv then
		
		local tbl = string.Explode( "@", inv )
			
		for c,d in pairs( tbl ) do
			
			tbl[c] = tonumber( d )
			
		end
			
		GAMEMODE.PlayerInventories[ string.lower( pl:SteamID() ) ] = tbl
			
	end
	
end 

function GM:Think( )

	GAMEMODE:EventThink()

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
	
		if ValidEntity( pl:GetVehicle() ) then
		
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
	umsg.Short( -10 )
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

	return !ply:HasItem( "models/gibs/manhack_gib03.mdl" )
	
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

	if ValidEntity( tr.Entity ) and tr.Entity:GetClass() == "prop_physics" then
	
		if ValidEntity( ply.Stash ) then
		
			ply.Stash:OnExit( ply )
			
			return true
		
		end
	
		ply:AddToInventory( tr.Entity )
		return true
		
	elseif ValidEntity( tr.Entity ) and table.HasValue( { "info_storage", "sent_lootbag", "point_stash", "npc_trader_army", "npc_trader_exodus", "npc_trader_bandoliers" }, tr.Entity:GetClass() ) then
	
		if ValidEntity( ply.Stash ) then
		
			ply.Stash:OnExit( ply )
		
		else
		
			tr.Entity:OnUsed( ply )
		
		end
	
	elseif not ValidEntity( tr.Entity ) then
	
		if ValidEntity( ply.Stash ) then
		
			ply.Stash:OnExit( ply )
		
		end
	
	end
	
	return true

end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if not ent:IsPlayer() and ent.IsItem then 

		dmginfo:ScaleDamage( 0 )
		return
		
	end
	
	return self.BaseClass:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	
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

function GM:ScaleBulletDamage( ply, hitgroup, dmginfo )

	if ValidEntity( ply.Stash ) and ( string.find( ply.Stash:GetClass(), "npc" ) or ply.Stash:GetClass() == "info_storage" ) then
	
		dmginfo:ScaleDamage( 0 )
		
		return
	
	end

	if hitgroup == HITGROUP_HEAD then
		
		if math.random(1,5) == 1 and dmginfo:GetAttacker():IsPlayer() and ( dmginfo:GetAttacker():Team() != ply:Team() or GetConVar( "sv_radbox_team_dmg" ):GetBool() ) then
		
			ply:SetBleeding( true )
			ply:EmitSound( "Player.DamageHeadShot" )
			ply:ViewBounce( 20 )
			
		end
		
		dmginfo:ScaleDamage( 1.75 * GetConVar( "sv_radbox_dmg_scale" ):GetFloat() ) 
		
    elseif hitgroup == HITGROUP_CHEST then
	
		if math.random(1,10) == 1 and dmginfo:GetAttacker():IsPlayer() and ( dmginfo:GetAttacker():Team() != ply:Team() or GetConVar( "sv_radbox_team_dmg" ):GetBool() ) then
		
			ply:SetBleeding( true )
			ply:EmitSound( "Player.DamageKevlar" )
			ply:ViewBounce( 15 )
			
		end
	
		dmginfo:ScaleDamage( 0.50 * GetConVar( "sv_radbox_dmg_scale" ):GetFloat() ) 
		
	elseif hitgroup == HITGROUP_STOMACH then
	
		dmginfo:ScaleDamage( 0.25 * GetConVar( "sv_radbox_dmg_scale" ):GetFloat() ) 
		
	else
	
		dmginfo:ScaleDamage( 0.10 * GetConVar( "sv_radbox_dmg_scale" ):GetFloat() )
		
	end
		
	ply:ViewBounce( ( dmginfo:GetDamage() / 20 ) * 10 )

end 

function GM:PlayerShouldTakeDamage( ply, attacker )

	if ply:Team() == TEAM_UNASSIGNED then return false end
	
	if ValidEntity( ply.Stash ) and ( string.find( ply.Stash:GetClass(), "npc" ) or ply.Stash:GetClass() == "info_storage" ) then return false end // player using a stash, dont let them die

	if string.find( attacker:GetClass(), "npc" ) then return true end
	
	if ValidEntity( attacker ) and ply == attacker then return true end
	
	if ValidEntity( attacker ) and attacker:IsPlayer() then return ( ply:Team() != attacker:Team() or GetConVar( "sv_radbox_team_dmg" ):GetBool() ) end // team damage is convar controlled

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
		
			local prop = ents.Create( "prop_physics" )
			prop:SetPos( ply:GetItemDropPos() )
			prop:SetModel( tbl.Model ) 
			prop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			prop:Spawn()
			prop.IsItem = true
			
			ply:RemoveFromInventory( id, true )
			ply:EmitSound( Sound( "items/ammopickup.wav" ) )
				
			if tbl.DropFunction then
			
				tbl.DropFunction( ply, id )
			
			end
		
		end
		
		return
	
	end
	
	local items = {}
	
	for i=1, count do
	
		if ply:HasItem( id ) then
		
			table.insert( items, id )
			
			if tbl.DropFunction then
			
				tbl.DropFunction( ply, id )
			
			end
		
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
	
	if not ValidEntity( ply.Stash ) or not table.HasValue( ply.Stash:GetItems(), id ) or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then
		
		ply:AddIDToInventory( id )
		ply.Stash:RemoveItem( id )
		
		return
	
	end
	
	local items = {}
	
	if ValidEntity( ply.Stash ) then
	
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
	
	if not ValidEntity( ply.Stash ) or not ply:HasItem( id ) or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then

		ply.Stash:AddItem( id )
		
		ply:RemoveFromInventory( id )
		ply:EmitSound( Sound( "c4.disarmfinish" ), 100, math.random( 90, 110 ) )
		
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
			
			if tbl.DropFunction then
			
				tbl.DropFunction( ply, id )
			
			end
			
		end
	
	end
	
	ply:RemoveMultipleFromInventory( items )
	ply:EmitSound( Sound( "c4.disarmfinish" ), 100, math.random( 90, 110 ) )

end

concommand.Add( "inv_store", StoreItem )

function SellItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
		
	if not ValidEntity( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc" ) or not ply:HasItem( id ) then return end
	
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
	
	for i=1, math.Clamp( count, 1, ply:GetItemCount( id ) ) do
	
		if ply:HasItem( id ) then
				
			table.insert( items, id )
			ply:AddCash( cash )
			
			if tbl.DropFunction then
			
				tbl.DropFunction( ply, id )
			
			end
			
		end
	
	end
	
	ply:RemoveMultipleFromInventory( items )

end

concommand.Add( "inv_sell", SellItem )

function BuyItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = tonumber( args[2] )
	
	if not ValidEntity( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc" ) or not table.HasValue( ply.Stash:GetItems(), id ) then return end
	
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

	if not ValidEntity( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc_trader" ) then return end

	if not ValidEntity( ply.StorageBox ) then
	
		ply.StorageBox = ents.Create( "info_storage" )
		ply.StorageBox:SetPos( ply:GetPos() )
		ply.StorageBox:SetupItems( ply )
		ply.StorageBox:SetUser( ply )
		ply.StorageBox:Spawn() 
	
	end
	
	ply:ToggleStashMenu( ply.StorageBox, true, "StashMenu", ply.Stash:GetBuybackScale(), true )

end

concommand.Add( "inv_save", OpenStorageMenu )

function OpenNPCMenu( ply, cmd, args )

	if not ValidEntity( ply.Stash ) or not string.find( ply.Stash:GetClass(), "npc_trader" ) then return end

	ply:ToggleStashMenu( ply.Stash, true, "StoreMenu", ply.Stash:GetBuybackScale() )

end

concommand.Add( "tradermenu", OpenNPCMenu )

function CloseNPCMenu( ply, cmd, args )

	if not ValidEntity( ply.Stash ) then return end

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

	if not ValidEntity( ply ) then 
	
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

	if not ply or ( ValidEntity( ply ) and ( ply:IsAdmin() or ply:IsSuperAdmin() ) ) then
	
		db.Wipe()
		db.Initialize()
	
	end

end

concommand.Add( "sv_radbox_reset_db", WipeDatabase )

function IncludeEvents()

	local folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.FindInLua( folder .. "/gamemode/events/*.lua" ) ) do
	
		include( folder .. "/gamemode/events/" .. d )
		
	end

end

IncludeEvents()
