
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

	local xOfs, yOfs, yOfs2 = 40, 10, 12
	self:keepFontStrings(ACP_AddonListSortDropDown)
	self:moveObject(ACP_AddonListCloseButton, "+", xOfs, nil, nil)
	self:moveObject(ACP_AddonListCollapseAll, nil, nil, "+", yOfs)
	self:moveObject(ACP_AddonListEntry1, nil, nil, "+", yOfs)
	self:keepFontStrings(ACP_AddonList_ScrollFrame)
	self:moveObject(ACP_AddonList_ScrollFrame, "+", xOfs, nil, nil)
	self:skinScrollBar(ACP_AddonList_ScrollFrame)
	self:moveObject(ACP_AddonListDisableAll, nil, nil, "-", yOfs2)
	self:moveObject(ACP_AddonListEnableAll, nil, nil, "-", yOfs2)
	self:moveObject(ACP_AddonListSetButton, nil, nil, "-", yOfs2)
	self:moveObject(ACP_AddonList_ReloadUI, nil, nil, "-", yOfs2)
	self:moveObject(ACP_AddonListBottomClose, nil, nil, "-", yOfs2)
	self:keepFontStrings(ACP_AddonList)
	self:applySkin(ACP_AddonList, true)

end
