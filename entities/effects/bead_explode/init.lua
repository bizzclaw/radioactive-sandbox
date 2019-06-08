
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "sprites/light_glow02_add", pos )
	particle:SetColor( Color(255, 255, 255) )
	particle:SetDieTime( math.Rand( 1.0, 2.0 ) )
	particle:SetStartAlpha( 150 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 80 )
	particle:SetEndSize( 0 )
	
	for i=1, 60 do
	
		local vec = VectorRand()
	
		local particle = emitter:Add( "sprites/light_glow02_add", pos )
		particle:SetVelocity( vec * 250 )
		particle:SetAngles( vec:Angle() )
		particle:SetColor( Color(255, 255, 255) )
		particle:SetDieTime( math.Rand( 1.0, 2.0 ) )
		particle:SetStartAlpha( 150 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 4, 8 ) )
		particle:SetEndSize( 0 )
		particle:SetEndLength( math.random( 50, 100 ) )
		particle:SetRoll( 0 )
		particle:SetAirResistance( 0 )
		particle:SetCollide( true )
		particle:SetBounce( math.Rand( 0.5, 1.0 ) )
		
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
		
		dlight.Pos = pos
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 5
		dlight.Decay = 1024
		dlight.size = 1024
		dlight.DieTime = CurTime() + 2
		
	end
	
	if emitter then
	
		emitter:Finish()
	
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end
