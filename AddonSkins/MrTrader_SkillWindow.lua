local aName, aObj = ...
if not aObj:isAddonEnabled("MrTrader_SkillWindow") then return end

function aObj:MrTrader_SkillWindow()

	-- hide filter texture when filter is clicked
	self:SecureHook("MRTUIUtils_FilterButton_SetType", function(btn, type, ...)
		btn:GetNormalTexture():SetAlpha(0)
		if type == "checkbox"
		or type == "command"
		then
			self.skinFrame[btn]:Hide()
		else
			self.skinFrame[btn]:Show()
		end
	end)

	self:skinEditBox{obj=MRTSkillFrameSearchBox, regs={9}, mi=true, noWidth=true}
	self:skinDropDown{obj=MRTSkillFrameSortDropDown}
	MRTSkillFilterButtons:DisableDrawLayer("OVERLAY") -- hide vertical bar
	-- Filter buttons
	for i = 1, 22 do
		local btn = _G["MRTSkillFilterButton"..i]
		btn:GetNormalTexture():SetAlpha(0)
		self:addSkinFrame{obj=btn}
	end
	self:skinScrollBar{obj=MRTSkillFilterScrollFrame}
	-- Reagents
	for i = 1, 10 do
		_G["MRTSkillButton"..i.."Border"]:SetBackdrop(nil)
		if self.modBtnBs then
			 self:addButtonBorder{obj=_G["MRTSkillButton"..i.."Icon"], ofs=3}
			 for j = 1, 4 do
			 	self:addButtonBorder{obj=_G["MRTSkillButton"..i.."ReagentLrg"..j]}
			 end
		end
	end
	self:skinScrollBar{obj=MRTSkillListScrollFrame}
	self:glazeStatusBar(MRTSkillRankFrame, 0, MRTSkillRankFrameBackground)
	self:skinEditBox{obj=MRTSkillInputBox, x=-6}
	self:addSkinFrame{obj=MRTSkillFrame, kfs=true, ri=true, y1=2, x2=1, y2=-2}
	-- Magic Button textures
	self:removeMagicBtnTex(MRTSkillViewCraftersButton)
	self:removeMagicBtnTex(MRTSkillCreateButton)
	self:removeMagicBtnTex(MRTSkillCreateAllButton)
	
-->>-- New Category frame
	self:skinEditBox{obj=MRTNewCategoryFrameCategoryName, regs={9}, x=-3}
	self:addSkinFrame{obj=MRTNewCategoryFrame, kfs=true, x1=5, y1=-6, x2=-5, y2=6}

end
