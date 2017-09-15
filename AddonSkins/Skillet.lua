local aName, aObj = ...
if not aObj:isAddonEnabled("Skillet") then return end
local _G = _G

aObj.addonsToSkin.Skillet = function(self) -- v3.27
	if not self.db.profile.TradeSkillUI then return end

	self:SecureHook(_G.Skillet, "ShowTradeSkillWindow", function(this)
		_G.SkilletRankFrameBorder:Hide()
		self:glazeStatusBar(_G.SkilletRankFrame, 0, _G.SkilletRankFrameBackground)
		self:skinDropDown{obj=_G.SkilletRecipeGroupDropdown, x2=110}
		self:skinDropDown{obj=_G.SkilletSortDropdown, x2=110}
		self:skinDropDown{obj=_G.SkilletFilterDropdown, x2=110}
		self:skinEditBox(_G.SkilletSearchBox, {6})
		self:skinSlider{obj=_G.SkilletSkillList.ScrollBar, size=3}
		self:applySkin(_G.SkilletSkillListParent)
		self:applySkin(_G.SkilletReagentParent)
		self:skinEditBox(_G.SkilletItemCountInputBox, {6})
		self:skinSlider{obj=_G.SkilletQueueList.ScrollBar, size=3}
		self:applySkin(_G.SkilletQueueParent)
		self:addSkinFrame{obj=_G.SkilletFrame, kfs=true}
		self:Unhook(this, "ShowTradeSkillWindow")
	end)
	self:SecureHook(_G.SkilletShoppingList, "Show", function(this)
		self:skinSlider{obj=_G.SkilletShoppingListList.ScrollBar, size=3}
		self:applySkin(_G.SkilletShoppingListParent)
		self:addSkinFrame{obj=_G.SkilletShoppingList, kfs=true}
		self:Unhook(this, "Show")
	end)
	self:SecureHook(_G.SkilletRecipeNotesFrame, "Show", function(this)
		self:skinSlider{obj=_G.SkilletNotesList.ScrollBar, size=3}
		self:applySkin(_G.SkilletRecipeNotesFrame)
		self:Unhook(this, "Show")
	end)
	self:SecureHook(_G.Skillet, "RecipeNote_OnClick", function(this, button)
		self:skinEditBox{obj=self:getChild(button, 2), regs={6}} -- skin EditBox
		self:Unhook(this, "RecipeNote_OnClick")
	end)
	self:SecureHook(_G.Skillet, "DisplayIgnoreList", function(this)
		self:skinSlider{obj=_G.SkilletIgnoreListList.ScrollBar, size=3}
		self:applySkin(_G.SkilletIgnoreListParent)
		self:addSkinFrame{obj=_G.SkilletIgnoreList, kfs=true}
		self:Unhook(this, "DisplayIgnoreList")
	end)
	self:skinDropDown{obj=_G.SkilletQueueLoadDropdown, x2=110}
	self:skinEditBox{obj=_G.SkilletQueueSaveEditBox, regs={6}} -- 6 is text
	self:applySkin{obj=_G.SkilletQueueManagementParent}

	-- tooltip
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "SkilletTradeskillTooltip")
	end

	if self.modBtns then
		-- skin queue buttons
		_G.SkilletQueueButton1:SetParent(_G.SkilletQueueParent) -- reparent it
		self:SecureHook(_G.Skillet, "UpdateQueueWindow", function()
			for i = 1, _G.floor(_G.SkilletQueueList:GetHeight() / _G.SKILLET_TRADE_SKILL_HEIGHT) do
				local dBtn = _G["SkilletQueueButton" .. i .. "DeleteButton"]
				if not dBtn.sb then self:skinButton{obj=dBtn, x1=-3, y1=-3, x2=3, y2=1} end
			end
		end)
		if _G.Skillet.PluginButton_OnClick ~= nil then
			self:SecureHook(_G.Skillet, "PluginButton_OnClick", function(this, button)
				if _G.SkilletFrame.added_buttons then
					for i = 1, #_G.SkilletFrame.added_buttons do
						local btn = _G["SkilletPluginDropdown" .. i]
						if not btn.sb then
							self:skinButton{obj=btn}
						end
					end
				end
			end)
		end
	end

end
