local _, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTab") then return end
local _G = _G

aObj.addonsToSkin.WorldQuestTab = function(self) -- v 8.3.03

	local tab
	for _, tabName in pairs{"Normal", "World", "Details"} do
		tab = _G["WQT_Tab" .. tabName]
		tab.TabBg:SetAlpha(0)
		tab.Hider:SetAlpha(0)
		-- use a button border to indicate the active tab
		self.modUIBtns:addButtonBorder{obj=tab, relTo=tab.Icon, ofs=1} -- use module function here to force creation
		self:clrBtnBdr(tab, "selected", 1)
		tab.Icon:SetSize(30, 28)
		tab.sbb:SetShown(tab == _G.WQT_WorldQuestFrame.selectedTa)
	end
	tab = nil
	-- hook this to manage the active tab
	self:SecureHook(_G.WQT_WorldQuestFrame, "SelectTab", function(this, tab)
		for _, tabName in pairs{"Normal", "World", "Details"} do
			_G["WQT_Tab" .. tabName].sbb:SetShown(_G["WQT_Tab" .. tabName] == tab)
		end
	end)

	_G.WQT_QuestLogFiller:DisableDrawLayer("BACKGROUND")
	_G.WQT_QuestLogFiller.DecorLeft:SetTexture(nil)
	_G.WQT_QuestLogFiller.DecorRight:SetTexture(nil)
	_G.WQT_QuestLogFiller.DecorRight2:SetTexture(nil)

	_G.WQT_WorldQuestFrame:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=_G.WQT_WorldQuestFrameSortButton, x1=0, x2=-1}

	-- self:addSkinFrame{obj=_G.WQT_WorldQuestFrameFilterDropDown, ft="a", kfs=true, nb=true}
	-- self:addSkinFrame{obj=_G.WQT_TrackDropDown, ft="a", kfs=true, nb=true}

	self:addSkinFrame{obj=_G.ADD_DropDownList1Backdrop, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.ADD_DropDownList1MenuBackdrop, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.ADD_DropDownList2Backdrop, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.ADD_DropDownList2MenuBackdrop, ft="a", kfs=true, nb=true}

	self:skinSlider{obj=_G.WQT_WorldQuestFrame.ScrollFrame.scrollBar, wdth=-6}
	_G.WQT_WorldQuestFrame.ScrollFrame.DetailFrame:DisableDrawLayer("ARTWORK")

	_G.WQT_OverlayFrame:DisableDrawLayer("BACKGROUND")
	_G.WQT_OverlayFrame:DisableDrawLayer("BORDER")
	_G.WQT_OverlayFrame.DetailFrame:DisableDrawLayer("ARTWORK")

	self:skinSlider{obj=_G.WQT_VersionFrame.scrollBar, rt="background", wdth=12}
	self:skinSlider{obj=_G.WQT_SettingsFrame.ScrollFrame.ScrollBar, rt="background", wdth=12}

	if self.modBtns then
		self:skinStdButton{obj=_G.WQT_WorldQuestFrame.FilterButton, aso={bbclr="grey"}}
	end

	for category in _G.WQT_SettingsFrame.categoryPool:EnumerateActive() do
		category:DisableDrawLayer("BACKGROUND")
		category:DisableDrawLayer("BORDER")
	end
	for template in _G.WQT_SettingsFrame.templatePools["WQT_SettingSliderTemplate"]:EnumerateActive() do
		self:skinSlider{obj=template.Slider}
		self:skinEditBox{obj=template.TextBox, regs={6}} -- 6 is text
	end
	for template in _G.WQT_SettingsFrame.templatePools["WQT_SettingDropDownTemplate"]:EnumerateActive() do
		self:skinDropDown{obj=template.DropDown, x1=0, x2=-1}
	end
	if self.modChkBtns then
		for template in _G.WQT_SettingsFrame.templatePools["WQT_SettingCheckboxTemplate"]:EnumerateActive() do
			self:skinCheckButton{obj=template.CheckBox}
		end
	end

	self:addSkinFrame{obj=_G.WQT_OldTaxiMapContainer, ft="a", kfs=true, nb=true, ri=true, ofs=0, x1=5, y2=-3}
	_G.WQT_FlightMapContainerButton.Border:SetTexture(nil)
	self:addSkinFrame{obj=_G.WQT_FlightMapContainer, ft="a", kfs=true, nb=true, ri=true, ofs=0, x1=5, y2=-3}
	_G.WQT_FlightMapContainerButton.Border:SetTexture(nil)
	self:addSkinFrame{obj=_G.WQT_WorldMapContainer, ft="a", kfs=true, nb=true, ri=true, ofs=0}
	_G.WQT_WorldMapContainerButton.Border:SetTexture(nil)

end
