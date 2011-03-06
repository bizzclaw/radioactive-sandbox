local PANEL = {}

function PANEL:Init()

	self:ShowCloseButton( false )
	self:SetKeyboardInputEnabled( false )
	self:SetDraggable( true ) 
	self.FuncList = {}
	
	self.Stashable = false
	self.StashStyle = "Take"
	self.PriceScale = 1
	
end

function PANEL:SetPriceScale( scale )

	self.PriceScale = scale

end

function PANEL:SetStashable( bool, style )

	self.Stashable = bool
	self.StashStyle = style

end

function PANEL:Think()

	if self.Dragging then
		
		local x = gui.MouseX() - self.Dragging[1]
        local y = gui.MouseY() - self.Dragging[2]
		
		x = math.Clamp( x, 0, ScrW() - self:GetWide() )
		y = math.Clamp( y, 0, ScrH() - self:GetTall() )
		
		self:SetPos( x, y )
		
		GAMEMODE:SetItemToPreview( self.ID, self.StashStyle, self.PriceScale )
	
	end

end

function PANEL:OnMouseReleased( mc )

	self.Dragging = nil
	self:MouseCapture( false )
	
	if mc != MOUSE_RIGHT then return end

	self:MouseMenu()

end

function PANEL:MouseMenu()

	local menu = vgui.Create( "DMenu", self )
	menu:AddOption( "Cancel" )
	
	if self.Stashable then
	
		if self.StashStyle == "Take" then
		
			menu:AddOption( self.StashStyle, function() RunConsoleCommand( "inv_take", self.ID, 1 ) end )
			
			if self:GetCount() > 1 then
			
				if self:GetCount() > 3 then
			
					local submenu = menu:AddSubMenu( "Take Multiple" )
				
					for k,v in pairs{ 3, 5, 10, 20 } do
			
						if self:GetCount() > v then
					
							submenu:AddOption( "Take "..v, function() RunConsoleCommand( "inv_take", self.ID, v ) end )
					
						end
				
					end
				
				end
			
				menu:AddOption( "Take All", function() RunConsoleCommand( "inv_take", self.ID, self:GetCount() ) end )
				
			end
			
			menu:Open()
			return
			
		elseif self.StashStyle == "Buy" then
		
			menu:AddOption( self.StashStyle, function() RunConsoleCommand( "inv_buy", self.ID, 1 ) end )
			
			local submenu = menu:AddSubMenu( "Buy Multiple" )
				
			for k,v in pairs{ 3, 5, 10, 20 } do
				
				submenu:AddOption( "Buy "..v, function() RunConsoleCommand( "inv_buy", self.ID, v ) end )
					
			end
			
			menu:Open()
			return
		
		elseif self.StashStyle == "Sell" then
		
			if !self.NotSellable then
		
				menu:AddOption( self.StashStyle, function() RunConsoleCommand( "inv_sell", self.ID, 1 ) end )
				
				if self:GetCount() > 1 then
				
					if self:GetCount() > 3 then
				
						local submenu = menu:AddSubMenu( "Sell Multiple" )
				
						for k,v in pairs{ 3, 5, 10, 20 } do
					
							if self:GetCount() > v then
					
								submenu:AddOption( "Sell "..v, function() RunConsoleCommand( "inv_sell", self.ID, v ) end )
					
							end
				
						end
					
					end
				
					menu:AddOption( "Sell All", function() RunConsoleCommand( "inv_sell", self.ID, self:GetCount() ) end )
					
				end
				
			end
		
		else
		
			menu:AddOption( self.StashStyle, function() RunConsoleCommand( "inv_store", self.ID, 1 ) end )		
			
			if self:GetCount() > 1 then
			
				if self:GetCount() > 3 then
			
					local submenu = menu:AddSubMenu( "Stash Multiple" )
				
					for k,v in pairs{ 3, 5, 10, 20 } do
				
						if self:GetCount() > v then
					
							submenu:AddOption( "Stash "..v, function() RunConsoleCommand( "inv_store", self.ID, v ) end )
					
						end
				
					end
			
				end
			
				menu:AddOption( "Stash All", function() RunConsoleCommand( "inv_store", self.ID, self:GetCount() ) end )
				
			end
		
		end
	
	end
	
	if not self.IsWeapon then
	
		menu:AddOption( "Drop", function() RunConsoleCommand( "inv_drop", self.ID, 1 ) end )
		
	end
	
	
	if self:GetCount() > 1 and not self.IsWeapon then
	
		if self:GetCount() > 3 then
	
			local submenu = menu:AddSubMenu( "Drop Multiple" )
				
			for k,v in pairs{ 3, 5, 10, 20 } do
				
				if self:GetCount() > v then
					
					submenu:AddOption( "Drop "..v, function() RunConsoleCommand( "inv_drop", self.ID, v ) end )
					
				end
				
			end
		
		end
	
		menu:AddOption( "Drop All", function() RunConsoleCommand( "inv_drop", self.ID, self:GetCount() ) end )
		
	end
	
	for k,v in pairs( self.FuncList ) do
	
		menu:AddOption( v( 0, 0, true ), function() RunConsoleCommand( "inv_action", self.ID, k ) end )
		
		if not self.IsWeapon then
		
			menu:AddOption( "F3  >  " .. v( 0, 0, true ), function() RunConsoleCommand( "inv_assignf3", self.ID, k ) F3Item:ResetModel( self.ID ) end )
			menu:AddOption( "F4  >  " .. v( 0, 0, true ), function() RunConsoleCommand( "inv_assignf4", self.ID, k ) F4Item:ResetModel( self.ID ) end )
			
		end
		
	end
	
	menu:Open()

end

function PANEL:SetCount( num )

	self.ItemCount = num
	
	if num > 1 then
	
		self:SetTitle( "  "..num )
		
	else
	
		self:SetTitle( "" )
	
	end

end

function PANEL:GetCount()

	return self.ItemCount or 0
	
end

function PANEL:AddCount( num )

	self:SetCount( self:GetCount() + num )

end

function PANEL:GetID()

	return self.ID or 0
	
end

function PANEL:IsStackable()

	return self.Stackable

end

function PANEL:SetItemTable( tbl )

	self:SetModel( tbl.Model, tbl.CamPos, tbl.CamOrigin )
	self.FuncList = tbl.Functions
	self.ID = tbl.ID
	self.IsWeapon = tbl.Weapon
	self.Stackable = tbl.Stackable
	self.PanelModel = tbl.Model
	
	if tbl.Sellable != nil and tbl.Sellable == false then
	
		self.NotSellable = true
		
	end

end

function PANEL:SetModel( model, campos, origin )

	self.ModelPanel = vgui.Create( "GoodModelPanel", self )
	self.ModelPanel:SetModel( model )
	self.ModelPanel.LayoutEntity = function( ent ) end
	self.ModelPanel:SetCamPos( Vector(20,10,5) )
	self.ModelPanel:SetLookAt( Vector(0,0,0) )
	self.ModelPanel.OnMousePressed = function( mc ) self:OnMousePressed( mc ) end
	self.ModelPanel.OnMouseReleased = function( mc ) self:OnMouseReleased( mc ) end
	
	if campos then
	
		self.ModelPanel:SetCamPos( campos )
		self.ModelPos = campos
		
	end
	
	if origin then
	
		self.ModelPanel:SetLookAt( origin )
		self.ModelOrigin = origin
		
	end

end

function PANEL:PerformLayout()
	
	if self.ModelPanel then
	
		self.ModelPanel:SetPos( self:GetPadding(), self:GetPadding() )
		self.ModelPanel:SetSize( 62, 62 )
	
	end

	self:SizeToContents()
	self:SetSize( 64, 64 )
	
end

function PANEL:Paint()

end

derma.DefineControl( "ItemPanel", "A HUD Element with a model in the middle", PANEL, "PanelBase" )
