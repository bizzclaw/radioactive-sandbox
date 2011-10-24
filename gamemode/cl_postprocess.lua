
Sharpen = 0
MotionBlur = 0
ViewWobble = 0
DisorientTime = 0

ColorModify = {}
ColorModify[ "$pp_colour_addr" ] 		= 0
ColorModify[ "$pp_colour_addg" ] 		= 0
ColorModify[ "$pp_colour_addb" ] 		= 0
ColorModify[ "$pp_colour_brightness" ] 	= 0
ColorModify[ "$pp_colour_contrast" ] 	= 1
ColorModify[ "$pp_colour_colour" ] 		= 1
ColorModify[ "$pp_colour_mulr" ] 		= 0
ColorModify[ "$pp_colour_mulg" ] 		= 0
ColorModify[ "$pp_colour_mulb" ] 		= 0

MixedColorMod = {}

function GM:RenderScreenspaceEffects()

	local approach = FrameTime() * 0.05

	if ( Sharpen > 0 ) then
	
		DrawSharpen( Sharpen, 0.5 )
		
		Sharpen = math.Approach( Sharpen, 0, FrameTime() * 0.5 )
		
	end

	if ( MotionBlur > 0 ) then
	
		DrawMotionBlur( 1 - MotionBlur, 1.0, 0.0 )
		
		MotionBlur = math.Approach( MotionBlur, 0, approach )
		
	end
	
	if LocalPlayer():FlashlightIsOn() then
	
		ColorModify[ "$pp_colour_brightness" ] = math.Approach( ColorModify[ "$pp_colour_brightness" ], 0.02, FrameTime() * 0.25 ) 
		ColorModify[ "$pp_colour_contrast" ] = math.Approach( ColorModify[ "$pp_colour_contrast" ], 1.05, FrameTime() * 0.25 ) 
	
	elseif NightVision then
	
		if LocalPlayer():Alive() then
		
			if IsIndoors then
		
				ColorModify[ "$pp_colour_brightness" ] = math.Approach( ColorModify[ "$pp_colour_brightness" ], 0.20, FrameTime() * 0.50 ) 
				ColorModify[ "$pp_colour_contrast" ] = math.Approach( ColorModify[ "$pp_colour_contrast" ], 1.10, FrameTime() * 0.50 ) 
				ColorModify[ "$pp_colour_mulg" ] = math.Approach( ColorModify[ "$pp_colour_mulg" ], 0.20, FrameTime() * 0.50 ) 
				ColorModify[ "$pp_colour_addg" ] = math.Approach( ColorModify[ "$pp_colour_addg" ], 0.15, FrameTime() * 0.50 ) 
				
			else
			
				ColorModify[ "$pp_colour_brightness" ] = math.Approach( ColorModify[ "$pp_colour_brightness" ], 0.40, FrameTime() * 0.50 ) 
				ColorModify[ "$pp_colour_contrast" ] = math.Approach( ColorModify[ "$pp_colour_contrast" ], 1.20, FrameTime() * 0.50 ) 
				ColorModify[ "$pp_colour_mulg" ] = math.Approach( ColorModify[ "$pp_colour_mulg" ], 0.20, FrameTime() * 0.50 ) 
				ColorModify[ "$pp_colour_addg" ] = math.Approach( ColorModify[ "$pp_colour_addg" ], 0.20, FrameTime() * 0.50 ) 
			
			end
		
		else
		
			NightVision = false
		
		end
	
	end
	
	local rads = LocalPlayer():GetNWInt( "Radiation", 0 )
	
	if rads > 0 and LocalPlayer():Alive() then
		
		local scale = rads / 5
		
		MotionBlur = math.Approach( MotionBlur, scale * 0.5, FrameTime() )
		Sharpen = math.Approach( Sharpen, scale * 5, FrameTime() * 3 )
	
		ColorModify[ "$pp_colour_colour" ] = math.Approach( ColorModify[ "$pp_colour_colour" ], 1.0 - scale * 0.8, FrameTime() * 0.1 )
		
	end
	
	for k,v in pairs( ColorModify ) do
		
		if k == "$pp_colour_colour" or k == "$pp_colour_contrast" then
		
			ColorModify[k] = math.Approach( ColorModify[k], 1, FrameTime() * 0.2 ) 
		
		else
	
			ColorModify[k] = math.Approach( ColorModify[k], 0, approach ) 
		
		end
		
		if IsIndoors then
		
			local daycol = DayColor[k] * ( GetConVar( "sv_radbox_daycycle_intensity" ):GetFloat() * GetConVar( "sv_radbox_daycycle_indoors_light" ):GetFloat() )
			MixedColorMod[k] = math.Approach( MixedColorMod[k] or 0, daycol + ColorModify[k], FrameTime() * 0.25 )
			
		else
		
			local daycol = DayColor[k] * GetConVar( "sv_radbox_daycycle_intensity" ):GetFloat()
			MixedColorMod[k] = math.Approach( MixedColorMod[k] or 0, daycol + ColorModify[k], FrameTime() * 0.25 )
		
		end
	
	end
	
	DrawColorModify( MixedColorMod )
	DrawPlayerRenderEffects()
	
end

function GM:GetMotionBlurValues( y, x, fwd, spin ) 

	if LocalPlayer():Alive() and LocalPlayer():Health() <= 50 then
	
		local scale = math.Clamp( LocalPlayer():Health() / 50, 0, 1 )
		// local beat = math.Clamp( HeartBeat - CurTime(), 0, 2 ) * ( 1 - scale )
		
		fwd = 1 - scale // + beat
		
	elseif LocalPlayer():GetNWBool( "InIron", false ) then
	
		fwd = 0.05
		
	end
	
	if DisorientTime and DisorientTime > CurTime() then
	
		if not LocalPlayer():Alive() then 
			DisorientTime = nil
		end
	
		local scale = ( ( DisorientTime or 0 ) - CurTime() ) / 10
		local newx, newy = RotateAroundCoord( 0, 0, 1.0, scale * 0.05 )
		
		return newy, newx, fwd, spin
	
	end
	
	return y, x, fwd, spin

end

function RotateAroundCoord( x, y, speed, dist )

	local newx = x + math.sin( CurTime() * speed ) * dist
	local newy = y + math.cos( CurTime() * speed ) * dist

	return newx, newy

end

local MaterialWhite = Material( "white_outline" )
local NightVisionScale = 0

function DrawPlayerRenderEffects()
	
	if not NightVision then 
	
		NightVisionScale = math.Approach( NightVisionScale, 0, FrameTime() * 0.5 ) 
	
	else
	
		if IsIndoors then
		
			NightVisionScale = math.Approach( NightVisionScale, 0.6, FrameTime() * 0.5 ) 
		
		else
		
			NightVisionScale = math.Approach( NightVisionScale, 1.0, FrameTime() * 0.5 ) 
		
		end
	
	end
	
	if NightVisionScale == 0 then return end
	
	local tbl = ents.FindByClass( "npc*" )
	tbl = table.Add( tbl, player.GetAll() )
	
	cam.Start3D( EyePos(), EyeAngles() )
	
	for k,v in pairs( tbl ) do
	
		if ( v:IsPlayer() and v:Alive() and v != LocalPlayer() and v:Team() != TEAM_UNASSIGNED and v:Team() != TEAM_SPECTATOR and v:Team() != TEAM_CONNECTING ) or v:IsNPC() then

			render.SuppressEngineLighting( true )
			render.SetColorModulation( 0.5, 1.0, 0.5 )
			render.SetBlend( NightVisionScale * 0.25 )
	
			SetMaterialOverride( MaterialWhite )
 
			cam.IgnoreZ( false )
 
			v:DrawModel()
 
			render.SuppressEngineLighting( false )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			SetMaterialOverride( 0 )

		end
	
	end
	
	cam.End3D()

end

WalkTimer = 0
VelSmooth = 0
DeathAngle = Angle(0,0,0)
DeathOrigin = Vector(0,0,0)

function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	VelSmooth = VelSmooth * 0.5 + vel:Length() * 0.1
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.1
	
	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.002
	
	local scale = LocalPlayer():GetNWInt( "Radiation", 0 ) / 5
	local wobble = 0
	
	if scale > 0 and LocalPlayer():Alive() then
	
		wobble = 0.3 * scale
		
	end
	
	local drunkscale = Drunkness / 10
	
	if Drunkness > 0 then
	
		if ( DrunkTimer or 0 ) < CurTime() then
		
			Drunkness = math.Clamp( Drunkness - 1, 0, 20 )
			DrunkTimer = CurTime() + 20
		
		end
		
		wobble = wobble + ( drunkscale * 0.3 )

	end
	
	if LocalPlayer():Health() <= 75 and LocalPlayer():Alive() then
	
		local hscale = math.Clamp( LocalPlayer():Health() / 50, 0, 1 )
		wobble = wobble + ( 0.2 - 0.2 * hscale )
		
	end
	
	ViewWobble = math.Approach( ViewWobble - 0.05 * FrameTime(), wobble, FrameTime() * 0.25 ) 
	
	if ply:Alive() then
	
		if ViewWobble > 0 then
	
			angle.roll = angle.roll + math.sin( CurTime() + TimeSeed( 1, -2, 2 ) ) * ( ViewWobble * 15 )
			angle.pitch = angle.pitch + math.sin( CurTime() + TimeSeed( 2, -2, 2 ) ) * ( ViewWobble * 15 )
			angle.yaw = angle.yaw + math.sin( CurTime() + TimeSeed( 3, -2, 2 ) ) * ( ViewWobble * 15 )
			
		end
		
		DeathAngle = angle
		DeathOrigin = origin
		
	elseif not ply:Alive() and CV_RagdollVision:GetBool() then
	
		local rag = ply:GetRagdollEntity()
		
		if ValidEntity( rag ) then
			
			local eyes = rag:LookupAttachment( "eyes" )
			local tbl = rag:GetAttachment( eyes )
			
			if tbl then
			
				angle = tbl.Ang
				origin = tbl.Pos + ( tbl.Ang:Up() * 16 ) + ( tbl.Ang:Forward() * -8 )
				
			end
		
		end
	
	end
	
	if ply:GetGroundEntity() != NULL then
	
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
		angle.pitch = angle.pitch + math.cos( WalkTimer * 1.25 ) * VelSmooth * 0.005
		
	end
		
	return self.BaseClass:CalcView( ply, origin, angle, fov )
	
end
