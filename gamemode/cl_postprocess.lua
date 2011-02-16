
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

local function DrawInternal()

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
	
		ColorModify[ "$pp_colour_brightness" ] = math.Approach( ColorModify[ "$pp_colour_brightness" ], 0.05, FrameTime() * 0.25 ) 
		ColorModify[ "$pp_colour_contrast" ] = math.Approach( ColorModify[ "$pp_colour_contrast" ], 1.10, FrameTime() * 0.25 ) 
	
	elseif NightVision then
	
		if LocalPlayer():Alive() then
		
			ColorModify[ "$pp_colour_brightness" ] = math.Approach( ColorModify[ "$pp_colour_brightness" ], 0.15, FrameTime() * 0.25 ) 
			ColorModify[ "$pp_colour_contrast" ] = math.Approach( ColorModify[ "$pp_colour_contrast" ], 1.50, FrameTime() * 0.25 ) 
			ColorModify[ "$pp_colour_mulg" ] = math.Approach( ColorModify[ "$pp_colour_mulg" ], 0.20, FrameTime() * 0.25 ) 
			ColorModify[ "$pp_colour_addg" ] = math.Approach( ColorModify[ "$pp_colour_addg" ], 0.10, FrameTime() * 0.25 ) 
		
		else
		
			NightVision = false
		
		end
	
	end
	
	for k,v in pairs( ColorModify ) do
		
		if k == "$pp_colour_colour" or k == "$pp_colour_contrast" then
		
			ColorModify[k] = math.Approach( ColorModify[k], 1, approach ) 
		
		else
	
			ColorModify[k] = math.Approach( ColorModify[k], 0, approach ) 
		
		end
	
		MixedColorMod[k] = DayColor[k] + ColorModify[k]
	
	end
	
	DrawColorModify( MixedColorMod )
	
	local rad = LocalPlayer():GetNWInt( "Radiation", 0 )
	
	if rad > 0 and LocalPlayer():Alive() then
		
		local scale = rad / 5
			
		MotionBlur = math.Approach( MotionBlur, scale * 0.5, FrameTime() )
		Sharpen = math.Approach( Sharpen, scale * 5, FrameTime() * 3 )
	
		ColorModify[ "$pp_colour_colour" ] = math.Approach( ColorModify[ "$pp_colour_colour" ], 1.0 - scale * 0.8, FrameTime() * 0.1 )
		
		if LocalPlayer():Health() > 50 then
		
			ViewWobble = 0.2 * scale
		
		end
		
	end

end
hook.Add( "RenderScreenspaceEffects", "RenderPostProcessing", DrawInternal )

function GM:GetMotionBlurValues( y, x, fwd, spin ) 

	if LocalPlayer():Alive() and LocalPlayer():Health() <= 50 then
	
		local scale = math.Clamp( LocalPlayer():Health() / 50, 0, 1 )
		//local beat = math.Clamp( HeartBeat - CurTime(), 0, 2 ) * ( 1 - scale )
		
		fwd = 1 - scale //+ beat
		ViewWobble = 0.2 - 0.2 * scale
		
	elseif LocalPlayer():GetNWBool( "InIron", false ) then
	
		fwd = 0.05
		
	end
	
	if DisorientTime > CurTime() then
	
		if not LocalPlayer():Alive() then 
			DisorientTime = 0
		end
	
		local scale = ( DisorientTime - CurTime() ) / 10
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

WalkTimer = 0
VelSmooth = 0

function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	VelSmooth = VelSmooth * 0.5 + vel:Length() * 0.1
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.1
	
	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01
	
	--[[if ply:Alive() and ply:Health() <= 50 then
	
		local scale = math.Clamp( LocalPlayer():Health() / 50, 0, 1 )
		local beat = math.Clamp(HeartBeat - CurTime(), 0, 1) * (1 - scale)
		fov = fov - beat * 5
		
	end]]
	
	if ViewWobble > 0 then
	
		angle.roll = angle.roll + math.sin( CurTime() ) * ( ViewWobble * 15 )
		ViewWobble = ViewWobble - 0.1 * FrameTime()
		
	end
	
	if ply:GetGroundEntity() != NULL then
	
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
		angle.pitch = angle.pitch + math.sin( WalkTimer * 0.3 ) * VelSmooth * 0.001
		
	end
		
	return self.BaseClass:CalcView( ply, origin, angle, fov )
	
end
