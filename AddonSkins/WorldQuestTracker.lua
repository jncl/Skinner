local aName, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTracker") then return end
local _G = _G

function aObj:WorldQuestTracker()

	self:SecureHook("ToggleWorldMap", function()
		if _G.WorldQuestTrackerGoToBIButton then
			_G.WorldQuestTrackerGoToBIButton.Background:SetTexture(nil)
			self:skinButton{obj=_G._G.WorldQuestTrackerGoToBIButton, ob3="World\nQuests", y1=2, y2=-1}
			self:Unhook("ToggleWorldMap")
		end
	end)

	_G.WorldQuestTrackerQuestsHeader.Background:SetTexture(nil)
	self:addButtonBorder{obj=_G.WorldQuestTrackerQuestsHeaderMinimizeButton, es=12, ofs=0}

end
