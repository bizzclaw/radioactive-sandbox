if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Winchester 1887"
	SWEP.IconLetter = "k"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_shotgun", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType = "shotgun"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_shot_m3super91.mdl"
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"

SWEP.SprintPos = Vector(-0.6026, -2.715, 0.0137)
SWEP.SprintAng = Vector(-3.4815, -21.9362, 0.0001)

SWEP.IronPos = Vector(4.7112, -4.0519, 1.7934)
SWEP.IronAng = Vector(0.3075, -0.1695, 0.9757)

SWEP.IsSniper = false
SWEP.AmmoType = "Buckshot"

SWEP.Primary.Sound			= Sound( "weapons/shotgun/shotgun_fire6.wav" )
SWEP.Primary.Pump           = Sound( "Weapon_M3.Pump" )
SWEP.Primary.Recoil			= 8.5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.085
SWEP.Primary.Delay			= 0.500

SWEP.Primary.ClipSize		= 2
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType = SHELL_SHOTGUN

function SWEP:Deploy()

	self.Weapon:SetNWBool( "Reloading", false )
	self.Weapon:SetVar( "PumpTime", 0 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

	if SERVER then
	
		self.Weapon:SetViewModelPosition()
		self.Weapon:SetZoomMode( 1 )
		
	end	
	
	self.InIron = false

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end 

function SWEP:CanPrimaryAttack()

	if self.LastRunFrame > CurTime() then return false end
	
	if self.Owner:GetNWInt( "Ammo"..self.AmmoType, 0 ) < 1 then 
	
		self.Weapon:EmitSound( self.Primary.Empty )
		return false 
		
	end
	
	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		self.Weapon:SetNWBool( "Reloading", false )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
		
		return false
	
	end

	if self.Weapon:Clip1() <= 0 then
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		
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
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end
	
	self.Weapon:SetVar( "PumpTime", CurTime() + 0.5 )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	self.Weapon:SetIron( false )
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end

function SWEP:Reload()

	if self.Weapon:Clip1() == self.Primary.ClipSize then return end
	
	self.Weapon:SetIron( false )
	
	if self.Weapon:Clip1() < self.Primary.ClipSize then
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		
		self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		
	end
	
end

function SWEP:PumpIt()

	self.Weapon:SetNWBool( "Reloading", false )
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
	self.Weapon:EmitSound( self.Primary.Pump )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end

function SWEP:Think()

	if self.Weapon:GetVar( "PumpTime", 0 ) != 0 and self.Weapon:GetVar( "PumpTime", 0 ) < CurTime() then
	
		self.Weapon:SetVar( "PumpTime", 0 )
		self.Weapon:PumpIt()
		
	end

	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		if self.Weapon:GetVar( "ReloadTimer", 0 ) < CurTime() then
			
			// Finsished reload
			if self.Weapon:Clip1() >= self.Primary.ClipSize then
			
				self.Weapon:SetNWBool( "Reloading", false )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
				
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				
				return
				
			end
			
			// Next cycle
			self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.75 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
			
		end
		
	end

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

end

function SWEP:ShootBullets( damage, numbullets, aimcone, zoommode )

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
	
		scale = aimcone * 1.75
		
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
	
		scale = math.Clamp( aimcone / 1.25, 0, 10 )
		
	end
	
	local tracer = 1
	
	if ( zoommode or 1 ) > 1 then
	
		tracer = 0
	
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= tracer
	bullet.Force	= damage * 2						
	bullet.Damage	= damage 
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= tracername
	bullet.Callback = function ( attacker, tr, dmginfo )
	
		dmginfo:ScaleDamage( self:GetDamageFalloffScale( tr.HitPos:Distance( self.Owner:GetShootPos() ) ) )
		
		if math.random(1,6) == 1 then
		
			self.Weapon:BulletPenetration( attacker, tr, dmginfo, 0 )
			
		end

	end
	
	self.Owner:FireBullets( bullet )
	
end

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
		
			scale = math.Clamp( self.Primary.Cone / 1.25, 0, 10 )
			
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
	
	end
	
end
