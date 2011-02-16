if SERVER then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "pistol"
	
end

if CLIENT then
	
	killicon.AddFont( "rad_npcgun", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "rad_base"

SWEP.WorldModel	= "models/weapons/w_smg_mac10.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" )
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.090
SWEP.Primary.Delay			= 0.050
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_9MM

SWEP.Burst = 5
SWEP.NextFire = 0

function SWEP:PrimaryAttack()

	if self.NextFire > CurTime() then return end

	if self.Burst < 1 then 
		
		self.Burst = math.random( 5, 10 )
		self.NextFire = CurTime() + math.Rand( 1.0, 2.0 )
		return 
		
	end

	self.Burst = self.Burst - 1
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 1 )
	self.Weapon:ShootEffects()

end

function SWEP:ShootEffects()	
	
	self.Owner:MuzzleFlash()								
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
	if CLIENT then return end

	local ed = EffectData()
	ed:SetOrigin( self.Owner:GetShootPos() )
	ed:SetEntity( self.Weapon )
	ed:SetAttachment( self.Weapon:LookupAttachment( "2" ) )
	ed:SetScale( ( self.Primary.ShellType or SHELL_9MM ) )
	util.Effect( "weapon_shell", ed, true, true )
	
end

function SWEP:ShootBullets( damage, numbullets, scale, zoommode )
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1
	bullet.Force	= damage * 2						
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= tracername
	bullet.Callback = function ( attacker, tr, dmginfo )

	end
	
	self.Owner:FireBullets( bullet )
	
end