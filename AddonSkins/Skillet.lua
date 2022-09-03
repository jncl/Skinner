local _, aObj = ...
local _G = _G

local function skinSkillet(self)
	if not self.db.profile.TradeSkillUI then return end

	self:SecureHook(_G.Skillet, "ShowTradeSkillWindow", function(this)
		this.tradeSkillFrame:DisableDrawLayer("BACKGROUND") -- title textures
		_G.SkilletRankFrameBorder:Hide()
		self:skinStatusBar{obj=_G.SkilletRankFrame, fi=0, bgTex=_G.SkilletRankFrameBackground}
		self:skinObject("dropdown", {obj=_G.SkilletRecipeGroupDropdown, x2=109})
		self:skinObject("dropdown", {obj=_G.SkilletSortDropdown, x2=109})
		self:skinObject("dropdown", {obj=_G.SkilletFilterDropdown, x2=109})
		self:skinObject("editbox", {obj=_G.SkilletSearchBox, ofs=1})
		self:skinObject("slider", {obj=_G.SkilletSkillList.ScrollBar})
		self:skinObject("frame", {obj=_G.SkilletSkillListParent, fb=true})
		if self.isRtl then
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
		self:skinObject("frame", {obj=_G.SkilletReagentParent, fb=true})
		self:skinObject("dropdown", {obj=_G.SkilletQueueLoadDropdown, x2=109})
		self:skinObject("editbox", {obj=_G.SkilletQueueSaveEditBox})
		self:skinObject("frame", {obj=_G.SkilletQueueManagementParent, fb=true})
		self:skinObject("editbox", {obj=_G.SkilletItemCountInputBox})
		self:skinObject("slider", {obj=_G.SkilletQueueList.ScrollBar})
		self:skinObject("frame", {obj=_G.SkilletQueueParent, fb=true})
		self:skinObject("frame", {obj=this.tradeSkillFrame, kfs=true, cb=true})
		if self.modBtns then
			self:skinOtherButton{obj=_G.SkilletShowOptionsButton, text="?"}
			_G.SkilletShowOptionsButton:SetSize(28, 28)
			_G.SkilletShowOptionsButton:GetHighlightTexture():SetTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
			self:moveObject{obj=_G.SkilletShowOptionsButton, x=0, y=-6}
			if self.isRtl then
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
			self:adjWidth{obj=_G.SkilletQueueOnlyButton, adj=4}
			self:skinStdButton{obj=_G.SkilletShoppingListButton}
			self:SecureHook(this, "ConfigureRecipeControls", function(this, _)
				self:clrBtnBdr(_G.SkilletStartQueueButton)
				self:clrBtnBdr(_G.SkilletCreateAllButton)
				self:clrBtnBdr(_G.SkilletCreateButton)
			end)
			_G.SkilletQueueButton1:SetParent(_G.SkilletQueueParent) -- reparent it
			self:SecureHook(_G.Skillet, "UpdateQueueWindow", function()
				for i = 1, _G.floor(_G.SkilletQueueList:GetHeight() / _G.SKILLET_TRADE_SKILL_HEIGHT) do
					if _G["SkilletQueueButton" .. i] then
						self:skinStdButton{obj=_G["SkilletQueueButton" .. i .. "DeleteButton"], ofs=3, y1=-1, y2=1}
					end
				end
				self:clrBtnBdr(_G.SkilletStartQueueButton)
				self:clrBtnBdr(_G.SkilletEmptyQueueButton)
			end)
			self:SecureHook(_G.Skillet, "PluginButton_OnClick", function(this, button)
				if _G.SkilletFrame.added_buttons then
					for i = 1, #_G.SkilletFrame.added_buttons do
						self:skinStdButton{obj=_G["SkilletPluginDropdown" .. i]}
					end
				end
			end)
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.SkilletRecipeGroupOperations, ofs=0, clr="gold"}
			if self.isRtl then
				self:addButtonBorder{obj=_G.SkilletFilterOperations, ofs=0, clr="gold"}
			end
			self:addButtonBorder{obj=_G.SkilletSearchClear, ofs=-4, x1=6, y2=7, clr="grey"}
			self:addButtonBorder{obj=_G.SkilletClearNumButton, ofs=-4, x1=6, y2=7, clr="grey"}
			self:addButtonBorder{obj=_G.SkilletSub10Button, ofs=0, clr="gold"}
			self:addButtonBorder{obj=_G.SkilletSub1Button, ofs=0, x1=-1, clr="gold"}
			self:addButtonBorder{obj=_G.SkilletAdd10Button, ofs=0, clr="gold"}
			self:addButtonBorder{obj=_G.SkilletAdd1Button, ofs=0, x1=-1, clr="gold"}
		end

		self:Unhook(this, "ShowTradeSkillWindow")
	end)

	self:SecureHookScript(_G.SkilletStandaloneQueue, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, cb=true})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.SkilletShoppingList, "Show", function(this)
		self:skinObject("slider", {obj=_G.SkilletShoppingListList.ScrollBar})
		self:skinObject("frame", {obj=_G.SkilletShoppingListParent, fb=true})
		self:skinObject("frame", {obj=_G.SkilletShoppingList, kfs=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.SkilletShoppingListRetrieveButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.SkilletShowQueuesFromAllAlts}
			if self.isRtl then
				self:skinCheckButton{obj=_G.SkilletShowQueuesFromSameFaction}
				self:skinCheckButton{obj=_G.SkilletShowQueuesIncludeGuild}
			end
			self:skinCheckButton{obj=_G.SkilletShowQueuesInItemOrder}
			self:skinCheckButton{obj=_G.SkilletShowQueuesMergeItems}
		end

		self:Unhook(this, "Show")
	end)

	self:SecureHook(_G.SkilletRecipeNotesFrame, "Show", function(this)
		self:skinObject("slider", {obj=_G.SkilletNotesList.ScrollBar})
		self:skinObject("frame", {obj=_G.SkilletRecipeNotesFrame, kfs=true})
		if self.modBtns then
			self:skinCloseButton{obj=_G.SkilletNotesCloseButton}
		end

		self:Unhook(this, "Show")
	end)

	self:SecureHook(_G.Skillet, "RecipeNote_OnClick", function(this, button)
		self:skinObject("editbox", {obj=self:getChild(button, 2)})

		self:Unhook(this, "RecipeNote_OnClick")
	end)

	self:SecureHook(_G.Skillet, "DisplayIgnoreList", function(this)
		self:skinObject("slider", {obj=_G.SkilletIgnoreListList.ScrollBar})
		self:skinObject("frame", {obj=_G.SkilletIgnoreListParent, fb=true})
		self:skinObject("frame", {obj=_G.SkilletIgnoreList, kfs=true, cb=true})

		self:Unhook(this, "DisplayIgnoreList")
	end)

	if self.modBtns then
		self:SecureHookScript(_G.SkilletMerchantBuyFrame, "OnShow", function(this)
			self:skinStdButton{obj=_G.SkilletMerchantBuyFrameButton}
			self:adjHeight{obj=_G.SkilletMerchantBuyFrameButton, adj=4}

			self:Unhook(this, "OnShow")
		end)
	end

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.SkilletTradeskillTooltip)
	end)

end

if aObj.isRtl then
	if aObj:isAddonEnabled("Skillet") then
		aObj.addonsToSkin.Skillet = function(self) -- v 4.26
			skinSkillet(aObj)
		end
	end
else
	if aObj:isAddonEnabled("Skillet-Classic") then
		aObj.addonsToSkin["Skillet-Classic"] = function(self) -- v
			skinSkillet(aObj)
		end
	end
end
