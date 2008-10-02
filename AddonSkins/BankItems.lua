
function Skinner:BankItems()
	if not self.db.profile.BankFrame then return end

	self:keepFontStrings(BankItems_Frame)
	self:moveObject(BankItems_TitleText, nil, nil, "+", 10)
	self:moveObject(BankItems_CloseButton, nil, nil, "+", 10)
	self:moveObject(self:getRegion(BankItems_Frame, 5), nil, nil, "+", 10) -- Version text
	self:moveObject(BankItems_GuildBankButton, "+", 0, "+", 5)
	self:skinDropDown(BankItems_UserDropdown)
	self:applySkin(BankItems_Frame)
	local BAGNUMBERS = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 100, 101} -- Equipped is 100, Mail is 101
	for _, i in ipairs(BAGNUMBERS) do
		local name = _G["BankItems_ContainerFrame"..i]
		self:keepFontStrings(name)
		self:applySkin(name)
	end

-->>--	Options Frame
	self:keepFontStrings(BankItems_OptionsFrame)
	self:SecureHook(BankItems_OptionsFrame, "Show", function(this)
		self:moveObject(self:getRegion(BankItems_OptionsFrame, 2), nil, nil, "-", 4) -- Title text
		self:Unhook(BankItems_OptionsFrame, "Show")
	end)
	self:moveObject(self:getRegion(BankItems_OptionsFrame, 2), nil, nil, "-", 4) -- Title text
	self:skinDropDown(BankItems_GTTDropDown)
	self:skinDropDown(BankItems_BehaviorDropDown)
	self:applySkin(BankItems_OptionsFrame)
-->>--	Export Frame
	self:moveObject(self:getRegion(BankItems_ExportFrame_Scroll, 1), nil, nil, "-", 4) -- Title text
	self:removeRegions(BankItems_ExportFrame_Scroll)
	self:skinScrollBar(BankItems_ExportFrame_Scroll)
	self:keepFontStrings(BankItems_ExportFrame_SearchDropDown)
	self:skinEditBox(BankItems_ExportFrame_SearchTextbox, {9})
	self:applySkin(BankItems_ExportFrame)
-->>--	GuildBank Frame
	self:keepFontStrings(BankItems_GBFrame)
	self:moveObject(BankItems_GBFrame_CloseButton, nil, nil, "+", 10)
	self:skinDropDown(BankItems_GuildDropdown)
	self:moveObject(self:getRegion(BankItems_GBFrame, 4), nil, nil, "-", 4) -- Title text
	self:applySkin(BankItems_GBFrame)

end
