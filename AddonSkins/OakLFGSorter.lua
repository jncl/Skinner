local _, aObj = ...
if not aObj:isAddonEnabled("OakLFGSorter") then return end
local _G = _G

aObj.addonsToSkin.OakLFGSorter = function(self) -- v 4.0.16

	self:SecureHookScript(_G.SorterClassicFrame, "OnShow", function(this)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			return
		end

		--@debug@
		-- aObj:showSL(this)
		--@end-debug@

		self:skinObject("scrollbar", {obj=_G.SorterClassicMinimalScrollBar})
		local header
		for _, kNum in _G.pairs{22, 23, 24, 25, 26, 27, 28, 30} do
			header = self:getChild(this, kNum)
			header:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=header})
		end
		self:skinObject("frame", {obj=this, kfs=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this, 29)} -- notesToggleBtn
			self:skinStdButton{obj=self:getChild(this, 31)} -- noteVisibilityBtn
		end

		local headerLogo = self:getChild(this, 8)
		headerLogo.ring:SetTexture(nil)
		local controlsRow = self:getChild(this, 9)
		self:SecureHookScript(controlsRow, "OnShow", function(fObj)
			self:skinObject("ddbutton", {obj=self:getChild(controlsRow, 5)}) -- categoryDropdownButton
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(controlsRow, 1)} -- toggleFiltersBtn
				self:skinStdButton{obj=self:getChild(controlsRow, 2)} -- refreshBtn
				self:skinStdButton{obj=self:getChild(controlsRow, 3)} -- delistBtn
				self:skinStdButton{obj=self:getChild(controlsRow, 4)} -- editListingBtn
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(controlsRow)

		-- TODO: not sure when this panel gets displayed
		-- local filterPanel = self:getChild(this, 12)
		-- self:SecureHookScript(filterPanel, "OnShow", function(fObj)
		-- 	--@debug@
		-- 	-- aObj:showSL(filterPanel)
		-- 	--@end-debug@
			-- child1 [.OakInnerBorder]
			-- child2 [OakToggleBox] (Tank)
			-- child3 [OakToggleBox] (Healer)
			-- child4 [OakToggleBox] (DPS)
			-- child5 [FlatButton] -- btnAll
			-- child6 [FlatButton] -- btnNone
			-- child7 [FlatButton] -- btnLust
			-- child8 [FlatButton] -- btnBrez
			-- child9 [FlatButton] -- btnPlate
			-- child10 [FlatButton] -- btnMail
			-- child11 [FlatButton] -- btnLeather
			-- child12 [FlatButton] -- btnCloth
			-- child13 [OakToggleBox]
			-- child14 [OakToggleBox]
			-- child15 [OakToggleBox]
			-- child16 [OakToggleBox]
			-- child17 [OakToggleBox]
			-- child18 [OakToggleBox]
			-- child19 [OakToggleBox]
			-- child20 [OakToggleBox]
			-- child21 [OakToggleBox]
			-- child22 [OakToggleBox]
			-- child23 [OakToggleBox]
			-- child24 [OakToggleBox]
			-- child25 [OakToggleBox]
			-- child26 -- applicantRegionContainer
			-- child27 -- btnDecline
			-- child28 [OakToggleBox] -- autoHideRolesBox
			-- child29 [OakToggleBox] -- mutePingBox
		-- 	self:skinObject("frame", {obj=fObj, kfs=true, ofs=2})

		-- 	self:Unhook(fObj, "OnShow")
		-- end)
		-- self:checkShown(filterPanel)

		local browserFilterPanel = self:getChild(this, 13)
		self:SecureHookScript(browserFilterPanel, "OnShow", function(fObj)
			local browserContent = self:getChild(fObj, 2)
			self:skinObject("ddbutton", {obj=self:getChild(browserContent, 1)}) -- playstyleDropdown
			self:skinObject("ddbutton", {obj=self:getChild(browserContent, 2)}) -- difficultyDropdown
			self:skinObject("ddbutton", {obj=self:getChild(browserContent, 3)}) -- raidBossesDropdown
			self:skinObject("editbox", {obj=self:getChild(browserContent, 4)}) -- raidRangeRows[raidBossKills]
			self:skinObject("editbox", {obj=self:getChild(browserContent, 6)}) -- raidRangeRows[raidTanks]
			self:skinObject("editbox", {obj=self:getChild(browserContent, 8)}) -- raidRangeRows[raidHealers]
			self:skinObject("editbox", {obj=self:getChild(browserContent, 10)}) -- raidRangeRows[raidDps]
			self:skinObject("editbox", {obj=self:getChild(browserContent, 12)}) -- keyMinBox
			self:skinObject("editbox", {obj=self:getChild(browserContent, 13)}) -- keyMaxBox
			self:skinObject("editbox", {obj=self:getChild(browserContent, 26)}) -- browserMinRatingBox
			-- LFGListFrame.SearchPanel.SearchBox is reparented, so skin it
			self:skinObject("editbox", {obj=_G.LFGListFrame.SearchPanel.SearchBox, si=true})

			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0, y1=2})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(browserContent, 5)} -- raidRangeRows[raidBossKills] resetBtn
				self:skinStdButton{obj=self:getChild(browserContent, 7)} -- raidRangeRows[raidTanks] resetBtn
				self:skinStdButton{obj=self:getChild(browserContent, 9)} -- raidRangeRows[raidHealers] resetBtn
				self:skinStdButton{obj=self:getChild(browserContent, 11)} -- raidRangeRows[raidDps] resetBtn
				self:skinStdButton{obj=self:getChild(browserContent, 28)} -- browserInRefreshBtn
				self:skinStdButton{obj=self:getChild(browserContent, 29)} -- browserResetBtn
				self:skinStdButton{obj=self:getChild(browserContent, 30)} -- activitySelectAllBtn
				self:skinStdButton{obj=self:getChild(browserContent, 31)} -- activitySelectNoneBtn
				self:skinStdButton{obj=self:getChild(browserContent, 32)} -- activitySelectBountifulBtn
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(browserFilterPanel)

		local supportersPanel = self:getChild(this, 14)
		self:SecureHookScript(supportersPanel, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0, y1=2})
			if self.modBtns then
				-- socials buttons
				self:skinStdButton{obj=self:getChild(fObj, 3)}
				self:skinStdButton{obj=self:getChild(fObj, 4)}
				self:skinStdButton{obj=self:getChild(fObj, 5)}
				self:skinStdButton{obj=self:getChild(fObj, 6)}
				self:skinStdButton{obj=self:getChild(fObj, 7)}
				-- self:skinStdButton{obj=self:getChild(fObj, 8)} -- fontPickerButton
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(supportersPanel)

		local optionsPanel = self:getChild(this, 15)
		self:SecureHookScript(optionsPanel, "OnShow", function(fObj)
			-- local fontPickerList = self:getChild(fObj, 9)
			local fontPickerButton = self:getChild(fObj, 17)
			local fontList = self:getChild(fObj, 18)
			-- self:skinObject("ddbutton", {obj=self:getChild(fObj, 5)}) --
			self:skinObject("ddbutton", {obj=self:getChild(fObj, 9)}) -- optionsMythicSideButton
			self:skinObject("ddbutton", {obj=self:getChild(fObj, 11)}) -- optionsThemeButton
			self:skinObject("ddbutton", {obj=self:getChild(fObj, 21)}) -- optionsFrameStrataButton
			self:skinObject("editbox", {obj=self:getChild(fObj, 23)}) -- scaleEdit (from controlsRow)
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0, y1=2})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(fObj, 14)} --
				self:skinStdButton{obj=self:getChild(fObj, 15)} --
				self:skinStdButton{obj=self:getChild(fObj, 16)} --
				self:skinStdButton{obj=fontPickerButton}
				self:skinStdButton{obj=self:getChild(fObj, 24)} -- resetBtn (from controlsRow)
				self:SecureHookScript(fontPickerButton, "OnClick", function(_)
					local buttons = self:getChild(fontList, 1):GetScrollChild()
					for _, btn in _G.pairs{buttons:GetChildren()} do
						self:skinStdButton{obj=btn}
					end
					self:Unhook(fObj, "OnClick")
				end)
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(optionsPanel)

		local footer = self:getChild(this, 21)
		self:SecureHookScript(footer, "OnShow", function(fObj)
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(fObj, 1)} -- lfgBtn
				self:skinStdButton{obj=self:getChild(fObj, 2)} -- lfrBtn
				self:skinStdButton{obj=self:getChild(fObj, 3)} -- suppBtn
				self:skinStdButton{obj=self:getChild(fObj, 4)} -- optionsBtn
				self:skinStdButton{obj=self:getChild(fObj, 5)} -- listBtn
				self:skinStdButton{obj=self:getChild(fObj, 6)} -- pvpBtn
				self:skinStdButton{obj=self:getChild(fObj, 8)} -- mythicPanelBtn
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(footer)

		local mythicplusPanel = self:getChild(this, 33)
		self:SecureHookScript(mythicplusPanel, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0, y1=2})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(fObj, 1)} -- vaultButton
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(mythicplusPanel)

		local quickSignupBar = self:getChild(this, 34)
		self:SecureHookScript(quickSignupBar, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, kfs=true, fb=true, clr="grey"})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(fObj, 5), x1=-2, x2=2}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(quickSignupBar)

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.SorterClassicFrame)

	self.RegisterCallback("OakLFGSorter", "SettingsPanel_DisplayCategory", function(_, panel)
		if panel.name ~= "OAK LFG Sorter" then return end
		self.spSkinnedPanels[panel] = true

		if self.modBtns then
			self:skinStdButton{obj=self:getChild(panel, 1)}
		end

		self.UnregisterCallback("OakLFGSorter", "SettingsPanel_DisplayCategory")
	end)

end
