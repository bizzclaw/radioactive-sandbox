
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter( pos )
	
	for i=1, 15 do
	
		local newpos = pos + VectorRand() * 15
	
		local particle = emitter:Add( "effects/spark", newpos )
		particle:SetVelocity( ( newpos - pos ):GetNormal() * 50 )
		particle:SetColor( Color(200, 200, 255) )
		particle:SetDieTime( 1.5 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 1, 3 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -30, 30 ) )
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, math.random( -50, 50 ) ) )
		
	end
	
	local particle = emitter:Add( "effects/yellowflare", pos )
	particle:SetVelocity( Vector(0,0,0) )
	particle:SetColor( Color(200, 200, 255) )
	particle:SetDieTime( 2.0 )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.Rand( 60, 80 ) )
	particle:SetEndSize( 0 )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetRollDelta( math.Rand( -5, 5 ) )
	
	if IsValid(emitter) then
		emitter:Finish()
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 200
		dlight.g = 200
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
