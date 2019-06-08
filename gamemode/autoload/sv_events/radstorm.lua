
local EVENT = {}

EVENT.StormSounds = {"ambient/atmosphere/thunder1.wav",
"ambient/atmosphere/thunder2.wav",
"ambient/atmosphere/thunder3.wav",
"ambient/atmosphere/thunder4.wav",
"ambient/atmosphere/hole_hit5.wav",
"ambient/atmosphere/city_skybeam1.wav",
"ambient/wind/wind_hit1.wav",
"ambient/wind/wind_hit2.wav",
"ambient/wind/wind_hit3.wav",
"ambient/wind/wind_med1.wav",
"ambient/wind/wind_med2.wav",
"ambient/wind/wind_moan1.wav",
"ambient/wind/wind_moan2.wav",
"ambient/wind/wind_moan4.wav",
"ambient/wind/wind_snippet3.wav",
"ambient/wind/wind_snippet4.wav",
"ambient/wind/wind_snippet5.wav",
"ambient/wind/windgust.wav",
"ambient/wind/windgust_strong.wav"}

EVENT.RadSounds = { "Geiger.BeepLow", "Geiger.BeepHigh" }

function EVENT:Start()

	for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != TEAM_UNASSIGNED then
		
			v:Notify( "A fallout storm is about to hit us hard." )
			timer.Simple( 2, function( ply ) if IsValid( ply ) then ply:Notify( "Get indoors or find shelter quickly." ) end end, v )
		
		end
	
	end

	self.Duration = math.random( 30, 60 )
	self.EndTime = CurTime() + self.Duration + 10
	self.StirTime = CurTime() + 15
	self.PlayerTime = CurTime() + 10
	self.GeigerTime = CurTime() + 10
	
end
	
function EVENT:Think()

	if self.GeigerTime < CurTime() then
	
		self.GeigerTime = CurTime() + math.Rand( 0.5, 1.0 )
		
		for k,v in pairs( player.GetAll() ) do
			
			v:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random( 80, 90 ) )
			
			umsg.Start( "RadScale", v )
			umsg.Float( math.Rand( 0.2, 0.5 ) )
			umsg.End()
		
		end
	
	end

	if self.PlayerTime < CurTime() then
	
		self.PlayerTime = CurTime() + 2
		
		for k,v in pairs( player.GetAll() ) do
	
			if not v:IsSheltered() then
		
				util.ScreenShake( v:GetPos(), 4, 3, 3, 100 )
		
				v:EmitSound( table.Random( self.StormSounds ), 100, math.random( 90, 110 ) )
				
				if math.random(1,3) == 1 then
				
					v:AddRadiation( 1 )
				
				end
				
				umsg.Start( "RadScale", v )
				umsg.Float( math.Rand( 0.5, 1.0 ) )
				umsg.End()

			end
	
		end
	
	end
	
	if self.StirTime < CurTime() then
	
		self.StirTime = CurTime() + 5
		
		if #ents.FindByClass( "point_radiation" ) < 1 then return end
	
		local rad = table.Random( ents.FindByClass( "point_radiation" ) )
		local rad2 = table.Random( ents.FindByClass( "point_radiation" ) )
		local timeout = 0
		
		while !rad:IsActive() and timeout < 50 do
		
			rad = table.Random( ents.FindByClass( "point_radiation" ) )
			timeout = timeout + 1
		
		end
		
		if timeout < 50 then
		
			rad:SetActive( false )
			timeout = 0
		
		end
		
		while rad2:IsActive() and timeout < 50 do
		
			rad2 = table.Random( ents.FindByClass( "point_radiation" ) )
			timeout = timeout + 1
		
		end
		
		if timeout < 50 then
		
			rad2:SetActive( true )
			
		end
	
	end

end

function EVENT:EndThink()

	if self.EndTime < CurTime() then
	
		GAMEMODE:SetEvent()
		
	end

end

function EVENT:End()

	for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != TEAM_UNASSIGNED then
		
			v:Notify( "It looks like the storm is finally over." )
			timer.Simple( 2, function( ply ) if IsValid( ply ) then ply:Notify( "The wind probably stirred up radiation, be careful." ) end end, v )
		
		end
	
	end

end

event.Register( EVENT )
