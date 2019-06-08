
include('shared.lua')

function ENT:Initialize()

end

function ENT:Draw()

	if IsValid( self.Entity:GetNWEntity( "QuestOwner", nil ) ) and self.Entity:GetNWEntity( "QuestOwner", nil ) != LocalPlayer() then return end

	self.Entity:DrawModel()
	
end

