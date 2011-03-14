
local EVENT = {}

EVENT.Types = { "anomaly_whiplash", 
				"anomaly_electro", 
				"anomaly_vortex", 
				"anomaly_warp", 
				"anomaly_hoverstone", 
				"anomaly_stormpearl", 
				"anomaly_cooker" }

function EVENT:Start()
	
	local num = #ents.FindByClass( "anomaly*" )
	
	for c,d in pairs( ents.FindByClass( "anomaly*" ) ) do
	
		local dist = 90000
		
		for k,v in pairs( player.GetAll() ) do
			
			if v:GetPos():Distance( d:GetPos() ) < dist then
				
				dist = v:GetPos():Distance( d:GetPos() )
				
			end
			
		end
		
		if dist > 700 then  // take out anomalies that players arent close to
			
			d:Remove()
			num = num - 1
			
		end
		
	end
	
	for i=1, GetConVar( "sv_radbox_max_anomalies" ):GetInt() - num do

		self:SpawnAnomaly( GAMEMODE:GetRandomSpawnPos() )
		
	end
	
	GAMEMODE:SetEvent()
	
end

function EVENT:SpawnAnomaly( pos )

	local enttype = table.Random( self.Types )
	
	if ( enttype == "anomaly_electro" or enttype == "anomaly_deathpearl" ) and math.random(1,3) == 1 then
	
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
	
	elseif enttype == "anomaly_hoverstone" then
	
		for i=1, math.random(1,3) do

			local ent = ents.Create( enttype )
			ent:SetPos( pos + Vector( 0, 0, 100 ) + VectorRand() * 50 )
			ent:Spawn()

		end
			
	elseif enttype == "anomaly_cooker" then
	
		local ent = ents.Create( enttype )
		ent:SetPos( pos + Vector( 0, 0, 5 ) )
		ent:Spawn()
	
		for i=1, math.random(1,3) do
		
			local count = 0		
			local rand = VectorRand() * 500
			rand.z = -50
		
			local trace = {}
			trace.start = pos + Vector(0,0,100)
			trace.endpos = trace.start + rand
			
			local tr = util.TraceLine( trace )
			
			while count < 50 and ( tr.HitPos:Distance( pos ) < 150 or not tr.Hit ) do
			
				rand = VectorRand() * 800
				rand.z = math.random( -50, -10 )
		
				trace = {}
				trace.start = pos + Vector(0,0,100)
				trace.endpos = trace.start + rand
			
				tr = util.TraceLine( trace )
				
				count = count + 1
			
			end
			
			if count < 50 then

				local ent = ents.Create( enttype )
				ent:SetPos( tr.HitPos + Vector( 0, 0, 5 ) )
				ent:Spawn()
				
			end

		end
	
	else

		local ent = ents.Create( enttype )
		ent:SetPos( pos + Vector( 0, 0, 5 ) )
		ent:Spawn()
		
	end

end
	
function EVENT:CheckPos( pos )

	local tbl = player.GetAll()
	tbl = table.Add( tbl, ents.FindByClass( "anomaly*" ) )
	tbl = table.Add( tbl, ents.FindByClass( "info_player*" ) )
	tbl = table.Add( tbl, ents.FindByClass( "npc_trader*" ) )

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
