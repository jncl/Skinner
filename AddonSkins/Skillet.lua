local aName, aObj = ...
if not aObj.isClsc
and not aObj:isAddonEnabled("Skillet")
or aObj.isClsc
and not aObj:isAddonEnabled("Skillet-Classic")
then
	return
end
local _G = _G

local function skinSkillet(self)
	if not self.db.profile.TradeSkillUI then return end

	self:SecureHook(_G.Skillet, "ShowTradeSkillWindow", function(this)
		this.tradeSkillFrame:DisableDrawLayer("BACKGROUND") -- title textures
		_G.SkilletRankFrameBorder:Hide()
		self:skinStatusBar{obj=_G.SkilletRankFrame, fi=0, bgTex=_G.SkilletRankFrameBackground}
		self:skinDropDown{obj=_G.SkilletRecipeGroupDropdown, x2=109}
		self:skinDropDown{obj=_G.SkilletSortDropdown, x2=109}
		self:skinDropDown{obj=_G.SkilletFilterDropdown, x2=109}
		self:skinEditBox{obj=_G.SkilletSearchBox, regs={6}, noHeight=true}
		self:skinSlider{obj=_G.SkilletSkillList.ScrollBar, size=3}
		self:applySkin(_G.SkilletSkillListParent)
		if not self.isClsc then
			-- hook this to skin SkillBars
			self:SecureHook(this, "UpdateTradeSkillWindow", function(this)
				local bar
				for i = 1, this.button_count do
					bar = _G["SkilletScrollButton" .. i].SubSkillRankBar
					self:removeRegions(bar, {1, 2, 3}) -- border textures
					self:skinStatusBar{obj=bar, fi=0}
				end
				bar = nil
			end)
		end
		self:applySkin(_G.SkilletReagentParent)
		self:skinDropDown{obj=_G.SkilletQueueLoadDropdown, x2=109}
		self:skinEditBox{obj=_G.SkilletQueueSaveEditBox, regs={6}, noHeight=true} -- 6 is text
		self:applySkin{obj=_G.SkilletQueueManagementParent}
		self:skinEditBox{obj=_G.SkilletItemCountInputBox, regs={6}, noHeight=true}
		self:skinSlider{obj=_G.SkilletQueueList.ScrollBar, size=3}
		self:applySkin(_G.SkilletQueueParent)
		self:addSkinFrame{obj=this.tradeSkillFrame, ft="a", kfs=true}
		if self.modBtns then
			self:skinOtherButton{obj=_G.SkilletShowOptionsButton, font=self.fontS, text="?"}
			_G.SkilletShowOptionsButton:SetSize(28, 28)
			_G.SkilletShowOptionsButton:GetHighlightTexture():SetTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
			self:moveObject{obj=_G.SkilletShowOptionsButton, x=0, y=-6}
			if not self.isClsc then
				self:skinStdButton{obj=_G.SkilletPluginButton}
			end
			self:skinStdButton{obj=_G.SkilletIgnoredMatsButton}
			self:skinStdButton{obj=_G.SkilletQueueManagementButton}
			self:skinStdButton{obj=_G.SkilletRecipeNotesButton}
			self:skinStdButton{obj=_G.SkilletQueueLoadButton}
			self:skinStdButton{obj=_G.SkilletQueueDeleteButton}
			self:skinStdButton{obj=_G.SkilletQueueSaveButton}
			self:skinStdButton{obj=_G.SkilletQueueAllButton}
			self:skinStdButton{obj=_G.SkilletCreateAllButton}
			self:skinStdButton{obj=_G.SkilletQueueButton}
			self:skinStdButton{obj=_G.SkilletCreateButton}
			self:skinStdButton{obj=_G.SkilletStartQueueButton}
			self:skinStdButton{obj=_G.SkilletEmptyQueueButton}
			self:skinStdButton{obj=_G.SkilletQueueOnlyButton}
			self:skinStdButton{obj=_G.SkilletShoppingListButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.SkilletRecipeGroupOperations, ofs=0, clr="gold"}
			if not self.isClsc then
				self:addButtonBorder{obj=_G.SkilletFilterOperations, ofs=0, clr="gold"}
				self:addButtonBorder{obj=_G.SkilletSearchFilterClear, ofs=-4, x1=6, y2=7, clr="grey"}
			else
				self:addButtonBorder{obj=_G.SkilletSearchClear, ofs=-4, x1=6, y2=7, clr="grey"}
			end
			self:addButtonBorder{obj=_G.SkilletClearNumButton, ofs=-4, x1=6, y2=7, clr="grey"}
			self:addButtonBorder{obj=_G.SkilletSub10Button, ofs=0, clr="gold"}
			self:addButtonBorder{obj=_G.SkilletSub1Button, ofs=0, x1=-1, clr="gold"}
			self:addButtonBorder{obj=_G.SkilletAdd10Button, ofs=0, clr="gold"}
			self:addButtonBorder{obj=_G.SkilletAdd1Button, ofs=0, x1=-1, clr="gold"}
		end

		self:Unhook(this, "ShowTradeSkillWindow")
	end)
	self:SecureHookScript(_G.SkilletStandaloneQueue, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft="a", kfs=true}

		self:Unhook(this, "OnShow")
	end)
	self:SecureHook(_G.SkilletShoppingList, "Show", function(this)
		self:skinSlider{obj=_G.SkilletShoppingListList.ScrollBar, size=3}
		self:applySkin(_G.SkilletShoppingListParent)
		self:addSkinFrame{obj=_G.SkilletShoppingList, ft="a", kfs=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.SkilletShoppingListRetrieveButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.SkilletShowQueuesFromAllAlts}
			if not self.isClsc then
				self:skinCheckButton{obj=_G.SkilletShowQueuesFromSameFaction}
				self:skinCheckButton{obj=_G.SkilletShowQueuesIncludeGuild}
			end
			self:skinCheckButton{obj=_G.SkilletShowQueuesInItemOrder}
			self:skinCheckButton{obj=_G.SkilletShowQueuesMergeItems}
		end

		self:Unhook(this, "Show")
	end)
	self:SecureHook(_G.SkilletRecipeNotesFrame, "Show", function(this)
		self:skinSlider{obj=_G.SkilletNotesList.ScrollBar, size=3}
		self:addSkinFrame{obj=_G.SkilletRecipeNotesFrame, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.SkilletNotesCloseButton}
		end

		self:Unhook(this, "Show")
	end)
	self:SecureHook(_G.Skillet, "RecipeNote_OnClick", function(this, button)
		self:skinEditBox{obj=self:getChild(button, 2), regs={6}, noHeight=true} -- 6 is text

		self:Unhook(this, "RecipeNote_OnClick")
	end)
	self:SecureHook(_G.Skillet, "DisplayIgnoreList", function(this)
		self:skinSlider{obj=_G.SkilletIgnoreListList.ScrollBar, size=3}
		self:applySkin(_G.SkilletIgnoreListParent)
		self:addSkinFrame{obj=_G.SkilletIgnoreList, ft="a", kfs=true}

		self:Unhook(this, "DisplayIgnoreList")
	end)

	-- tooltip
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "SkilletTradeskillTooltip")
	end

	if self.modBtns then
		self:skinStdButton{obj=_G.SkilletMerchantBuyFrameButton}
		-- skin queue buttons
		_G.SkilletQueueButton1:SetParent(_G.SkilletQueueParent) -- reparent it
		self:SecureHook(_G.Skillet, "UpdateQueueWindow", function()
			for i = 1, _G.floor(_G.SkilletQueueList:GetHeight() / _G.SKILLET_TRADE_SKILL_HEIGHT) do
				local dBtn = _G["SkilletQueueButton" .. i .. "DeleteButton"]
				if not dBtn.sb then self:skinStdButton{obj=dBtn, ofs=3, y1=-1, y2=1} end
			end
		end)
		if _G.Skillet.PluginButton_OnClick ~= nil then
			self:SecureHook(_G.Skillet, "PluginButton_OnClick", function(this, button)
				if _G.SkilletFrame.added_buttons then
					for i = 1, #_G.SkilletFrame.added_buttons do
						local btn = _G["SkilletPluginDropdown" .. i]
						if not btn.sb then
							self:skinStdButton{obj=btn}
						end
					end
				end
			end)
		end
	end

end

if not aObj.isClsc then
	aObj.addonsToSkin.Skillet = function(self) -- v
		skinSkillet(aObj)
	end
end
if aObj.isClsc then
	aObj.addonsToSkin["Skillet-Classic"] = function(self) -- v
		skinSkillet(aObj)
	end
end
