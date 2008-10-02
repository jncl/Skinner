
function Skinner:epgp()

-->>--	Main UI
	self:keepFontStrings(EPGPFrame)
	EPGPFrame:SetWidth(EPGPFrame:GetWidth() * self.FxMult)
	EPGPFrame:SetHeight(EPGPFrame:GetHeight() * self.FyMult)
	self:moveObject(EPGPFrameTitleText, nil, nil, "-", 20)
	self:moveObject(EPGPFramePageText, "+", 10, "-", 76)
	self:moveObject(EPGPFrameCloseButton, "+", 28, "+", 8)
	self:applySkin(EPGPFrame)
-->>--	Tabs
	self:keepRegions(EPGPFrameTab1, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	self:keepRegions(EPGPFrameTab2, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	self:moveObject(EPGPFrameTab1, nil, nil, "-", 71)
	self:moveObject(EPGPFrameTab2, "+", 12, nil, nil)
	if self.db.profile.TexturedTab then
		self:applySkin(EPGPFrameTab1, nil, 0, 1)
		self:applySkin(EPGPFrameTab2, nil, 0, 1)
		self:SecureHook("ATemplates_SetTab", function(parent, id)
--			self:Debug("AT_ST: [%s, %s]", parent, id)
			if id == 1 then
				self:setActiveTab(EPGPFrameTab1)
				self:setInactiveTab(EPGPFrameTab2)
			else
				self:setActiveTab(EPGPFrameTab2)
				self:setInactiveTab(EPGPFrameTab1)
			end
		end)
	else
		self:applySkin(EPGPFrameTab1)
		self:applySkin(EPGPFrameTab2)
	end
-->>--	Standings Frame
	self:keepFontStrings(EPGPFramePage1)
	self:keepFontStrings(EPGPFramePage1ListDropDown)
	self:moveObject(EPGPFramePage1ListDropDown, "+", 30, nil, nil)
	self:skinEditBox(EPGPListingSearchBox, {9})
	self:moveObject(EPGPListingSearchBox, "+", 30, nil, nil)
	self:moveObject(EPGPListingNameColumnHeader, "-", 10, nil, nil)
	self:keepFontStrings(EPGPScrollFrame)
	self:skinScrollBar(EPGPScrollFrame)
	self:skinEditBox(EPGPFramePage1InputBox, {9})
	self:moveObject(EPGPFramePage1InputBoxLabel, nil, nil, "-", 18)
-->>--	Options Menu Frame
	self:keepFontStrings(EPGPFramePage2MasterLootPopupQualityThreshold)
	self:keepFontStrings(EPGPFramePage2ReportChannelDropDown)
	self:moveObject(EPGPFramePage2BackupButton, nil, nil, "-", 76)

end
