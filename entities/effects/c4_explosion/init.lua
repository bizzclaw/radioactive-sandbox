
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	
	local emitter = ParticleEmitter( pos )
	
	for i=1,math.random(10,15) do
		
		local particle = emitter:Add( "particles/smokey", pos )

		particle:SetVelocity( Vector(math.random(-90, 90),math.random(-90, 90), math.random(-70, 70) ) )
		particle:SetDieTime( math.Rand(3,6) )
		particle:SetStartAlpha( math.Rand( 55, 115 ) )
		particle:SetStartSize( math.Rand( 20, 30 ) )
		particle:SetEndSize( math.Rand( 140, 240 ) )
		particle:SetRoll( math.Rand( -95, 95 ) )
		particle:SetRollDelta( math.Rand( -0.12, 0.12 ) )
		particle:SetColor( 10,10,10 )
		
	end
	
	for i=1, math.random(10,15) do
		
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + Vector(math.random(-40,40),math.random(-40,40),math.random(-30,50)))

		particle:SetVelocity( Vector(math.random(-150,150),math.random(-150,150),math.random(100,200)) )
		particle:SetDieTime( math.Rand(1,1.5) )
		particle:SetStartAlpha( math.Rand( 200, 240 ) )
		particle:SetStartSize( 5 )
		particle:SetEndSize( math.Rand( 90, 100 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
		particle:VelocityDecay( false )
				
	end
	
	for i=1, math.random(15,25) do
		
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + Vector(math.random(-40,40),math.random(-40,40),math.random(10,20)))

		particle:SetVelocity( Vector(math.random(-200,200),math.random(-200,200),math.random(0,60)) )
		particle:SetDieTime( math.Rand( 1, 2 ) )
		particle:SetStartAlpha( math.Rand( 200, 240 ) )
		particle:SetStartSize( 48 )
		particle:SetEndSize( math.Rand( 168, 190 ) )
		particle:SetRoll( math.Rand( 360,480 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
		particle:VelocityDecay( true )	
				
	end
	
	for i=0,math.random(5,9) do
	
		local particle = emitter:Add( "effects/fire_embers"..math.random(1,3), pos )
		particle:SetVelocity( Vector(math.random(-400,400),math.random(-400,400),math.random(300,550)) )
		particle:SetDieTime(math.Rand(2,5))
		particle:SetStartAlpha(math.random(140,220))
		particle:SetEndAlpha(50)
		particle:SetStartSize(math.random(3,4))
		particle:SetEndSize(0)
		particle:SetRoll(math.random(-200,200))
		particle:SetRollDelta( math.random( -1, 1 ) )
		particle:SetColor(255, 220, 100)
		particle:SetGravity(Vector(0,0,-520)) //-600 is normal
		particle:SetCollide(true)
		particle:SetBounce(0.45) 
		
	end
	
	for i=1, 5 do
	
		local particle = emitter:Add( "particle/particle_smokegrenade", pos )
		
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		
		if i % 2 == 1 then
			particle:SetVelocity( Vector( math.random(-100,100), math.random(-100,100), math.random(0,50) ) )
			particle:SetStartSize( math.Rand( 50, 100 ) )
			particle:SetEndSize( math.Rand( 250, 500 ) )
		else
			particle:SetVelocity( Vector( math.random(-200,200), math.random(-200,200), 0 ) )
			particle:SetStartSize( math.Rand( 50, 100 ) )
			particle:SetEndSize( math.Rand( 200, 400 ) )
		end
		
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		
		local dark = math.random( 10, 50 )
		particle:SetColor( dark, dark, dark )
		
		if math.random(1,4) != 1 then
			
			local vec = Vector( math.Rand(-8,8), math.Rand(-8,8), math.Rand(8,12) )
			local particle = emitter:Add( "effects/fire_cloud2", pos + vec * 10 )

			particle:SetVelocity( vec * 80 )
			particle:SetDieTime( 1.0 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 100 )
			particle:SetStartSize( 8 )
			particle:SetEndSize( 0 )
			particle:SetColor( math.random( 150, 255 ), math.random( 100, 150 ), 100 )
			
			particle:SetGravity( Vector( 0, 0, math.random( -700, -500 ) ) )
			particle:SetAirResistance( math.random( 20, 60 ) )
			particle:SetCollide( true )

			particle:SetLifeTime( 0 )
			particle:SetThinkFunction( CloudThink )
			particle:SetNextThink( CurTime() + 0.1 )
			
		end
		
	end
	
	emitter:Finish()
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = pos
		dlight.r = 250
		dlight.g = 200
		dlight.b = 50
		dlight.Brightness = math.Rand( 4, 8 )
		dlight.Decay = 1024
		dlight.size = 1024
		dlight.DieTime = CurTime() + 5
		
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end

function CloudThink( part )

	part:SetNextThink( CurTime() + 0.12 )

	local scale = 1 - part:GetLifeTime()
	local pos = part:GetPos()
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "particle/particle_smokegrenade", pos  )
	
	particle:SetVelocity( VectorRand() * 3 + ( WindVector * ( 3 * ( 1 - scale ) ) ) )
	particle:SetDieTime( math.Rand( 2.0, 3.0 ) + scale * 1.0 )
	particle:SetStartAlpha( math.random( 100, 150 ) )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 1, 3 ) + scale * math.random( 20, 50 ) )
	particle:SetEndSize( math.random( 1, 5 ) + scale * math.random( 30, 50 ) )
	
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
	
	local dark = math.random( 10, 50 )
	particle:SetColor( dark, dark, dark )
	
	emitter:Finish()

end
