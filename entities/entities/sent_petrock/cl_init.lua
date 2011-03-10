
include('shared.lua')

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
		
	end

end

function ENT:Think()

	local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Entity:LocalToWorld( self.Entity:OBBCenter() ) )
 	
 	particle:SetVelocity( VectorRand() * 10 ) 
 	particle:SetLifeTime( 0 )  
 	particle:SetDieTime( math.Rand( 0.25, 0.50 ) ) 
 	particle:SetStartAlpha( 20 ) 
 	particle:SetEndAlpha( 0 ) 
 	particle:SetStartSize( math.random( 5, 10 ) ) 
 	particle:SetEndSize( 0 ) 
 	particle:SetColor( 100, math.random( 100, 150 ), math.random( 150, 250 ) )
	particle:SetAirResistance( 50 )

end

function ENT:Draw()

	self.Entity:DrawModel()

end

