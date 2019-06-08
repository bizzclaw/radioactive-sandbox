
--// Fetch artifact quest

if CLIENT then

	GM:RegisterQuest( "Locate and retrieve an artifact.", "radbox/menu_qmark" )
	
	return

end

local QUEST = {}

QUEST.ItemDesc = {}
QUEST.ItemDesc[ "models/srp/items/art_stoneblood.mdl" ] = { "This Bitter Coral artifact seems to be composed of highly corrosive compounds.",
															"When touched, it will often stimulate your immune system and heal even the most serious wounds.",
															"However, touching it too much may result in open sores and excessive bleeding." }
QUEST.ItemDesc[ "models/srp/items/art_moonlight.mdl" ] = { "This Blink artifact you brought to me is very intriguing...",
															"It has a strange energy field which envelopes anything touching it.",
															"Shaking this unstable artifact will trigger an outburst of energy.",
															"The energy exerted by this artifact will displace whatever it touches, much like a Warp anomaly." }
QUEST.ItemDesc[ "models/srp/items/art_fireball.mdl" ] = { "This Scaldstone artifact is composed of compacted orange amber among other unknown compounds.",
															"An ongoing chemical reaction inside of it seems to generate an endless amount of heat.",
															"When touched, it will often cause blood to clot. It will effectively heal even the worst cuts.",
															"However, agitating it too much may result in the artifact releasing a burst of heat." }
QUEST.ItemDesc[ "models/srp/items/art_crystalthorn.mdl" ] = { "This Porcupine artifact has a perpetual electrical field surrounding it.",
															"When agitated, it will often release a wave of energy that will rejuvinate even the most tired person.",
															"However, shaking it too much will cause it to release a dangerous surge of electricity.",
															"When stimulated it may also release hazardous doses of radiation." }
QUEST.ItemDesc[ "models/srp/items/art_urchen.mdl" ] = { "This Tainted Moss artifact is composed of compacted sediment and organic matter.",
															"There is no information on how these artifacts are formed, or what anomaly creates them.",
															"Agitating this useful artifact will often cause it to absorb all radiation in a wide radius.",
															"However, when shaken too much this artifact will release radiation as well as highly toxic vapors." }
QUEST.ItemDesc[ "models/props_phx/misc/smallcannonball.mdl" ] = { "These seemingly harmless artifacts are presumed to be the core of a Storm Pearl.",
															"Agitating this artifact will cause it to vibrate so fast that it cannot be held still.",
															"It is unwise to agitate this artifact, as it will unleeash hazardous energy once it is triggered.",
															"These artifacts are often avoided by collectors since they are so dangerous."}
QUEST.ItemDesc[ "models/props_debris/concrete_chunk05g.mdl" ] = { "This Pet Rock artifact has a gravitational field that defies modern science.",
															"When stimulated, it will temporarily spread its gravitational properties to whatever touched it.",
															"However, like the Hoverstone anomaly, these rocks can cause internal bleeding." }

QUEST.Start = function( ply )

	ply.NextArtifactThink = 0
	ply.HasMissionArtifact = false
	
	for k,v in pairs( ply:GetInventory() ) do
	
		local tbl = item.GetByID( v )
		
		if tbl.Type == ITEM_ARTIFACT then
			
			ply.HasMissionArtifact = true
			
			ply:Notify( "It seems you already have an artifact. Let me know when you're willing to part with it." )
			ply:SetRadarStaticTarget( ply:GetTeamTrader() )
			
			return
			
		end
		
	end
	
	ply:Notify( "Artifacts are known to form around certain anomalies." )
	
	if ply:Team() == TEAM_EXODUS then
	
		timer.Simple( 3, function( ply ) if ValidEntity( ply ) then ply:Notify( "I suggest that you buy a Field Detector Module for this mission." ) end end, ply )
		timer.Simple( 6, function( ply ) if ValidEntity( ply ) then ply:Notify( "Once you find an artifact, bring it to me and I will analyze its properties." ) end end, ply )
		
	else
	
		timer.Simple( 3, function( ply ) if ValidEntity( ply ) then ply:Notify( "I suggest that you get a Field Detector Module for this mission." ) end end, ply )
		timer.Simple( 6, function( ply ) if ValidEntity( ply ) then ply:Notify( "Your payment will depend on the rarity of the artifact you bring me." ) end end, ply )
	
	end
	
	
	
end

QUEST.CanStart = function( ply )

	local has = false
	local exists = #ents.FindByClass( "artifact*" ) > 0
	local anoms = ents.FindByClass( "anomaly_hoverstone" )
	anoms = table.Add( anoms, ents.FindByClass( "anomaly_stormpearl" ) )
	
	for k,v in pairs( ply:GetInventory() ) do
	
		local tbl = item.GetByID( v )
		
		if tbl.Type == ITEM_ARTIFACT then
			
			has = true
			
		end
		
	end
	
	if not exists and #anoms < 1 and not has then
	
		ply:DialogueWindow( "This mission is not currently available." )
		
		return false
	
	end

	return true

end

QUEST.Cancel = function( ply )
	
	ply:SetInQuest( false, 0 )

end

QUEST.StatusThink = function( ply )

	if ply.NextArtifactThink < CurTime() and not ply.HasMissionArtifact then
	
		ply.NextArtifactThink = CurTime() + 1
		
		for k,v in pairs( ply:GetInventory() ) do
		
			local tbl = item.GetByID( v )
		
			if tbl.Type == ITEM_ARTIFACT then
			
				ply.HasMissionArtifact = true
				
				ply:Notify( "You've found an artifact? Bring it to me as soon as possible." )
				ply:SetRadarStaticTarget( ply:GetTeamTrader() )
			
			end
		
		end
	
	end

end

QUEST.CanEnd = function( ply )

	for k,v in pairs( ply:GetInventory() ) do
	
		local tbl = item.GetByID( v )
		
		if tbl.Type == ITEM_ARTIFACT then
			
			return true
			
		end
		
	end

	return false
	
end

QUEST.Dialogue = function( ply )

	ply:DialogueWindow( "You haven't retrieved any artifacts." )

end

QUEST.End = function( ply )

	local removed = false
	local model = "models/srp/items/art_stoneblood.mdl"
	local price = 3000

	for k,v in pairs( ply:GetInventory() ) do
	
		local tbl = item.GetByID( v )
		
		if tbl.Type == ITEM_ARTIFACT and not removed then
			
			ply:RemoveFromInventory( tbl.ID )
			removed = true
			model = tbl.Model
			price = tbl.Price
			
		end
		
	end
	
	if ply:Team() == TEAM_BANDOLIERS then
	
		price = price + 1000
		
	elseif ply:Team() == TEAM_EXODUS then
	
		price = price - 200
	
	end
	
	ply:AddCash( price )
	ply:DialogueWindow( "You have earned $"..price.."." )
	
	ply:SetInQuest( false, 0 )
	ply:SetRadarStaticTarget( NULL )
	
	if ply:Team() == TEAM_EXODUS then
	
		timer.Simple( 60, function( ply ) if ValidEntity( ply ) then ply:Notify( "The artifact analysis process is nearly done." ) end end, ply )
		
		for k,v in pairs( QUEST.ItemDesc[ model ] ) do
		
			timer.Simple( 80 + k * 4, function( ply ) if ValidEntity( ply ) then ply:Notify( v ) end end, ply )
		
		end
	
	end

end

GM:RegisterQuest( QUEST )
