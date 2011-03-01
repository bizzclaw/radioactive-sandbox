
include( 'team.lua' )
include( 'items.lua' )
include( 'quests.lua' )
include( 'shared.lua' )
include( 'moddable.lua' )
include( 'daycycle.lua' )
include( 'cl_targetid.lua' )
include( 'cl_spawnmenu.lua' )
include( 'cl_scoreboard.lua' )
include( 'cl_postprocess.lua' )
include( 'cl_inventory.lua' )
include( 'vgui/vgui_panelbase.lua' )
include( 'vgui/vgui_dialogue.lua' )
include( 'vgui/vgui_itemdisplay.lua' )
include( 'vgui/vgui_teampicker.lua' )
include( 'vgui/vgui_npcmenu.lua' )
include( 'vgui/vgui_quickslot.lua' )
include( 'vgui/vgui_targetid.lua' )
include( 'vgui/vgui_helpmenu.lua' )
include( 'vgui/vgui_playerdisplay.lua' )
include( 'vgui/vgui_itempanel.lua' )
include( 'vgui/vgui_panelsheet.lua' )
include( 'vgui/vgui_goodmodelpanel.lua' )

CV_AutoEmote = CreateClientConVar( "cl_radbox_auto_emote", "1", true, false )

function GM:Initialize( )
	
	GAMEMODE:InitVGUI()
	
	WindVector = Vector( math.random(-10,10), math.random(-10,10), 0 )
	StaticPos = Vector(0,0,0)
	NightVision = false
	VehicleView = false
	EmoteCooldown = 0
	Drunkness = 0
	DeathScreenTime = 0
	DeathScreenScale = 0
	HeartBeat = 0
	ArmAngle = 0
	ArmSpeed = 70
	BlipTime = 2.0
	FadeDist = 0.3 // radar vars
	MaxDist = 1500
	PosTable = {}
	RadarEntTable = {}
	TimeSeedTable = {}
	
	surface.CreateFont ( "Graffiare", 34, 200, true, true, "DeathFont" )
	surface.CreateFont ( "Graffiare", 28, 200, true, true, "AmmoFont" )
	surface.CreateFont ( "Verdana", 12, 300, true, true, "AmmoFontSmall" )
	surface.CreateFont ( "Verdana", 12, 200, true, true, "TargetIDFont" )
	
	matRadar = Material( "radbox/radar" )
	matArm = Material( "radbox/radar_arm" )
	matArrow = Material( "radbox/radar_arrow" )
	matNoise = Material( "radbox/nvg_noise" )
	
	matHealth = Material( "radbox/img_health" )
	matStamina = Material( "radbox/img_stamina" )
	matBlood = Material( "radbox/img_blood" )
	matRadiation = Material( "radbox/img_radiation" )
	
end

function GM:ShowTeam()

	if IsValid( self.TeamSelectFrame ) then return end
	
	self.TeamSelectFrame = vgui.Create( "TeamPicker" )
	self.TeamSelectFrame:SetSize( 415, 370 )
	self.TeamSelectFrame:Center()
	self.TeamSelectFrame:MakePopup()
	self.TeamSelectFrame:SetKeyboardInputEnabled( false )

end

function GM:ShowHelp()

	if IsValid( self.HelpFrame ) then return end
	
	self.HelpFrame = vgui.Create( "HelpMenu" )
	self.HelpFrame:SetSize( 415, 370 )
	self.HelpFrame:Center()
	self.HelpFrame:MakePopup()
	self.HelpFrame:SetKeyboardInputEnabled( false )

end

function GM:ShouldDrawLocalPlayer( ply )

	if ValidEntity( ply:GetVehicle() ) and gmod_vehicle_viewmode:GetInt() == 1 then
	
		return true
	
	end

	local wep = ply:GetActiveWeapon()
	
	if not ValidEntity( wep ) then return false end

	return wep:GetClass() == "rad_hands" and wep:GetNWBool( "Thirdperson", false ) 
	
end

function GM:HUDShouldDraw( name )

	if GAMEMODE.ScoreboardVisible then return false end
	
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudSuitPower", "CHudPoisonDamageIndicator"} do
		if name == v then return false end 
  	end 
	
	if name == "CHudDamageIndicator" and not LocalPlayer():Alive() then
		return false
	end
	
	return true
	
end

function GM:PlayerBindPress( ply, bind, pressed )

	if not pressed then return end
	
	if bind == "+duck" and ValidEntity( ply:GetVehicle() ) then
	
		local val = gmod_vehicle_viewmode:GetInt()
		
		if val == 0 then val = 1 else val = 0 end
		
		RunConsoleCommand( "gmod_vehicle_viewmode", val )
		
		return true
	
	elseif string.find( bind, "impulse 100" ) and Inv_HasItem( "models/gibs/manhack_gib03.mdl" ) then
	
		NightVision = !NightVision
	
		if NightVision then 
		
			LocalPlayer():EmitSound( Sound( "items/nvg_on.wav" ), 100, 130 )
			
		else
		
			LocalPlayer():EmitSound( Sound( "items/nvg_off.wav" ) )
		
		end
		
	end
	
	return false
	
end

function TimeSeed( num, min, max )
	
	if not TimeSeedTable[num] then 
	
		TimeSeedTable[num] = { Min = min, Max = max, Curr = min, Dest = min, Approach = 0.001 } 
		
	end
	
	return TimeSeedTable[num].Curr

end

function GM:Think()

	if EmoteCooldown < CurTime() and LocalPlayer():Alive() and CV_AutoEmote:GetBool() then
	
		EmoteCooldown = CurTime() + math.random( 60, 120 )
		
		if Drunkness > 3 then
			
			RunConsoleCommand( "say", table.Random( GAMEMODE.ChatEmotes[ "Drunk" ] ) )
		
		elseif LocalPlayer():GetNWInt( "Radiation", 0 ) > 1 then
		
			RunConsoleCommand( "say", table.Random( GAMEMODE.ChatEmotes[ "Radiation" ] ) )
		
		elseif LocalPlayer():GetNWBool( "Bleeding", false ) then
		
			RunConsoleCommand( "say", table.Random( GAMEMODE.ChatEmotes[ "Bleeding" ] ) )
		
		elseif LocalPlayer():Health() < 100 then
		
			RunConsoleCommand( "say", table.Random( GAMEMODE.ChatEmotes[ "Pain" ] ) )
		
		end
	
	end

	for k,v in pairs( TimeSeedTable ) do
	
		if v.Curr != v.Dest then
		
			v.Curr = math.Approach( v.Curr, v.Dest, v.Approach )
		
		else
		
			v.Dest = math.Rand( v.Min, v.Max )
			v.Approach = math.Rand( 0.0001, 0.01 )
		
		end
	
	end

	if ValidEntity( LocalPlayer() ) and LocalPlayer():Alive() and not StartMenuShown then
	
		StartMenuShown = true
		GAMEMODE:ShowHelp()
	
	end

	if not LocalPlayer():Alive() and InventoryScreen:IsVisible() then
	
		InventoryScreen:SetVisible( false )
		InfoScreen:SetVisible( false )
		PlayerScreen:SetVisible( false )
		StashScreen:SetVisible( false )
		gui.EnableScreenClicker( false )
		
	end
	
	if not Inv_HasItem( "models/gibs/manhack_gib03.mdl" ) and NightVision then
	
		NightVision = false
	
	end

	GAMEMODE:FadeRagdolls()

	if LocalPlayer():Alive() and HeartBeat < CurTime() and ( LocalPlayer():GetNWBool( "Bleeding", false ) or LocalPlayer():Health() < 50 ) then
	
		local scale = LocalPlayer():Health() / 100
		HeartBeat = CurTime() + 0.5 + scale * 1.5
		
		LocalPlayer():EmitSound( Sound( "radbox/heartbeat.wav" ), 100, 150 - scale * 50 )
		
	end
	
	if Inv_HasItem( "models/gibs/shield_scanner_gib1.mdl" ) then
	
		MaxDist = 2200
		ArmSpeed = 80
	
	else
	
		MaxDist = 1500
		ArmSpeed = 70
	
	end

	if ( NextRadarThink or 0 ) < CurTime() then
	
		NextRadarThink = CurTime() + 1
	
		RadarEntTable = player.GetAll()
		RadarEntTable = table.Add( RadarEntTable, ents.FindByClass( "npc_*" ) )
		RadarEntTable = table.Add( RadarEntTable, ents.FindByClass( "sent_lootbag" ) )
		RadarEntTable = table.Add( RadarEntTable, ents.FindByClass( "point_stash" ) )
		
	end
	
end

function GM:FadeRagdolls()

	for k,v in pairs( ents.FindByClass( "class C_ClientRagdoll" ) ) do
	
		if v.Time and v.Time < CurTime() then
		
			v:SetColor( 255, 255, 255, v.Alpha )
			v.Alpha = math.Approach( v.Alpha, 0, -2 )
			
			if v.Alpha <= 0 then
				v:Remove()
			end
		
		elseif not v.Time then
		
			v.Time = CurTime() + 10
			v.Alpha = 255
		
		end
	end
end

function GrenadeHit( msg )

	DisorientTime = CurTime() + 8
	
end
usermessage.Hook( "GrenadeHit", GrenadeHit )

function DeathScreen( msg )

	DeathScreenScale = 0
	DeathScreenTime = CurTime() + 15
	
end
usermessage.Hook( "DeathScreen", DeathScreen )

function DrawNoise()

	if !NightVision then return end
	
	for i=0, math.Round( ScrW() / 640 ) do
	
		for j=0, math.Round( ScrH() / 640 ) do
		
			surface.SetDrawColor( 200, 200, 200, 15 ) 
			surface.SetMaterial( matNoise ) 
			surface.DrawTexturedRectRotated( i * 640, j * 640, 640, 640, math.random(0,3) * 90 ) 
		
		end
	
	end

end

function DrawBar( x, y, w, h, value, maxvalue, icon, colorlight, colordark )

	draw.RoundedBox( 4, x - 1, y, h + 1, h, Color( 0, 0, 0, 200 ) )
	
	surface.SetDrawColor( colorlight.r, colorlight.g, colorlight.b, 200 ) 
	surface.SetMaterial( icon ) 
	surface.DrawTexturedRect( x, y + 1, h - 1, h - 2 ) 
	
	//draw.SimpleText( icon, "HUDBarFont", x + ( h * 0.5 ), y + ( h * 0.5 ) - 1, colorlight, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	x = x + h + 2
	
	draw.RoundedBox( 4, x, y, w, h, Color( 0, 0, 0, 200 ) )
	
	local maxlen = ( value / maxvalue ) * w
	local i = 3
	
	while i < maxlen - 2 do
	
		draw.RoundedBox( 0, x + i, y + 3, 2, h - 6, colordark )
		draw.RoundedBox( 0, x + i, y + 3, 2, ( h * 0.5 ) - 3, colorlight )
		
		i = i + 4
	
	end

end

function DrawIcon( x, y, w, h, icon, color )

	draw.RoundedBox( 4, x - 1, y, h + 1, h, Color( 0, 0, 0, 200 ) )
	//draw.SimpleText( icon, "HUDBarFont", x + ( h * 0.5 ), y + ( h * 0.5 ) - 1, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	surface.SetDrawColor( color.r, color.g, color.b, 200 ) 
	surface.SetMaterial( icon ) 
	surface.DrawTexturedRect( x, y + 1, h - 1, h - 2 ) 

end

function DrawAmmo( x, y, w, h, text, label )

	if not ValidEntity( LocalPlayer():GetActiveWeapon() ) then return end

	draw.RoundedBox( 4, x, y, w, h, Color( 0, 0, 0, 200 ) )
	
	draw.SimpleText( text, "AmmoFont", x + 5, y + ( h * 0.5 ) - 5, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	draw.SimpleText( label, "AmmoFontSmall", x + 5, y + 5, Color( 255, 255, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	
end

function GM:GetAfflictions()

	local tbl = {}
	local cols = { Color( 40, 200, 40 ), Color( 80, 150, 40 ), Color( 150, 150, 0 ), Color( 200, 100, 40 ), Color( 255, 40, 40 ) }
	local rad = LocalPlayer():GetNWInt( "Radiation", 0 )

	if LocalPlayer():GetNWBool( "Bleeding", false ) then
	
		table.insert( tbl, { Icon = matBlood, Color = Color( 225, 40, 40 ) } )
		
	end
	
	if rad > 0 then

		table.insert( tbl, { Icon = matRadiation, Color = cols[ rad ] } )
		
	end
	
	return tbl

end

function GM:HUDPaint()

	GAMEMODE:HUDDrawTargetID()
	
	if not LocalPlayer():Alive() and LocalPlayer():Team() != TEAM_UNASSIGNED then
		
		DeathScreenScale = math.Approach( DeathScreenScale, 1, FrameTime() * 0.3 ) 
		
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH() * ( 0.15 * DeathScreenScale ), Color( 0, 0, 0, 200 ) )
		draw.RoundedBox( 0, 0, ScrH() - ( ScrH() * ( 0.15 * DeathScreenScale ) ), ScrW(), ScrH() * ( 0.15 * DeathScreenScale ), Color( 0, 0, 0, 200 ) )
		
		if DeathScreenScale == 1 then
		
			local time = math.Round( DeathScreenTime - CurTime() )
			
			if time > 0 then
			
				draw.SimpleText( "YOU WILL BE ABLE TO RESPAWN IN "..time.." SECONDS", "DeathFont", ScrW() * 0.5, ScrH() * 0.1, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
			else
			
				draw.SimpleText( "PRESS ANY KEY TO RESPAWN", "DeathFont", ScrW() * 0.5, ScrH() * 0.1, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			end
			
			draw.SimpleText( "PRESS F2 TO JOIN A DIFFERENT FACTION", "DeathFont", ScrW() * 0.5, ScrH() * 0.9, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		end
	
	end
	
	if not LocalPlayer():Alive() or LocalPlayer():Team() == TEAM_UNASSIGNED or InventoryScreen:IsVisible() then return end
	
	DrawNoise()
	
	local xlen = 200
	local ylen = 25
	local xpos = 5
	local ypos = ScrH() - 5 - ylen
	
	DrawBar( xpos, ypos, xlen, ylen, LocalPlayer():Health(), 200, matHealth, Color( 225, 40, 40, 255 ), Color( 175, 20, 20, 255 ) )
	
	ypos = ScrH() - 10 - ylen * 2
	
	DrawBar( xpos, ypos, xlen, ylen, LocalPlayer():GetNWInt( "Stamina", 0 ), 100, matStamina, Color( 40, 80, 225, 255 ), Color( 20, 40, 175, 255 ) )
	
	F3Item:SetPos( xpos + ylen + xlen + 7, ypos )
	F3Item:SetSize( ylen * 3, ylen * 2 + 5 )
	
	F4Item:SetPos( xpos + ylen + xlen + 12 + ylen * 3, ypos )
	F4Item:SetSize( ylen * 3, ylen * 2 + 5 )
	
	local tbl = GAMEMODE:GetAfflictions()
	
	for k,v in pairs( tbl ) do
	
		ypos = ScrH() - ( 10 + ( k * 5 ) ) - ylen * ( 2 + k )
		
		DrawIcon( xpos, ypos, xlen, ylen, v.Icon, v.Color )
	
	end
	
	if ValidEntity( LocalPlayer():GetActiveWeapon() ) and ( LocalPlayer():GetActiveWeapon().AmmoType or "SMG" ) != "Knife" then
	
		local total = LocalPlayer():GetNWInt( "Ammo" .. ( LocalPlayer():GetActiveWeapon().AmmoType or "SMG" ), 0 )
		local ammo = math.Clamp( LocalPlayer():GetActiveWeapon():Clip1(), 0, total )
		
		local xlen = 55
	
		DrawAmmo( ScrW() - 5 - xlen, ScrH() - 55, xlen, 50, total, "TOTAL" )
		DrawAmmo( ScrW() - 10 - xlen * 2, ScrH() - 55, xlen, 50, ammo, "AMMO" )
	
	end
	
	local radius = 200 
	local centerx = ScrW() - ( radius / 2 ) - 20
	local centery = 20 + ( radius / 2 )
	
	ArmAngle = ArmAngle + FrameTime() * ArmSpeed
		
	if ArmAngle > 360 then
		ArmAngle = 0 + ( ArmAngle - 360 )
	end
	
	surface.SetDrawColor( 255, 255, 255, 200 ) 
	surface.SetMaterial( matRadar ) 
	surface.DrawTexturedRect( ScrW() - radius - 20, 20, radius, radius ) 
	
	local aimvec = LocalPlayer():GetAimVector()
		
	for k,v in pairs( RadarEntTable ) do
	
		if not ValidEntity( v ) then break end
		
		local dirp = ( LocalPlayer():GetPos() - v:GetPos() ):Normalize()
		local aimvec = LocalPlayer():GetAimVector()
		aimvec.z = dirp.z
		
		local dir = ( aimvec:Angle() + Angle( 0, ArmAngle + 90, 0 ) ):Forward()
        local dot = dir:Dot( dirp )
        local diff = ( v:GetPos() - LocalPlayer():GetPos() )
		
		local close = math.sqrt( diff.x * diff.x + diff.y * diff.y ) < MaxDist * FadeDist

		if ( !v:IsPlayer() or ( v != LocalPlayer() and v:Team() == LocalPlayer():Team() ) ) and !IsOnRadar( v ) and ( dot > 0.99 or close ) then
			
			local pos = v:GetPos()
			local color = Color( 0, 255, 0 )
				
			if not v:IsPlayer() then
			
				color = Color( 80, 150, 255 )
				
				if string.find( v:GetClass(), "npc_trader" ) then
				
					color = Color( 255, 255, 255 )
				
				elseif string.find( v:GetClass(), "npc" ) then
				
					color = Color( 255, 80, 80 )
				
				end
			
			elseif not v:Alive() then
				
				color = Color( 255, 255, 80 )
				
				if ValidEntity( v:GetRagdollEntity() ) then
					
					pos = v:GetRagdollEntity():GetPos()
		
				end
					
			elseif v:Team() != LocalPlayer():Team() then
				
				color = Color( 255, 80, 80 )
				
			end
				
			local dietime = CurTime() + BlipTime
			
			if close then
				
				dietime = -1
				
			end
			
			table.insert( PosTable, { Ent = v, Pos = pos, DieTime = dietime, Color = color } )
			
		end
		
	end
	
	for k,v in pairs( PosTable ) do
		
		local diff = ( v.Pos - LocalPlayer():GetPos() )
		local alpha = 50 
		
		if v.DieTime != -1 then
		
			alpha = 50 * ( math.Clamp( v.DieTime - CurTime(), 0, BlipTime ) / BlipTime )
		
		elseif ( !ValidEntity( v.Ent ) or ( v.Ent:IsPlayer() and !v.Ent:Alive() ) ) then
			
			PosTable[k].DieTime = CurTime() + 1.0
			
		end
			
		if math.sqrt( diff.x * diff.x + diff.y * diff.y ) > MaxDist * FadeDist and v.DieTime == -1 then
			
			PosTable[k].DieTime = CurTime() + 1.0
			
		end
			
		if alpha > 0 and math.sqrt( diff.x * diff.x + diff.y * diff.y ) < MaxDist then
			
			local addx = diff.x / MaxDist
			local addy = diff.y / MaxDist
			local addz = math.sqrt( addx * addx + addy * addy )
			local phi = math.atan2( addx, addy ) - math.atan2( aimvec.x, aimvec.y ) - ( math.pi / 2 )
			
			addx = math.cos( phi ) * addz
			addy = math.sin( phi ) * addz
			
			draw.RoundedBox( 4, centerx + addx * ( ( radius - 15 ) / 2 ) - 4, centery + addy * ( ( radius - 15 ) / 2 ) - 4, 5, 5, Color( v.Color.r, v.Color.g, v.Color.b, alpha ) )
			
		end
	
	end
		
	for k,v in pairs( PosTable ) do
		
		if v.DieTime != -1 and v.DieTime < CurTime() then
			
			table.remove( PosTable, k )
			
		end
		
	end
		
	surface.SetDrawColor( 255, 255, 255, 200 ) 
	surface.SetMaterial( matArm )
	surface.DrawTexturedRectRotated( centerx, centery, radius, radius, ArmAngle ) 
	
	local ent = LocalPlayer():GetDTEntity( 0 )
	
	if ValidEntity( ent ) or StaticPos != Vector(0,0,0) then
	
		local ang = Angle(0,0,0)
	
		if ValidEntity( ent ) then
		
			ang = ( ent:GetPos() - LocalPlayer():GetShootPos()):Angle() - LocalPlayer():GetForward():Angle()
			
			local diff = ( ent:GetPos() - LocalPlayer():GetPos() )
				
			if math.sqrt( diff.x * diff.x + diff.y * diff.y ) < MaxDist * FadeDist then 
				
				return
				
			end
		
		end
		
		if StaticPos != Vector(0,0,0) then
		
			ang = ( StaticPos - LocalPlayer():GetShootPos()):Angle() - LocalPlayer():GetForward():Angle()
		
		end
		
		surface.SetDrawColor( 255, 255, 255, 150 ) 
		surface.SetMaterial( matArrow )
		surface.DrawTexturedRectRotated( centerx, centery, radius, radius, ang.y )
		
	end
	
end

function IsOnRadar( ent )

	for k,v in pairs( PosTable ) do
	
		if v.Ent == ent then
		
			return v
		
		end
	
	end

end

function GM:HUDWeaponPickedUp( wep )

end

function GM:HUDItemPickedUp( itemname )

end

function GM:HUDAmmoPickedUp( itemname, amount )

end

function GM:HUDDrawPickupHistory( )

end

function GM:HUDPaintBackground()

end

function GM:CreateMove( cmd )

end

function SetRadarTarget( msg )
 
	StaticPos = msg:ReadVector()
 
end
usermessage.Hook( "StaticTarget", SetRadarTarget )

function AddDrunkness( msg )
 
	Drunkness = math.Clamp( Drunkness + msg:ReadShort(), 0, 10 )
	DrunkTimer = CurTime() + 60
 
end
usermessage.Hook( "Drunk", AddDrunkness )

function InventorySynch( handler, id, encoded, decoded )

	LocalInventory = {}
	LocalInventory = decoded
	
	if InventoryScreen and InventoryScreen:IsVisible() then
	
		InventoryScreen:RefreshItems( LocalInventory )
		
	end

end
datastream.Hook( "InventorySynch", InventorySynch )

function StashSynch( handler, id, encoded, decoded )

	LocalStash = {}
	LocalStash = decoded
	
	if StashScreen and StashScreen:IsVisible() then
	
		StashScreen:RefreshItems( LocalStash )
		
	end

end
datastream.Hook( "StashSynch", StashSynch )