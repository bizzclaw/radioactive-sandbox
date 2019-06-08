
local EVENT = {}

EVENT.Types = { "biganomaly_vortex", "biganomaly_deathfog" }

EVENT.Notify = {}
EVENT.Notify[ "biganomaly_vortex" ] = "An unusually large Vortex anomaly has been sighted in the area. Stay alert."
EVENT.Notify[ "biganomaly_deathfog" ] = "A Death Fog anomaly has been sighted in the area. Be careful."

EVENT.Alert = {}
EVENT.Alert[ "biganomaly_vortex" ] = "A large Vortex anomaly has formed near your position! Get out of there now!"
EVENT.Alert[ "biganomaly_deathfog" ] = "A Death Fog anomaly has formed above your position! Get indoors now or put on a respirator!"

EVENT.MaxDist = {}
EVENT.MaxDist[ "biganomaly_vortex" ] = 3000
EVENT.MaxDist[ "biganomaly_deathfog" ] = 2500

function EVENT:GetSpawnPos()

	if #ents.FindByClass( "point_skymarker" ) > 0 then
	
		local marker = table.Random( ents.FindByClass( "point_skymarker" ) )
		local min, max = marker:GetBounds()
		
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
		
		return pos
	
	else
	
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
				
				return pos
				
			end
			
		end
	
	end

end

function EVENT:Start()
	
	self:SpawnAnomaly( GAMEMODE:GetRandomSpawnPos() )
	
	GAMEMODE:SetEvent()
	
end

function EVENT:SpawnAnomaly( pos )

	local enttype = table.Random( self.Types )
	
	if enttype == "biganomaly_deathfog" then
	
		local ent = ents.Create( enttype )
		ent:SetPos( pos + Vector( 0, 0, 600 ) )
		ent:Spawn()
	
	else

		local ent = ents.Create( enttype )
		ent:SetPos( pos + Vector( 0, 0, 5 ) )
		ent:Spawn()
		
	end
	
	self.Ent = enttype
	self.EntPos = pos

end
	
function EVENT:CheckPos( pos )

	local tbl = ents.FindByClass( "info_player*" )
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
		
			if v:GetPos():Distance( self.EntPos ) < self.MaxDist[ self.Ent ] then
		
				v:Notify( self.Alert[ self.Ent ] )
				
			else
			
				v:Notify( self.Notify[ self.Ent ] )
			
			end
		
		end
	
	end

end

event.Register( EVENT )
