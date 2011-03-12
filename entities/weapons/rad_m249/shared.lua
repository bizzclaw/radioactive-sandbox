if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "M249 SAW"
	SWEP.IconLetter = "z"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_m249", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.IronPos = Vector(-4.4543, 0, 2.0536)
SWEP.IronAng = Vector(0, 0, 0)

SWEP.SprintPos = Vector (4.0541, -2.0077, -5.4061)
SWEP.SprintAng = Vector (11.4322, 40.43, -7.9447)

SWEP.IsSniper = false
SWEP.AmmoType = "Rifle"
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_M249.Single" )
SWEP.Primary.Recoil			= 8.5
SWEP.Primary.Damage			= 55
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.090

SWEP.Primary.ClipSize		= 100
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_762NATO
