local PANEL = {}

PANEL.Text = { "<html><body style=\"background-color:DimGray;\">",
"<p style=\"font-family:tahoma;color:red;font-size:25;text-align:center\"><b>READ THIS, NOOBLET!</b></p>",
"<p style=\"font-family:verdana;color:black;font-size:10px;text-align:left\"><b>The Inventory System:</b> ",
"To toggle your inventory, press your spawn menu button (default Q). Right click an item in your inventory to interact with it. You can also bind certain items to your F3 and F4 keys using the right click menu. To interact with dropped loot and stashes, press your USE key (default E) on them.<br><br>",
"<b>Faction Trader NPCs:</b> Each faction has a trader NPC. Talk to your trader (with your USE key) in order to trade items, store items permanently and go on quests.<br><br>",
"<b>Missions:</b> If you go on a mission for your trader, your objective's direction will be marked by a compass on your radar. Talk to the trader when you complete the mission in order to earn money.<br><br>",
"<b>The HUD:</b> The radar marks the position of many things. Blue dots are stashes and loot. White dots are traders. Red dots are enemies. Green dots are friendly faction members. Orange dots are other faction members. If an other faction member stands still they will not appear on the radar.",
"If you have radiation poisoning, an icon indicating the severity of the poisoning will appear on the bottom left of your screen. An icon will also appear if you are bleeding.<br><br>",
"<b>Radiation:</b> Radiation is visually unnoticeable. When near radiation, your handheld geiger counter will make sounds indicating how close you are to a radioactive deposit. Radiation poisoning is cured by vodka or Anti-Rad.<br><br>",
"<b>Anomalies:</b> Anomalies appear randomly around the map. Some anomalies are more dangerous than others, and most of them cannot be destroyed. Certain anomalies are often difficult to spot without a Field Detector Module, and some are quite easy to notice.<br><br>",
"<b>Artifacts:</b> Artifacts are the rarest and most expensive items. They are produced by most anomalies. Certain anomalies may produce artifacts when damaged. <br><br>",
"<b>Player Animations:</b> You can make yourself do custom animations by right clicking while you have the 'Hands' weapon out. Press your WALK key (default alt) while holding a weapon to holster it.<br><br>",
"<b>Chat Modes:</b> You can whisper, talk locally, use your radio or do emotes by ticking the appropriate checkbox above the chat panel (if the server has it activated). Team chat works the same as in any other gamemode.</p><br><br>" }

function PANEL:Init()

	self:SetTitle( "" )
	self:ShowCloseButton( false )
	self:ChooseParent()
	
	local text = ""
	
	for k,v in pairs( self.Text ) do
	
		text = text .. v
	
	end
	
	self.Label = vgui.Create( "HTML", self )
	self.Label:SetHTML( text )
	
	self.Entry = vgui.Create( "DTextEntry", self )
	self.Entry:SetText( "Character Name (OPTIONAL)" )
	self.Entry:SetEditable( true )
	self.Entry.OnMousePressed = function( mcode )
	
		self.Entry:SetText( "" )
	
	end
	
	self.Button = vgui.Create( "DButton", self )
	self.Button:SetText( "Let Me Play, Goddamnit" )
	self.Button.OnMousePressed = function()

		self:Remove() 
		
		if self.Entry:GetText() != "Character Name (OPTIONAL)" and self.Entry:GetText() != "" then
		
			RunConsoleCommand( "cl_radbox_character_name", unpack( string.Explode( " ", self.Entry:GetText() ) ) )
		
		end
		
		if LocalPlayer():Team() != TEAM_UNASSIGNED then return end
		
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

	local x,y = self:GetPadding(), self:GetPadding() + 10
	
	self.Label:SetSize( self:GetWide() - ( self:GetPadding() * 2 ) - 5, self:GetTall() - 50 )
	self.Label:SetPos( x + 5, y + 5 )
	
	self.Entry:SetSize( 150, 20 )
	self.Entry:SetPos( self:GetWide() * 0.5 - self.Entry:GetWide() - 5, self:GetTall()- 30 ) 
	
	self.Button:SetSize( 150, 20 )
	self.Button:SetPos( self:GetWide() * 0.5 + 5, self:GetTall() - 30 )
	
	self:SizeToContents()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	draw.SimpleText( "Radioactive Sandbox Help Menu", "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "HelpMenu", "A help menu.", PANEL, "PanelBase" )
