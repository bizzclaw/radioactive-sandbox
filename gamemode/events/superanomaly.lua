
local EVENT = {}

EVENT.Types = { "biganomaly_vortex" }

function EVENT:Start()

	for k,v in pairs( ents.FindByClass( "info_lootspawn" ) ) do
	
		local trace = {}
		trace.start = v:GetPos()
		trace.endpos = trace.start + Vector(0,0,90000)
		trace.filter = v
		
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
			
			local max = Vector( ltr.HitPos.x, ntr.HitPos.y, tr.HitPos.z - 5 )
			local min = Vector( rtr.HitPos.x, str.HitPos.y, tr.HitPos.z - 5 )
			
			local occ = true
			local pos = Vector(0,0,0)
			
			while occ do
				
				local trace = {}
				trace.start = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z )
				trace.endpos = Vector( math.random( min.x, max.x ), math.random( min.y, max.y ), min.z - 90000 )
				
				local tr = util.TraceLine( trace )
				
				occ = self:CheckPos( tr.HitPos )
				pos = tr.HitPos
				
			end
				
			self:SpawnAnomaly( pos )
			
			GAMEMODE:SetEvent()
			
			return
		
		end
	
	end
	
end

function EVENT:SpawnAnomaly( pos )

	local ent = ents.Create( table.Random( self.Types ) )
	ent:SetPos( pos + Vector( 0, 0, 5 ) )
	ent:Spawn()

end
	
function EVENT:CheckPos( pos )

	local tbl = player.GetAll()
	tbl = table.Add( tbl, ents.FindByClass( "anomaly*" ) )

	for k,v in pairs( tbl ) do
	
		if v:GetPos():Distance( pos ) < 500 then
		
			return true
		
		end
	
	end
	
	return false

end
	
function EVENT:Think()

end

function EVENT:EndThink()

end

function EVENT:End()

	for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != TEAM_UNASSIGNED then
		
			v:Notify( "A strange anomaly has formed near your position, stay alert." )
		
		end
	
	end

end

event.Register( EVENT )
