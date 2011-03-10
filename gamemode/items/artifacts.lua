
// This is the ID given to any item that is rare and artifacts
ITEM_ARTIFACT = 450

function FUNC_BLINK( ply, id, client )

	if client then return "Shake" end
	
	local min, max = ply:WorldSpaceAABB()

	local ed = EffectData()
	ed:SetOrigin( min )
	ed:SetStart( max )
	ed:SetMagnitude( ply:BoundingRadius() )
	util.Effect( "prop_teleport", ed )
	
	local count = 0
	local pos = ply:GetPos()

	while count < 20 and pos:Distance( ply:GetPos() ) < 500 do
	
		local spawn = table.Random( ents.FindByClass( "info_lootspawn" ) )
		
		local trace = {}
		trace.start = spawn:GetPos()
		trace.endpos = trace.start + Vector(0,0,90000)
		trace.filter = spawn
		
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
			
			local trace = {}
			trace.start = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z )
			trace.endpos = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z - 90000 )
			
			local tr = util.TraceLine( trace )
			
			pos = tr.HitPos + Vector(0,0,100)

		end
		
		count = count + 1
		
	end
	
	ply:SetPos( pos )
	
	local vec = VectorRand()
	vec.z = 0.1
	
	ply:SetVelocity( vec * 1000 )
	
	umsg.Start( "GrenadeHit", ply )
	umsg.End()
	
	ply:SetDSP( 47 )
	ply:EmitSound( Sound( "ambient/levels/citadel/weapon_disintegrate4.wav" ) )
	ply:EmitSound( Sound( "ambient/levels/labs/teleport_weird_voices1.wav" ), 100, math.random(150,170) )
	ply:TakeDamage( 15, ply )
	
	timer.Simple( 5, function( ply ) if ValidEntity( ply ) then ply:SetDSP( 0 ) end end, ply )
	
	umsg.Start( "Drunk", ply )
	umsg.Short( 5 )
	umsg.End()
	
end

function FUNC_CORAL( ply, id, client )

	if client then return "Touch" end
	
	if math.random(1,5) == 1 then
	
		local dmg = DamageInfo()
		dmg:SetDamage( 100 )
		dmg:SetDamageType( DMG_SLASH )
		dmg:SetAttacker( ply )
	
		ply:SetBleeding( true )
		ply:EmitSound( Sound( "NPC_Manhack.Slice" ) )
	
	else
	
		ply:SetHealth( 200 )
		ply:EmitSound( Sound( "radbox/anom01.wav" ) )
	
		umsg.Start( "Drunk", ply )
		umsg.Short( 3 )
		umsg.End()
	
	end
	
end

function FUNC_SCALD( ply, id, client )

	if client then return "Touch" end
	
	if math.random(1,5) == 1 then
	
		local dmg = DamageInfo()
		dmg:SetDamage( 150 )
		dmg:SetDamageType( DMG_BURN )
		dmg:SetAttacker( ply )
		
		ply:TakeDamageInfo( dmg )
	
	else
	
		ply:SetBleeding( false )
		ply:AddHealth( 50 )
		ply:EmitSound( Sound( "radbox/anom02.wav" ) )
	
	end
	
end

function FUNC_PORC( ply, id, client )

	if client then return "Shake" end
	
	if math.random(1,5) == 1 then
	
		local dmg = DamageInfo()
		dmg:SetDamage( 75 )
		dmg:SetDamageType( DMG_SHOCK )
		dmg:SetAttacker( ply )
		
		ply:TakeDamageInfo( dmg )
		ply:SetStamina( 0 ) 
		ply:AddRadiation( 1 )
		ply:EmitSound( Sound( "ambient.electrical_random_zap_1" ) )
	
	else
	
		ply:SetStamina( 100 )
		ply:AddHealth( 20 )
		ply:EmitSound( Sound( "radbox/anom03.wav" ) )
		
		if math.random(1,10) == 1 then
		
			ply:AddRadiation( 1 )
		
		end
	
	end
	
end

function FUNC_MOSS( ply, id, client )

	if client then return "Shake" end
	
	if math.random(1,5) == 1 then
	
		local dmg = DamageInfo()
		dmg:SetDamage( 75 )
		dmg:SetDamageType( DMG_POISON )
		dmg:SetAttacker( ply )
	
		ply:TakeDamageInfo( dmg )
		ply:AddRadiation( 2 )
		ply:EmitSound( Sound( "NPC_Barnacle.TongueStretch" ) )
		ply:EmitSound( table.Random( GAMEMODE.Coughs ) )
		
		umsg.Start( "Drunk", ply )
		umsg.Short( 20 )
		umsg.End()
		
		
	
	else
	
		for k,v in pairs( player.GetAll() ) do
		
			if v:GetPos():Distance( ply:GetPos() ) < 500 then
			
				v:AddRadiation( math.random( -5, -1 ) )
			
			end
		
		end
		
		local count = 0
		
		for k,v in pairs( ents.FindByClass( "point_radiation" ) ) do
		
			if v:IsActive() and v:GetPos():Distance( ply:GetPos() ) < 800 then
			
				v:SetActive( false )
				
				count = count + 1
			
			elseif count > 0 and not v:IsActive() and v:GetPos():Distance( ply:GetPos() ) > 800 then
			
				v:SetActive( true )
				
				count = count - 1
			
			end
		
		end

		ply:AddStamina( 20 )
		ply:EmitSound( Sound( "radbox/anom04.wav" ) )
	
	end
	
end

function FUNC_BEAD( ply, id, client )

	if client then return "Shake" end

	local bead = ents.Create( "anomaly_bead" )
	bead:SetPos( ply:GetItemDropPos() )
	bead:Spawn()
	
	ply:RemoveFromInventory( id )

end

item.Register( { 
	Name = "'Storm Bead' Artifact", 
	Description = "This artifact is presumed to be the core of a Storm Pearl anomaly. It vibrates when you shake it.",
	Stackable = true, 
	Type = ITEM_ARTIFACT,
	Weight = 6.50, 
	Price = 1500,
	Rarity = 0.90,
	Model = "models/props_phx/misc/smallcannonball.mdl",
	Functions = { FUNC_BEAD },
	CamPos = Vector(15,25,5),
	CamOrigin = Vector(0,7,2)
} )

item.Register( { 
	Name = "'Bitter Coral' Artifact", 
	Description = "This artifact is found where Death Fog anomalies form. Your skin begins to blister whenever you touch it.",
	Stackable = true, 
	Type = ITEM_ARTIFACT,
	Weight = 3.50, 
	Price = 2000,
	Rarity = 0.90,
	Model = "models/srp/items/art_stoneblood.mdl",
	Functions = { FUNC_CORAL },
	CamPos = Vector(14,0,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "'Blink' Artifact", 
	Description = "This artifact is found where Warp anomalies form. It sparkles and flickers when you shake it.",
	Stackable = true, 
	Type = ITEM_ARTIFACT,
	Weight = 3.50, 
	Price = 2000,
	Rarity = 0.90,
	Model = "models/srp/items/art_moonlight.mdl",
	Functions = { FUNC_BLINK },
	CamPos = Vector(12,5,5),
	CamOrigin = Vector(0,0,3)
} )

item.Register( { 
	Name = "'Scaldstone' Artifact", 
	Description = "This artifact is found where Cooker anomalies form. It seems to constantly radiate warmth.",
	Stackable = true, 
	Type = ITEM_ARTIFACT,
	Weight = 3.50, 
	Price = 2000,
	Rarity = 0.90,
	Model = "models/srp/items/art_fireball.mdl",
	Functions = { FUNC_SCALD },
	CamPos = Vector(8,10,5),
	CamOrigin = Vector(0,0,3)
} )

item.Register( { 
	Name = "'Porcupine' Artifact", 
	Description = "This artifact is found where Electro anomalies form. Your muscles tense up when you hold it.",
	Stackable = true, 
	Type = ITEM_ARTIFACT,
	Weight = 3.50, 
	Price = 2000,
	Rarity = 0.90,
	Model = "models/srp/items/art_crystalthorn.mdl",
	Functions = { FUNC_PORC },
	CamPos = Vector(10,8,5),
	CamOrigin = Vector(0,0,5)
} )

item.Register( { 
	Name = "'Tainted Moss' Artifact", 
	Description = "This artifact is presumed to form near radioactive deposits. It emits trace amounts of radiation.",
	Stackable = true, 
	Type = ITEM_ARTIFACT,
	Weight = 4.50, 
	Price = 2000,
	Rarity = 0.90,
	Model = "models/srp/items/art_urchen.mdl",
	Functions = { FUNC_MOSS },
	CamPos = Vector(8,10,8),
	CamOrigin = Vector(0,0,4)
} )
