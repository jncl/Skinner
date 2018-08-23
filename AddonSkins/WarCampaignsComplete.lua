local aName, aObj = ...
if not aObj:isAddonEnabled("WarCampaignsComplete") then return end
local _G = _G

aObj.addonsToSkin.WarCampaignsComplete = function(self) -- v 1.0

	local WCCUIMF = "WarCampaignsCompleteUIMainFrame"

	self:addSkinFrame{obj=_G[WCCUIMF], ft="a", kfs=true, ri=true, ofs=2, x2=1}

	self:skinTabs{obj=_G[WCCUIMF .. "SubFrameHeader"]}

	-- Monitor Tab (1)
	self:addButtonBorder{obj=_G[WCCUIMF .. "Tab1SubFrameRefreshButton"], ofs=-2, x1=1}
	for _, type in pairs{"Name", "Lvl", "XP", "AP", "Buttons"} do
		self:keepRegions(_G[WCCUIMF .. "Tab1SubFrame" .. type .. "ColumnHeaderButton"], {4, 5, 6})
		self:addSkinFrame{obj=_G[WCCUIMF .. "Tab1SubFrame" .. type .. "ColumnHeaderButton"], ft="a", nb=true, aso={bd=5}}
	end
	self:skinSlider{obj=_G[WCCUIMF .. "Tab1SubFrameScrollFrame"].ScrollBar, rt="artwork"}
	if self.modBtnBs then
		self:SecureHookScript(_G[WCCUIMF .. "Tab1SubFrameScrollFrame"], "OnUpdate", function(this)
			for i = 1, _G[WCCUIMF .. "Tab1SubFrameScrollFrame"].numToDisplay do
				_G[WCCUIMF .. "Tab1SubFrame_ScrollFrameButton" .. i .. "BG"]:SetTexture(nil)
				for j = 1, 4 do
					local btn = WCCUIMF .. "Tab1SubFrame_ScrollFrameButton" .. i .. "Monitor" .. j
					self:addButtonBorder{obj=_G[btn], reParent={_G[btn .. "TopRightText"], _G[btn .. "CenterText"], _G[btn .. "Indicator"]}}
				end
			end
		end)
	end
	_G[WCCUIMF .. "Tab1SubFrameFooterBG"]:SetTexture(nil)
	-- skin footer buttons
	if self.modBtnBs then
		self:addButtonBorder{obj=_G[WCCUIMF .. "Tab1SubFrameFooterMissionsReportButton"]}
		self:addButtonBorder{obj=_G[WCCUIMF .. "Tab1SubFrameFooterAdvancementsReportButton"]}
		self:addButtonBorder{obj=_G[WCCUIMF .. "Tab1SubFrameFooterWorkOrdersReportButton"]}
	end

	-- Characters Tab (2)
	self:skinDropDown{obj=_G[WCCUIMF .. "Tab2SubFrameCharacterDropDownMenu"]}
	self:skinSlider{obj=_G[WCCUIMF .. "Tab2SubFrameScrollFrame"].ScrollBar, rt="artwork"}
	if self.modBtnBs then
		for i = 1, _G[WCCUIMF .. "Tab2SubFrameScrollFrame"].numToDisplay do
			local btn = WCCUIMF .. "Tab2SubFrame_ScrollFrameButton" .. i
			self:addButtonBorder{obj=_G[btn], relTo=_G[btn .. "_IconTexture"]}
			_G.RaiseFrameLevel(_G[btn].sbb)
			if self.modChkBtns then
				self:skinCheckButton{obj=_G[btn .. "_Check"]}
			end
		end
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab2SubFrameOrderAutomaticallyCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab2SubFrameCurrentCharacterFirstCheckButton"]}
	end
	if self.modBtns then
		self:skinStdButton{obj=_G[WCCUIMF .. "Tab2SubFrameOrderButton"]}
		self:skinStdButton{obj=_G[WCCUIMF .. "Tab2SubFrameDeleteCharacterButton"]}
		self:skinStdButton{obj=_G[WCCUIMF .. "Tab2SubFrameUncheckAllButton"]}
		self:skinStdButton{obj=_G[WCCUIMF .. "Tab2SubFrameCheckAllButton"]}
	end

	-- Misc Tab (3)
	if self.modChkBtns then
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab3SubFrameShowMinimapButtonCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab3SubFrameShowCharacterTooltipMinimapButtonCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab3SubFrameDockMinimapButtonCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab3SubFrameLockMinimapButtonCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab3SubFrameLargeMinimapButtonCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab3SubFrameShowOriginalMissionsReportMinimapButtonCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab3SubFrameShowTroopDetailsInTooltipCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab3SubFrameShowCharacterRealmsCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab3SubFrameForgetDragPositionCheckButton"]}
	end
	self:skinDropDown{obj=_G[WCCUIMF .. "Tab3SubFrameMonitorRowsDropDownMenu"]}
	self:skinDropDown{obj=_G[WCCUIMF .. "Tab3SubFrameMonitorColumnsDropDownMenu"]}
	if self.modBtns then
		self:skinStdButton{obj=_G[WCCUIMF .. "Tab3SubFrameCenterButton"]}
		self:skinStdButton{obj=_G[WCCUIMF .. "Tab3SubFrameReloadUIButton"]}
		self:skinStdButton{obj=_G[WCCUIMF .. "Tab3SubFrameColumnButton"]}
		self:skinStdButton{obj=_G[WCCUIMF .. "Tab3SubFrameResetButton"]}
	end

	-- Alert Tab (4)
	self:skinDropDown{obj=_G[WCCUIMF .. "Tab4SubFrameAlertDropDownMenu"]}
	if self.modChkBtns then
		-- skin check buttons
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab4SubFrameAlertMissionsCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab4SubFrameAlertAdvancementsCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab4SubFrameAlertTroopsCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab4SubFrameAlertDisableInInstancesCheckButton"]}
	end

	-- LDB Tab (5)
	self:skinDropDown{obj=_G[WCCUIMF .. "Tab5SubFrameSourceDropDownMenu"]}

	if self.modChkBtns then
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowMissionsCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowNextMissionCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowNextMissionCharacterCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowAdvancementsCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowNextAdvancementCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowNextAdvancementCharacterCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowOrdersCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowNextOrderCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowNextOrderCharacterCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowHOACheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowResourcesCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowSealsCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowLabelsCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameUseLetterLabelsCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowWhenNoneCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameNumbersOnlyCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameHideLibDBIconMinimapButtonCheckButton"]}
		self:skinCheckButton{obj=_G[WCCUIMF .. "Tab5SubFrameShowCharacterTooltipLibDBIconMinimapButtonCheckButton"]}
	end

	-- minimap button
	self.mmButs["WarCampaignsComplete"] = _G.WCCMinimapButton

end
