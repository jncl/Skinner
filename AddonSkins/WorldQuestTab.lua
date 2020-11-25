local _, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTab") then return end
local _G = _G

aObj.addonsToSkin.WorldQuestTab = function(self) -- v 9.0.03

	-- tabs added to QuestLogFrame
	local tab
	for _, tabName in pairs{"Normal", "World", "Details"} do
		tab = _G["WQT_Tab" .. tabName]
		tab.TabBg:SetAlpha(0)
		tab.Hider:SetAlpha(0)
		-- use a button border to indicate the active tab
		self.modUIBtns:addButtonBorder{obj=tab, relTo=tab.Icon, ofs=3} -- use module function here to force creation
		self:clrBtnBdr(tab, "selected")
		tab.Icon:SetSize(28, 28)
		tab.sbb:SetShown(tab == _G.WQT_WorldQuestFrame.selectedTa)
	end
	tab = nil
	-- hook this to manage the active tab
	self:SecureHook(_G.WQT_WorldQuestFrame, "SelectTab", function(this, tab)
		for _, tabName in pairs{"Normal", "World", "Details"} do
			_G["WQT_Tab" .. tabName].sbb:SetShown(_G["WQT_Tab" .. tabName] == tab)
		end
	end)

	self:keepFontStrings(_G.WQT_QuestLogFiller)

	_G.WQT_WorldQuestFrame:DisableDrawLayer("BACKGROUND")
	self:skinObject("dropdown", {obj=_G.WQT_WorldQuestFrame.sortButton, x1=0, x2=-1, y2=-3})
	self:skinObject("slider", {obj=_G.WQT_WorldQuestFrame.ScrollFrame.scrollBar, x1=4, y1=-2, x2=-4, y2=2})
	self:keepFontStrings(_G.WQT_WorldQuestFrame.ScrollFrame.DetailFrame)
	self:keepFontStrings(_G.WQT_OverlayFrame)
	-- .CloseButton
	self:keepFontStrings(_G.WQT_OverlayFrame.DetailFrame)
	if self.modBtns then
		self:skinStdButton{obj=_G.WQT_WorldQuestFrame.FilterButton}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.WQT_WorldQuestFrame.SettingsButton, ofs=1}
	end
	self:SecureHook(_G.WQT_WorldQuestFrame, "SetCustomEnabled", function(this, value)
		self:checkDisabledDD(_G.WQT_WorldQuestFrame.sortButton, not _G.WQT_WorldQuestFrame.sortButton:IsEnabled())
		if self.modBtns then
			self:clrBtnBdr(this.FilterButton)
		end
		if self.modBtnBs then
			self:clrBtnBdr(this.SettingsButton)
		end
	end)

	-- TODO: WQT_GroupSearch

	-- Settings
	self:skinObject("slider", {obj=_G.WQT_VersionFrame.scrollBar, x1=-6, x2=5})
	self:skinObject("slider", {obj=_G.WQT_SettingsFrame.ScrollFrame.ScrollBar, x1=-6, x2=5})
	for category in _G.WQT_SettingsFrame.categoryPool:EnumerateActive() do
		category:DisableDrawLayer("BACKGROUND")
		category:DisableDrawLayer("BORDER")
	end
	for template in _G.WQT_SettingsFrame.templatePools["WQT_SettingSliderTemplate"]:EnumerateActive() do
		self:skinObject("slider", {obj=template.Slider})
		self:skinObject("editbox", {obj=template.TextBox})
	end
	for template in _G.WQT_SettingsFrame.templatePools["WQT_SettingDropDownTemplate"]:EnumerateActive() do
		self:skinObject("dropdown", {obj=template.DropDown, x1=0, x2=-1, y2=-3})
	end
	for template in _G.WQT_SettingsFrame.templatePools["WQT_SettingTextInputTemplate"]:EnumerateActive() do
		self:skinObject("editbox", {obj=template.TextBox})
	end
	if self.modBtns then
		for template in _G.WQT_SettingsFrame.templatePools["WQT_SettingButtonTemplate"]:EnumerateActive() do
			self:skinStdButton{obj=template.Button}
			self:SecureHook(template, "SetDisabled", function(this, value)
				self:clrBtnBdr(this.Button)
			end)
		end
		for template in _G.WQT_SettingsFrame.templatePools["WQT_SettingConfirmButtonTemplate"]:EnumerateActive() do
			self:skinStdButton{obj=template.Button}
			self:SecureHook(template, "SetDisabled", function(this, value)
				self:clrBtnBdr(this.Button)
			end)
			self:skinStdButton{obj=template.ButtonConfirm}
			self:skinStdButton{obj=template.ButtonDecline}
		end
	end
	if self.modChkBtns then
		for template in _G.WQT_SettingsFrame.templatePools["WQT_SettingCheckboxTemplate"]:EnumerateActive() do
			self:skinCheckButton{obj=template.CheckBox}
		end
	end

	self:skinObject("frame", {obj=_G.WQT_OldTaxiMapContainer, kfs=true, ri=true, ofs=0})
	_G.WQT_FlightMapContainerButton.Border:SetTexture(nil) -- ring texture
	self:skinObject("frame", {obj=_G.WQT_FlightMapContainer, kfs=true, ri=true, ofs=0})
	_G.WQT_FlightMapContainerButton.Border:SetTexture(nil) -- ring texture
	self:skinObject("frame", {obj=_G.WQT_WorldMapContainer, kfs=true, ri=true, ofs=0})
	_G.WQT_WorldMapContainerButton.Border:SetTexture(nil) -- ring texture

end
