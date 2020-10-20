local aName, aObj = ...
if not aObj:isAddonEnabled("Overachiever") then return end
local _G = _G

aObj.addonsToSkin.Overachiever = function(self) -- v 1.1.0
	if not self.db.profile.AchievementUI then return end

	--- Options
	local function skinKids(panel)
		if panel.TjOpt_tab.scrolling then
			aObj:skinSlider{obj=panel.TjOpt_scrollchild:GetParent().ScrollBar, wdth=0}
		end
		for i = 1, #panel.TjOpt_tab.items do
			local itm = _G[panel.TjOpt_tab.items[i].name]
			if itm then
				if itm.TjDDM then
					aObj:skinDropDown{obj=itm, x2=26, bx1=true}
				elseif itm:IsObjectType("CheckButton") then
					aObj:skinCheckButton{obj=itm}
				end
			end
		end
	end
	local pCnt = 0
	self.RegisterCallback("Overachiever", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name == "Overachiever"
		or panel.parent == "Overachiever"
		and not self.iofSkinnedPanels[panel]
		then
			skinKids(panel)
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
		end
		if pCnt == 2 then
			self.UnregisterCallback("Overachiever", "IOFPanel_Before_Skinning")
		end
	end)

end

aObj.lodAddons.Overachiever_Tabs = function(self) -- v 1.1.0
	if not self.db.profile.AchievementUI then return end

	local function cleanButtons(frame)
		-- remove textures etc from buttons
		local btn
		for i = 1, #frame.buttons do
			btn = frame.buttons[i]
			aObj:nilTexture(_G[frame.buttons[i]:GetName() .. "TopTsunami1"], true)
			aObj:nilTexture(_G[frame.buttons[i]:GetName() .. "BottomTsunami1"], true)
			btn:DisableDrawLayer("BACKGROUND")
			-- don't DisableDrawLayer("BORDER") as the button border won't show if skinned
			btn:DisableDrawLayer("ARTWORK")
			aObj:applySkin{obj=btn, bd=10, ng=true}
			if btn.plusMinus then btn.plusMinus:SetAlpha(0) end
			btn.icon:DisableDrawLayer("BACKGROUND")
			btn.icon:DisableDrawLayer("BORDER")
			btn.icon:DisableDrawLayer("OVERLAY")
			-- set textures to nil and prevent them from being changed as guildview changes the textures
			aObj:nilTexture(btn.icon.frame, true)
			-- colour text and button border
			if btn.description then
				btn.description:SetTextColor(aObj.BT:GetRGB())
			end
			if btn.hiddenDescription then
				btn.hiddenDescription:SetTextColor(aObj.BT:GetRGB())
			end

			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn.icon, x1=4, y1=-1, x2=-4, y2=6}
				btn.icon.sbb:SetBackdropBorderColor(btn:GetBackdropBorderColor())
				btn.icon.sbb:SetBackdropBorderColor(btn:GetBackdropBorderColor())
				-- hook these to handle description text  & button border colour changes
				aObj:SecureHook(btn, "Desaturate", function(this)
					this.icon.sbb:SetBackdropBorderColor(this:GetBackdropBorderColor())
				end)
			end
			aObj:SecureHook(btn, "Saturate", function(this)
				if this.description then
					this.description:SetTextColor(aObj.BT:GetRGB())
				end
				if this.icon.sbb then
					this.icon.sbb:SetBackdropBorderColor(this:GetBackdropBorderColor())
				end
			end)
		end
		btn = nil
	end

	-- Search Frame
	self:keepFontStrings(_G.Overachiever_SearchFrame)
	self:skinDropDown{obj=_G.Overachiever_SearchFrameSortDrop, x2=26, bx1=true}
	self:skinEditBox{obj=_G.Overachiever_SearchFrameNameEdit, regs={6}, noWidth=true}
	self:skinEditBox{obj=_G.Overachiever_SearchFrameDescEdit, regs={6}, noWidth=true}
	self:skinEditBox{obj=_G.Overachiever_SearchFrameCriteriaEdit, regs={6}, noWidth=true}
	self:skinEditBox{obj=_G.Overachiever_SearchFrameRewardEdit, regs={6}, noWidth=true}
	self:skinEditBox{obj=_G.Overachiever_SearchFrameAnyEdit, regs={6}, noWidth=true}
	self:skinDropDown{obj=_G.Overachiever_SearchFrameTypeDrop, x2=26, bx1=true}
	self:skinCheckButton{obj=_G.Overachiever_SearchFrameFullListCheckbox}
	self:skinSlider(_G.Overachiever_SearchFrameContainerScrollBar)
	self:applySkin(self:getChild(_G.Overachiever_SearchFrame, 1))
	LowerFrameLevel(self:getChild(_G.Overachiever_SearchFrame, 1))
	if self.modBtns then
		self:skinStdButton{obj=self:getPenultimateChild(_G.Overachiever_SearchFrame.panel)}
		self:skinStdButton{obj=self:getLastChild(_G.Overachiever_SearchFrame.panel)}
	end
	cleanButtons(_G.Overachiever_SearchFrame.scrollFrame)

	-- Suggestions Frame
	self:keepFontStrings(_G.Overachiever_SuggestionsFrame)
	self:skinDropDown{obj=_G.Overachiever_SuggestionsFrameSortDrop, x2=26, bx1=true}
	self:skinEditBox{obj=_G.Overachiever_SuggestionsFrameZoneOverrideEdit, regs={6}, noWidth=true}
	self:skinDropDown{obj=_G.Overachiever_SuggestionsFrameSubzoneDrop, x2=26, bx1=true}
	self:skinDropDown{obj=_G.Overachiever_SuggestionsFrameDiffDrop, x2=26, bx1=true}
	self:skinDropDown{obj=_G.Overachiever_SuggestionsFrameRaidSizeDrop, x2=26, bx1=true}
	self:skinCheckButton{obj=_G.Overachiever_SuggestionsFrameShowHiddenCheckbox}
	self:skinSlider(_G.Overachiever_SuggestionsFrameContainerScrollBar)
	self:applySkin(self:getChild(_G.Overachiever_SuggestionsFrame, 1))
	LowerFrameLevel(self:getChild(_G.Overachiever_SuggestionsFrame, 1))
	if self.modBtns then
		self:skinStdButton{obj=self:getChild(_G.Overachiever_SuggestionsFrame.panel, 2)}
		self:skinStdButton{obj=self:getLastChild(_G.Overachiever_SuggestionsFrame.panel)}
	end
	cleanButtons(_G.Overachiever_SuggestionsFrame.scrollFrame)

	-- Watch Frame
	self:keepFontStrings(_G.Overachiever_WatchFrame)
	self:skinDropDown{obj=_G.Overachiever_WatchFrameSortDrop, x2=26, bx1=true}
	self:skinDropDown{obj=_G.Overachiever_WatchFrameListDrop, x2=26, bx1=true}
	self:skinDropDown{obj=_G.Overachiever_WatchFrameDefListDrop, x2=26, bx1=true}
	self:skinCheckButton{obj=_G.Overachiever_WatchFrameCopyDestCheckbox}
	self:skinDropDown{obj=_G.Overachiever_WatchFrameDestinationListDrop, x2=26, bx1=true}
	self:skinSlider(_G.Overachiever_WatchFrameContainerScrollBar)
	local wFrame = self:getChild(_G.Overachiever_WatchFrame, 1)
	self:applySkin(wFrame)
	wFrame:SetFrameLevel(wFrame:GetFrameLevel() - 2) -- make sure text is shown
	wFrame = nil
	if self.modBtns then
		self:skinStdButton{obj=self:getChild(_G.Overachiever_WatchFrame.panel, 3)}
		self:skinStdButton{obj=self:getChild(_G.Overachiever_WatchFrame.panel, 4)}
	end
	cleanButtons(_G.Overachiever_WatchFrame.scrollFrame)

end
