
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
	self.Distance = 700
	self.SoundTime = 0

end

function ENT:PhysicsSimulate( phys, delta )

	if not self.Active then return SIM_NOTHING end
	
	if self.ReActivate then
	
		self.ReActivate = false
		
		phys:ApplyForceCenter( VectorRand() * 50 )
	
	end
	
	if ValidEntity( self.Target ) then
	
		local vel = ( self.Target:GetPos() - self.Entity:GetPos() ):Normalize()
		
		phys:ApplyForceCenter( vel * 50 )
	
	end

end

function ENT:Think() 

	local active = false

	for k,v in pairs( player.GetAll() ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < self.Distance then
		
			active = true
			self.Target = v
		
		end
	
	end
	
	self.Active = active
	
	if active == false then
	
		self.ReActivate = true
		
		if ValidEntity( self.Target ) then
		
			self.Target:SetDSP( 0, false )
			self.Target = nil
		
		end
		
		if self.SoundTime < CurTime() then
			
			self.SoundTime = CurTime() + 5
			
			self.Entity:EmitSound( table.Random( self.WeirdSounds ), 100, math.random( 150, 180 ) )
			
		end
	
	else
	
		local phys = self.Entity:GetPhysicsObject()
	
		if ValidEntity( phys ) then
	
			phys:Wake()

		end
		
		if ValidEntity( self.Target ) and self.Target:Alive() then
		
			local scale = 1 - math.Clamp( self.Entity:GetPos():Distance( self.Target:GetPos() ) / self.Distance, 0, 1 ) 
			
			util.ScreenShake( self.Target:GetPos(), scale * 5, scale * 3, 2, 100 )
		
			self.Target:TakeDamage( 3 * scale, self.Entity )
			self.Target:AddStamina( math.floor( -3 * scale ) )
			self.Target:SetDSP( 39, false )
			
			if scale > 0.75 then
			
				umsg.Start( "Drunk", self.Target )
				umsg.Short( 1 )
				umsg.End()
			
			end
		
		end
	
	end
	
end 

function ENT:Use( ply, caller )

end
