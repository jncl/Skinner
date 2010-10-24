if not Skinner:isAddonEnabled("MrTrader_SkillWindow") then return end

function Skinner:MrTrader_SkillWindow()

	-- hide filter texture when filter is clicked
	self:SecureHook("MRTUIUtils_FilterButton_SetType", function(btn, type, ...)
		self:Debug("MRTUIU_FB_ST: [%s, %s, %s, %s, %s, %s]", btn, type, ...)
		btn:GetNormalTexture():SetAlpha(0)
		if type == "checkbox"
		or type == "command"
		then
			self.skinFrame[btn]:Hide()
		else
			self.skinFrame[btn]:Show()
		end
	end)

	self:skinDropDown{obj=MRTSkillItemDropDown}
	self:skinEditBox{obj=MRTSkillFrameEditBox}
	-- Filter buttons
	for i = 1, 22 do
		local btn = _G["MRTSkillFilterButton"..i]
		btn:GetNormalTexture():SetAlpha(0)
		self:addSkinFrame{obj=btn}
	end
	self:skinScrollBar{obj=MRTSkillFilterScrollFrame}
	self:skinScrollBar{obj=MRTSkillListScrollFrame}
	self:glazeStatusBar(MRTSkillRankFrame, 0, MRTSkillRankFrameBackground)
	self:skinEditBox{obj=MRTSkillInputBox, x=-6}
	self:addSkinFrame{obj=MRTSkillFrame, kfs=true, x1=10, y1=-11, x2=0, y2=71}
	-- Reagents
	for i = 1, 10 do
		_G["MRTSkillButton"..i.."Border"]:SetBackdrop(nil)
	end

-->>-- New Category frame
	self:skinEditBox{obj=MRTNewCategoryFrameCategoryName, x=-3}
	self:addSkinFrame{obj=MRTNewCategoryFrame, kfs=true, x1=5, y1=-6, x2=-5, y2=6}

end
