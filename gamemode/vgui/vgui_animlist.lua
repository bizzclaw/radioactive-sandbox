LastPose = nil

local PANEL = {}

function PANEL:Init()

	self:ShowCloseButton( false )
	self:SetKeyboardInputEnabled( false )
	self:SetDraggable( true ) 
	
	self.List = vgui.Create( "DComboBox", self )
	self.List.OnSelect = function( index, value, data )
		
		for k,v in pairs( GAMEMODE.PoseList ) do
		
			if data == v.Name then
			
				if v.Pose then
				
					if LastPose then
					
						LocalPlayer():StopLuaAnimation( LastPose )
					
					end
			
					RunConsoleCommand( "cl_radbox_pose", v.Pose )
					LocalPlayer():SetLuaAnimation( v.Pose )
					
				else
				
					RunConsoleCommand( "cl_radbox_pose" )
					LocalPlayer():StopAllLuaAnimations( 0.5 )
				
				end
				
				self:Remove()
				
				return
			
			end
			
		end
		
	end
	
	for k,v in pairs( GAMEMODE.PoseList ) do
	
		self.List:AddChoice( v.Name, v.Pose )
	
	end
	
end

function PANEL:GetPadding()

	return 20
	
end

function PANEL:PerformLayout()
	
	self.List:SetPos( self:GetWide() * 0.5 - self.List:GetWide() * 0.5, self:GetPadding() + 10 )
	self.List:SetSize( 200 - self:GetPadding() * 2, self:GetPadding() )

	self:SetSize( 200, self:GetPadding() * 3 + 10 )
	
end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	draw.SimpleText( "Animation List", "Default", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "AnimList", "A HUD Element with a list of poses.", PANEL, "PanelBase" )
