if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "ar2"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "IMI Galil"
	SWEP.IconLetter = "v"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
	killicon.AddFont( "rad_galil", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"

SWEP.IronPos = Vector(-5.1337, -3.9115, 2.1624)
SWEP.IronAng = Vector(0.0873, 0.0006, 0)

SWEP.SprintPos = Vector (5.6501, -4.3222, 2.1819)
SWEP.SprintAng = Vector (-10.5144, 47.7303, 2.2908)

SWEP.IsSniper = false
SWEP.AmmoType = "Rifle"
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_Galil.Single" )
SWEP.Primary.Recoil			= 7.5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.040
SWEP.Primary.Delay			= 0.110

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true

SWEP.Primary.ShellType = SHELL_556
