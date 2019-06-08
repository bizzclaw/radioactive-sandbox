
include('shared.lua')

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	
	self.NextPart = 0

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
		
	end

end

function ENT:Think()

	if self.NextPart < CurTime() then
	
		self.NextPart = CurTime() + 0.5

		local particle = self.Emitter:Add( "effects/spark", self.Entity:GetPos() + VectorRand() * 5 )
		particle:SetVelocity( Vector(0,0,0) )
		particle:SetColor( Color(200, 200, 255) )
		particle:SetDieTime( 0.5 )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 1.0, 2.0 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -30, 30 ) )
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, math.random( 25, 50 ) ) )
		
	end

end

function ENT:Draw()

	self.Entity:DrawModel()

end

