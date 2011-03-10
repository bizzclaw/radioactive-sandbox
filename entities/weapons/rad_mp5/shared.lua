if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "HK MP5"
	SWEP.IconLetter = "x"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_mp5", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "smg"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.SprintPos = Vector(-0.6026, -2.715, 0.0137)
SWEP.SprintAng = Vector(-3.4815, -21.9362, 0.0001)

SWEP.IronPos = Vector(4.7375, -3.0969, 1.7654)
SWEP.IronAng = Vector(1.541, -0.1335, -0.144)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Sound			= Sound( "Weapon_MP5Navy.Single" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.050
SWEP.Primary.Delay			= 0.085

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_9MM
