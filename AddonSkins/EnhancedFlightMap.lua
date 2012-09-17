local aName, aObj = ...
if not aObj:isAddonEnabled("EnhancedFlightMap") then return end

function aObj:EnhancedFlightMap()

	-- Config
	self:applySkin{obj=EFM_GUI_Timer_Options}
	self:applySkin{obj=EFM_GUI_Display_Options}
	self:applySkin{obj=EFM_GUI_Preload_Data}
	-- do in reverse order as changing parents removes them from the previous list
	self:getRegion(TestScrollChild, 3):SetParent(EFM_GUI_Preload_Data)
	self:getRegion(TestScrollChild, 2):SetParent(EFM_GUI_Display_Options)
	self:getRegion(TestScrollChild, 1):SetParent(EFM_GUI_Timer_Options)

	-- Map
	self:applySkin(EFM_MapWindow)

	-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then EFM_ToolTip:SetBackdrop(backdrop) end
		self:SecureHookScript(EFM_ToolTip, "OnShow", function(this)
			self:skinTooltip(EFM_ToolTip)
		end)
	end
	
end
