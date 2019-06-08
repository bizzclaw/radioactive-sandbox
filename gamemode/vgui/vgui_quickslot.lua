local PANEL = {}

function PANEL:Init()

	self:SetTitle( "" )
	self:ShowCloseButton( false )
	self:ParentToHUD()

	self.Text = ""
	self.LastThink = 0
	
end

function PANEL:SetText( text )

	self.Text = text

end

function PANEL:Think()
	
	if IsValid( LocalPlayer() ) and LocalPlayer():Alive() then

		if LocalPlayer():GetNWBool( "InIron", false ) and self:IsVisible() then
		
			self:SetVisible( false )
		
		end
		
	end

	if not self.ID then return end
	
	if self.LastThink > CurTime() then return end
	
	self.LastThink = CurTime() + 1

	if not Inv_HasItem( self.ID ) and self.ModelPanel then
	
		self.ModelPanel:Remove()
		self.ModelPanel = nil
	
	elseif Inv_HasItem( self.ID ) then
	
		self:ResetModel( self.ID )
	
	end

end

function PANEL:ResetModel( id )

	if self.ID and self.ID == id and self.ModelPanel then return end

	if self.ModelPanel then 
	
		self.ModelPanel:Remove()
		self.ModelPanel = nil
	
	end

	self.ID = id

	local tbl = item.GetByID( id ) 
		
	self.ModelPanel = vgui.Create( "GoodModelPanel", self )
	self.ModelPanel.LayoutEntity = function( ent ) end
	self.ModelPanel:SetCamPos( tbl.CamPos or Vector(20,10,5) )
	self.ModelPanel:SetLookAt( tbl.CamOrigin or Vector(0,0,0) )
	self.ModelPanel:SetModel( tbl.Model )
	
	self:InvalidateLayout()

end

function PANEL:PerformLayout()

	if not self.ModelPanel then return end
	
	self.ModelPanel:SetSize( self:GetTall(), self:GetTall() )
	self.ModelPanel:SetPos( self:GetWide() - self:GetTall(), 0 )

end

function PANEL:Paint()

	if not LocalPlayer():Alive() then return end

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 200 ) )
	
	if self.ModelPanel then
	
		draw.RoundedBox( 4, self:GetWide() - self:GetTall(), 2, self:GetTall() - 2, self:GetTall() - 4, Color( 150, 150, 150, 125 ) )
		
	end
	
	draw.SimpleText( self.Text, "AmmoFontSmall", 10, self:GetTall() * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "QuickSlot", "A quick slot item panel.", PANEL, "PanelBase" )
