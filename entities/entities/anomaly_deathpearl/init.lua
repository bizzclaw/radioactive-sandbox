
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
	
	self.Entity:StartMotionController()
	
	self.Active = false
	self.SoundTime = 0
	self.Target = {}

end

function ENT:GetRadiationRadius()

	return 700

end

function ENT:PhysicsSimulate( phys, delta )

	if not self.Active then return SIM_NOTHING end
	
	if self.ReActivate then
	
		self.ReActivate = false
		
		phys:ApplyForceCenter( VectorRand() * 50 )
	
	end
	
	if ValidEntity( self.Target[1] ) then
	
		local vel = ( self.Target[1]:GetPos() - self.Entity:GetPos() ):Normalize()
		
		phys:ApplyForceCenter( vel * 50 )
	
	end

end

function ENT:Think() 

	local active = false

	for k,v in pairs( player.GetAll() ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < self.Distance and not table.HasValue( self.Target, v ) then
		
			active = true
			table.insert( self.Target, v )
		
		end
	
	end
	
	self.Active = active
	
	if active == false then
	
		self.ReActivate = true
		
		for k,v in pairs( self.Target ) do
		
			if ValidEntity( v ) then
			
				v:SetDSP( 0, false )
				self.Target[k] = nil
			
			end
			
		end
		
		if self.SoundTime < CurTime() then
			
			self.SoundTime = CurTime() + math.random( 5, 10 )
			
			self.Entity:EmitSound( table.Random( self.WeirdSounds ), 100, math.random( 130, 160 ) )
			
		end
	
	else
	
		local phys = self.Entity:GetPhysicsObject()
	
		if ValidEntity( phys ) then
	
			phys:Wake()

		end
		
		for k,v in pairs( self.Target ) do
		
			if ValidEntity( v ) and v:Alive() then
			
				local scale = 1 - math.Clamp( self.Entity:GetPos():Distance( v:GetPos() ) / self.Distance, 0, 1 ) 
				
				util.ScreenShake( v:GetPos(), scale * 5, scale * 3, 2, 100 )
			
				v:TakeDamage( 3 * scale, self.Entity )
				v:AddStamina( math.floor( -3 * scale ) )
				v:SetDSP( 39, false )
				
				if scale > 0.75 then
				
					umsg.Start( "Drunk", v )
					umsg.Short( 1 )
					umsg.End()
				
				end
			
			end
			
		end
	
	end
	
end 

function ENT:Use( ply, caller )

end
