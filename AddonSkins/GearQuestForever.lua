local _, aObj = ...
if not aObj:isAddonEnabled("GearQuestForever") then return end
local _G = _G

aObj.addonsToSkin.GearQuestForever = function(self) -- v 1.3.3

	-- CreateFrame("Frame", "GearQuest
		-- GearQuestCustomWorking
		-- GearQuestSimScrollChild
		-- GearQuestLookupResultsChild
		--
		-- GearQuestSlotPopup
--x		-- GearQuestPortraitGuide
		-- GearQuestSimulateClassDropDown
		-- GearQuestSimulateSpecDropDown
		-- GearQuestSimulateFactionDropDown
	-- , "BackdropTemplate")
--x		-- GearQuestLanguageMenu
		-- GearQuestWeaponMenu
		-- GearQuestSimulateDialog
	-- , UIParent)
--x		-- GearQuestGuide
--x		-- GearQuestSourceFilterCatcher
		-- GearQuestSlotRankPanel
--x		-- GearQuestTracker
--x		-- GearQuestObtainToast
	--- , UIParent, "PortraitFrameTemplate")
--x		-- GearQuestLogFrame
	-- , BackdropFrameTemplate())
	-- , UIParent, "BackdropTemplate")
		-- GearQuestSimulateDialog
	-- , UIParent, "GameTooltipTemplate")
--x		-- GearQuestTooltipScanner

	local function setTextClr(fStr, heading)
		if heading then
			fStr:SetTextColor(aObj.HT:GetRGB())
		else
			fStr:SetTextColor(aObj.BT:GetRGB())
		end
		fStr.SetTextColor = _G.nop
	end
	self:SecureHookScript(_G.GearQuestLogFrame, "OnShow", function(frame)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, frame}})
			return
		end
		--@debug@
		-- _G.Spew("GQLF", frame)
		--@end-debug@

		-- .pageBar
			-- .tabGroup
		-- .sideTabRail
		-- .tabLog
		-- .tabLookup
		-- .tabSimulator
		-- .tabSettings
		-- .tabOrders

		-- colour text fields
		setTextClr(frame.detailTitle, true)
		frame.detailRankBox.text:SetTextColor(self.BT:GetRGB())
		frame.detailLore:SetTextColor(self.BT:GetRGB())
		frame.detailHeader:SetTextColor(self.HT:GetRGB())
		frame.detailBody:SetTextColor(self.BT:GetRGB())
		-- .detailRecipe
		if frame.detailBodyTail then
			frame.detailBodyTail:SetTextColor(self.BT:GetRGB())
		end
		frame.detailCoords:SetTextColor(self.BT:GetRGB())
		frame.detailCoordsProbe:SetTextColor(self.BT:GetRGB())
		if frame.detailCoordsTail then
			frame.detailCoordsTail:SetTextColor(self.BT:GetRGB())
		end
		frame.detailDone:SetTextColor(self.BT:GetRGB())
		frame.detailEmpty:SetTextColor(self.BT:GetRGB())
		frame.detailBg.gqParchment:SetTexture(nil)
		frame.detailRewardHeader:SetTextColor(self.HT:GetRGB())
		frame.detailRewardIcon.nameBg:SetTexture(nil)

		if frame.sf then
			return
		end

		-- TODO: skin side tabs

		self:skinObject("slider", {obj=frame.detailScroll.ScrollBar})
		-- frame.detailGutter
		self:skinObject("frame", {obj=frame.detailBg, kfs=true, rb="nop"})
		self:skinObject("frame", {obj=frame, kfs=true, cb=true, ofs=0})
		if _G.GearQuestForeverDB
		and _G.GearQuestForeverDB.settings
		and not _G.GearQuestForeverDB.settings.hideLogArt
		then
			frame.gqLogScene:SetAlpha(1)
			frame.gqLogSceneShade:SetAlpha(1)
		end
		if self.modBtns then
			self:skinStdButton{obj=frame.trackBtn, sechk=true}
			self:skinStdButton{obj=frame.untrackBtn, sechk=true}
			self:skinStdButton{obj=frame.mapBtn, sechk=true}
			self:skinStdButton{obj=frame.removeBtn, sechk=true}
			self:skinStdButton{obj=frame.restoreBtn, sechk=true}
			self:skinStdButton{obj=frame.exitBtn}
		end

		self:SecureHookScript(frame.logPage, "OnShow", function(_)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, frame.logPage}})
				return
			end

			local function hookShow(mObj)
				aObj:SecureHookScript(mObj, "OnShow", function(fObj)
					aObj:skinObject("frame", {obj=fObj, kfs=true})
					if aObj.modBtns then
						aObj:skinStdButton{obj=fObj.selectBtn, sechk=true}
						aObj:skinStdButton{obj=fObj.applyBtn, sechk=true}
					end

					aObj:Unhook(frame, "OnShow")
				end)
				aObj:checkShown(frame)
			end
			hookShow(frame.sourceFilterMenu)
			for _, branch in _G.pairs{"profBranch", "dungeonBranch", "trashBranch", "vendorBranch", "questBranch"} do
				hookShow(frame.sourceFilterMenu[branch])
			end

			-- TODO: skin top tabs
			-- TODO: skin expand buttons

			self:removeBackdrop(frame.gearScoreBar)
			self:skinObject("statusbar", {obj=frame.gearScoreBar.status, fi=0})

			self:skinObject("slider", {obj=frame.scroll.ScrollBar})
			self:skinObject("frame", {obj=frame.listInset, kfs=true, rb="nop"})
			self:removeBackdrop(frame.huntsPerSlot)
			self:skinObject("slider", {obj=frame.huntsPerSlotSlider})
			if self.modBtns then
				self:skinStdButton{obj=frame.collapseAllBtn}
				self:skinStdButton{obj=frame.sourceFilterBtn}
				self:skinStdButton{obj=frame.armorTypeBtn}
				self:skinStdButton{obj=frame.playStyleBtn}
				self:skinStdButton{obj=frame.tooltipsBtn}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=frame.tabSpecArrow, ofs=-2, x1=1, clr="grey"}
			end

			self:SecureHookScript(frame.playStylePanel, "OnShow", function(fObj)
				if _G.InCombatLockdown() then
					self:add2Table(self.oocTab, {self.checkShown, {self, fObj}})
					return
				end

				for i = 1, 2 do
					for _, card in _G.pairs(fObj.cardPages[i]) do
						self:skinObject("frame", {obj=card, fb=true, ofs=-1})
					end
				end
				self:skinObject("frame", {obj=fObj, kfs=true})
				if self.modBtns then
					self:skinStdButton{obj=self:getChild(fObj, fObj:GetNumChildren() - 3)} -- closeBtn
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.prevPageBtn, ofs=-2, x1=1, clr="gold", sechk=true}
					self:addButtonBorder{obj=fObj.nextPageBtn, ofs=-2, x1=1, clr="gold", sechk=true}
				end

				self:Unhook(frame.playStylePanel, "OnShow")
			end)
			self:checkShown(frame.playStylePanel)

			self:SecureHookScript(frame.tooltipsPanel, "OnShow", function(fObj)
				if _G.InCombatLockdown() then
					self:add2Table(self.oocTab, {self.checkShown, {self, fObj}})
					return
				end

				self:skinObject("frame", {obj=fObj.leftPreview, kfs=true, fb=true})
				self:skinObject("frame", {obj=fObj.rightPreview, kfs=true, fb=true})
				self:skinObject("frame", {obj=fObj, kfs=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.closeBtn}
				end

				_G.RunNextFrame(function()
					self:skinObject("slider", {obj=frame.settingsUnitGearMinDropSlider})
					self:skinObject("frame", {obj=frame.settingsUnitGearSourcesMenu, kfs=true})
					if self.modBtns then
						self:skinStdButton{obj=frame.settingsUnitGearSourcesBtn}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=frame.settingsScoreCheck}
						self:skinCheckButton{obj=frame.settingsOtherSpecCheck}
						self:skinCheckButton{obj=frame.settingsScoreMissCheck}
						self:skinCheckButton{obj=frame.settingsUnitGearCheck}
						self:skinCheckButton{obj=frame.settingsUnitGearAlwaysCheck}
						self:skinCheckButton{obj=frame.settingsUnitGearChanceCheck}
						self:skinCheckButton{obj=frame.settingsEnchantCheck}
					end
				end)

				-- N.B. DON'T unhook as the controls are recreated each time
				-- self:Unhook(frame.tooltipsPanel, "OnShow")
			end)
			self:checkShown(frame.tooltipsPanel)

			self:Unhook(frame.logPage, "OnShow")
		end)
		self:checkShown(frame.logPage)

		self:SecureHookScript(frame.lookupPage, "OnShow", function(fObj)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, fObj}})
				return
			end

			self:skinObject("editbox", {obj=frame.lookupBox})
			self:skinObject("slider", {obj=frame.lookupScroll.ScrollBar})
			self:skinObject("frame", {obj=frame.lookupInset, kfs=true, rb="nop"})
			if self.modBtns then
				self:skinStdButton{obj=frame.lookupSearch}
			end

			self:Unhook(frame.lookupPage, "OnShow")
		end)
		self:checkShown(frame.lookupPage)

		self:SecureHookScript(frame.simPage, "OnShow", function(fObj)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, fObj}})
				return
			end

			self:skinObject("frame", {obj=frame.simClassInset, kfs=true, rb="nop"})
			self:skinObject("slider", {obj=frame.simScroll.ScrollBar})
			self:skinObject("frame", {obj=frame.simDetail, kfs=true, rb="nop"})
			-- .simClassButtons
			frame.simTitle:SetTextColor(self.HT:GetRGB())
			frame.simBody:SetTextColor(self.BT:GetRGB())
			frame.simFactionHeader:SetTextColor(self.BT:GetRGB())
			frame.simSpecHeader:SetTextColor(self.BT:GetRGB())
			frame.simLevelHeader:SetTextColor(self.BT:GetRGB())
			frame.simStatus:SetTextColor(self.BT:GetRGB())
			self:skinObject("editbox", {obj=frame.simLevelEdit})
			if self.modBtns then
				self:skinStdButton{obj=frame.simAllianceBtn}
				self:skinStdButton{obj=frame.simHordeBtn}
				self:skinStdButton{obj=frame.simApplyBtn}
				self:skinStdButton{obj=frame.simResetBtn}
				for _, btn in _G.pairs(frame.simSpecButtons) do
					self:skinStdButton{obj=btn}
				end
			end

			self:Unhook(frame.simPage, "OnShow")
		end)
		self:checkShown(frame.simPage)

		self:SecureHookScript(frame.settingsPage, "OnShow", function(fObj)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, fObj}})
				return
			end

			-- general
			self:skinObject("slider", {obj=frame.settingsGeneralScroll.ScrollBar})
			for _, header in _G.pairs(frame.settingsGeneralChild.gqSectionHeaders) do
				header:SetTextColor(self.HT:GetRGB())
			end
			frame.settingsPageTitle:SetTextColor(self.HT:GetRGB())
			frame.settingsMinimapLabel:SetTextColor(self.BT:GetRGB())
			frame.settingsLanguageLabel:SetTextColor(self.BT:GetRGB())
			frame.settingsHint:SetTextColor(self.BT:GetRGB())
			frame.settingsLargeValue:SetTextColor(self.HT:GetRGB())
			self:skinObject("slider", {obj=frame.settingsLargeSlider})
			frame.settingsLargeSlider.Low:SetTextColor(self.BT:GetRGB())
			frame.settingsLargeSlider.High:SetTextColor(self.BT:GetRGB())
			frame.settingsLargeSlider.Text:SetTextColor(self.BT:GetRGB())
			for _, str in _G.pairs{"Large", "Art", "ScoreBar", "Chat"} do -- "OtherSpec", "Score"
				frame["settings" .. str .. "Label"]:SetTextColor(self.HT:GetRGB())
				frame["settings" .. str .. "Hint"]:SetTextColor(self.BT:GetRGB())
			end
			if self.modBtns then
				self:skinStdButton{obj=frame.settingsLanguageDrop}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=frame.settingsMinimapCheck}
				self:skinCheckButton{obj=frame.settingsArtCheck}
				self:skinCheckButton{obj=frame.settingsScoreBarCheck}
				self:skinCheckButton{obj=frame.settingsChatCheck}
			end
			-- hunts
			self:skinObject("slider", {obj=frame.settingsHuntsScroll.ScrollBar})
			for _, header in _G.pairs(frame.settingsHuntsChild.gqSectionHeaders) do
				header:SetTextColor(self.HT:GetRGB())
			end
			for _, str in _G.pairs{"Lower", "Toast", "Arrow", "Guide", "MapPin", "MapPinSize", "Tracker"} do
				frame["settings" .. str .. "Label"]:SetTextColor(self.HT:GetRGB())
				frame["settings" .. str .. "Hint"]:SetTextColor(self.BT:GetRGB())
			end
			self:skinObject("slider", {obj=frame.settingsMapPinSizeSlider})
			frame.settingsMapPinSizeSlider.Low:SetTextColor(self.BT:GetRGB())
			frame.settingsMapPinSizeSlider.High:SetTextColor(self.BT:GetRGB())
			frame.settingsMapPinSizeSlider.Text:SetTextColor(self.BT:GetRGB())
			if self.modChkBtns then
				self:skinCheckButton{obj=frame.settingsLowerCheck}
				self:skinCheckButton{obj=frame.settingsToastCheck}
				self:skinCheckButton{obj=frame.settingsArrowCheck}
				self:skinCheckButton{obj=frame.settingsGuideCheck}
				self:skinCheckButton{obj=frame.settingsMapPinCheck}
				self:skinCheckButton{obj=frame.settingsTrackerCheck}
			end
			-- commands
			self:skinObject("slider", {obj=frame.settingsCommandsScroll.ScrollBar})
			for _, row in _G.pairs(frame.settingsCommandRows) do
				row.cmd:SetTextColor(self.HT:GetRGB())
				row.expl:SetTextColor(self.BT:GetRGB())
			end
			-- credits
			self:skinObject("slider", {obj=frame.settingsCreditsScroll.ScrollBar})
			self:skinObject("editbox", {obj=frame.settingsDiscordBox})
			frame.settingsDiscordHeader:SetTextColor(self.HT:GetRGB())
			frame.settingsDiscordBody:SetTextColor(self.BT:GetRGB())
			frame.settingsCreditsTitle:SetTextColor(self.HT:GetRGB())
			frame.settingsCreditsBody:SetTextColor(self.BT:GetRGB())
			if self.modBtns then
				self:skinStdButton{obj=frame.settingsDiscordCopy}
			end
			-- donations
			self:skinObject("slider", {obj=frame.settingsDonationsScroll.ScrollBar})
			self:skinObject("editbox", {obj=frame.settingsDonationBox})
			frame.settingsDonationBody:SetTextColor(self.BT:GetRGB())
			if self.modBtns then
				self:skinStdButton{obj=frame.settingsDonationCopy}
			end

			self:skinObject("frame", {obj=frame.settingsList, kfs=true, rb="nop"})
			self:skinObject("frame", {obj=frame.settingsDetail, kfs=true, rb="nop"})

			self:Unhook(frame.settingsPage, "OnShow")
		end)
		self:checkShown(frame.settingsPage)

		-- self:Unhook(_G.GearQuestLogFrame, "OnShow")
	end)
	self:checkShown(_G.GearQuestLogFrame)

	self:SecureHookScript(_G.GearQuestOrdersPage, "OnShow", function(fObj)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, fObj}})
			return
		end

		self:skinObject("slider", {obj=fObj.scroll.ScrollBar})
		self:skinObject("frame", {obj=fObj, kfs=true, noBdr=true})
		if self.modBtns then
			_G.RunNextFrame(function()
				for _, btn in _G.pairs(fObj.profButtons) do
					self:skinStdButton{obj=btn}
				end
			end)
		end

		self:Unhook(_G.GearQuestOrdersPage, "OnShow")
	end)
	self:checkShown(_G.GearQuestOrdersPage)

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("editbox", {obj=fObj.nameBox})
			self:skinObject("slider", {obj=fObj.scroll.ScrollBar})
			self:skinObject("frame", {obj=fObj.baseMenu, kfs=true, ofs=0})
			self:skinObject("frame", {obj=fObj, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.specButton}
				self:skinStdButton{obj=fObj.deleteButton}
				self:skinStdButton{obj=fObj.saveButton}
				self:skinStdButton{obj=self:getChild(fObj, fObj:GetNumChildren() -3)} -- closeBtn
			end
			for _, row in _G.pairs(fObj.rows) do
				self:skinObject("editbox", {obj=row.box})
			end
		end)
	end}, "GearQuestCustomSpecPanel")

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0})
		end)
	end}, "GearQuestSpecPicker")

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0})
		end)
	end}, "GearQuestArmorMenu")

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("frame", {obj=fObj, kfs=true})
		end)
	end}, "GearQuestOrderNotice")

end
