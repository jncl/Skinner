
function Skinner:Badapples()
	if not self.db.profile.FriendsFrame then return end

-->>--	BadapplesFrame
	self:keepRegions(BadapplesFriendsFrameTab6, {7, 8}) -- N.B. these regions are text & highlight
	self:moveObject(BadapplesFriendsFrameTab6, "+", 9, nil, nil)
	if self.db.profile.TexturedTab then self:applySkin(BadapplesFriendsFrameTab6, nil ,0)
	else self:applySkin(BadapplesFriendsFrameTab6) end
	-- move the 1st tab so they all fit
	self:moveObject(FriendsFrameTab1, "-", 6, nil, nil)  -- TODO this is not working

	-- TODO onclick the tab(s) changes, fix this
	self:keepRegions(BadapplesFriendsFrameToggleTab4, {7, 8}) -- N.B. these regions are text & highlight
	BadapplesFriendsFrameToggleTab4:SetHeight(BadapplesFriendsFrameToggleTab4:GetHeight() - 5)
	self:moveObject(_G["BadapplesFriendsFrameToggleTab4Text"], "-", 2, "+", 3)
	self:moveObject(_G["BadapplesFriendsFrameToggleTab4HighlightTexture"], "-", 2, "+", 5)
	self:applySkin(BadapplesFriendsFrameToggleTab4)

	self:keepRegions(BadapplesIgnoreFrameToggleTab4, {7, 8}) -- N.B. these regions are text & highlight
	BadapplesIgnoreFrameToggleTab4:SetHeight(BadapplesIgnoreFrameToggleTab4:GetHeight() - 5)
	self:moveObject(_G["BadapplesIgnoreFrameToggleTab4Text"], "-", 2, "+", 3)
	self:moveObject(_G["BadapplesIgnoreFrameToggleTab4HighlightTexture"], "-", 2, "+", 5)
	self:applySkin(BadapplesIgnoreFrameToggleTab4)

	self:keepRegions(BadapplesMutedFrameToggleTab4, {7, 8}) -- N.B. these regions are text & highlight
	BadapplesMutedFrameToggleTab4:SetHeight(BadapplesMutedFrameToggleTab4:GetHeight() - 5)
	self:moveObject(_G["BadapplesMutedFrameToggleTab4Text"], "-", 2, "+", 3)
	self:moveObject(_G["BadapplesMutedFrameToggleTab4HighlightTexture"], "-", 2, "+", 5)
	self:applySkin(BadapplesMutedFrameToggleTab4)

	for i = 1, 4 do
		local togTab = _G["BadapplesFrameToggleTab"..i]
		self:keepRegions(togTab, {7, 8}) -- N.B. regions 7 & 8 are text & highlight
		togTab:SetHeight(togTab:GetHeight() - 5)
		if i == 1 then self:moveObject(togTab, nil, nil, "+", 3) end
		self:moveObject(_G[togTab:GetName().."Text"], "-", 2, "+", 3)
		self:moveObject(_G[togTab:GetName().."HighlightTexture"], "-", 2, "+", 5)
		self:applySkin(togTab)
	end
-->--	Side Tab
	self:removeRegions(BadapplesFriendsFrameSideTab1, {1}) -- N.B. other regions are icon and highlight
	BadapplesFriendsFrameSideTab1:SetWidth(BadapplesFriendsFrameSideTab1:GetWidth() * 1.25)
	BadapplesFriendsFrameSideTab1:SetHeight(BadapplesFriendsFrameSideTab1:GetHeight() * 1.25)
	self:moveObject(BadapplesFriendsFrameSideTab1, "+", 29, nil, nil)
	self:applySkin(BadapplesFriendsFrameSideTab1)

	self:keepFontStrings(BadapplesListScrollFrame)
	self:moveObject(BadapplesListScrollFrame, "+", 35, "+", 10)
	self:skinScrollBar(BadapplesListScrollFrame)
	self:keepFontStrings(BadapplesDropDown)
	self:moveObject(BadapplesFrameEditBox, "+", 10, "-", 76)
	self:skinEditBox(BadapplesFrameEditBox, {9})
	self:keepFontStrings(BadapplesFrameNameColumnHeader)
	self:moveObject(BadapplesFrameNameColumnHeader, nil, nil, "+", 10)
	self:applySkin(BadapplesFrameNameColumnHeader)
	self:keepFontStrings(BadapplesFrameReasonColumnHeader)
	self:applySkin(BadapplesFrameReasonColumnHeader)
	self:moveObject(BadapplesFrameTotals, nil, nil, "-", 80)
	self:moveObject(BadapplesFrameRemoveButton, "+", 30, "-", 76)
	self:keepFontStrings(BadapplesFrame)

end
