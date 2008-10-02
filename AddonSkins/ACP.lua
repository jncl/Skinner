
function Skinner:ACP()

	-- change the scale to match other frames
	ACP_AddonList:SetScale(GameMenuFrame:GetEffectiveScale())

	ACP_AddonList:SetWidth(ACP_AddonList:GetWidth() * self.FxMult)
	ACP_AddonList:SetHeight(ACP_AddonList:GetHeight() * self.FyMult)

	-- resize the frame's children to match the frame size
	for i = 1, select("#", ACP_AddonList:GetChildren()) do
		local v = select(i, ACP_AddonList:GetChildren())
		v:SetWidth(v:GetWidth() * self.FxMult)
		v:SetHeight(v:GetHeight() * self.FyMult)
	end

	self:keepFontStrings(ACP_AddonListSortDropDown)
	self:moveObject(ACP_AddonListCloseButton, "+", 40, nil, nil)
	self:moveObject(ACP_AddonListCollapseAll, nil, nil, "+", 10)
	self:moveObject(ACP_AddonListEntry1, nil, nil, "+", 10)
	self:keepFontStrings(ACP_AddonList_ScrollFrame)
	self:moveObject(ACP_AddonList_ScrollFrame, "+", 40, nil, nil)
	self:skinScrollBar(ACP_AddonList_ScrollFrame)
	self:moveObject(ACP_AddonListDisableAll, nil, nil, "-", 12)
	self:moveObject(ACP_AddonListEnableAll, nil, nil, "-", 12)
	self:moveObject(ACP_AddonListSetButton, nil, nil, "-", 12)
	self:moveObject(ACP_AddonList_ReloadUI, nil, nil, "-", 12)
	self:keepFontStrings(ACP_AddonList)
	self:applySkin(ACP_AddonList, true)

end
