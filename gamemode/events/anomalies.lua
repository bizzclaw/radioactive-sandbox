
local EVENT = {}

EVENT.Types = { "anomaly_whiplash", "anomaly_electro", "anomaly_vortex", "anomaly_warp" }
EVENT.MaxAnomalies = 25

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
			
			local num = #ents.FindByClass( "anomaly*" )
			
			for c,d in pairs( ents.FindByClass( "anomaly*" ) ) do
				
				local dist = 90000
				
				for h,g in pairs( player.GetAll() ) do
					
					if g:GetPos():Distance( d:GetPos() ) < dist then
						
						dist = g:GetPos():Distance( d:GetPos() )
						
					end
					
				end
					
				if dist > 700 then  // take out anomalies that players arent close to
					
					d:Remove()
					num = num - 1
					
				end
				
			end
			
			for i=1, self.MaxAnomalies - num do
			
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
			
			end
			
			GAMEMODE:SetEvent()
			
			return
		
		end
	
	end
	
end

function EVENT:SpawnAnomaly( pos )

	local enttype = table.Random( self.Types )
	
	if enttype == "anomaly_electro" and math.random(1,3) == 1 then
	
		local spot = table.Random( ents.FindByClass( "info_lootspawn" ) )
		
		local rand = VectorRand() * 90000
		rand.z = -5
		
		local trace = {}
		trace.start = spot:GetPos()
		trace.endpos = trace.start + rand
		
		local tr = util.TraceLine( trace )
		
		local ent = ents.Create( enttype )
		ent:SetPos( tr.HitPos + Vector( 0, 0, 5 ) )
		ent:Spawn()
	
	else

		local ent = ents.Create( enttype )
		ent:SetPos( pos + Vector( 0, 0, 5 ) )
		ent:Spawn()
		
	end

end
	
function EVENT:CheckPos( pos )

	local tbl = player.GetAll()
	tbl = table.Add( tbl, ents.FindByClass( "anomaly*" ) )

	for k,v in pairs( tbl ) do
	
		if v:GetPos():Distance( pos ) < 600 then
		
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
		
			v:Notify( "New anomalies have been sighted in the area, be careful." )
		
		end
	
	end

end

event.Register( EVENT )
