if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "ar2"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip      = false
	
	SWEP.PrintName = "FAMAS"
	SWEP.IconLetter = "t"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_famas", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "rad_base"

SWEP.ViewModel		= "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_famas.mdl"

SWEP.IronPos = Vector (-3.1223, -3.5405, 2.1875)
SWEP.IronAng = Vector (3.9828, 2.6895, 1.6346)

SWEP.SprintPos = Vector (2.4481, -2.6969, -1.0747)
SWEP.SprintAng = Vector (-7.5087, 33.9215, -15.2125)

SWEP.IsSniper = false
SWEP.AmmoType = "Rifle"
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_Famas.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 28
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.090

SWEP.Primary.ClipSize		= 25
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_556
