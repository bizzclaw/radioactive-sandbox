
include('shared.lua')

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	self.Timer = 0

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
		
	end

end

function ENT:Think()

	if self.Timer < CurTime() then

		local particle = self.Emitter:Add( "sprites/light_glow02_add", self.Entity:LocalToWorld( self.Entity:OBBCenter() ) + VectorRand() * 30 )
		
		particle:SetVelocity( Vector(0,0,-10) ) 
		particle:SetLifeTime( 0 )  
		particle:SetDieTime( math.Rand( 0.50, 0.75 ) ) 
		particle:SetStartAlpha( math.random( 50, 100 ) ) 
		particle:SetEndAlpha( 0 ) 
		particle:SetStartSize( math.random( 5, 10 ) ) 
		particle:SetEndSize( 1 ) 
		particle:SetColor( 200, 200, math.random( 200, 250 ) )
		particle:SetAirResistance( 50 )
		
		self.Timer = CurTime() + math.Rand( 0, 2 )

	end
	
end

function ENT:Draw()

	self.Entity:DrawModel()

end

