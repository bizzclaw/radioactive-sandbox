if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "ar2"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Steyr Scout"
	SWEP.IconLetter = "n"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_scout", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"

SWEP.SprintPos = Vector(-1.7763, -1.9796, 1.677)
SWEP.SprintAng = Vector(-11.9431, -36.4352, 0)

SWEP.IronPos = Vector(5.0124, -8.9394, 2.1298)
SWEP.IronAng = Vector(0, 0, -0.3972)

SWEP.ZoomModes = { 0, 40, 10 }
SWEP.ZoomSpeeds = { 0.25, 0.40, 0.40 }

SWEP.IsSniper = true
SWEP.AmmoType = "Sniper"

SWEP.Primary.Sound			= Sound( "Weapon_Scout.Single" )
SWEP.Primary.Recoil			= 15.5
SWEP.Primary.Damage			= 80
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.002
SWEP.Primary.Delay			= 1.300

SWEP.Primary.ClipSize		= 10
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType = SHELL_338MAG
