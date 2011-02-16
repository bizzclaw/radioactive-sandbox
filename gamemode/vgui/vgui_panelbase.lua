local PANEL = {}

function PANEL:Init()

	self:SetTitle( "" )
	self:ChooseParent()
	
end

function PANEL:ChooseParent()
	
end

function PANEL:OnMousePressed( mc )

	self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
	self:MouseCapture( true )

end

function PANEL:Think()

	if self.Dragging then
		
		local x = gui.MouseX() - self.Dragging[1]
        local y = gui.MouseY() - self.Dragging[2]
		
		x = math.Clamp( x, 0, ScrW() - self:GetWide() )
		y = math.Clamp( y, 0, ScrH() - self:GetTall() )
		
		self:SetPos( x, y )
	
	end

end

function PANEL:GetPadding()
	return 1
end

function PANEL:GetDefaultTextColor()
	return Color( 255, 255, 255, 255 )
end

function PANEL:GetTextLabelColor()
	return Color( 255, 255, 0 )
end

function PANEL:GetTextLabelFont()
	return "PanelText"
end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )

end

derma.DefineControl( "PanelBase", "A HUD Base Element", PANEL, "DFrame" )
