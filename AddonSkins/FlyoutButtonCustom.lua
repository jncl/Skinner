local aName, aObj = ...
if not aObj:isAddonEnabled("FlyoutButtonCustom") then return end

function aObj:FlyoutButtonCustom()

	-- turn off borders and keep them off
	FbcShowBorders = nil
	FlyoutButtonCustom_Settings = FlyoutButtonCustom_Settings or {}
	FlyoutButtonCustom_Settings["ShowBorders"] = false
	local mt = {__newindex = function(t, k, v)
		if k == "ShowBorders" then
			FbcShowBorders = nil
			rawset(t, k, false)
			return
		else rawset(t, k, v) end
	end}
	setmetatable(FlyoutButtonCustom_Settings, mt)
	
	-- Settings frame
	self:ScheduleTimer(function() aObj:addSkinFrame{obj=FBCSettingsDialog, kfs=true, y1=2, x2=2} end, 5)

end
