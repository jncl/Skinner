local aName, aObj = ...
local _G = _G

function aObj:WorldQuestGroupFinder()

	-- WQGFManualActionsFrame
	_G.WQGFManualActionsFrameTitleFrame:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.WQGFManualActionsFrame, ofs=-2}

	-- WorldQuestGroupCurrentWQFrame
	_G.WorldQuestGroupCurrentWQFrame:SetBackdrop(nil)
	_G.WorldQuestGroupCurrentWQFrame.SetBackdrop = _G.nop

end
