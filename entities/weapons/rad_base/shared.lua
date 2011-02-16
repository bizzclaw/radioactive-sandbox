if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "ar2"
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "BASE WEAPON"
	SWEP.IconLetter = "c"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.SprintPos = Vector(0,0,0)
SWEP.SprintAng = Vector(0,0,0)

SWEP.IronPos = Vector(0,0,0)
SWEP.IronAng = Vector(0,0,0)

SWEP.ZoomModes = { 0, 50, 10 }
SWEP.ZoomSpeeds = { 5, 5, 5 }

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"
SWEP.IronsightsFOV = 65

SWEP.Primary.Empty          = Sound( "weapons/clipempty_rifle.wav" )
SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 99999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.Sound        = Sound( "weapons/zoom.wav" )
SWEP.Secondary.Delay  		= 0.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.LastRunFrame = 0
SWEP.InIron = false
SWEP.ApproachPos = Vector(0,0,0)

SWEP.FalloffDistances = {}
SWEP.FalloffDistances[ "Sniper" ] = { Range = 5000, Falloff = 8000 }
SWEP.FalloffDistances[ "Rifle" ] = { Range = 2000, Falloff = 2000 }
SWEP.FalloffDistances[ "SMG" ] = { Range = 1500, Falloff = 1500 }
SWEP.FalloffDistances[ "Pistol" ] = { Range = 1000, Falloff = 500 }
SWEP.FalloffDistances[ "Buckshot" ] = { Range = 300, Falloff = 500 }

function SWEP:SetViewModelPosition( vec, ang, movetime )
	
	self.Weapon:SetNWVector( "ViewVector", vec )
	self.Weapon:SetNWVector( "ViewAngle", ang )
	self.Weapon:SetNWInt( "ViewDuration", movetime ) 
	self.Weapon:SetNWInt( "ViewTime", CurTime() )

end

function SWEP:GetViewModelPosition( pos, ang )

	local newpos = self.Weapon:GetNWVector( "ViewVector", nil )
	local newang = self.Weapon:GetNWVector( "ViewAngle", nil )
	local movetime = self.Weapon:GetNWInt( "ViewDuration", 0.25 ) 
	local duration = self.Weapon:GetNWInt( "ViewTime", 0 ) 
	
	local pang = self.Owner:EyeAngles()
	local vel = self.Owner:GetVelocity()
	
	if not self.Owner:GetNWBool( "InIron", false ) then
	
		vel.x = math.Clamp( vel.x, -300, 300 )
		vel.y = math.Clamp( vel.y, -300, 300 )
		vel.z = math.Clamp( vel.z, -200, 200 )
		
		self.ApproachPos.x = math.Approach( self.ApproachPos.x, vel.x, 18 ) 
		self.ApproachPos.y = math.Approach( self.ApproachPos.y, vel.y, 18 ) 
		self.ApproachPos.z = math.Approach( self.ApproachPos.z, vel.z, 18 ) 
		
		pos = pos - self.ApproachPos / 150
		
	end
		
	if not newpos or not newang then
	
		newpos = pos
		newang = ang
		
	end
	
	local mul = 0
	
	self.SwayScale 	= 1.0
	self.BobScale 	= 1.0
	
	if ( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() > 0 and self.Owner:GetNWFloat( "Weight", 0 ) < 50 ) or InventoryScreen:IsVisible() then
	
		self.SwayScale 	= 1.25
		self.BobScale 	= 1.25
		
		if not self.SprintStart then
		
			self.SprintStart = CurTime()
			
		end
		
		mul = math.Clamp( ( CurTime() - self.SprintStart ) / movetime, 0, 1 )
		mul = -( mul - 1 ) ^ 2 + 1
		
		newang = self.SprintAng
		newpos = self.SprintPos
		
	else 
	
		if self.Owner:GetNWBool( "InIron", false ) then
		
			self.SwayScale 	= 0.25
			self.BobScale 	= 0.25
		
		end
		
		if self.SprintStart then
		
			self.SprintEnd = CurTime()
			self.SprintStart = nil
			
		end
	
		if self.SprintEnd then
		
			mul = math.Clamp( ( CurTime() - self.SprintEnd ) / movetime, 0, 1 )
			mul = ( mul - 1 ) ^ 2
			
			newang = self.SprintAng
			newpos = self.SprintPos
			
			if mul == 0 then
			
				self.SprintEnd = nil 
				
			end
			
		else
		
			mul = self:GetMoveScale( movetime, duration, mul )
			
		end
	end

	return self:MoveViewModelTo( newpos, newang, pos, ang, mul )
	
end

function SWEP:GetMoveScale( movetime, duration, mul )

	mul = 1
		
	if CurTime() - movetime < duration then
	
		mul = math.Clamp( ( CurTime() - duration ) / movetime, 0, 1 )
		
	end
	
	if self.Weapon:GetNWBool( "ReverseAnim", false ) then
	
		return -( mul - 1 ) ^ 3
		
	end
	
	return ( mul - 1 ) ^ 3 + 1

end

function SWEP:AngApproach( newang, ang, mul )

	ang:RotateAroundAxis( ang:Right(), 		newang.x * mul )
	ang:RotateAroundAxis( ang:Up(), 		newang.y * mul )
	ang:RotateAroundAxis( ang:Forward(), 	newang.z * mul )
	
	return ang

end
function SWEP:PosApproach( newpos, pos, ang, mul ) 

	local right 	= ang:Right()
	local up 		= ang:Up()
	local forward 	= ang:Forward()

	pos = pos + newpos.x * right * mul
	pos = pos + newpos.y * forward * mul
	pos = pos + newpos.z * up * mul
	
	return pos

end

function SWEP:MoveViewModelTo( newpos, newang, pos, ang, mul )

	ang = self:AngApproach( newang, ang, mul )
	pos = self:PosApproach( newpos, pos, ang, mul )

	return pos, ang

end

function SWEP:Initialize()

	if CLIENT then return end

	self.Weapon:SetWeaponHoldType( self.HoldType )
	
end

function SWEP:Deploy()

	if SERVER then
	
		self.Weapon:SetViewModelPosition()
		self.Weapon:SetZoomMode( 1 )
		self.Owner:DrawViewModel( true )
		
	end	
	
	self.InIron = false

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:Think()	

	if self.Owner:GetVelocity():Length() > 0 then
	
		if self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetNWFloat( "Weight", 0 ) < 50 then
		
			self.LastRunFrame = CurTime() + 0.3
			
			if self.InIron and not self.IsSniper then
		
				self.Weapon:SetIron( false )
			
			end
		
		end
		
		if self.Weapon:GetZoomMode() != 1 then
		
			self.Weapon:UnZoom()
			
		end
		
	end
	
	if self.MoveTime and self.MoveTime < CurTime() and SERVER then
	
		self.MoveTime = nil
		self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
		self.Owner:DrawViewModel( false )
		
	end

end

function SWEP:SetZoomMode( num )

	if num > #self.ZoomModes then
	
		num = 1

		self.Weapon:UnZoom()
		
	end
	
	self.Owner:SetNWBool( "InIron", num != 1)
	self.Weapon:SetNWInt( "Mode", num )
	self.Owner:SetFOV( self.ZoomModes[num], self.ZoomSpeeds[num] )

end

function SWEP:GetZoomMode()

	return self.Weapon:GetNWInt( "Mode", 1 )
	
end

function SWEP:UnZoom()

	if CLIENT then return end

	self.Weapon:SetZoomMode( 1 )
	self.Weapon:SetNWBool( "ReverseAnim", true )
	self.Weapon:SetViewModelPosition( self.IronPos, self.IronAng, 0.3 )
			
	self.Owner:DrawViewModel( true )
	self.Owner:SetNWBool( "InIron", false )
	
end

function SWEP:SetIron( bool )

	if CLIENT then return end
	
	if self.InIron == bool then return end

	self.InIron = bool
	self.Weapon:SetNWBool( "ReverseAnim", !bool )
	self.Weapon:SetViewModelPosition( self.IronPos, self.IronAng, 0.3 )
	
	self.Owner:SetNWBool( "InIron", bool )
	
	if not bool then
		self.Owner:SetFOV( 0, 0.2 )
	else
		self.Owner:SetFOV( self.IronsightsFOV, 0.2 )
	end

end

function SWEP:Reload()

	if self.Weapon:Clip1() == self.Primary.ClipSize then return end

	if self.Weapon:GetZoomMode() != 1 then
	
		self.Weapon:UnZoom()
		
	end	
	
	if not self.IsSniper then
	
		self.Weapon:SetIron( false )
		
	end

	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	
end

function SWEP:CanSecondaryAttack()

	if self.Owner:KeyDown( IN_SPEED ) or self.LastRunFrame > CurTime() then return false end

	if ( self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_LEFT ) or self.Owner:KeyDown( IN_RIGHT ) or self.Weapon:Clip1() <= 0 ) and self.IsSniper then
	
		if self.Weapon:GetZoomMode() != 1 then
		
			self.Weapon:UnZoom()
			
		end
	
		return false
		
	end
	
	return true
	
end

function SWEP:CanPrimaryAttack()

	if self.LastRunFrame > CurTime() then return false end
	
	if self.Owner:GetNWInt( "Ammo"..self.AmmoType, 0 ) < 1 then 
	
		self.Weapon:EmitSound( self.Primary.Empty )
		return false 
		
	end

	if self.Weapon:Clip1() <= 0 then
	
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		
		if self.Weapon:GetZoomMode() != 1 then
		
			self.Weapon:UnZoom()
			
		end	
		
		if not self.IsSniper then
	
			self.Weapon:SetIron( false )
		
		end
		
		return false
		
	end
	
	return true
	
end

function SWEP:ShootEffects()	

	if SERVER then
	
		self.Owner:ViewBounce( self.Primary.Recoil )  
		
	end
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
	if CLIENT then return end

	local ed = EffectData()
	ed:SetOrigin( self.Owner:GetShootPos() )
	ed:SetEntity( self.Weapon )
	ed:SetAttachment( self.Weapon:LookupAttachment( "2" ) )
	ed:SetScale( ( self.Primary.ShellType or SHELL_9MM ) )
	util.Effect( "weapon_shell", ed, true, true )
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	
	if self.Weapon:GetZoomMode() > 1 then
	
		self.Weapon:UnZoom()
	
	end
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end

function SWEP:SecondaryAttack()

	if not self.Weapon:CanSecondaryAttack() then return end
	
	if not self.IsSniper then
	
		self.Weapon:SetIron( !self.InIron )
	
		return
	
	end
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.25 );
	
	if SERVER then
		
		if self.Weapon:GetZoomMode() == 1 then
		
			self.Weapon:SetNWBool( "ReverseAnim", false )
			self.Weapon:SetViewModelPosition( self.IronPos, self.IronAng, 0.3 )
			self.MoveTime = CurTime() + 0.35
			
		else
		
			self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
			
		end
	
	end
	
	self.Weapon:EmitSound( self.Secondary.Sound )
	
end

function SWEP:AdjustMouseSensitivity()

	local num = self.Weapon:GetNWInt( "Mode", 1 )
	local scale = ( self.ZoomModes[num] or 0 ) / 100
	
	if scale == 0 then
		return nil
	end

	return scale
	
end		

function SWEP:GetDamageFalloffScale( distance )		

	local scale = 1		

	if distance > self.FalloffDistances[ self.AmmoType ].Range then		

		scale = ( 1 - ( ( distance - self.FalloffDistances[ self.AmmoType ].Range ) / self.FalloffDistances[ self.AmmoType ].Falloff ) )		

	end		
	
	return math.Clamp( scale, 0.1, 1.0 )
end

function SWEP:ShootBullets( damage, numbullets, aimcone, zoommode )

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
	
		scale = aimcone * 1.75
		
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
	
		scale = math.Clamp( aimcone / 1.75, 0, 10 )
		
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1
	bullet.Force	= damage * 2						
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	if self.IsSniper and self.AmmoType == "Sniper" then
	
		bullet.TracerName = "sniper_tracer"
	
	end
	
	bullet.Callback = function ( attacker, tr, dmginfo )
	
		dmginfo:ScaleDamage( self:GetDamageFalloffScale( tr.HitPos:Distance( self.Owner:GetShootPos() ) ) )

		if ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() then return end
	
		self.Weapon:BulletPenetration( attacker, tr, dmginfo, 0 )

	end
	
	self.Owner:FireBullets( bullet )
	
end

function SWEP:GetPenetrationDistance( mat_type )

	if ( mat_type == MAT_PLASTIC || mat_type == MAT_WOOD || mat_type == MAT_ALIENFLESH || mat_type == MAT_GLASS ) then
	
		return 64
	
	end
	
	return 32
	
end

function SWEP:GetPenetrationDamageLoss( mat_type, distance, damage )

	if ( mat_type == MAT_GLASS || mat_type == MAT_ALIENFLESH ) then
		return damage
	elseif ( mat_type == MAT_PLASTIC  || mat_type == MAT_WOOD ) then
		return damage - distance
	elseif( mat_type == MAT_TILE || mat_type == MAT_SAND || mat_type == MAT_DIRT ) then
		return damage - ( distance * 1.2 )
	end
	
	return damage - ( distance * 1.8 )
	
end

function SWEP:BulletPenetration( attacker, tr, dmginfo, bounce )

	if ( !self or !ValidEntity( self.Weapon ) ) then return end
	
	if ValidEntity( tr.Entity ) and string.find( tr.Entity:GetClass(), "npc" ) then		
	
		local effectdata = EffectData()		
		effectdata:SetOrigin( tr.HitPos )		
		util.Effect( "BloodImpact", effectdata )		
	
	end		
	
	
	// Don't go through more than 3 times
	if ( bounce > 3 ) then return false end
	
	// Direction (and length) that we are gonna penetrate
	local PeneDir = tr.Normal * self:GetPenetrationDistance( tr.MatType )
		
	local PeneTrace = {}
	   PeneTrace.endpos = tr.HitPos
	   PeneTrace.start = tr.HitPos + PeneDir
	   PeneTrace.mask = MASK_SHOT
	   PeneTrace.filter = { self.Owner }
	   
	local PeneTrace = util.TraceLine( PeneTrace ) 
	
	// Bullet didn't penetrate.
	if ( PeneTrace.StartSolid or PeneTrace.Fraction >= 1.0 or tr.Fraction <= 0.0 ) or tr.MatType == MAT_FLESH then return false end
	
	local distance = ( PeneTrace.HitPos - tr.HitPos ):Length()
	local new_damage = self:GetPenetrationDamageLoss( tr.MatType, distance, dmginfo:GetDamage() )
	
	if new_damage > 0 then
	
		local bullet = 
		{	
			Num 		= 1,
			Src 		= PeneTrace.HitPos,
			Dir 		= tr.Normal,	
			Spread 		= Vector( 0, 0, 0 ),
			Tracer		= 0,
			Force		= 5,
			Damage		= new_damage,
			AmmoType 	= "Pistol",
		}
		
		bullet.Callback = function ( attacker, tr, dmginfo )
	
			self.Weapon:BulletPenetration( attacker, tr, dmginfo, bounce + 1 )
		
		end
		
		local effectdata = EffectData()
		effectdata:SetOrigin( PeneTrace.HitPos )
		effectdata:SetNormal( PeneTrace.Normal )
		util.Effect( "Impact", effectdata ) 
		
		timer.Simple( 0.05, attacker.FireBullets, attacker, bullet, true )
		
		if SERVER and tr.MatType != MAT_FLESH then
	
			WorldSound( table.Random( GAMEMODE.Ricochet ), tr.HitPos, 100, math.random(90,120) )
	
		end
		
	end
	
end

function SWEP:ShouldNotDraw()

	if ValidEntity( self.Owner:GetVehicle() ) then
	
		return true
	
	end

	return false
	
end

if CLIENT then

	SWEP.CrossRed = CreateClientConVar( "crosshair_r", 255, true, false )
	SWEP.CrossGreen = CreateClientConVar( "crosshair_g", 255, true, false )
	SWEP.CrossBlue = CreateClientConVar( "crosshair_b", 255, true, false )
	SWEP.CrossAlpha = CreateClientConVar( "crosshair_a", 255, true, false )

end

SWEP.CrosshairScale = 1

function SWEP:DrawHUD()

	if self.Weapon:ShouldNotDraw() then return end

	if not self.IsSniper and not self.Owner:GetNWBool( "InIron", false ) then
	
		local x = ScrW() * 0.5
		local y = ScrH() * 0.5
		local scalebywidth = ( ScrW() / 1024 ) * 10
		local scale = self.Primary.Cone
		
		if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		
			scale = self.Primary.Cone * 1.75
			
		elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		
			scale = math.Clamp( self.Primary.Cone / 1.75, 0, 10 )
			
		end
		
		scale = scale * scalebywidth
		
		local dist = math.abs( self.CrosshairScale - scale )
		self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05 )
		
		local gap = 40 * self.CrosshairScale
		local length = gap + 20 * self.CrosshairScale
		
		surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
		surface.DrawLine( x - length, y, x - gap, y )
		surface.DrawLine( x + length, y, x + gap, y )
		surface.DrawLine( x, y - length, x, y - gap )
		surface.DrawLine( x, y + length, x, y + gap )
	
		return
	
	end
	
	local mode = self.Weapon:GetNWInt( "Mode", 1 )
	
	if mode != 1 then
	
		local w = ScrW()
		local h = ScrH()
		local wr = ( h / 3 ) * 4

		surface.SetTexture( surface.GetTextureID( "gmod/scope" ) )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawTexturedRect( ( w / 2 ) - wr / 2, 0, wr, h )
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, ( w / 2 ) - wr / 2, h )
		surface.DrawRect( ( w / 2 ) + wr / 2, 0, w - ( ( w / 2 ) + wr / 2 ), h )
		surface.DrawLine( 0, h * 0.50, w, h * 0.50 )
		surface.DrawLine( w * 0.50, 0, w * 0.50, h )
		
	end
	
end

