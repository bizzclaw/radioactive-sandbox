AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self.Entity:DrawShadow( false )
	
	self.Active = true
	self.Radius = 500
	self.SoundRadius = 800
	self.Pos = self.Entity:GetPos()
	
end

function ENT:SetActive( bool )

	self.Active = bool

end

function ENT:IsActive()

	return self.Active

end

function ENT:KeyValue( key, value )

	if key == "radius" then
	
		self.Radius = math.Clamp( tonumber( value ), 100, 5000 )
		self.SoundRadius = self.Radius * 1.4
	
	elseif key == "randomradius" then
	
		self.Radius = math.random( 100, math.Clamp( tonumber( value ), 500, 5000 ) )
		self.SoundRadius = self.Radius * 1.4
	
	end

end

function ENT:GetRadiationRadius()

	return self.Radius

end

function ENT:Think()

	if not self.Active then return end
	
	for k,v in pairs( player.GetAll() ) do
	
		local dist = v:GetPos():Distance( self.Pos )
		
		if dist < self.SoundRadius then
		
			if dist < self.Radius then
		
				if ( v.RadAddTime or 0 ) < CurTime() then
			
					v.RadAddTime = CurTime() + 5
					v:AddRadiation( 1 )
					
				end
		
			end
		
			if ( v.NextRadSound or 0 ) < CurTime() then
			
				local scale = math.Clamp( dist / self.Radius, 0.1, 1.0 )
			
				v.NextRadSound = CurTime() + scale * 1.25
				
				if v:GetRadiation() < 3 then
				
					v:EmitSound( "Geiger.BeepLow", 100, math.random( 90, 110 ) )
				
				else
				
					v:EmitSound( "Geiger.BeepHigh", 100, math.random( 90, 110 ) )
				
				end
			
			end
		
		end
	
	end
	
end
