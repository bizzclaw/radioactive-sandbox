if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "USP Compact"
	SWEP.IconLetter = "a"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	killicon.AddFont( "rad_usp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.SprintPos = Vector (0.4776, 0.446, 3.1631)
SWEP.SprintAng = Vector (-15.3501, -1.3761, -1.5457)

SWEP.IronPos = Vector (4.473, 0.5303, 2.7239)
SWEP.IronAng = Vector (-0.2771, 0.0702, 0)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Recoil			= 5.5
SWEP.Primary.Damage			= 28
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.045
SWEP.Primary.Delay			= 0.160

SWEP.Primary.ClipSize		= 12
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType = SHELL_9MM
