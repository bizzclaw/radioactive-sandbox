local PANEL = {}

function PANEL:Init()

	self:ShowCloseButton( false )
	self:SetKeyboardInputEnabled( false )
	self:SetDraggable( true ) 
	
	self.Button = vgui.Create( "DButton", self )
	self.Button:SetText( "Close" )
	self.Button.OnMousePressed = function()

		if not InventoryScreen:IsVisible() then
			gui.EnableScreenClicker( false )
		end
	
		self:Remove() 
		
	end
	
	self.TextSizeY = 20
	
end

function PANEL:SetText( text )

	self.Text = text
	self:InvalidateLayout()
	
end

function PANEL:GetPadding()

	return 20
	
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

function PANEL:PerformLayout()
	
	if self.Button then
		
		self.Button:SetPos( self:GetWide() * 0.5 - self.Button:GetWide() * 0.5, self.TextSizeY + 16 )
		self.Button:SetSize( 48, 18 )
	
	end

	self:SetSize( 400, self.TextSizeY + 42 )
	
end

function PANEL:Paint()

	Derma_DrawBackgroundBlur( self )
	
	surface.SetFont( "ItemDisplayFont" )
	
	local tbl = string.Explode( " ", self.Text )
	local str = { "" } 
	local pos = 1
	
	for k,v in pairs( tbl ) do
		
		local test = str[pos] .. " " .. v
		local size = surface.GetTextSize( test )
		
		if size > self:GetWide() - 40 then
		
			str[pos] = string.Trim( str[pos] )
			pos = pos + 1
			str[pos] = ( str[pos] or "" ) .. v
		
		else
		
			str[pos] = str[pos] .. " " .. v
		
		end
		
	end
	
	self.TextSizeY = 20 + ( pos - 1 ) * 15
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 100 ) )
	
	draw.RoundedBox( 4, 10, 10, self:GetWide() - 20, self.TextSizeY, Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 11, 11, self:GetWide() - 22, self.TextSizeY - 2, Color( 150, 150, 150, 150 ) )
	
	for k,v in pairs( str ) do
	
		draw.SimpleText( v, "ItemDisplayFont", self:GetWide() * 0.5, 20 + ( ( k - 1 ) * 15 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end

end

derma.DefineControl( "Dialogue", "A HUD Element with a label and close buton.", PANEL, "PanelBase" )
