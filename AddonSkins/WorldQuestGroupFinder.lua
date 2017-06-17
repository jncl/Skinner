local aName, aObj = ...
if not aObj:isAddonEnabled("WorldQuestGroupFinder") then return end
local _G = _G

function aObj:WorldQuestGroupFinder()

	-- WQGFManualActionsFrame
	_G.WQGFManualActionsFrameTitleFrame:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.WQGFManualActionsFrame, ofs=-2}

	-- WorldQuestGroupCurrentWQFrame
	_G.WorldQuestGroupCurrentWQFrame:SetBackdrop(nil)
	_G.WorldQuestGroupCurrentWQFrame.SetBackdrop = _G.nop

end
