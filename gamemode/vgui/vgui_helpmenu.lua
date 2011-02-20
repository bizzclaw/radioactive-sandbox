local PANEL = {}

PANEL.Text = { "The Inventory System:\n",
 "To toggle your inventory, press your spawn menu button (default Q). Right click an item in your inventory to interact with it. To interact with loot and stashes, press your USE key on them.\n\n",
 "Traders:\n",
 "Each faction has a trader NPC. Talk to your trader (press your USE key on it) in order to trade items and go on quests.\n\n",
 "Missions:\n",
 "If you go on a mission for your trader, your objective's direction will be marked by a compass on your radar. Talk to the trader when you complete the mission in order to earn cash.\n\n",
 "The Radar:\n",
 "The radar marks the position of many things. Blue dots are stashes and loot. White dots are traders. Red dots are enemies. Green dots are faction members. Beware, radioactive deposits are not marked on the radar.\n\n\n",
 "HEY SHITHEAD! READ ALL THIS CRAP IF YOU'RE A NEWBIE!" }

function PANEL:Init()

	self:SetTitle( "" )
	self:ShowCloseButton( false )
	self:ChooseParent()
	
	local text = ""
	
	for k,v in pairs( self.Text ) do
	
		text = text .. v
	
	end
	
	self.Label = vgui.Create( "DLabel", self )
	self.Label:SetWrap( true )
	self.Label:SetText( text )
	self.Label:SetFont( "ItemDisplayFont" )
	self.Label:SetSize( 400, 300 )
	
	self.Button = vgui.Create( "DButton", self )
	self.Button:SetText( "Ready" )
	self.Button.OnMousePressed = function()

		self:Remove() 
		
		if not GetConVar( "sv_radbox_allow_loners" ):GetBool() then
		
			GAMEMODE:ShowTeam()
			
		else
		
			RunConsoleCommand( "changeteam", TEAM_LONER )
		
		end
		
	end
	
end

function PANEL:ChooseParent()
	
end

function PANEL:GetPadding()
	return 5
end

function PANEL:PerformLayout()

	local x,y = self:GetPadding(), self:GetPadding()
	
	self.Label:SetPos( x, y )
	
	self.Button:SetSize( 48, 18 )
	self.Button:SetPos( self:GetWide() * 0.5 - self.Button:GetWide() * 0.5, y + 320 )
	
	self:SizeToContents()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	draw.SimpleText( "Radioactive Sandbox Help Menu", "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "HelpMenu", "A help menu.", PANEL, "PanelBase" )
