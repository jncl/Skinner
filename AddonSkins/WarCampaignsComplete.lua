local aName, aObj = ...
if not aObj:isAddonEnabled("WarCampaignsComplete") then return end
local _G = _G

aObj.addonsToSkin.WarCampaignsComplete = function(self) -- v 1.0.8


	self:SecureHookScript(_G.WarCampaignsCompleteUIMainFrame, "OnShow", function(this)
		local WCCUIMF = this:GetName()

		-- Monitor Tab (1)
		local tabName = WCCUIMF .. "Tab1SubFrame"
		self:addButtonBorder{obj=_G[tabName .. "RefreshButton"], ofs=-2, x1=1}
		for _, type in pairs{"Name", "Lvl", "XP", "HoA", "AP", "Buttons"} do
			self:keepRegions(_G[tabName .. type .. "ColumnHeaderButton"], {4, 5, 6})
			self:addSkinFrame{obj=_G[tabName .. type .. "ColumnHeaderButton"], ft="a", nb=true, aso={bd=5}, ofs=1, x2=0}
		end
		self:skinSlider{obj=_G[tabName .. "ScrollFrame"].ScrollBar, rt="artwork"}
		if self.modBtnBs then
			self:SecureHookScript(_G[tabName .. "ScrollFrame"], "OnUpdate", function(this)
				for i = 1, this.numToDisplay do
					_G[this.buttonName .. i .. "BG"]:SetTexture(nil)
					local btn
					for j = 1, 4 do
						btn = this.buttonName .. i .. "Monitor" .. j
						self:addButtonBorder{obj=_G[btn], reParent={_G[btn .. "TopRightText"], _G[btn .. "CenterText"], _G[btn .. "Indicator"]}}
					end
					btn = nil
				end
			end)
		end
		_G[tabName .. "FooterBG"]:SetTexture(nil)
		self:addFrameBorder{obj=_G[tabName], ft="a", x1=-10, y1=8, x2=11, y2=-6}
		if self.modBtnBs then
			self:addButtonBorder{obj=_G[tabName .. "FooterMissionsReportButton"]}
			self:addButtonBorder{obj=_G[tabName .. "FooterAdvancementsReportButton"]}
			self:addButtonBorder{obj=_G[tabName .. "FooterWorkOrdersReportButton"]}
		end

		-- Characters Tab (2)
		tabName = WCCUIMF .. "Tab2SubFrame"
		self:skinDropDown{obj=_G[tabName .. "CharacterDropDownMenu"]}
		self:skinSlider{obj=_G[tabName .. "ScrollFrame"].ScrollBar, rt="artwork"}
		self:addFrameBorder{obj=_G[tabName], ft="a", x1=-10, y1=8, x2=11, y2=-6}
		if self.modBtns then
			self:skinStdButton{obj=_G[tabName .. "OrderButton"]}
			self:SecureHook(_G[tabName .. "OrderButton"], "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G[tabName .. "OrderButton"], "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=_G[tabName .. "DeleteCharacterButton"]}
			self:skinStdButton{obj=_G[tabName .. "UncheckAllButton"]}
			self:skinStdButton{obj=_G[tabName .. "CheckAllButton"]}
		end
		if self.modBtnBs then
			self:SecureHookScript(_G[tabName .. "ScrollFrame"], "OnUpdate", function(this)
				for i = 1, this.numToDisplay do
					self:addButtonBorder{obj=_G[this.buttonName .. i], relTo=_G[this.buttonName .. i .. "_IconTexture"]}
					_G.RaiseFrameLevel(_G[this.buttonName .. i].sbb)
					if self.modChkBtns then
						self:skinCheckButton{obj=_G[this.buttonName .. i .. "_Check"]}
					end
				end
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G[tabName .. "OrderAutomaticallyCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "CurrentCharacterFirstCheckButton"]}
		end

		-- Misc Tab (3)
		tabName = WCCUIMF .. "Tab3SubFrame"
		self:skinDropDown{obj=_G[tabName .. "MonitorRowsDropDownMenu"]}
		self:skinDropDown{obj=_G[tabName .. "MonitorColumnsDropDownMenu"]}
		self:addFrameBorder{obj=_G[tabName], ft="a", x1=-10, y1=8, x2=11, y2=-6}
		if self.modBtns then
			self:skinStdButton{obj=_G[tabName .. "CenterButton"]}
			self:skinStdButton{obj=_G[tabName .. "ReloadUIButton"]}
			self:skinStdButton{obj=_G[tabName .. "ColumnButton"]}
			self:skinStdButton{obj=_G[tabName .. "ResetButton"]}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G[tabName .. "ShowMinimapButtonCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowCharacterTooltipMinimapButtonCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "DockMinimapButtonCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "LockMinimapButtonCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "LargeMinimapButtonCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowOriginalMissionsReportMinimapButtonCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowTroopDetailsInTooltipCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowCharacterRealmsCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ForgetDragPositionCheckButton"]}
		end

		-- Alert Tab (4)
		tabName = WCCUIMF .. "Tab4SubFrame"
		self:skinDropDown{obj=_G[tabName .. "AlertDropDownMenu"]}
		self:addFrameBorder{obj=_G[tabName], ft="a", x1=-10, y1=8, x2=11, y2=-6}
		if self.modChkBtns then
			self:skinCheckButton{obj=_G[tabName .. "AlertMissionsCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "AlertAdvancementsCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "AlertTroopsCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "AlertDisableInInstancesCheckButton"]}
		end

		-- LDB Tab (5)
		tabName = WCCUIMF .. "Tab5SubFrame"
		self:skinDropDown{obj=_G[tabName .. "SourceDropDownMenu"]}
		self:addFrameBorder{obj=_G[tabName], ft="a", x1=-10, y1=8, x2=11, y2=-6}
		if self.modChkBtns then
			self:skinCheckButton{obj=_G[tabName .. "ShowMissionsCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowNextMissionCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowNextMissionCharacterCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowAdvancementsCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowNextAdvancementCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowNextAdvancementCharacterCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowOrdersCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowNextOrderCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowNextOrderCharacterCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowHOACheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowResourcesCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowSealsCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowLabelsCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "UseLetterLabelsCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowWhenNoneCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "NumbersOnlyCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "HideLibDBIconMinimapButtonCheckButton"]}
			self:skinCheckButton{obj=_G[tabName .. "ShowCharacterTooltipLibDBIconMinimapButtonCheckButton"]}
		end

		-- Help Tab (6)
		tabName = WCCUIMF .. "Tab6SubFrame"
		self:addFrameBorder{obj=_G[tabName], ft="a", x1=-10, y1=8, x2=11, y2=-6}

		self:skinTabs{obj=_G[WCCUIMF .. "SubFrameHeader"], ignore=true, ignht=true, x1=0, y1=-4, x2=0, y2=-4}
		self:addSkinFrame{obj=this, ft="a", kfs=true, ri=true, ofs=2, x2=3}
		tabName, WCCUIMF = nil, nil

		self:Unhook(this, "OnShow")
	end)

	-- minimap button
	self.mmButs["WarCampaignsComplete"] = _G.WCCMinimapButton

end
