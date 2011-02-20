local PANEL = {}

function PANEL:Init()

	self:SetTitle( "" )
	self:ShowCloseButton( false )
	self:ParentToHUD()
	
	self.Name = ""
	self.TeamName = ""
	self.Color = Color( 255, 255, 255 )
	
end

function PANEL:SetEntity( ent )

	if ValidEntity( self.Ent ) and self.Ent == ent then 
	
		if not self:IsVisible() and LocalPlayer():GetNWBool( "InIron", false ) == false then
		
			self:SetVisible( true )
		
		end
	
		self.Timer = CurTime() + 5 
		
		return 
		
	end

	local name = team.GetTraderName( ent )
	local teamname = "Neutral"
	local col = Color( 255, 255, 255 )
	
	if string.find( ent:GetClass(), "zombie" ) then
	
		name = "Zombie"
		teamname = "Mutant"
		col = Color( 255, 80, 80 )
	
	elseif string.find( ent:GetClass(), "rogue" ) then
	
		name = GAMEMODE:GetPlayerGayName( ent:GetModel() .. ent:EntIndex() )
		teamname = "Loner"
		col = Color( 255, 80, 80 )
	
	elseif ent:IsPlayer() then
	
		name = GAMEMODE:GetPlayerGayName( ent, tostring( ent:Deaths() + 1 ) .. ent:Name() )
		teamname = team.GetName( ent:Team() )
		col = Color( 255, 80, 80 )
	
		if ent:Team() == LocalPlayer():Team() then
		
			col = Color( 255, 255, 255 )
			
		end
	
	end

	self.Name = name
	self.TeamName = teamname
	self.Color = col
	self.Timer = CurTime() + 5
	self.Ent = ent
	
	self:ResetModel( ent:GetModel() )
	self:SetVisible( true )

end

function PANEL:Think()

	if ( self.Timer and self.Timer < CurTime() ) or not LocalPlayer():Alive() or InventoryScreen:IsVisible() then
	
		self:SetVisible( false )
		self.Timer = nil
	
	end
	
	if LocalPlayer():GetNWBool( "InIron", false ) and self:IsVisible() then
	
		self:SetVisible( false )
		self.Timer = nil
	
	end

end

function PANEL:ResetModel( mdl )

	if self.ModelPanel then 
	
		self.ModelPanel:Remove()
		self.ModelPanel = nil
	
	end
		
	self.ModelPanel = vgui.Create( "GoodModelPanel", self )
	self.ModelPanel.LayoutEntity = function( ent ) end
	self.ModelPanel.ExcludedModels = function()

		return {}

	end
	
	if mdl == "models/zombie/poison.mdl" then
	
		self.ModelPanel:SetCamPos( Vector(40,-5,35) )
		self.ModelPanel:SetLookAt( Vector(0,-5,55) )
		
	elseif mdl == "models/zombie/classic.mdl" then
	
		self.ModelPanel:SetCamPos( Vector(30,-3,50) )
		self.ModelPanel:SetLookAt( Vector(0,-3,57) )
		
	elseif mdl == "models/zombie/fast.mdl" then
	
		self.ModelPanel:SetCamPos( Vector(35,5,35) )
		self.ModelPanel:SetLookAt( Vector(0,0,38) )
	
	else
	
		self.ModelPanel:SetCamPos( Vector(30,0,55) )
		self.ModelPanel:SetLookAt( Vector(0,0,60) )
		
	end
	
	self.ModelPanel:SetModel( mdl )
	
	self:InvalidateLayout()

end

function PANEL:PerformLayout()

	if not self.ModelPanel then return end
	
	self.ModelPanel:SetSize( self:GetWide() - 20, self:GetWide() - 20 )
	self.ModelPanel:SetPos( 10, 40 )

end

function PANEL:Paint()

	if not LocalPlayer():Alive() then return end

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 200 ) )
	draw.RoundedBox( 4, 10, 40, self:GetWide() - 20, self:GetWide() - 20, Color( 150, 150, 150, 125 ) )
	
	draw.SimpleText( self.Name, "TargetIDFont", self:GetWide() * 0.5, 15, self.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( self.TeamName, "TargetIDFont", self:GetWide() * 0.5, 30, self.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "TargetID", "A quick target id panel.", PANEL, "PanelBase" )
