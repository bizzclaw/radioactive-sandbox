
ENT.Type 			= "point"
ENT.Base 			= "base_point"

ENT.Min = Vector(0,0,0)
ENT.Max = Vector(0,0,0)

function ENT:Initialize()
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,90000)
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	if tr.HitSky then 
		
		local left = {}
		left.start = tr.HitPos
		left.endpos = left.start + Vector( 90000, 0, 0 )
		
		local right = {}
		right.start = tr.HitPos
		right.endpos = right.start + Vector( -90000, 0, 0 )
		
		local ltr = util.TraceLine( left )
		local rtr = util.TraceLine( right )
		
		local north = {}
		north.start = ltr.HitPos
		north.endpos = north.start + Vector( 0, 90000, 0 )
		
		local south = {}
		south.start = rtr.HitPos
		south.endpos = south.start + Vector( 0, -90000, 0 )
		
		local ntr = util.TraceLine( north )
		local str = util.TraceLine( south )
		
		self.Max = Vector( ltr.HitPos.x, ntr.HitPos.y, tr.HitPos.z - 5 )
		self.Min = Vector( rtr.HitPos.x, str.HitPos.y, tr.HitPos.z - 5 )
		
	end
	
end

function ENT:GetBounds()

	return self.Min, self.Max

end
