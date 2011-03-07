
local DAYCYCLE = {}

if CLIENT then

	DayColor = {}
	DayColor[ "$pp_colour_addr" ] = 0
	DayColor[ "$pp_colour_addg" ] = 0
	DayColor[ "$pp_colour_addb" ] = 0
	DayColor[ "$pp_colour_brightness" ] = 0
	DayColor[ "$pp_colour_contrast" ] = 0
	DayColor[ "$pp_colour_colour" ] = 0
	DayColor[ "$pp_colour_mulr" ] = 0
	DayColor[ "$pp_colour_mulg" ] = 0
	DayColor[ "$pp_colour_mulb" ] = 0

	hook.Add( "Initialize", "DAYCYCLE.Initialize",
	
		function()
		
			DAYCYCLE.NextTimeThink = 0
			DAYCYCLE.LastColor = nil
			
		end
		
	)

	hook.Add( "Think", "DAYCYCLE.Think",
	
			function()
			
				if !GetConVar( "sv_radbox_daycycle" ):GetBool() then return end
				
				if GetGlobalBool( "Initialized" ) == false then return end
				
				if DAYCYCLE.NextTimeThink > CurTime() then return end

				DAYCYCLE.NextTimeThink = CurTime() + 0.25
				
				if GetGlobalString( "DAYCYCLE:SkyName" ) == "" then return end
				
				if DAYCYCLE.Materials == nil then
				
					local skyname = GetGlobalString( "DAYCYCLE:SkyName" )
				
					DAYCYCLE.Materials = {}
					DAYCYCLE.Materials[1] = Material("skybox/" .. skyname .. "up")
					DAYCYCLE.Materials[2] = Material("skybox/" .. skyname .. "dn")
					DAYCYCLE.Materials[3] = Material("skybox/" .. skyname .. "lf")
					DAYCYCLE.Materials[4] = Material("skybox/" .. skyname .. "rt")
					DAYCYCLE.Materials[5] = Material("skybox/" .. skyname .. "bk")
					DAYCYCLE.Materials[6] = Material("skybox/" .. skyname .. "ft")
					
				end
				
				local col = GetGlobalVector( "DAYCYCLE:SkyMod" )
				local bright = GetGlobalFloat( "DAYCYCLE:SkyBrightness" )
				local cont = GetGlobalFloat( "DAYCYCLE:SkyContrast" )
				
				DayColor[ "$pp_colour_brightness" ] = bright
				DayColor[ "$pp_colour_contrast" ] = cont
				DayColor[ "$pp_colour_mulr" ] = tonumber( col.x / 5 )
				DayColor[ "$pp_colour_mulg" ] = tonumber( col.y / 5 )
				DayColor[ "$pp_colour_mulb" ] = tonumber( col.z / 5 )
				
				if col != DAYCYCLE.LastColor then
				
					if not DAYCYCLE.LastColor then
					
						DAYCYCLE.LastColor = col
					
					end
				
					DAYCYCLE.LastColor.r = math.Approach( DAYCYCLE.LastColor.r, col.r, 0.01 )
					DAYCYCLE.LastColor.g = math.Approach( DAYCYCLE.LastColor.g, col.g, 0.01 )
					DAYCYCLE.LastColor.b = math.Approach( DAYCYCLE.LastColor.b, col.b, 0.01 )
				
					for k,v in pairs( DAYCYCLE.Materials ) do
					
						v:SetMaterialVector( "$color", DAYCYCLE.LastColor )
						
					end
					
				end
			
			end
		)

	return
	
end

local DAY_LENGTH	= 60 * 24
local MORNING		= DAY_LENGTH / 4 
local EVENING		= MORNING * 3
local MIDDAY		= DAY_LENGTH / 2
local MORNING_START	= MORNING - 144
local MORNING_END	= MORNING + 144
local EVENING_START	= EVENING - 144
local EVENING_END	= EVENING + 144
local DAY_START		= 5 * 60
local DAY_END		= 18.5 * 60

function DAYCYCLE.SetSunTime( minute )

	local tbl = DAYCYCLE.LightTable[minute]
	
	if DAYCYCLE.ShadowControl then
	
		DAYCYCLE.ShadowControl:Fire( "SetDistance", tbl.ShadowLength , 0 )
		DAYCYCLE.ShadowControl:Fire( "direction", tbl.ShadowAngle , 0 )
		DAYCYCLE.ShadowControl:Fire( "color", tbl.ShadowColor, 0 )
		
	end
	
	if DAYCYCLE.Sun then
	
		DAYCYCLE.Sun:Fire( "addoutput", tbl.SunAngle , 0 )
		DAYCYCLE.Sun:Activate()
		
	end
	
	if DAYCYCLE.FogControl then
	
		DAYCYCLE.FogControl:Fire( "setcolor", tbl.FogColor * DAYCYCLE.FogDefault.r .. " " .. tbl.FogColor * DAYCYCLE.FogDefault.g .. " " .. tbl.FogColor * DAYCYCLE.FogDefault.b )
	
	end
	
	SetGlobalVector( "DAYCYCLE:SkyMod", tbl.SkyColor )
	SetGlobalFloat( "DAYCYCLE:SkyContrast", tbl.SkyContrast )
	SetGlobalFloat( "DAYCYCLE:SkyBrightness", tbl.SkyBrightness )
	
end

function DAYCYCLE.CalculateTimeColor( dayminute )

	local red = 1
	local blue = 1
	local green = 1
	local brightness = 0
	local contrast = 0
	local fog = 0
	
	// sunrise
	if dayminute >= 1 and dayminute < MORNING_END then
		
		if dayminute < MORNING_START then // first

			red = 0.25
			green = 0.25
			blue = 0.35
			
			brightness = -0.07
			contrast = -0.3
			fog = -0.5
			
		else // second
		
			local frac = ( dayminute - MORNING_START ) / ( MORNING_END - MORNING_START )

			red = math.Clamp( frac * 1.5, 0, 0.25 )
			green = math.Clamp( frac * 1.2, 0, 0.25 )
			blue = math.Clamp( frac, 0, 0.35 )
			
			brightness = -0.07 + frac * 0.1
			contrast = -0.3 + frac * 0.5 
			fog = -0.5 + frac * 0.5

		end
		
	end
	
	// dusk
	if dayminute > EVENING_START and dayminute <= DAY_LENGTH then
	
		local frac = 1 - ( ( dayminute - EVENING_START ) / ( EVENING_END - EVENING_START ) )
		
		if dayminute > EVENING_END then // last
		
			red = 0.25
			green = 0.25
			blue = 0.35
			
			brightness = -0.07
			contrast = -0.3
			fog = -0.5
			
		else // second last
		
			red = math.Clamp( frac, 0, 0.25 )
			green = math.Clamp( frac * 0.7, 0, 0.25 )
			blue = math.Clamp( frac * 0.8, 0, 0.35 )
			
			brightness = -0.07 + frac * 0.1
			contrast = -0.3 + frac * 0.5 
			fog = -0.5 + frac * 0.5

		end
		
	end

	red = math.Clamp( red, 0, 1 )
	blue = math.Clamp( blue, 0, 1 )
	green = math.Clamp( green, 0, 1 )
	brightness = math.Clamp( brightness, -1, 1 )
	contrast = math.Clamp( contrast, -1, 1 )
	fog = math.Clamp( fog, 0, 1 )

	return Vector( red, green, blue ), brightness, contrast, fog
	
end

function DAYCYCLE.CalculateShadowColor( dayminute )

	local shadowcolor = 255
	
	if dayminute > MORNING and dayminute < EVENING then
	
		local frac = 0
		
		if dayminute < MIDDAY then
		
			local a = dayminute - MORNING
			local b = MIDDAY - MORNING
			local frac = ( a / b )
			shadowcolor = math.floor( 255 - ( frac * 127 ) )
			
		else
		
			local a = dayminute - MIDDAY
			local b = EVENING - MIDDAY
			local frac = ( a / b )
			shadowcolor = math.floor( 128 + ( frac * 127 ) )
			
		end
		
	end
	
	return shadowcolor .. " " .. shadowcolor .. " " .. shadowcolor
	
end
	
function DAYCYCLE.InitLightTable()

	DAYCYCLE.LightTable = {}
	
	for n=1, DAY_LENGTH do
	
		DAYCYCLE.LightTable[n] = {}
	
		DAYCYCLE.LightTable[n].Night = math.Clamp( math.abs( ( n - MIDDAY ) / MIDDAY ) , 0 , 0.7 );
		DAYCYCLE.LightTable[n].SunAngle = (n / DAY_LENGTH) * 360
		DAYCYCLE.LightTable[n].SunAngle = DAYCYCLE.LightTable[n].SunAngle + 90
		
		if DAYCYCLE.LightTable[n].SunAngle > 360 then
		
			DAYCYCLE.LightTable[n].SunAngle = DAYCYCLE.LightTable[n].SunAngle - 360
			
		end
		
		DAYCYCLE.LightTable[n].SunAngle = "pitch " .. DAYCYCLE.LightTable[n].SunAngle
		
		DAYCYCLE.LightTable[n].ShadowLength = tostring( DAYCYCLE.LightTable[n].Night * 300 )
		DAYCYCLE.LightTable[n].ShadowAngle = math.Approach( -1 , 1 , ( MIDDAY / n ) ) .. " 0 -1"
		DAYCYCLE.LightTable[n].ShadowColor = DAYCYCLE.CalculateShadowColor( n )
		
		local col, bright, cont, fogcol = DAYCYCLE.CalculateTimeColor( n )
		
		DAYCYCLE.LightTable[n].FogColor = fogcol
		DAYCYCLE.LightTable[n].SkyColor = col
		DAYCYCLE.LightTable[n].SkyBrightness = bright
		DAYCYCLE.LightTable[n].SkyContrast = cont
		
	end
	
end

hook.Add( "EntityKeyValue", "DAYCYCLE.KeyValue",

	function( ent, key, val )
			
		if ent:GetClass() == "worldspawn" and key == "skyname" then
			
			SetGlobalString( "DAYCYCLE:SkyName", val )
				
		elseif ent:GetClass() == "env_fog_controller" then
			
			if key == "fogcolor" then
		
				local str = string.Explode( " ", val )
		
				DAYCYCLE.FogDefault = Color( tonumber( str[1] ), tonumber( str[2] ), tonumber( str[3] ) )
			
			end
		
		end
			
	end
)

hook.Add( "Initialize", "DAYCYCLE.Initialize",

	function()
	
		DAYCYCLE.InitDone = false
		DAYCYCLE.InitLightTable()
		DAYCYCLE.NextTimeThink = 0
		DAYCYCLE.DayMinute = 0
		DAYCYCLE.LastBrightness = nil
		
	end
)
	
hook.Add( "InitPostEntity", "DAYCYCLE.PostEntInit",

	function()
	
		if !GetConVar( "sv_radbox_daycycle" ):GetBool() then return end
			
		DAYCYCLE.Sun = ents.FindByClass( "env_sun" )[1] 
		DAYCYCLE.FogControl = ents.FindByClass( "env_fog_controller" )[1] 
			
		if not ValidEntity( DAYCYCLE.Sun ) then
			
			DAYCYCLE.Sun = ents.Create( "env_sun" )
			DAYCYCLE.Sun:SetKeyValue( "pitch", "90" )
			DAYCYCLE.Sun:Spawn()
			
		end
			
		DAYCYCLE.Sun:SetKeyValue( "material", "sprites/light_glow02_add_noz.vmt" )
		DAYCYCLE.Sun:SetKeyValue( "overlaymaterial", "sprites/light_glow02_add_noz.vmt" )
			
		DAYCYCLE.ShadowControl = ents.FindByClass( "shadow_control" )[1]
			
		if not ValidEntity( DAYCYCLE.ShadowControl ) then
			
			DAYCYCLE.ShadowControl = ents.Create( "shadow_control" )
			DAYCYCLE.ShadowControl:Spawn()
			
		end
			
		DAYCYCLE.InitDone = true
		SetGlobalBool( "Initialized", true )
		
	end
)
	
hook.Add( "Think", "DAYCYCLE.Think",

	function()
		
		if !DAYCYCLE.InitDone then return end
			
		if DAYCYCLE.NextTimeThink > CurTime() then return end

		DAYCYCLE.NextTimeThink = CurTime() + GetConVar( "sv_radbox_daycycle_speed" ):GetFloat() //MINUTE_LENGTH
		DAYCYCLE.DayMinute = DAYCYCLE.DayMinute + 1
			
		if DAYCYCLE.DayMinute > DAY_LENGTH then 
			
			DAYCYCLE.DayMinute = 1 
				
		end
			
		DAYCYCLE.SetSunTime( DAYCYCLE.DayMinute )
			
	end
)
