
local matRefraction	= Material( "radbox/refract_ring" )

function EFFECT:Init( data )

	self.Entity:SetRenderBounds( Vector() * -2048, Vector() * 2048 )
	
	self.Pos = data:GetOrigin()
	self.Emitter = ParticleEmitter( self.Pos )
	self.Size = 50
	self.Refract = 0
	self.DieTime = CurTime() + 0.5
	
	for i=1, 50 do
	
		local particle = self.Emitter:Add( "effects/fleck_cement" .. math.random(1,2), self.Pos )
		particle:SetVelocity( VectorRand() * 1000 )
		particle:SetDieTime( 2.5 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 5, 10 ) )
		particle:SetEndSize( 1 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetColor( 100, 100, 100 )
		
	end
	
	local particle = self.Emitter:Add( "effects/strider_muzzle", self.Pos )
	particle:SetVelocity( Vector( 0, 0, 0 ) )
	particle:SetDieTime( 1.5 )
	particle:SetStartAlpha( 0 )
	particle:SetEndAlpha( 200 )
	particle:SetStartSize( 2000 )
	particle:SetEndSize( 0 )
	particle:SetRoll( math.random( -360, 360 ) )
	particle:SetRollDelta( math.random( -200, 200 ) )
	particle:SetColor( 200, 200, 255 )
	
	self.Emitter:Finish()
	
end

function EFFECT:Think( )

	self.Refract = self.Refract + 1.5 * FrameTime()
	self.Size = self.Refract * 10000

	if self.DieTime < CurTime() then
	
		self.Emitter:Finish()
		return false
	
	end
	
	return true
	
end

function EFFECT:Render()

	matRefraction:SetMaterialFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.1 )
	
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawQuadEasy( self.Pos + Vector(0,0,1),
					 Vector(0,0,1),
					 self.Size, self.Size,
					 Color( 255, 255, 255, 255 ) )

end
