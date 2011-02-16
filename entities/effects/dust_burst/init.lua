
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	
	local col = render.GetSurfaceColor( pos, pos + Vector(0,0,-500) )
	
	col.r = math.Clamp( col.r + 25, 0, 255 )
	col.g = math.Clamp( col.g + 25, 0, 255 )
	col.b = math.Clamp( col.b + 25, 0, 255 )
		
	local emitter = ParticleEmitter( pos )
	
	for i=1, 20 do
	
		local vec = VectorRand()
		vec.z = math.Rand( 0, 0.25 )
	
		local particle = emitter:Add( "particle/particle_smokegrenade", pos )
		particle:SetVelocity( vec * 100 )
		particle:SetColor( col.r, col.g, col.b )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 2 )
		particle:SetEndSize( math.random( 20, 30 ) )
		particle:SetRoll( 0 )
		particle:SetAirResistance( 10 )
		
		local particle = emitter:Add( "effects/fleck_cement" .. math.random(1,2), pos )
		particle:SetVelocity( VectorRand() * 500 )
		particle:SetDieTime( 2.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 2, 4 ) )
		particle:SetEndSize( 1 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetColor( 100, 100, 100 )
		particle:SetGravity( Vector( 0, 0, -300 ) )
		
	end
	
	emitter:Finish()
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()

end
