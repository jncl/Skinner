local aName, aObj = ...
if not aObj:isAddonEnabled("WorldQuestGroupFinder") then return end
local _G = _G

aObj.addonsToSkin.WorldQuestGroupFinder = function(self) -- v 0.27

	self:SecureHookScript(_G.WQGFManualActionsFrame, "OnShow", function(this)
		this.TitleFrame:SetBackdrop(nil)
		self:skinStdButton{obj=this.NextButton}
		self:addSkinFrame{obj=this, ft="a", ofs=-2}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.WorldQuestGroupFinder, "AttachBorderToWQ", function(wqID, update)
		_G.WorldQuestGroupCurrentWQFrame:SetBackdrop(nil)
		_G.WorldQuestGroupCurrentWQFrame.SetBackdrop = _G.nop
		self:Unhook(_G.WorldQuestGroupFinder, "AttachBorderToWQ")
	end)

	-- skin WQGFButtons
	local function skinWQGFBtn(btn)

		aObj:removeRegions(btn, {2, 4})
		btn:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
		btn:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
		aObj:addButtonBorder{obj=btn, ofs=0}
		aObj:moveObject{obj=btn, y=4}
		btn:SetScript("OnLeave", function() _G.GameTooltip:Hide() end)

	end

	for _, child in _G.ipairs{_G.ObjectiveTrackerFrame.BlocksFrame:GetChildren()} do
		if child.WQGFButton then
			skinWQGFBtn(child.WQGFButton)
		end
	end

	-- hook  this to skin new WQGFButtons
 	self:RawHook(_G.WorldQuestGroupFinder, "CreateWQGFButton", function(block, questID)
		local gfb = self.hooks[_G.WorldQuestGroupFinder].CreateWQGFButton(block, questID)
		skinWQGFBtn(gfb)
		return gfb
	end, true)

end
