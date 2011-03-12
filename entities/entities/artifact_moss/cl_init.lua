
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
	
		self.NextPart = CurTime() + 1.5

		local particle = self.Emitter:Add( "particle/particle_smokegrenade", self.Entity:GetPos() + VectorRand() * 5 )
		particle:SetColor( 150, 150, 100 )
		particle:SetDieTime( 0.5 )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 5, 10 ) )
		particle:SetEndSize( math.Rand( 3, 6 ) )
		
	end

end

function ENT:Draw()

	self.Entity:DrawModel()

end

