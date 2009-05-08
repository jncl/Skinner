
function Skinner:Examiner()
	if not self.db.profile.InspectUI then return end

	self:keepRegions(Examiner, {2, 3, 4, 9, 10, 11, 12}) -- N.B. 2-4 are text and 9-12 are background regions
	self:addSkinFrame{obj=Examiner, x1=10, y1=-11, x2=-33}

-->>--	Config Frame
	self:addSkinFrame{obj=Examiner.frames[1]}
-->>--	Cache Frame
	self:skinScrollBar{obj=ExaminerCacheScroll}
	self:addSkinFrame{obj=Examiner.frames[2]}
-->>--	Stats Frame
	self:skinScrollBar{obj=ExaminerStatScroll}
	self:addSkinFrame{obj=Examiner.frames[3]}
-->>--	PVP Frame
	for i = 1, #Examiner.arena do
		self:addSkinFrame{obj=Examiner.arena[i]}
	end
	self:addSkinFrame{obj=Examiner.frames[4]}
-->>-- Feats Frame
	Examiner.featsDropDown:SetBackdrop(nil)
	-- hook this to skin the dropdown menu
	self:SecureHookScript(Examiner.featsDropDown.button, "OnClick", function(this)
		self:skinScrollBar{obj=_G["AzDropDownScroll"..AzDropDown.vers]}
		self:addSkinFrame{obj=_G["AzDropDownScroll"..AzDropDown.vers]:GetParent()}
		self:Unhook(Examiner.featsDropDown.button, "OnClick")
	end)
	self:skinScrollBar{obj=ExaminerFeatsScroll}
	self:addSkinFrame{obj=Examiner.frames[5]}
-->>--	Talent Frame
	self:skinFFToggleTabs("ExaminerTab", MAX_TALENT_TABS)
	self:skinScrollBar{obj=ExaminerTalentsScrollChild}

end
