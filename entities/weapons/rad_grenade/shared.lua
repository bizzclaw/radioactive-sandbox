if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip      = true
	
	SWEP.PrintName = "HE Grenade"
	SWEP.IconLetter = "h"
	SWEP.Slot = 3
	SWEP.Slotpos = 3
	
	killicon.AddFont( "sent_grenade", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	killicon.AddFont( "rad_grenade", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.HoldType = "grenade"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_fraggrenade.mdl"

SWEP.SprintPos = Vector (10.9603, -1.1484, -0.4996)
SWEP.SprintAng = Vector (13.9974, 21.7915, 59.3288)

SWEP.IsSniper = false
SWEP.AmmoType = "Knife"
SWEP.ThrowPower = 500

SWEP.Primary.Sound			= Sound( "WeaponFrag.Throw" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.100
SWEP.Primary.Delay			= 2.300

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= false

function SWEP:Think()	

	if self.Owner:GetVelocity():Length() > 0 then
	
		if self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() > 0 and self.Owner:GetNWFloat( "Weight", 0 ) < 50 then
		
			self.LastRunFrame = CurTime() + 0.3
		
		end
		
	end
	
	if self.ThrowTime then
	
		if self.ThrowTime - 0.3 < CurTime() and not self.ThrowAnim then
		
			self.ThrowAnim = true 
			
			if self.ThrowPower > 1000 then
			
				self.Weapon:SendWeaponAnim( ACT_VM_THROW )
				
			end
		
		end
		
		if self.ThrowTime < CurTime() then
	
			self.ThrowTime = nil
			self.ReloadTime = CurTime() + 0.75
			
			if CLIENT then return end
			
			local tbl = item.GetByModel( "models/weapons/w_eq_fraggrenade.mdl" )
			
			if self.Owner:HasItem( tbl.ID ) then 
		
				self.Owner:RemoveFromInventory( tbl.ID )
			
			end
			
			local ent = ents.Create( "sent_grenade" )
			ent:SetPos( self.Owner:GetShootPos() + self.Owner:GetRight() * 5 + self.Owner:GetUp() * -5 )
			ent:SetOwner( self.Owner )
			ent:SetAngles( self.Owner:GetAimVector():Angle() )
			ent:SetSpeed( self.ThrowPower )
			ent:Spawn()
			
			if not self.Owner:HasItem( tbl.ID ) then
				
				self.Owner:StripWeapon( "rad_grenade" )
				
			end
			
		end
	
	end
	
	if self.ReloadTime and self.ReloadTime < CurTime() then
	
		self.ReloadTime = nil
	
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	end

end

function SWEP:SecondaryAttack()

	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:ShootEffects()
	
	self.ThrowTime = CurTime() + 1.25
	self.ThrowAnim = false
	self.ThrowPower = 800

end

function SWEP:PrimaryAttack()

	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:ShootEffects()
	
	self.ThrowTime = CurTime() + 1.25
	self.ThrowAnim = false
	self.ThrowPower = 3000
	
end

function SWEP:ShootEffects()	

	if SERVER then
	
		self.Owner:ViewBounce( self.Primary.Recoil )  
		
	end
								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
end

function SWEP:DrawHUD()

end

