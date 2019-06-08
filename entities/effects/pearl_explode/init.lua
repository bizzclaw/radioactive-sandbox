
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local trace = {}
	trace.start = pos
	trace.endpos = trace.start + Vector(0,0,1000)
	
	local tr = util.TraceLine( trace )
	
	self.Pos = tr.HitPos
	self.Emitter = ParticleEmitter( pos )
	
	for i=1, 25 do
	
		local vec = VectorRand()
		vec.z = math.Rand( 0, 1 )
	
		local particle = self.Emitter:Add( "sprites/light_glow02_add", pos )
		particle:SetVelocity( vec * 150 )
		particle:SetColor( Color(255, 255, 255) )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 150 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 50, 100 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( 0 )
		particle:SetAirResistance( 10 )
		
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
	
	self.Time = CurTime() + 1
	
end

function EFFECT:Think( )

	local scale = math.Clamp( 1 - ( self.Time - CurTime() ) / 2, 0, 1 )
	
	for i=1,10 do
	
		local rand = VectorRand()
		rand.z = 0
		
		local trace = {}
		trace.start = self.Pos + ( rand * scale * 1000 )
		trace.endpos = trace.start + Vector(0,0,-3000) 
	
		local tr = util.TraceLine( trace )
		
		local particle = self.Emitter:Add( "effects/spark", tr.HitPos )
		particle:SetVelocity( Vector( 0, 0, math.random( 0, 100 ) ) )
		particle:SetColor( Color(255, 255, 255) )
		particle:SetDieTime( math.Rand( 0.5, 1.5 ) )
		particle:SetStartSize( math.random( 5, 10 ) )
		particle:SetEndSize( 0 )
		particle:SetEndLength( math.random( 100, 300 ) )
		particle:SetRoll( table.Random{ -90, 90 } )
		particle:SetAirResistance( 10 )
	
	end

	if self.Time < CurTime() then
	
		if IsValid(self.Emitter) then
			self.Emitter:Finish()
		end
	
		return false
	
	end

	return true
	
end

function EFFECT:Render()

end
