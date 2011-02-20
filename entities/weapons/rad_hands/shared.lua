if SERVER then

	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Hands"
	SWEP.IconLetter = "H"
	SWEP.Slot = 0
	SWEP.Slotpos = 1
	
end

SWEP.HoldType = "normal"

SWEP.Base = "rad_base"

SWEP.ViewModel			= ""
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"

SWEP.IsSniper = false
SWEP.AmmoType = "Knife"

SWEP.Primary.ClipSize		= 1

function SWEP:SecondaryAttack()

end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )

	self.Weapon:SetNWBool( "Thirdperson", !self.Weapon:GetNWBool( "Thirdperson", false ) )
	
end

function SWEP:DrawHUD()
	
end

function SWEP:CalcView( ply, origin, angle, fov )

	if !self.Weapon:GetNWBool( "Thirdperson", false ) then return origin, angle, fov end

	local trace = {}
	trace.start = origin
	trace.endpos = origin + ( angle:Forward() * -256 )
	trace.mask = MASK_PLAYERSOLID
	
	local tr = util.TraceLine( trace )
	
	origin = tr.HitPos
	
	if tr.Hit then
	
		origin = tr.HitPos + angle:Forward() * 8
	
	end

	return origin, angle, fov

end