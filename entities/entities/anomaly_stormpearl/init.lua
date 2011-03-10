
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.WeirdSounds = { Sound( "ambient/levels/citadel/strange_talk1.wav" ), 
Sound( "ambient/levels/citadel/strange_talk3.wav" ), 
Sound( "ambient/levels/citadel/strange_talk4.wav" ), 
Sound( "ambient/levels/citadel/strange_talk5.wav" ), 
Sound( "ambient/levels/citadel/strange_talk6.wav" ), 
Sound( "ambient/levels/citadel/strange_talk7.wav" ), 
Sound( "ambient/levels/citadel/strange_talk8.wav" ), 
Sound( "ambient/levels/citadel/strange_talk9.wav" ),
Sound( "ambient/levels/citadel/strange_talk10.wav" ),
Sound( "ambient/levels/citadel/strange_talk11.wav" ) }

ENT.Pain = { Sound( "ambient/atmosphere/thunder1.wav" ), 
Sound( "ambient/atmosphere/thunder2.wav" ), 
Sound( "ambient/atmosphere/thunder3.wav" ), 
Sound( "ambient/atmosphere/thunder4.wav" ),
Sound( "ambient/atmosphere/terrain_rumble1.wav" ),
Sound( "ambient/atmosphere/hole_hit4.wav" ),
Sound( "ambient/atmosphere/cave_hit5.wav" ) }

ENT.Rape = Sound( "ambient/explosions/citadel_end_explosion2.wav" )

ENT.Distance = 600

function ENT:Initialize()
	
	self.Entity:SetModel( "models/XQM/Rails/gumball_1.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()

	end
	
	self.SoundTime = 0
	self.HurtSound = 0
	self.Target = {}

end

function ENT:GetRadiationRadius()

	return 700

end

function ENT:OnTakeDamage( dmg )

	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:ApplyForceCenter( ( self.Entity:GetPos() - dmg:GetDamagePosition() ):Normalize() * dmg:GetDamageForce() * 2 )
	
	end
	
	if self.HurtSound < CurTime() then
	
		self.HurtSound = CurTime() + 0.5
		
		self.Entity:EmitSound( table.Random( self.Pain ), 100, math.random( 180, 200 ) )
	
	end
	
	if math.random(1,15) == 1 then
	
		self.Entity:SetNWBool( "Explode", true )
		self.ExplodeTime = CurTime() + math.random( 5, 20 )
	
	end

end

function ENT:OnRemove()

	for k,v in pairs( player.GetAll() ) do
		
		if ValidEntity( v ) and v:Alive() and self.Entity:GetPos():Distance( v:GetPos() ) < 1000 then
			
			local scale = 1 - math.Clamp( self.Entity:GetPos():Distance( v:GetPos() ) / 1000, 0, 1 ) 
			
			util.ScreenShake( v:GetPos(), scale * 20, scale * 25, 2, 100 )
			
			v:TakeDamage( 75 * scale, self.Entity )
			v:AddStamina( math.floor( -50 * scale ) )
			
			if scale > 0.75 then
				
				umsg.Start( "Drunk", v )
				umsg.Short( 5 )
				umsg.End()
				
			end
			
		end
		
	end

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "pearl_explode", ed, true, true )
	
	self.Entity:EmitSound( self.Rape, 100, 160 )
	
	if math.Rand(0,1) < GAMEMODE.ArtifactRarity[ self.Entity:GetClass() ] then
	
		local prop = ents.Create( "prop_physics" )
		prop:SetPos( self.Entity:GetPos() )
		prop:SetModel( "models/props_phx/misc/smallcannonball.mdl" )
		prop:Spawn()
		
		timer.Simple( 60, function( ent ) if ValidEntity( ent ) then ent:Remove() end end, prop )
	
	end

end

function ENT:Think() 

	if self.ExplodeTime then
	
		if self.HurtSound < CurTime() then
	
			self.HurtSound = CurTime() + math.Rand( 0.5, 2.0 )
		
			self.Entity:EmitSound( table.Random( self.Pain ), 100, math.random( 180, 200 ) )
	
		end
	
	end

	if self.ExplodeTime and self.ExplodeTime < CurTime() then
	
		for k,v in pairs( player.GetAll() ) do
	
			if ValidEntity( v ) and table.HasValue( self.Target, v ) then
		
				v:SetDSP( 0, false ) 

			end
		
		end
	
		self.Entity:Remove()
	
	end

	for k,v in pairs( player.GetAll() ) do
	
		if ValidEntity( v ) and v:GetPos():Distance( self.Entity:GetPos() ) < self.Distance and not table.HasValue( self.Target, v ) then
		
			v:SetDSP( 23, false ) 
		
			table.insert( self.Target, v )
		
		end
	
	end
	
	for k,v in pairs( player.GetAll() ) do
	
		if ValidEntity( v ) and v:GetPos():Distance( self.Entity:GetPos() ) >= self.Distance and table.HasValue( self.Target, v ) then
		
			v:SetDSP( 0, false )
			
			table.remove( self.Target, k )
			
			break
		
		end
	
	end
	
	for k,v in pairs( self.Target ) do
		
		if ValidEntity( v ) and v:Alive() then
			
			local scale = 1 - math.Clamp( self.Entity:GetPos():Distance( v:GetPos() ) / self.Distance, 0, 1 ) 
			
			util.ScreenShake( v:GetPos(), scale * 2, scale * 15, 2, 100 )
			
			v:TakeDamage( 3 * scale, self.Entity )
			v:AddStamina( math.floor( -4 * scale ) )
			
			if scale > 0.75 then
				
				umsg.Start( "Drunk", v )
				umsg.Short( 1 )
				umsg.End()
				
			end
			
		end
		
	end
	
	if self.SoundTime < CurTime() then
		
		self.SoundTime = CurTime() + math.random( 5, 10 )
		
		self.Entity:EmitSound( table.Random( self.WeirdSounds ), 100, math.random( 130, 160 ) )
		
	end
	
end 

function ENT:Use( ply, caller )

end
