
include('shared.lua')

ENT.Size = 15

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	self.Timer = 0
	self.Trip = 0
	self.Alpha = 0
	self.Mod = {}
	
	self.Mod[ "$pp_colour_addr" ] = 2
	self.Mod[ "$pp_colour_addg" ] = 2
	self.Mod[ "$pp_colour_addb" ] = 2
	self.Mod[ "$pp_colour_colour" ] = 2
	self.Mod[ "$pp_colour_mulr" ] = 2
	self.Mod[ "$pp_colour_mulg" ] = 2
	self.Mod[ "$pp_colour_mulb" ] = 2
	self.Mod[ "$pp_colour_brightness" ] = 0
	self.Mod[ "$pp_colour_contrast" ] = 0
	
	self.Sharp = 1
	self.Blur = 1

end

function ENT:Think()

	if self.Timer < CurTime() then
	
		self.Timer = CurTime() + math.Rand( 0.5, 1.5 )
	
		local vec = VectorRand()
		vec.z = math.Rand( -0.25, 0.25 )
	
		local newpos = self.Entity:GetPos() + vec * 150
	
		local particle = self.Emitter:Add( "sprites/light_glow02_add", newpos )
		particle:SetVelocity( Vector(0,0,-50) )
		particle:SetColor( math.random(1,255), math.random(1,255), math.random(1,255) )
		particle:SetDieTime( 1.5 )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 1 )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -30, 30 ) )
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, math.random( -50, -25 ) ) )
		
		if LocalPlayer():GetPos():Distance( self.Entity:GetPos() ) < 400 then
		
			if math.random( 1, 10 ) == 1 then
			
				Drunkness = Drunkness + math.random(1,3)
			
			end
			
			self.Blur = math.Rand( -1, 4 )
			self.Sharp = math.Rand( -1, 8 )
			
			for k,v in pairs( self.Mod ) do
			
				self.Mod[ k ] = math.Rand( -2, 2 )
				
				if k == "$pp_colour_brightness" or k == "$pp_colour_contrast" then
				
					if math.random( 1, 5 ) == 1 then
					
						self.Mod[ k ] = math.Rand( 0, 1 )
						
					else
					
						self.Mod[ k ] = 1
					
					end
				
				end
			
			end
	
		end
	
	end
	
	if self.Trip < CurTime() then
	
		self.Trip = CurTime() + 0.1
	
		if LocalPlayer():GetPos():Distance( self.Entity:GetPos() ) < 400 then
		
			MotionBlur = math.Approach( MotionBlur, self.Blur, FrameTime() * 2 )
			Sharpen = math.Approach( Sharpen, self.Sharp, FrameTime() * 2 )
		
			for k,v in pairs( self.Mod ) do
			
				ColorModify[ k ] = math.Approach( ColorModify[ k ], v, FrameTime() )
			
			end
		
		end
	
	end

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
	
	end

end

function ENT:Draw()
	
end

