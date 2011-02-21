
function ENT:Initialize()

	self.Center = self.Entity:OBBCenter()
	self.SoundRadius = self.Entity:OBBMaxs():Distance( self.Entity:OBBMins() ) + 300
	self.Active = math.Rand(0,1) > 0.5
	self.Table = {}
	
end

function ENT:PassesTriggerFilters( ent )

	return ValidEntity( ent ) and ent:IsPlayer()
	
end

function ENT:SetActive( bool )

	self.Active = bool

end

function ENT:IsActive()

	return self.Active

end

function ENT:KeyValue( key, value )

end

function ENT:StartTouch( ent )

	if self.Entity:PassesTriggerFilters( ent ) and not table.HasValue( self.Table, ent ) then
	
		table.insert( self.Table, ent )
	
	end

end

function ENT:EndTouch( ent )

	if table.HasValue( ent ) then
	
		table.remove( self.Table, ent )
	
	end

end

function ENT:Think()

	if not self.Active then return end
	
	for k,v in pairs( player.GetAll() ) do
	
		local dist = v:GetPos():Distance( self.Center )
		
		if dist < self.SoundRadius then
		
			if table.HasValue( self.Table, v ) then
		
				if ( v.RadAddTime or 0 ) < CurTime() then
			
					v.RadAddTime = CurTime() + 5
					v:AddRadiation( 1 )
					
				end
		
			end
		
			if ( v.NextRadSound or 0 ) < CurTime() then
			
				local scale = math.Clamp( dist / self.SoundRadius, 0.1, 1.0 )
			
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
