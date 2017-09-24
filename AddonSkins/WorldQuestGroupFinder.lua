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

	-- skin existing WQGFButtons
	local function skinWQGFBtn(btn)
		aObj:removeRegions(btn, {2, 4})
		btn:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
		btn:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
		aObj:addButtonBorder{obj=btn, ofs=0}
		aObj:moveObject{obj=btn, y=4}
		btn:SetScript("OnLeave", function() _G.GameTooltip:Hide() end)
	end
	local kids, child = {_G.ObjectiveTrackerFrame.BlocksFrame:GetChildren()}
	for i = 1, #kids do
		child = kids[i]
		if child.WQGFButton then
			skinWQGFBtn(child.WQGFButton)
		end
	end
	kids, child = nil, nil

	-- hook  this to skin new WQGFButtons
 	self:RawHook(_G.WorldQuestGroupFinder, "CreateWQGFButton", function(block, questID)
		local gfb = self.hooks[_G.WorldQuestGroupFinder].CreateWQGFButton(block, questID)
		skinWQGFBtn(gfb)
		return gfb
	end, true)

end
