
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.PreZap = {"weapons/physcannon/superphys_small_zap1.wav",
"weapons/physcannon/superphys_small_zap2.wav",
"weapons/physcannon/superphys_small_zap3.wav",
"weapons/physcannon/superphys_small_zap4.wav"}

ENT.ZapHit = {"weapons/physcannon/energy_disintegrate4.wav",
"weapons/physcannon/energy_disintegrate5.wav"}

ENT.ExplodeZap = {"ambient/explosions/explode_7.wav",
"ambient/levels/labs/electric_explosion1.wav", 
"ambient/levels/labs/electric_explosion2.wav", 
"ambient/levels/labs/electric_explosion3.wav", 
"ambient/levels/labs/electric_explosion4.wav"}

ENT.ZapRadius = 400

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
		
	self.Entity:SetCollisionBounds( Vector( -150, -150, -150 ), Vector( 150, 150, 150 ) )
	self.Entity:PhysicsInitBox( Vector( -150, -150, -150 ), Vector( 150, 150, 150 ) )
	
	self.SoundTime = 0
	
end

function ENT:GetRadiationRadius()

	return 200

end

function ENT:Touch( ent ) 
	
	if self.SetOff then return end
	
	if ent:IsPlayer() or string.find( ent:GetClass(), "npc" ) or string.find( ent:GetClass(), "prop_phys" ) then
	
		self.SetOff = CurTime() + 3
		
	end
	
end 

function ENT:Think()

	if self.SetOff and self.SetOff > CurTime() then
	
		if self.SoundTime < CurTime() then
		
			self.SoundTime = CurTime() + 0.3
	
			local tbl = ents.FindByClass( "prop_phys*" )
			tbl = table.Add( tbl, ents.FindByClass( "npc*" ) )
			tbl = table.Add( tbl, player.GetAll() )
		
			for k,v in pairs( tbl ) do
			
				if v:GetPos():Distance( self.Entity:GetPos() ) < self.ZapRadius then
				
					v:EmitSound( table.Random( self.PreZap ), 100, math.random(60,80) )
				
				end
			
			end
			
		end
	
	elseif self.SetOff and self.SetOff < CurTime() then
	
		self.Entity:Explode()
		
		self.SetOff = nil
	
	end

end

function ENT:Explode()

	local tbl = ents.FindByClass( "prop_phys*" )
	tbl = table.Add( tbl, ents.FindByClass( "npc*" ) )
	tbl = table.Add( tbl, player.GetAll() )
	
	for k,v in pairs( tbl ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < self.ZapRadius then
			
			if ( v:IsPlayer() and not ValidEntity( v:GetVehicle() ) ) or not v:IsPlayer() then
			
				if v:IsPlayer() and not ValidEntity( v:GetVehicle() ) then
			
					v.Inventory = {}
			
				end
				
				local ed = EffectData()
				ed:SetOrigin( v:GetPos() )
				util.Effect( "electric_zap", ed )
				
				local force = VectorRand()
				force.z = 0.25
			
				local dmg = DamageInfo()
				dmg:SetDamage( 500 )
				dmg:SetDamageType( DMG_DISSOLVE )
				dmg:SetAttacker( self.Entity )
				dmg:SetInflictor( self.Entity )
				dmg:SetDamageForce( force * 1000 )
				
				v:TakeDamageInfo( dmg )
				v:EmitSound( table.Random( self.ZapHit ), 100, math.random(90,110) )
				
				self.Entity:DrawBeams( self.Entity, v )
				
			end
				
		end
	
	end
	
	for i=1, math.random( 8, 12 ) do
	
		local vec = VectorRand() 
		vec.z = math.Rand( -1.0, 0.5 )
	
		local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = trace.start + vec * 500
		
		local tr = util.TraceLine( trace )
		
		while ( tr.HitPos:Distance( self.Entity:GetPos() ) < 50 or not tr.Hit ) do
		
			local vec = VectorRand() 
			vec.z = math.Rand( -0.25, 0.50 )
	
			local trace = {}
			trace.start = self.Entity:GetPos()
			trace.endpos = trace.start + vec * self.ZapRadius
			trace.filter = self.Entity
		
			tr = util.TraceLine( trace )
		
		end
		
		self.Entity:DrawBeams( self.Entity, self.Entity, tr.HitPos )
		
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		util.Effect( "electric_zap", ed )
	
	end
	
	self.Entity:EmitSound( table.Random( self.ExplodeZap ), 100, math.random(90,110) )
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "electric_bigzap", ed )
	
end


function ENT:DrawBeams( ent1, ent2, pos )
	
	local target = ents.Create( "info_target" )
	target:SetPos( ent1:LocalToWorld( ent1:OBBCenter() ) )
	target:SetParent( ent1 )
	target:SetName( tostring( ent1 )..math.random(1,900) )
	target:Spawn()
	target:Activate()
	
	local target2 = ents.Create( "info_target" )
	
	if pos then
	
		target2:SetPos( pos )
		target2:SetName( tostring( pos ) )
	
	else
	
		target2:SetPos( ent2:LocalToWorld( ent2:OBBCenter() ) )
		target2:SetParent( ent2 )
		target2:SetName( tostring( ent2 )..math.random(1,900) )
	
	end
	
	target2:Spawn()
	target2:Activate()
	
	local laser = ents.Create( "env_beam" )
	laser:SetPos( ent1:GetPos() )
	laser:SetKeyValue( "spawnflags", "1" )
	laser:SetKeyValue( "rendercolor", "200 200 255" )
	laser:SetKeyValue( "texture", "sprites/laserbeam.spr" )
	laser:SetKeyValue( "TextureScroll", "1" )
	laser:SetKeyValue( "damage", "0" )
	laser:SetKeyValue( "renderfx", "6" )
	laser:SetKeyValue( "NoiseAmplitude", ""..math.random(5,20) )
	laser:SetKeyValue( "BoltWidth", "1" )
	laser:SetKeyValue( "TouchType", "0" )
	laser:SetKeyValue( "LightningStart", target:GetName() )
	laser:SetKeyValue( "LightningEnd", target2:GetName() )
	laser:SetOwner( self.Entity:GetOwner() )
	laser:Spawn()
	laser:Activate()
	
	laser:Fire( "kill", "", 0.2 )
	target:Fire( "kill", "", 0.2 )
	target2:Fire( "kill", "", 0.2 )

end 




