
function Skinner:Examiner()
	if not self.db.profile.Inspect then return end

	Examiner:SetWidth(Examiner:GetWidth() * self.FxMult)
	Examiner:SetHeight(Examiner:GetHeight() + 6)
	self:keepRegions(Examiner, {2, 3, 4, 9, 10, 11, 12}) -- N.B. 2-4 are text and 9-12 are background regions
	self:moveObject(self:getChild(Examiner, 1), "+", 30, "+", 8)
	self:moveObject(Examiner.buttons[1], "-", 10, "-", 6)
	self:moveObject(self:getRegion(Examiner, 9), "-", 10, "+", 10)
	self:keepFontStrings(ExaminerDropDown)
	self:moveObject(Examiner.model, "+", 10, nil, nil) -- will move all its children as well
	self:applySkin(Examiner)

-->>--	Config Frame
	self:applySkin(Examiner.frames[1])
-->>--	Cache Frame
	self:keepFontStrings(ExaminerCacheScroll)
	self:skinScrollBar(ExaminerCacheScroll)
	self:applySkin(Examiner.frames[2])
-->>--	Stats Frame
	self:keepFontStrings(ExaminerStatScroll)
	self:skinScrollBar(ExaminerStatScroll)
	self:applySkin(Examiner.frames[3])
-->>--	PVP Frame
	for i = 1, #Examiner.arena do
		self:applySkin(Examiner.arena[i])
	end
	self:applySkin(Examiner.frames[4])
-->>--	Talent Frame
	self:skinFFToggleTabs("ExaminerTab", 3)
	self:keepFontStrings(ExaminerTalentsScrollChild)
	self:skinScrollBar(ExaminerTalentsScrollChild)

end
