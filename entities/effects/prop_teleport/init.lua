
function EFFECT:Init( data )

	local low = data:GetOrigin()
	local high = data:GetStart()
	local num = data:GetMagnitude()
	num = math.Clamp( num * 5, 50, 300 )
		
	local emitter = ParticleEmitter( low )
	
	for i=0, num do
	
		local pos = Vector( math.Rand( low.x, high.x ), math.Rand( low.y, high.y ), math.Rand( low.z, high.z ) )
			
		local particle = emitter:Add( "effects/yellowflare", pos )
		particle:SetVelocity( Vector(0,0,0) )
		particle:SetColor( Color(150, 0, 255) )
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 3, 6 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -50, 50 ) )
		
		particle:SetAirResistance( math.random( 50, 100 ) )
		particle:SetGravity( Vector( 0, 0, math.random( -100, -50 ) ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.5 )
		
	end
	
	if IsValid(emitter) then
		emitter:Finish()
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 150
		dlight.g = 0
		dlight.b = 255
		dlight.Brightness = 4
		dlight.Decay = 2048
		dlight.size = 1024
		dlight.DieTime = CurTime() + 2
		
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end
