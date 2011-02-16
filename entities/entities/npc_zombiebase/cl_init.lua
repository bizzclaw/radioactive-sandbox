include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()

	self.Entity:DrawModel()
	
end

function ENT:BuildBonePositions( NumBones, NumPhysBones )
	
end

function ENT:SetRagdollBones( bIn )

	self.m_bRagdollSetup = bIn

end

function ENT:DoRagdollBone( PhysBoneNum, BoneNum )
	
end
