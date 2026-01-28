if _G.WOW_PROJECT_ID ~= _G.WOW_PROJECT_MAINLINE then return end

local _, aObj = ...

local _G = _G

aObj.SetupMainline_PlayerFrames = function()
	local ftype = "p"

	-- N.B. ArenaUI managed in UnitFrames module

	aObj.blizzLoDFrames[ftype].ArtifactUI = function(self)
		if not self.prdb.ArtifactUI or self.initialized.ArtifactUI then return end
		self.initialized.ArtifactUI = true

		self:SecureHookScript(_G.ArtifactFrame, "OnShow", function(this)
			self:keepFontStrings(this.BorderFrame)
			this.ForgeBadgeFrame:DisableDrawLayer("OVERLAY") -- this hides the frame
			this.ForgeBadgeFrame.ForgeLevelLabel:SetDrawLayer("ARTWORK") -- this shows the artifact level
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=5, y1=4, y2=-11})
			-- Perks
			this.PerksTab:DisableDrawLayer("BORDER")
			this.PerksTab:DisableDrawLayer("OVERLAY")
			this.PerksTab.TitleContainer.Background:SetAlpha(0) -- title underline texture
			self:removeRegions(this.PerksTab.DisabledFrame, {1})
			this.PerksTab.Model:DisableDrawLayer("OVERLAY")
			for i = 1, 14 do
				this.PerksTab.CrestFrame["CrestRune" .. i]:SetAtlas(nil)
			end
			-- hook this to stop Background being Refreshed
			self:RawHook(_G.ArtifactPerksMixin, "RefreshBackground", function(_)
				_G.nop()
			end, true)
			local function skinPowerBtns()
				if this.PerksTab.PowerButtons then
					for _, btn in _G.pairs(this.PerksTab.PowerButtons) do
						aObj:changeTandC(btn.RankBorder)
						aObj:changeTandC(btn.RankBorderFinal)
					end
				end
			end
			skinPowerBtns()
			-- hook this to skin new buttons
			self:SecureHook(this.PerksTab, "RefreshPowers", function(_, _)
				skinPowerBtns()
			end)
			-- Appearances
			self:SecureHook(this.AppearancesTab, "Refresh", function(fObj)
				for appearanceSet in fObj.appearanceSetPool:EnumerateActive() do
					appearanceSet:DisableDrawLayer("BACKGROUND")
				end
				for appearanceSlot in fObj.appearanceSlotPool:EnumerateActive() do
					appearanceSlot:DisableDrawLayer("BACKGROUND")
					appearanceSlot.Border:SetTexture(nil)
				end
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].AzeriteEssenceUI = function(self)
		if not self.prdb.AzeriteEssenceUI or self.initialized.AzeriteEssenceUI then return end
		self.initialized.AzeriteEssenceUI = true

		self:SecureHookScript(_G.AzeriteEssenceUI, "OnShow", function(this)
			-- LHS
			self:keepFontStrings(this.PowerLevelBadgeFrame)
			self:removeInset(this.LeftInset)
			this.OrbGlass:SetTexture(nil)
			-- remove revolving circles & stop them from re-appearing
			this.ItemModelScene:ClearScene()
			-- remove revolving stars
			this.StarsAnimationFrame1:DisableDrawLayer("BORDER")
			this.StarsAnimationFrame2:DisableDrawLayer("BORDER")
			this.StarsAnimationFrame3:DisableDrawLayer("BORDER")
			-- remove ring etc from milestones
			for i, slot in _G.ipairs(this.Slots) do
				-- print("Slot", i, slot)
				for j, stateFrame in _G.ipairs(slot.StateFrames) do
					-- print("StateFrames", j, stateFrame, stateFrame:GetNumRegions())
					if i == 1 then -- Major Milestone
						stateFrame.Glow:SetAlpha(0)
						stateFrame.Shadow:SetAlpha(0)
						stateFrame.Ring:SetAlpha(0)
						stateFrame.HighlightRing:SetAlpha(0)
					elseif j == 1
					and stateFrame:GetNumRegions() == 7
					then -- Minor Milestone
						stateFrame.Ring:SetAlpha(0)
						stateFrame.HighlightRing:SetAlpha(0)
					end
				end
			end
			-- RHS
			self:removeInset(this.RightInset)
			self:skinObject("scrollbar", {obj=this.EssenceList.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					element.Background:SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, relTo=element.Icon, reParent={element.IconCover, element.Glow, element.Glow2, element.Glow3}}
					end
				else
					if aObj.modBtnBs then
						element.sbb:SetBackdropBorderColor(element.Name:GetTextColor())
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.EssenceList.ScrollBox, skinElement, aObj, true)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AzeriteEssenceUI)

		-- AzeriteEssenceLearnAnimFrame

	end

	aObj.blizzLoDFrames[ftype].AzeriteUI = function(self)
		if not self.prdb.AzeriteUI or self.initialized.AzeriteUI then return end
		self.initialized.AzeriteUI = true

		self:SecureHookScript(_G.AzeriteEmpoweredItemUI, "OnShow", function(this)
			self:keepFontStrings(this)
			self:skinObject("frame", {obj=this.BorderFrame, fType=ftype, bg=true})
			this.ClipFrame.BackgroundFrame:DisableDrawLayer("BACKGROUND")
			this.ClipFrame.BackgroundFrame.KeyOverlay:DisableDrawLayer("ARTWORK")
			for _, rf in _G.pairs(this.ClipFrame.BackgroundFrame.RankFrames) do
				rf:DisableDrawLayer("BORDER")
			end

			self:Unhook(this, "OnShow")
		end)

	end

	-- aObj.blizzFrames[ftype].CastingBar = function(self)
	-- 	if not self.prdb.CastingBar.skin
	-- 	or self.initialized.CastingBar then
	-- 		self.blizzFrames[ftype].CastingBar = nil
	-- 		return
	-- 	end
	-- 	self.initialized.CastingBar = true

	-- 	if _G.C_AddOns.IsAddOnLoaded("Quartz")
	-- 	or _G.C_AddOns.IsAddOnLoaded("Dominos_Cast")
	-- 	then
	-- 		self.blizzFrames[ftype].CastingBar = nil
	-- 		return
	-- 	end

	-- 	local cbFrame
	-- 	-- OverlayPlayerCastingBarFrame used by ClassTalents
	-- 	for _, type in _G.pairs{"Player", "Pet", "OverlayPlayer"} do
	-- 		cbFrame = _G[type .. "CastingBarFrame"]
	-- 		cbFrame.TextBorder:SetTexture(nil)
	-- 		cbFrame.Border:SetTexture(nil)
	-- 		cbFrame.Flash:SetTexture(nil)
	-- 		self:changeShield(cbFrame.BorderShield, cbFrame.Icon)
	-- 		if self.prdb.CastingBar.glaze then
	-- 			self:skinObject("statusbar", {obj=cbFrame, bg=cbFrame.Background, hookFunc=true})
	-- 		end
	-- 		cbFrame.Background:SetAllPoints(cbFrame)
	-- 	end

	-- end

	aObj.blizzLoDFrames[ftype].CharacterCustomize = function(self)
		if not self.prdb.CharacterCustomize or self.initialized.CharacterCustomize then return end

		if not _G.CharCustomizeFrame then
			_G.C_Timer.After(0.1, function()
				self.blizzLoDFrames[ftype].CharacterCustomize(self)
			end)
			return
		end

		self.initialized.CharacterCustomize = true

		self:SecureHookScript(_G.CharCustomizeFrame, "OnShow", function(this)
			self:SecureHook(_G.BarberShopFrame, "UpdateSex", function(fObj)
				for btn in fObj.sexButtonPool:EnumerateActive() do
					btn.Ring:SetTexture(nil)
					btn.BlackBG:SetTexture(nil)
				end
			end)
			self:SecureHook(this, "UpdateAlteredFormButtons", function(fObj)
				local buttonPool = fObj:GetAlteredFormsButtonPool()
				for btn in buttonPool:EnumerateActive() do
					btn.Ring:SetTexture(nil)
				end
			end)
			-- Categories
			local function skinBtnTemplate(template)
				if this.pools:GetPool(template) then
					for btn in this.pools:GetPool(template):EnumerateActive() do
						if btn.Ring then
							btn.Ring:SetTexture(nil)
						end
					end
				end
			end
			self:SecureHook(this, "UpdateOptionButtons", function(fObj, _)
				for type in _G.pairs{"Category", "AlteredForm", "AlteredFormSmall", "ConditionalModel", "BodyType"} do
					skinBtnTemplate("CharCustomize" .. type .. "ButtonTemplate")
				end
				for slider in this.sliderPool:EnumerateActive() do
					self:skinObject("slider", {obj=slider.ScrollBar, fType=ftype})
				end
				if self.modBtns then
					for ddObj in this.dropdownPool:EnumerateActive() do
						self:skinStdButton{obj=ddObj.Dropdown, fType=ftype, ignoreHLTex=true, sechk=true, y1=1, y2=-1}
						self:skinStdButton{obj=ddObj.IncrementButton, fType=ftype, sechk=true, ofs=1}
						self:skinStdButton{obj=ddObj.DecrementButton, fType=ftype, sechk=true, ofs=1}
						if ddObj.Dropdown.WarningTexture
						and ddObj.Dropdown.WarningTexture:GetAlpha() == 0
						then
							ddObj.Dropdown.WarningTexture:Hide()
						end
					end
				end
				if self.modChkBtns then
					for cBtn in this.pools:GetPool("CustomizationOptionCheckButtonTemplate"):EnumerateActive() do
						self:skinCheckButton{obj=cBtn.Button, fType=ftype}
					end
				end
			end)
			if self.modBtns then
				self:skinStdButton{obj=_G.BarberShopFrame.CancelButton, fType=ftype, ofs=0}
				self:skinStdButton{obj=_G.BarberShopFrame.ResetButton, fType=ftype, sechk=true, ofs=0}
				self:skinStdButton{obj=_G.BarberShopFrame.AcceptButton, fType=ftype, sechk=true, ofs=0}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.RandomizeAppearanceButton, fType=ftype, ofs=-4, x1=5, y2=5, clr="gold"}
				for _, btn in _G.pairs(this.SmallButtons.ControlButtons) do
					self:addButtonBorder{obj=btn, fType=ftype, ofs=-4, x1=5, y2=5, clr="gold"}
				end
				self:SecureHook(this, "UpdateZoomButtonStates", function(fObj)
					self:clrBtnBdr(fObj.SmallButtons.ZoomOutButton, "gold")
					self:clrBtnBdr(fObj.SmallButtons.ZoomInButton, "gold")
				end)
			end

		if not aObj.isMnlnBeta then
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, _G.CharCustomizeNoHeaderTooltip)
			end)
		end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].ContainerFrames = function(self)
		if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
		self.initialized.ContainerFrames = true

		if _G.C_AddOns.IsAddOnLoaded("LiteBag") then
			self.blizzFrames[ftype].ContainerFrames = nil
			return
		end

		local function skinBag(frame, id)
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cbns=true})
			-- Add gear texture to portrait button for settings
			local cfpb = frame.PortraitButton
			cfpb.gear = cfpb:CreateTexture(nil, "artwork")
			cfpb.gear:SetTexture(self.tFDIDs.gearWhl)
			cfpb.gear:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
			cfpb:SetSize(18, 18)
			cfpb.Highlight:ClearAllPoints()
			cfpb.Highlight:SetPoint("center")
			cfpb.Highlight:SetSize(22, 22)
			aObj:SecureHook(frame, "UpdateItems", function(this)
				aObj:skinItemSlots(frame, ftype)
			end)
			aObj:skinItemSlots(frame, ftype)
			-- Backpack
			if id == 0 then
				aObj:skinObject("editbox", {obj=_G.BagItemSearchBox, fType=ftype, si=true, ca=true})
				frame.MoneyFrame.Border:DisableDrawLayer("BACKGROUND")
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=_G.BagItemAutoSortButton, ofs=0, y1=1}
				end
			end
		end

		self:SecureHook("ContainerFrame_GenerateFrame", function(frame, _, id)
			-- skin the frame if required
			if not frame.sf then
				skinBag(frame, id)
			end
		end)

		if _G.ContainerFrameSettingsManager.TokenTracker then
			_G.ContainerFrameSettingsManager.TokenTracker.Border:DisableDrawLayer("BACKGROUND")
		end

	end

	aObj.blizzFrames[ftype].CurrencyTransfer = function(self)
		if not self.prdb.CurrencyTransfer or self.initialized.CurrencyTransfer then return end
		self.initialized.CurrencyTransfer = true

		self:SecureHookScript(_G.CurrencyTransferMenu, "OnShow", function(this)
			self:skinObject("ddbutton", {obj=this.Content.SourceSelector.Dropdown, fType=ftype})
			self:skinObject("editbox", {obj=this.Content.AmountSelector.InputBox, fType=ftype, y2=4})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.Content.AmountSelector.MaxQuantityButton, fType=ftype}
				self:skinStdButton{obj=this.Content.ConfirmButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.Content.CancelButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].DamageMeter = function(self)
		if not self.prdb.DamageMeter or self.initialized.DamageMeter then return end
		self.initialized.DamageMeter = true

		local function skinEntry(frame)
			for _, tex in _G.pairs(frame.StatusBar.BackgroundRegions) do
				tex:SetTexture(nil)
			end
			aObj:skinObject("statusbar", {obj=frame.StatusBar, fType=ftype, fi=0})
		end
		local function skinSessionWindow(frame)
			frame.Header:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.SettingsDropdown, fType=ftype, es=12, ofs=-2, y1=1, y2=5}
				aObj:addButtonBorder{obj=frame.SessionDropdown, fType=ftype, rpA=true, es=12, x1=-3, y1=3, x2=4, y2=-3}
				aObj:addButtonBorder{obj=frame.DamageMeterTypeDropdown, fType=ftype, es=12, ofs=-1, y1=0, y2=2}
			end
			self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
			local function skinPlayerEntry(...)
				local _, element, elementData
				if _G.select("#", ...) == 2 then
					element, elementData = ...
				else
					_, element, elementData = ...
				end
				skinEntry(element)
			end
			_G.ScrollUtil.AddInitializedFrameCallback(frame.ScrollBox, skinPlayerEntry, aObj, true)
			skinEntry(frame.LocalPlayerEntry)
			self:skinObject("scrollbar", {obj=frame.SourceWindow.ScrollBar, fType=ftype})
			local function skinSpellEntry(...)
				local _, element, elementData, new
				if _G.select("#", ...) == 2 then
					element, elementData = ...
				elseif _G.select("#", ...) == 3 then
					element, elementData, new = ...
				else
					_, element, elementData, new = ...
				end
				skinEntry(element)
			end
			_G.ScrollUtil.AddInitializedFrameCallback(frame.SourceWindow.ScrollBox, skinSpellEntry, aObj, true)
		end
		_G.DamageMeter:ForEachSessionWindow(function(sessionWindow)
			skinSessionWindow(sessionWindow)
		end)

		self:SecureHook(_G.DamageMeter, "SetupSessionWindow", function(fObj, windowData, windowIndex)
			skinSessionWindow(windowData.sessionWindow)
		end)

	end

	aObj.blizzFrames[ftype].DressUpFrame = function(self)
		if not self.prdb.DressUpFrame or self.initialized.DressUpFrame then return end
		self.initialized.DressUpFrame = true

		if _G.C_AddOns.IsAddOnLoaded("DressUp") then
			self.blizzFrames[ftype].DressUpFrame = nil
			return
		end

		self:SecureHookScript(_G.SideDressUpFrame, "OnShow", function(this)
			self:removeRegions(_G.SideDressUpFrameCloseButton, {5}) -- corner texture
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=-3, y1=-3, x2=-2})
			_G.LowerFrameLevel(this) -- make it appear behind parent frame
			if self.modBtns then
				self:skinStdButton{obj=_G.SideDressUpFrame.ResetButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.DressUpFrame, "OnShow", function(this)
			self:skinObject("ddbutton", {obj=this.OutfitDropdown, fType=ftype})
			self:skinObject("frame", {obj=this.OutfitDetailsPanel, fType=ftype, kfs=true, ofs=-7})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, y2=-4})
			if self.prdb.DUTexture then
				this.ModelBackground:SetDrawLayer("ARTWORK")
				this.ModelBackground:SetAlpha(1)
			else
				this.ModelBackground:SetAlpha(0)
			end
			if self.modBtns then
				self:skinStdButton{obj=this.OutfitDropdown.SaveButton, fType=ftype}
				self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MaximizeButton, fType=ftype, font=self.fontS, text=self.nearrow}
				self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MinimizeButton, fType=ftype, font=self.fontS, text=self.swarrow}
				self:skinStdButton{obj=_G.DressUpFrameCancelButton, fType=ftype}
				self:skinStdButton{obj=this.ResetButton, fType=ftype}
				self:skinStdButton{obj=this.LinkButton, fType=ftype}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.ToggleOutfitDetailsButton, fType=ftype}
			end

			self:SecureHookScript(this.SetSelectionPanel, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-5})
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinSelection(...)
					local _, element, elementData
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					else
						_, element, elementData = ...
					end
					element.BackgroundTexture:SetTexture(nil)
					if self.modBtnBs then
						element.IconBorder:SetAlpha(0)
						self:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, ofs=3}
						if element.sbb then
							self:setBtnClr(element, elementData.itemQuality)
						end
					end
				end
				_G.ScrollUtil.AddInitializedFrameCallback(fObj.ScrollBox, skinSelection, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)

		end)

		self:SecureHookScript(_G.TransmogAndMountDressupFrame, "OnShow", function(this)
			if self.modChkBtns then
				self:skinCheckButton{obj=this.ShowMountCheckButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].FriendsFrame = function(self)
		if not self.prdb.FriendsFrame or self.initialized.FriendsFrame then return end
		self.initialized.FriendsFrame = true

		local function addTabBorder(frame)
			aObj:skinObject("frame", {obj=frame, fType=ftype, chkfb=true, x1=0, y1=-81, x2=1, y2=0})
		end
		self:SecureHookScript(_G.FriendsFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3, y2=-2})

			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, _G.FriendsTooltip)
			end)

			self:SecureHookScript(_G.FriendsTabHeader, "OnShow", function(fTH)
				_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("ddbutton", {obj=_G.FriendsFrameStatusDropdown, fType=ftype})
				-- Top Tabs
				self:skinObject("tabs", {obj=fTH.TabSystem, pool=true, fType=ftype,upwards=true, offsets={x1=1, y1=0, x2=-1, y2=-4}})
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, fType=ftype, ofs=-2, x1=1}
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.ContactsMenuButton, fType=ftype, clr="gold", ofs=-2, x1=1}
				end
				self:SecureHookScript(_G.FriendsFrameBattlenetFrame.BroadcastFrame, "OnShow", function(fObj)
					self:keepFontStrings(fObj.Border)
					fObj.EditBox:DisableDrawLayer("BACKGROUND")
					self:skinObject("editbox", {obj=fObj.EditBox, fType=ftype})
					self:moveObject{obj=fObj.EditBox.PromptText, x=5}
					self:adjHeight{obj=fObj.EditBox, adj=-6}
					self:skinObject("frame", {obj=fObj, fType=ftype, ofs=-10})
					if self.modBtns then
						self:skinStdButton{obj=fObj.UpdateButton, fType=ftype}
						self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:SecureHookScript(_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj, fType=ftype, rns=true})

					self:Unhook(fObj, "OnShow")
				end)

				self:Unhook(fTH, "OnShow")
			end)
			self:checkShown(_G.FriendsTabHeader)

			self:SecureHookScript(_G.FriendsListFrame, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						if element.background then
							element.background:SetAlpha(0)
							if aObj.modBtnBs then
								aObj:addButtonBorder{obj=element.travelPassButton, fType=ftype, schk=true, ofs=0, y1=3, y2=-2}
								aObj:addButtonBorder{obj=element.summonButton, fType=ftype, schk=true}
							end
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				addTabBorder(fObj)
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameAddFriendButton, fType=ftype, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameSendMessageButton, fType=ftype}
					self:skinStdButton{obj=self:getChild(fObj.RIDWarning, 1), fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.FriendsListFrame)

			self:SecureHookScript(_G.RecentAlliesFrame, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.List.ScrollBar, fType=ftype})
				addTabBorder(fObj)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.IgnoreListWindow, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, cb=true, ofs=0, y1=-1})
				if self.modBtns then
					self:skinStdButton{obj=fObj.UnignorePlayerButton, fType=ftype, schk=true}
				end
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, elementData
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					else
						_, element, elementData = ...
					end
				end
				_G.ScrollUtil.AddInitializedFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.WhoFrame, "OnShow", function(fObj)
				self:removeInset(_G.WhoFrameListInset)
				for i = 1, 4 do
					_G["WhoFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
					if i == 2 then
						self:skinObject("ddbutton", {obj=_G.WhoFrameDropdown, fType=ftype, ofs=0})
						self:adjHeight{obj=_G.WhoFrameDropdown, adj=-4}
					else
						self:skinObject("frame", {obj=_G["WhoFrameColumnHeader" .. i], fType=ftype, y2=-2, y2=-3})
					end
				end
				self:moveObject{obj=_G.WhoFrameColumnHeader4, x=2}
				_G.WhoFrameEditBox.Backdrop:SetTexture(nil)
				self:skinObject("editbox", {obj=_G.WhoFrameEditBox, fType=ftype, mi=true, mix=12, x1=-5, y1=-4, y2=4})
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=_G.WhoFrameGroupInviteButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.WhoFrameAddFriendButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.WhoFrameWhoButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.AddFriendFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("editbox", {obj=_G.AddFriendNameEditBox, fType=ftype})
			self:moveObject{obj=_G.AddFriendNameEditBoxFill, x=5}
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.AddFriendInfoFrameContinueButton}
				self:skinStdButton{obj=_G.AddFriendEntryFrameAcceptButton}
				self:skinStdButton{obj=_G.AddFriendEntryFrameCancelButton}
				self:SecureHookScript(_G.AddFriendNameEditBox, "OnTextChanged", function(_)
					self:clrBtnBdr(_G.AddFriendEntryFrameAcceptButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.FriendsFriendsFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("ddbutton", {obj=this.FriendsDropdown, fType=ftype})
			self:removeBackdrop(this.ScrollFrameBorder)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=this.SendRequestButton, fType=ftype, schk=true}
				self:skinStdButton{obj=this.CloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.BattleTagInviteFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(this, 2)} -- SEND_REQUEST
				self:skinStdButton{obj=self:getChild(this, 3)} -- CANCEL
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RecruitAFriendFrame, "OnShow", function(this)
			this.RewardClaiming:DisableDrawLayer("BACKGROUND")
			this.RewardClaiming.NextRewardButton.IconBorder:SetTexture(nil)
			self:removeInset(this.RewardClaiming.Inset)
			this.RecruitList.Header:DisableDrawLayer("BACKGROUND")
			self:removeInset(this.RecruitList.ScrollFrameInset)
			self:skinObject("scrollbar", {obj=this.RecruitList.ScrollBar, fType=ftype})
			this.SplashFrame.Description:SetTextColor(self.BT:GetRGB())
			self:skinObject("frame", {obj=this.SplashFrame, fType=ftype, ofs=2, y1=4, y2=-5})
			addTabBorder(this)
			if self.modBtns then
				self:skinStdButton{obj=this.RewardClaiming.ClaimOrViewRewardButton, fType=ftype}
				self:skinStdButton{obj=this.RecruitmentButton, fType=ftype}
				self:skinStdButton{obj=this.SplashFrame.OKButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RecruitAFriendRewardsFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this.Border, fType=ftype, kfs=true, ofs=-4})
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseButton, fType=ftype}
			end
			if self.modBtnBs then
				for reward in this.rewardPool:EnumerateActive() do
					self:addButtonBorder{obj=reward.Button, fType=ftype, clr="sepia"}
				end
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RecruitAFriendRecruitmentFrame, "OnShow", function(this)
			self:skinObject("editbox", {obj=this.EditBox, fType=ftype})
			self:adjHeight{obj=this.EditBox, adj=-6}
			self:skinObject("frame", {obj=this.Border, fType=ftype, kfs=true, ofs=-4})
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseButton, fType=ftype}
				self:skinStdButton{obj=this.GenerateOrCopyLinkButton, fType=ftype, schk=true, sechk=true}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.QuickJoinFrame, "OnShow", function(this)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			self:removeMagicBtnTex(this.JoinQueueButton)
			if self.modBtns then
				self:skinStdButton{obj=this.JoinQueueButton, fType=ftype, x2=0, schk=true}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.QuickJoinRoleSelectionFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=-5})
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton, fType=ftype}
				self:skinStdButton{obj=this.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				for _, btn in _G.pairs(_G.QuickJoinRoleSelectionFrame.Roles) do
					self:skinCheckButton{obj=btn.CheckButton, fType=ftype}
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].GuildControlUI = function(self)
		if not self.prdb.GuildControlUI or self.initialized.GuildControlUI then return end
		self.initialized.GuildControlUI = true

		self:SecureHookScript(_G.GuildControlUI, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			_G.GuildControlUIHbar:SetAlpha(0)
			self:skinObject("ddbutton", {obj=this.dropdown, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-8, y2=3})
			self:moveObject{obj=this, x=-25, y=12}

			self:SecureHookScript(this.orderFrame, "OnShow", function(fObj)
				local frame
				local function skinROFrames()
					for i = 1, _G.MAX_GUILDRANKS do
						frame = _G["GuildControlUIRankOrderFrameRank" .. i]
						if frame
						and not frame.sknd
						then
							frame.sknd = true
							aObj:skinObject("editbox", {obj=frame.nameBox, fType=ftype, y1=-4, y2=4})
							if aObj.modBtnBs then
								aObj:addButtonBorder{obj=frame.downButton, ofs=0}
								aObj:addButtonBorder{obj=frame.upButton, ofs=0}
								aObj:addButtonBorder{obj=frame.deleteButton, ofs=0}
							end
						end
					end
				end
				self:SecureHook("GuildControlUI_RankOrder_Update", function(_)
					skinROFrames()
				end)
				skinROFrames()

				if self.modBtns then
					self:skinStdButton{obj=fObj.newButton}
					self:skinStdButton{obj=fObj.dupButton}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.orderFrame)

			self:SecureHookScript(this.bankTabFrame, "OnShow", function(fObj)
				self:skinObject("ddbutton", {obj=fObj.dropdown, fType=ftype})
				fObj.inset:DisableDrawLayer("BACKGROUND")
				fObj.inset:DisableDrawLayer("BORDER")
				self:skinObject("scrollbar", {obj=fObj.inset.scrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})

				self:Unhook(fObj, "OnShow")
			end)

			-- hook this as buttons are created as required, done here as inside the HookScript function is too late
			self:SecureHook("GuildControlUI_BankTabPermissions_Update", function(_)
				for i = 1, _G.MAX_GUILDBANK_TABS do
					if _G["GuildControlBankTab" .. i]
					and not _G["GuildControlBankTab" .. i].sknd
					then
						_G["GuildControlBankTab" .. i].sknd = true
						_G["GuildControlBankTab" .. i]:DisableDrawLayer("BACKGROUND")
						self:skinObject("editbox", {obj=_G["GuildControlBankTab" .. i].owned.editBox, fType=ftype})
						if self.modBtns then
							self:skinStdButton{obj=_G["GuildControlBankTab" .. i].buy.button, as=true}
						end
						if self.modBtnBs then
							self:addButtonBorder{obj=_G["GuildControlBankTab" .. i].owned, relTo=_G["GuildControlBankTab" .. i].owned.tabIcon, es=10}
						end
						if self.modChkBtns then
							self:skinCheckButton{obj=_G["GuildControlBankTab" .. i].owned.viewCB}
							self:skinCheckButton{obj=_G["GuildControlBankTab" .. i].owned.depositCB}
						end
					end
				end
			end)

			self:SecureHookScript(this.rankPermFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:skinObject("ddbutton", {obj=fObj.dropdown, fType=ftype})
				self:skinObject("editbox", {obj=fObj.goldBox, fType=ftype, y1=-4, y2=4})
				if self.modChkBtns then
					for _, child in _G.ipairs{fObj:GetChildren()} do
						if child:IsObjectType("CheckButton") then
							self:skinCheckButton{obj=child}
						end
					end
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.rankPermFrame)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].GuildInvite = function(self)
		if not self.prdb.GuildInvite or self.initialized.GuildInvite then return end
		self.initialized.GuildInvite = true

		self:SecureHookScript(_G.GuildInviteFrame, "OnShow", function(this)
			_G.GuildInviteFrameTabardBorder:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.GuildInviteFrameJoinButton}
				self:skinStdButton{obj=_G.GuildInviteFrameDeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].InspectUI = function(self)
		if not self.prdb.InspectUI or self.initialized.InspectUI then return end
		self.initialized.InspectUI = true

		self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})

			-- let AddOn skins know when when UI is skinned (used by oGlow skin)
			self.callbacks:Fire("InspectUI_Skinned", self)
			self.callbacks.events["InspectUI_Skinned"] = nil

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.InspectPaperDollFrame, "OnShow", function(this)
			_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
			_G.InspectModelFrame:DisableDrawLayer("BORDER")
			_G.InspectModelFrame:DisableDrawLayer("OVERLAY")
			_G.InspectModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
			self.RegisterCallback("IPDF", "IPDIF_GetChildren", function(_, child, _)
				if self:hasTextInName(child, "Slot")
				and self.modBtnBs
				then
					child:DisableDrawLayer("BACKGROUND")
					self:addButtonBorder{obj=child, fType=ftype, ibt=true}
				elseif self:hasTextInDebugNameRE(child, "InspectTalents$")
				and self.modBtns
				then
					self:skinStdButton{obj=child, fType=ftype, sechk=true}
					if _G.C_AddOns.IsAddOnLoaded("BetterCharacterPanel") then
						child:SetSize(102, 24)
						child.Text:SetPoint("CENTER", 0, 0)
						self:moveObject{obj=child, x=-15, y=35}
						child.LeftHighlight:SetTexture(nil)
						child.RightHighlight:SetTexture(nil)
						child.MiddleHighlight:SetTexture(nil)
					end
				end
			end)
			self:scanChildren{obj=_G.InspectPaperDollItemsFrame, cbstr="IPDIF_GetChildren"}
			if self.modBtns then
				self:skinStdButton{obj=this.ViewButton}
			end
			if self.modBtnBs then
				self:SecureHook("InspectPaperDollItemSlotButton_Update", function(btn)
					if not btn.hasItem then
						self:clrBtnBdr(btn, "grey")
						btn.icon:SetTexture(nil)
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.InspectPVPFrame, "OnShow", function(this)
			this.BG:SetTexture(nil)
			for _, slot in _G.ipairs(this.Slots) do
				slot.Border:SetTexture(nil)
				self:makeIconSquare(slot, "Texture", "gold")
			end

			self:Unhook(this, "OnShow")
		end)

		-- N.B. InspectTalentFrame now replaced by new TalentUI

		self:SecureHookScript(_G.InspectGuildFrame, "OnShow", function(this)
			_G.InspectGuildFrameBG:SetAlpha(0)
			this.Points:DisableDrawLayer("BACKGROUND")

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].LootFrames = function(self)
		if not self.prdb.LootFrames.skin or self.initialized.LootFrames then return end
		self.initialized.LootFrames = true

		self:SecureHookScript(_G.LootFrame, "OnShow", function(this)
			this.Bg:DisableDrawLayer("BACKGROUND")
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			self:keepFontStrings(this.ScrollBox.Shadows)
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					if element.Item then
						element.NameFrame:SetTexture(nil)
						element.BorderFrame:SetAlpha(0)
						element.HighlightNameFrame:SetTexture(nil)
						element.PushedNameFrame:SetTexture(nil)
						if element.QualityStripe then
							element.QualityStripe:SetTexture(nil)
						end
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element.Item, fType=ftype, ibt=true, ofs=3, y2=-2}
						end
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, x1=4})
			if self.modBtns then
				self:skinCloseButton{obj=this.ClosePanelButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		local function skinGroupLoot(frame)
			frame:DisableDrawLayer("BACKGROUND")
			frame:DisableDrawLayer("BORDER")
			aObj:skinObject("statusbar", {obj=frame.Timer, fi=0, bg=frame.Timer.Background})
			-- hook this to show the Timer
			aObj:SecureHook(frame, "Show", function(fObj)
				fObj.Timer:SetFrameLevel(fObj:GetFrameLevel() + 1)
			end)
			frame:SetScale(aObj.prdb.LootFrames.size ~= 1 and 0.75 or 1)
			frame.IconFrame.Border:SetAlpha(0)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.IconFrame, fType=ftype, relTo=frame.IconFrame.Icon}
				-- TODO: colour the item border
			end
			-- if aObj.modBtns then
			-- 	aObj:skinCloseButton{obj=frame.PassButton}
			-- end
			if aObj.prdb.LootFrames.size ~= 3 then -- Normal or small
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, x1=-3, y2=-3})
			else -- Micro
				aObj:moveObject{obj=frame.IconFrame, x=95, y=5}
				frame.Name:SetAlpha(0)
				frame.NeedButton:ClearAllPoints()
				frame.NeedButton:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -34, -4)
				frame.PassButton:ClearAllPoints()
				frame.PassButton:SetPoint("LEFT", frame.NeedButton, "RIGHT", 0, 2)
				frame.GreedButton:ClearAllPoints()
				frame.GreedButton:SetPoint("RIGHT", frame.NeedButton, "LEFT")
				frame.DisenchantButton:ClearAllPoints()
				frame.DisenchantButton:SetPoint("RIGHT", frame.GreedButton, "LEFT", 2, 0)
				aObj:adjWidth{obj=frame.Timer, adj=-30}
				frame.Timer:ClearAllPoints()
				frame.Timer:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -10, 13)
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, x1=97, y2=8})
			end
		end
		local NUM_GROUP_LOOT_FRAMES = 4
		for i = 1, NUM_GROUP_LOOT_FRAMES do
			self:SecureHookScript(_G["GroupLootFrame" .. i], "OnShow", function(this)
				skinGroupLoot(this)

				self:Unhook(this, "OnShow")
			end)
		end

		self:SecureHookScript(_G.GroupLootHistoryFrame, "OnShow", function(this)
			this.Bg:DisableDrawLayer("BACKGROUND")
			self:skinObject("ddbutton", {obj=this.EncounterDropdown, fType=ftype})
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinHistory(...)
				local _, element, elementData
				if _G.select("#", ...) == 2 then
					element, elementData = ...
				else
					_, element, elementData = ...
				end
				if elementData.lootListID then
					element.BackgroundArtFrame.NameFrame:SetTexture(nil)
					element.BackgroundArtFrame.BorderFrame:SetAlpha(0)
					aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true})
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element.Item, fType=ftype, ibt=true}
					end
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinHistory, aObj, true)
			this.Timer.Background:SetTexture(self.sbTexture)
			this.Timer.Background:SetVertexColor(self.sbClr:GetRGBA())
			this.Timer.Fill:SetTexture(self.sbTexture)
			this.Timer.Border:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0, y1=-1})
			if self.modBtns then
				self:skinCloseButton{obj=this.ClosePanelButton, fType=ftype}
			end

			self:SecureHookScript(this.PerfectAnimFrame, "OnShow", function(fObj)
				fObj.BackgroundArtFrame.NameFrame:SetTexture(nil)
				fObj.BackgroundArtFrame.BorderFrame:SetAlpha(0)
				self:skinObject("frame", {obj=fObj, fType=ftype, fb=true})
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.Item, fType=ftype, ibt=true}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.PerfectAnimFrame)

			self:Unhook(this, "OnShow")
		end)

		-- BonusRollFrame
		self:SecureHookScript(_G.BonusRollFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2, 3, 5})
			self:skinObject("statusbar", {obj=this.PromptFrame.Timer, fi=0})
			self:skinObject("frame", {obj=this, fType=ftype, bg=true})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.MasterLooterFrame, "OnShow", function(this)
			self:removeRegions(this.Item, {2, 3, 4, 5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				 self:skinCloseButton{obj=self:getChild(this, 4), fType=ftype} -- unamed close button
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Item, fType=ftype, relTo=this.Item.Icon}
				-- TODO: colour the item border
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].ObjectiveTracker = function(self)
		if not self.prdb.ObjectiveTracker.skin
		and not self.prdb.ObjectiveTracker.popups
		and not self.prdb.ObjectiveTracker.animapowers
		and not self.prdb.ObjectiveTracker.headers
		then
			return
		end
		self.initialized.ObjectiveTracker = true

		local skinAutoPopUp = _G.nop
		if self.prdb.ObjectiveTracker.popups then
			function skinAutoPopUp(block)
				aObj:skinObject("frame", {obj=block.Contents, fType=ftype, kfs=true})
				block.Contents.Exclamation:SetAlpha(1)
				block.Contents.QuestionMark:SetAlpha(1)
				if block.popUpType == "COMPLETE" then
					block.Contents.QuestionMark:Show()
				else
					block.Contents.Exclamation:Show()
				end
			end
		end

		self:SecureHookScript(_G.ObjectiveTrackerFrame, "OnShow", function(this)
			--[[
				AchievementObjectiveTracker
				AdventureObjectiveTracker
				BonusObjectiveTracker
				CampaignQuestObjectiveTracker
				MonthlyActivitiesObjectiveTracker
				ProfessionsRecipeTracker
				QuestObjectiveTracker
				ScenarioObjectiveTracker
				UIWidgetObjectiveTracker
				WorldQuestObjectiveTracker
			]]
			if self.prdb.ObjectiveTracker.headers then
				this.Header.Background:SetTexture(nil)
			end
			if self.prdb.ObjectiveTracker.skin then
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=-20, y1=4, x2=12, y2=-4})
			end
			if self.modBtnBs then
				self:skinExpandButton{obj=this.Header.MinimizeButton, onSB=true}
			end

			if self.prdb.ObjectiveTracker.modules then
				local function skinBar(bar)
					-- aObj:Debug("skinBar: [%s, %s]", bar, bar.template)
					if bar.template == "BonusTrackerProgressBarTemplate"
					or bar.template == "ScenarioProgressBarTemplate"
					then
						for _, tex in _G.pairs{"IconBG", "BarFrame", "BarFrame2", "BarFrame3", "BarGlow", "Sheen", "Starburst"} do
							bar.Bar[tex]:SetTexture(nil)
						end
						for _, frame in _G.pairs{"Flare1", "Flare2", "SmallFlare1", "SmallFlare2", "FullBarFlare1", 'FullBarFlare2'} do
							bar[frame]:DisableDrawLayer("ARTWORK")
						end
						aObj:skinObject("statusbar", {obj=bar.Bar, fi=0, bg=bar.Bar.BarBG})
					elseif bar.template == "ObjectiveTrackerProgressBarTemplate"
					or bar.template == "ObjectiveTrackerTimerBarTemplate"
					then
						aObj:removeRegions(bar.Bar, {1, 2, 3}) -- Border textures
						aObj:skinObject("statusbar", {obj=bar.Bar, fi=0, bg=aObj:getRegion(bar.Bar, bar.template:find("Progress") and 5 or 4)})
					end
				end
				local modName
				local function skinModule(module, _)
					modName = module:GetName()
					if aObj.prdb.ObjectiveTracker.headers then
						module.Header.Background:SetTexture(nil)
					end
					if module.hasContents then
						if modName == "ScenarioObjectiveTracker" then
							for _, block in _G.pairs(module.FixedBlocks) do
								if block == module.ObjectivesBlock then
									if block.spellFramePool
									and aObj.modBtnBs
									then
										for spell in block.spellFramePool:EnumerateActive() do
											aObj:addButtonBorder{obj=spell, fType=ftype, relTo=spell.Icon, reParent={spell.cooldown}, ooc=true}
										end
									end
								elseif block == module.StageBlock then
									--@debug@
									-- aObj:Debug("skinModule StageBlock: [%s, %s]", block.widgetSetID)
									-- _G.Spew("StageBlock", block)
									--@end-debug@
									if block.widgetSetID ~= 842 then -- Delves
										aObj:skinObject("frame", {obj=block, fType=ftype, kfs=true, ofs=0, x2=-17, y2=6, clr="sepia"})
									end
									-- N.B. widgets skinned in UIWidgets skinWidget function
								elseif block == module.TopWidgetContainerBlock
								or block == module.BottomWidgetContainerBlock
								then
									_G.nop()
								elseif block == module.MawBuffsBlock then
									-- Blizzard_MawBuffs.xml
									if aObj.prdb.ObjectiveTracker.animapowers then
										aObj.modUIBtns:skinStdButton{obj=block.Container, fType=ftype, ignoreHLTex=true, ofs=-9, x1=12, x2=-2, clr="turq", ca=0.65} -- use module, treat like a frame
										block.Container.SetWidth = _G.nop
										block.Container.SetHighlightAtlas = _G.nop
										aObj:secureHook(block.Container, "UpdateListState", function(bObj, _)
											aObj:clrBtnBdr(bObj)
										end)
										aObj:skinObject("frame", {obj=block.Container.List, fType=ftype, kfs=true, ofs=-9, x1=0, x2=-16, clr="turq", ca=0.65})
										aObj:secureHook(block.Container.List, "Update", function(this, _)
											for mawBuff in this.buffPool:EnumerateActive() do
												mawBuff.Border:SetTexture(nil)
											end
										end)
									end
								elseif block == module.ChallengeModeBlock then
									aObj:skinObject("statusbar", {obj=block.StatusBar, fi=0, bg=block.TimerBG, other={block.TimerBGBack}})
									aObj:removeRegions(block, {3}) -- challengemode-timer atlas
									aObj:skinObject("frame", {obj=block, fType=ftype, y2=7})
									aObj:secureHook(block, "SetUpAffixes", function(blk, _)
										for affix in blk.affixPool:EnumerateActive() do
											affix.Border:SetTexture(nil)
										end
									end)
								elseif block == module.ProvingGroundsBlock then
									block.BG:SetTexture(nil)
									block.GoldCurlies:SetTexture(nil)
									aObj:skinObject("statusbar", {obj=block.StatusBar, fi=0})
									aObj:removeRegions(block.StatusBar, {1}) -- border
									block.CountdownAnimFrame.BGAnim:SetTexture(nil)
									block.CountdownAnimFrame.BorderAnim:SetTexture(nil)
									aObj:skinObject("frame", {obj=block, fType=ftype, x2=41})
								end
							end
						end
						if module.usedBlocks then
							for template, blocks in _G.pairs(module.usedBlocks) do
								if template:find("AutoQuestPopUp") then
									for _, block in _G.pairs(blocks) do
										skinAutoPopUp(block)
									end
								end
							end
						end
						if module.usedProgressBars then
							for _, pBar in _G.pairs(module.usedProgressBars) do
								skinBar(pBar)
							end
						end
						if module.usedTimerBars then
							for _, tBar in _G.pairs(module.usedTimerBars) do
								skinBar(tBar)
							end
						end
						if module.usedRightEdgeFrames
						and aObj.modBtnBs
						then
							for _, frame in _G.pairs(module.usedRightEdgeFrames) do
								if frame.template:find("ItemButton") then
									-- N.B.: can cause ADDON_ACTION_FORBIDDEN when clicked
									aObj:addButtonBorder{obj=frame, fType=ftype, ofs=4, clr="gold"}
								elseif frame.template:find("FindGroupButton") then
									aObj:addButtonBorder{obj=frame, fType=ftype, ofs=-1, x1=0, clr="gold"}
								end
							end
						end
					end
				end
				for _, module in _G.pairs(this.modules) do
					skinModule(module)
					self:SecureHook(module, "LayoutContents", function(fObj)
						skinModule(fObj, true)
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ObjectiveTrackerFrame)

		if self.prdb.ObjectiveTracker.rewards then
			local function skinRewards(reward)
				for btn in reward.framePool:EnumerateActive() do
					btn.ItemBorder:SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.ItemIcon}
					end
				end
			end
			self:SecureHook(_G.ObjectiveTrackerManager, "ShowRewardsToast", function(this, _, _, _, _, _)
				for rewardsToast in this.rewardsToastPool:EnumerateActive() do
					rewardsToast:DisableDrawLayer("ARTWORK")
					rewardsToast:DisableDrawLayer("BORDER")
					-- self:skinObject("frame", {obj=rewardsToast, fType=ftype, kfs=true})
					skinRewards(rewardsToast)
				end
			end)

			self:SecureHookScript(_G.ObjectiveTrackerTopBannerFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")
				this:DisableDrawLayer("BORDER")
				this:DisableDrawLayer("OVERLAY")
				this.Filigree:SetDrawLayer("OVERLAY")

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.ScenarioRewardsFrame, "OnShow", function(this)
				this:DisableDrawLayer("ARTWORK")
				this:DisableDrawLayer("BORDER")
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
				skinRewards(this)
				self:SecureHook(this, "DisplayRewards", function(fObj, _, _)
					skinRewards(fObj)
				end)

				self:Unhook(this, "OnShow")
			end)
		end

	end

	aObj.blizzLoDFrames[ftype].PlayerSpells = function(self)
		if not self.prdb.PlayerSpells or self.initialized.PlayerSpells then return end
		self.initialized.PlayerSpells = true

		local function skinSearchPreviewContainer(frame)
			local function skinSearch(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					element.IconFrame:SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinSearch, aObj, true)
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=5, y2=-2})
		end

		self:SecureHookScript(_G.PlayerSpellsFrame, "OnShow", function(this)
			this.PortraitContainer.portrait:SetAlpha(0)
			self:skinObject("tabs", {obj=this.TabSystem,  pool=true, fType=ftype, ignoreSize=true, track=false})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, y1=0, x2=1})

			self:SecureHookScript(this.MaximizeMinimizeButton, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:skinOtherButton{obj=fObj.MaximizeButton, fType=ftype, font=self.fontS, text=self.nearrow}
					self:skinOtherButton{obj=fObj.MinimizeButton, fType=ftype, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MaximizeMinimizeButton)

			self:SecureHookScript(this.SpecFrame, "OnShow", function(fObj)
				fObj.Background:SetTexture(nil)
				fObj.BlackBG:SetTexture(nil)
				local function skinSpecFrames()
					for specContentFrame in fObj.SpecContentFramePool:EnumerateActive() do
						specContentFrame:DisableDrawLayer("BORDER")
						specContentFrame:DisableDrawLayer("OVERLAY")
						-- add border around SpecImage
						aObj.modUIBtns:addButtonBorder{obj=specContentFrame, fType=ftype, relTo=specContentFrame.SpecImage}
						self:skinObject("frame", {obj=specContentFrame, fType=ftype, chkfb=true, y2=-4})
						if specContentFrame.specIndex == fObj:GetCurrentSpecIndex() then
							self:clrBtnBdr(specContentFrame, "orange")
							if specContentFrame.sf then
								self:clrBBC(specContentFrame.sf, "orange")
							end
						else
							self:clrBtnBdr(specContentFrame, "grey")
							if specContentFrame.sf then
								self:clrBBC(specContentFrame.sf, "grey")
							end
						end
						if aObj.modBtns then
							aObj:skinStdButton{obj=specContentFrame.ActivateButton, fType=ftype, schk=true}
						end
					end
				end
				skinSpecFrames()
				self:SecureHook(fObj, "UpdateSpecFrame", function(_)
					if not _G.C_SpecializationInfo.IsInitialized() then
						return
					end
					skinSpecFrames()
				end)
				self:SecureHook(fObj, "UpdateSpecContents", function(_)
					if _G.GetNumSpecializations(false, false) == 0 then
						return
					end
					skinSpecFrames()
				end)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.SpecFrame)

			self:SecureHookScript(this.TalentsFrame, "OnShow", function(fObj)
				fObj.BlackBG:SetTexture(nil)
				fObj.BottomBar:SetTexture(nil)
				local htc = fObj.HeroTalentsContainer
				htc.HeroSpecButton.Border:SetTexture(nil)
				htc.HeroSpecButton.BorderHover:SetTexture(nil)
				-- TODO: Only hide these textures when a spec is selected
				if not htc:IsDisplayingHeroSpecChoices() then
					htc.HeroSpecButton.ChoiceBorder:SetTexture(nil)
					htc.HeroSpecButton.ChoiceBorderHover:SetTexture(nil)
				else
					self:SecureHook(htc, "UpdateHeroSpecButton", function(frame)
						if not htc:IsDisplayingHeroSpecChoices() then
							htc.HeroSpecButton.ChoiceBorder:SetTexture(nil)
							htc.HeroSpecButton.ChoiceBorderHover:SetTexture(nil)
						end
						self:Unhook(frame, "UpdateHeroSpecButton")
					end)
				end
				self:changeTandC( htc.CurrencyFrame.Background)
				-- .CollapseButton is displayed when Hero Spec hasn't been selected
				self:skinObject("frame", {obj=htc.PreviewContainer, fType=ftype, kfs=true, fb=true, ofs=-26, y1=-45, clr="grey"})
				self:skinObject("frame", {obj=htc.ExpandedContainer, fType=ftype, kfs=true, fb=true, ofs=-26, y1=-45})
				self:skinObject("frame", {obj=htc.CollapsedContainer, fType=ftype, kfs=true, fb=true, ofs=-26, y1=-45})
				-- .HeroTalentsUnlockedAnimFrame

				self:skinObject("ddbutton", {obj=fObj.LoadSystem.Dropdown, fType=ftype})
				self:skinObject("editbox", {obj=fObj.SearchBox, fType=ftype, si=true, y1=-4, y2=4})
				skinSearchPreviewContainer(fObj.SearchPreviewContainer)
				fObj.WarmodeButton.Ring:SetAlpha(0)
				if self.modBtns then
					self:skinStdButton{obj=fObj.ApplyButton, fType=ftype, sechk=true, ofs=2}
					self:skinStdButton{obj=fObj.InspectCopyButton, fType=ftype}
				end

				self:SecureHookScript(fObj.PvPTalentList, "OnShow", function(frame)
					local function skinElement(...)
						local _, element, elementData, new
						if _G.select("#", ...) == 2 then
							element, elementData = ...
						elseif _G.select("#", ...) == 3 then
							element, elementData, new = ...
						else
							_, element, elementData, new = ...
						end
						if new ~= false then
							element.Border:SetTexture(nil)
							element.Selected:SetTexture(nil)
							element.SelectedOtherCheck:SetTexture(nil)
						end
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr=(elementData.selectedHere or elementData.selectedOther) and "yellow" or "green"}
							if element.sbb then
								aObj:clrBtnBdr(element, (elementData.selectedHere or elementData.selectedOther) and "yellow" or "green")
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinElement, aObj, true)
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=6})

					self:Unhook(frame, "OnShow")
				end)

				self:SecureHookScript(_G.HeroTalentsSelectionDialog, "OnShow", function(frame)
					for spec in frame.SpecContentFramePool:EnumerateActive() do
						spec.ColumnDivider:SetTexture(nil)
						-- TODO: make the SpecImage square ?
						spec.SpecImageBorder:SetTexture(nil)
						spec.SpecImageBorderSelected:SetTexture(nil)
						for _, texArray in _G.pairs{"ActivatedLeftFrames", "ActivatedRightFrames"} do
							for _, tex in _G.ipairs(spec[texArray]) do
								tex:SetTexture(nil)
							end
						end
						self:skinObject("frame", {obj=spec, fType=ftype, fb=true})
						if self.modBtns then
							self:skinStdButton{obj=spec.ActivateButton, fType=ftype}
							self:skinStdButton{obj=spec.ApplyChangesButton, fType=ftype, sechk=true}
						end
					end
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=2})

					self:Unhook(frame, "OnShow")
				end)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.TalentsFrame)

			local elementData, btn
			local function skinSpells()
				for _, view in _G.pairs(_G.PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.ViewFrames) do
					for _, spell in _G.ipairs(view:GetLayoutChildren()) do
						if spell.GetElementData then
							elementData = spell:GetElementData()
							spell.Backplate:SetTexture(nil)
							if elementData.isHeader then
								spell.Text:SetTextColor(aObj.HT:GetRGB())
								spell.Border:SetTexture(nil)
							else
								spell.Name:SetTextColor(aObj.HT:GetRGB())
								spell.SubName:SetTextColor(aObj.BT:GetRGB())
								spell.RequiredLevel:SetTextColor(aObj.BT:GetRGB())
								btn = spell.Button
								btn.Border:SetAtlas(nil)
								btn.BorderSheen:SetTexture(nil)
								-- fix for #177 ADDON_ACTION_FORBIDDEN AddOn 'Skinner' tried to call the protected function 'CastSpellByID()'
								aObj:secureHook(spell, "UpdateVisuals", function(sObj)
									sObj.Button.Border:SetAtlas(nil)
								end)
								if aObj.modBtnBs then
									aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.Icon, rpA=true, ofs=3, sba=true}
								end
							end
						end
					end
				end
			end
			self:SecureHookScript(this.SpellBookFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				fObj.HelpPlateButton.Ring:SetTexture(nil)
				self:skinObject("tabs", {obj=fObj.CategoryTabSystem,  pool=true, fType=ftype, ignoreSize=true, track=false})
				-- SettingsDropdown
				self:getRegion(fObj.AssistedCombatRotationSpellFrame, 2):SetTexture(nil)
				self:skinObject("editbox", {obj=fObj.SearchBox, fType=ftype, si=true, y1=-4, y2=4})
				skinSearchPreviewContainer(fObj.SearchPreviewContainer)
				self:skinObject("frame", {obj=fObj.PagedSpellsFrame, fType=ftype, kfs=true, fb=true, x1=0, y1=8, x2=3, y2=-4})
				skinSpells()
				fObj.PagedSpellsFrame:RegisterCallback(_G.PagedContentFrameBaseMixin.Event.OnUpdate, skinSpells, aObj)
				self:skinPageBtns(fObj.PagedSpellsFrame)
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.AssistedCombatRotationSpellFrame.Button, fType=ftype, sft=true, ofs=4}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.SpellBookFrame)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ClassTalentLoadoutCreateDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.NameControl.EditBox, fType=ftype, y1=-10, y2=10})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.ClassTalentLoadoutImportDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj.ImportControl.InputContainer, fType=ftype, kfs=true, fb=true, ofs=6})
			self:skinObject("editbox", {obj=fObj.NameControl.EditBox, fType=ftype, y1=-10, y2=10})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.ClassTalentLoadoutEditDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.NameControl.EditBox, fType=ftype, y1=-10, y2=10})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.DeleteButton, fType=ftype}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.UsesSharedActionBars.CheckButton, fType=ftype}
			end
			self:Unhook(fObj, "OnShow")
		end)
	end

	local skinHdrs, skinNISpinner, skinQualityDialog, skinReagentBtn, skinReagentBtns, skinRecraftSlot = _G.nop, _G.nop, _G.nop, _G.nop, _G.nop, _G.nop
	aObj.blizzLoDFrames[ftype].ProfessionsTemplates = function(self)
		if not self.prdb.Professions or self.initialized.ProfessionsTemplates then return end
		self.initialized.ProfessionsTemplates = true

		self:RawHook("OpenProfessionsItemFlyout", function(...)
			local flyout = self.hooks.OpenProfessionsItemFlyout(...)
			self:skinObject("frame", {obj=flyout, fType=ftype, kfs=true, rns=true, ofs=0})
			if self.modBtnBs then
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						-- TODO: sort out item colour issue
						if not element.sbb then
							self:addButtonBorder{obj=element, fType=ftype, ibt=true, relTo=element.Icon}
						else
							self:clrButtonFromBorder(element)
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(flyout.ScrollBox, skinElement, aObj, true)
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=flyout.HideUnownedCheckbox, fType=ftype}
			end

			self:Unhook("OpenProfessionsItemFlyout")
			return flyout
		end, true)

		if self.modBtnBs then
			function skinReagentBtn(btn, ignTex)
				ignTex = ignTex or false
				if btn.CropFrame then
					btn.CropFrame:SetTexture(nil)
					-- show Normal/Pushed texture if CropFrame shown
					if btn.CropFrame:IsShown() then
						ignTex = true
					end
				end
				if btn.SlotBackground then
					btn.SlotBackground:SetTexture(nil)
				end
				if not btn.sbb then
					aObj:addButtonBorder{obj=btn, fType=ftype, ibt=true, relTo=btn.Icon, reParent={btn.ColorOverlay, btn.HighlightTexture, btn.QualityOverlay, btn.InputOverlay}, ignTex=ignTex}
				end
			end
			function skinReagentBtns(sfFrame)
				for slot in sfFrame.reagentSlotPool:EnumerateActive() do
					skinReagentBtn(slot.Button)
					if aObj.modChkBtns
					and slot.Checkbox
					then
						aObj:skinCheckButton{obj=slot.Checkbox, fType=ftype}
					end
				end
				if sfFrame.extraSlotFrames then
					for _, slot in _G.pairs(sfFrame.extraSlotFrames) do
						if slot.Button
						and (slot == sfFrame.salvageSlot
						or slot == sfFrame.enchantSlot)
						then
							skinReagentBtn(slot.Button)
						end
					end
				end
			end
		end

		function skinHdrs(frame)
			for hdr in frame.tableBuilder:EnumerateHeaders() do
				hdr:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=hdr, fType=ftype, ofs=1})
			end
		end

		function skinNISpinner(ebObj)
			ebObj:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("editbox", {obj=ebObj, fType=ftype, chginset=false, ofs=0, x1=-6})
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=ebObj.IncrementButton, ofs=0, x2=-1, clr="gold", sechk=true}
				aObj:addButtonBorder{obj=ebObj.DecrementButton, ofs=0, x2=-1, clr="gold", sechk=true}
			end
		end

		function skinQualityDialog(frame)
			for _, c in _G.pairs(frame.containers) do
				skinReagentBtn(c.Button)
				skinNISpinner(c.EditBox)
			end
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, rns=true})
			if aObj.modBtns then
				aObj:skinCloseButton{obj=frame.ClosePanelButton, fType=ftype}
				aObj:skinStdButton{obj=frame.CancelButton, fType=ftype}
				aObj:skinStdButton{obj=frame.AcceptButton, fType=ftype, sechk=true}
			end
		end

		function skinRecraftSlot(frame)
			frame.Background:SetAlpha(0)
			frame.InputSlot.BorderTexture:SetAlpha(0)
			skinReagentBtn(frame.InputSlot, true)
			frame.OutputSlot.ItemFrame:SetTexture(nil)
			skinReagentBtn(frame.OutputSlot)
		end

	end

	aObj.blizzLoDFrames[ftype].Professions = function(self)
		if not self.prdb.Professions or self.initialized.Professions then return end
		self.initialized.Professions = true

		local function skinSchematicForm(frame)
			skinRecraftSlot(frame.recraftSlot)
			aObj:removeRegions(frame.RecipeLevelBar, {1, 2, 3})
			aObj:skinObject("statusbar", {obj=frame.RecipeLevelBar, fi=0})
			aObj:skinObject("ddbutton", {obj=frame.RecipeLevelDropdown, fType=ftype})
			aObj:skinObject("frame", {obj=frame.Details.QualityMeter.Border, fType=ftype, kfs=true, fb=true, x2=0, y2=3})
			aObj:skinObject("frame", {obj=frame.Details, fType=ftype, kfs=true, fb=true, x1=3, y1=-14, x2=-5, y2=21})
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.Details.CraftingChoicesContainer.ConcentrateContainer.ConcentrateToggleButton, fType=ftype, x2=1}
				skinReagentBtns(frame)
				aObj:SecureHook(frame, "Init", function(fObj, _)
					skinReagentBtns(fObj)
				end)
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=frame.TrackRecipeCheckbox, fType=ftype}
				aObj:skinCheckButton{obj=frame.AllocateBestQualityCheckbox, fType=ftype}
			end
		end
		local function skinProfFrame()
			local this = _G.ProfessionsFrame
			self:skinObject("tabs", {obj=this.TabSystem,  pool=true, fType=ftype, ignoreSize=true, track=false})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinOtherButton{obj=this.MaximizeMinimize.MaximizeButton, font=self.fontS, text=self.nearrow}
				self:skinOtherButton{obj=this.MaximizeMinimize.MinimizeButton, font=self.fontS, text=self.swarrow}
			end

			self:SecureHookScript(this.CraftingPage, "OnShow", function(fObj)
				fObj.TutorialButton.Ring:SetTexture(nil)
				fObj.GearSlotDivider:DisableDrawLayer("ARTWORK")
				self:skinObject("ddbutton", {obj=fObj.RankBar.ExpansionDropdownButton, fType=ftype, noSF=true, bx1=-5, by1=3, bx2=1, by2=-3})
				self:removeNineSlice(fObj.RecipeList.BackgroundNineSlice)
				self:skinObject("editbox", {obj=fObj.RecipeList.SearchBox, fType=ftype, si=true})
				self:skinObject("ddbutton", {obj=fObj.RecipeList.FilterDropdown, fType=ftype, filter=true})
				self:skinObject("scrollbar", {obj=fObj.RecipeList.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element:DisableDrawLayer("BACKGROUND")
						if element.RankBar then
							aObj:skinObject("statusbar", {obj=element.RankBar, regions={1, 2, 3}, fi=0})
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.RecipeList.ScrollBox, skinElement, aObj, true)
				self:skinObject("frame", {obj=fObj.RecipeList, fType=ftype, kfs=true, fb=true, ofs=4, x2=0})
				fObj.SchematicForm.Background:SetAlpha(0)
				fObj.SchematicForm.MinimalBackground:SetAlpha(0)
				self:removeNineSlice(fObj.SchematicForm.NineSlice)
				skinSchematicForm(fObj.SchematicForm)
				aObj:skinObject("frame", {obj=fObj.SchematicForm, fType=ftype, fb=true, ofs=4, x2=5, y2=0})
				fObj.RankBar.Border:SetTexture(nil)
				skinNISpinner(fObj.CreateMultipleInputBox)
				self:skinObject("scrollbar", {obj=fObj.GuildFrame.Container.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj.GuildFrame.Container, fType=ftype, kfs=true, rns=true, fb=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.CreateAllButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.CreateButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.ViewGuildCraftersButton, fType=ftype, sechk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.ConcentrationDisplay, fType=ftype, relTo=fObj.ConcentrationDisplay.Icon, ofs=3}
					self:addButtonBorder{obj=fObj.LinkButton, fType=ftype, ofs=-2, x1=0, y1=-4}
					for _, btn in _G.pairs(fObj.InventorySlots) do
						btn.NormalTexture:SetTexture(nil)
						self:addButtonBorder{obj=btn, fType=ftype, ibt=true}
						self:clrButtonFromBorder(btn)
					end
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.CraftingPage.CraftingOutputLog, "OnShow", function(frame)
				self:keepFontStrings(frame.ScrollBox.Shadows)
				self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
				local function skinLine(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
					element.ItemContainer.NameFrame:SetAlpha(0)
					element.ItemContainer.BorderFrame:SetAlpha(0)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element.ItemContainer.Item, fType=ftype, ibt=true}
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinLine, aObj, true)
				self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, rns=true})
				if self.modBtns then
					self:skinCloseButton{obj=frame.ClosePanelButton, fType=ftype}
				end

				self:Unhook(frame, "OnShow")
			end)
			self:checkShown(this.CraftingPage.CraftingOutputLog)

			self:SecureHookScript(this.CraftingPage.SchematicForm.QualityDialog, "OnShow", function(frame)
				skinQualityDialog(frame)

				self:Unhook(frame, "OnShow")
			end)

			self:SecureHookScript(this.SpecPage, "OnShow", function(fObj)
				local function skinTabs(tabsPool)
					for tab in tabsPool:EnumerateActive() do
						aObj:keepFontStrings(tab)
						if not aObj.isTT then
							aObj:skinObject("frame", {obj=tab, fType=ftype})
						else
							aObj:skinObject("frame", {obj=tab, fType=ftype, noBdr=true, y2=0})
							if tab.isSelected then
								aObj:setActiveTab(tab.sf)
							else
								aObj:setInactiveTab(tab.sf)
							end
						end
						tab.sf.ignore = true
					end
				end
				self:SecureHook(fObj, "InitializeTabs", function(frame, _)
						skinTabs(frame.tabsPool)
				end)
				skinTabs(fObj.tabsPool)
				if self.isTT then
					local function TabSelectedCallback(_, selectedID)
						for tab in fObj.tabsPool:EnumerateActive() do
							if tab.sf then
								aObj:setInactiveTab(tab.sf)
								if tab.traitTreeID == selectedID then
									aObj:setActiveTab(tab.sf)
								end
							end
						end
					end
					_G.EventRegistry:RegisterCallback("ProfessionsSpecializations.TabSelected", TabSelectedCallback, self)
				end
				fObj.PanelFooter:DisableDrawLayer("OVERLAY")
				self:skinObject("frame", {obj=fObj.TreeView, fType=ftype, kfs=true, rns=true, fb=true, y1=4, x2=-38})
				fObj.DetailedView.UnspentPoints.CurrencyBackground:SetAlpha(0)
				self:skinObject("frame", {obj=fObj.DetailedView, fType=ftype, kfs=true, rns=true, fb=true, y1=4})
				fObj.VerticalDivider:DisableDrawLayer("OVERLAY")
				fObj.TopDivider:DisableDrawLayer("OVERLAY")
				fObj.TreePreview.PathIcon.Ring:SetTexture(nil)
				self:skinObject("frame", {obj=fObj.TreePreview, fType=ftype, fb=true, y1=5})
				if self.modBtns then
					self:skinStdButton{obj=fObj.ApplyButton, fType=ftype, sechk=true, ofs=2}
					self:skinStdButton{obj=fObj.UnlockTabButton, fType=ftype, sechk=true, ofs=2}
					self:skinStdButton{obj=fObj.ViewTreeButton, fType=ftype, ofs=2}
					self:skinStdButton{obj=fObj.BackToPreviewButton, fType=ftype, ofs=2}
					self:skinStdButton{obj=fObj.ViewPreviewButton, fType=ftype, ofs=2}
					self:skinStdButton{obj=fObj.BackToFullTreeButton, fType=ftype, ofs=2}
					self:skinStdButton{obj=fObj.DetailedView.UnlockPathButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.DetailedView.SpendPointsButton, fType=ftype, sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.OrdersPage, "OnShow", function(fObj)
				self:SecureHook(fObj, "SetupTable", function(frame, _)
					skinHdrs(frame)
				end)
				skinHdrs(fObj)

				self:SecureHookScript(fObj.BrowseFrame, "OnShow", function(frame)
					self:skinObject("tabs", {obj=frame, tabs=frame.orderTypeTabs, fType=ftype, ignoreSize=true, lod=self.isTT and true, offsets={y2=-4}, track=false})
					if self.isTT then
						self:SecureHook(fObj, "SetCraftingOrderType", function(frmObj, orderType)
							for _, typeTab in _G.ipairs(frmObj.BrowseFrame.orderTypeTabs) do
								if typeTab.orderType == orderType then
									self:setActiveTab(typeTab.sf)
								else
									self:setInactiveTab(typeTab.sf)
								end
							end
						end)
					end
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, ofs=-1, y1=-90})
					frame.RecipeList.Background:SetTexture(nil)
					self:removeNineSlice(frame.RecipeList.BackgroundNineSlice)
					self:skinObject("ddbutton", {obj=frame.RecipeList.FilterDropdown, fType=ftype, filter=true})
					self:skinObject("editbox", {obj=frame.RecipeList.SearchBox, fType=ftype, si=true})
					self:skinObject("scrollbar", {obj=frame.RecipeList.ScrollBar, fType=ftype})
					local function skinRecipeElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							element:DisableDrawLayer("BACKGROUND")
							if element.RankBar then
								aObj:skinObject("statusbar", {obj=element.RankBar, regions={1, 2, 3}, fi=0})
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.RecipeList.ScrollBox, skinRecipeElement, aObj, true)
					frame.OrderList.Background:SetTexture(nil)
					self:removeNineSlice(frame.OrderList.NineSlice)
					self:skinObject("scrollbar", {obj=frame.OrderList.ScrollBar, fType=ftype})
					frame.OrdersRemainingDisplay.Background:SetTexture(nil)
					if self.modBtns then
						self:skinStdButton{obj=frame.FavoritesSearchButton, fType=ftype, ofs=-2, clr="gold"}
						self:skinStdButton{obj=frame.SearchButton, fType=ftype}
						self:skinStdButton{obj=frame.BackButton, fType=ftype}
					end

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.BrowseFrame)

				self:SecureHookScript(fObj.OrderView, "OnShow", function(frame)
					self:skinObject("ddbutton", {obj=frame.RankBar.ExpansionDropdownButton, fType=ftype, noSF=true, bx1=-5, by1=3, bx2=1, by2=-3})
					self:removeNineSlice(frame.OrderInfo.NineSlice)
					frame.OrderInfo.NoteBox.Background.Border:SetTexture(nil)
					self:skinObject("frame", {obj=frame.OrderInfo.NoteBox, fType=ftype, fb=true, y1=-18})
					frame.OrderInfo.NPCRewardsFrame.Background:SetTexture(nil)
					self:skinObject("frame", {obj=frame.OrderInfo, fType=ftype, kfs=true, fb=true, x1=-5})
					self:removeNineSlice(frame.OrderDetails.NineSlice)
					skinSchematicForm(frame.OrderDetails.SchematicForm)
					self:skinObject("frame", {obj=frame.OrderDetails.FulfillmentForm.NoteEditBox, fType=ftype, kfs=true, fb=true, x1=20, y1=-18, x2=-20})
					self:skinObject("frame", {obj=frame.OrderDetails, fType=ftype, kfs=true, fb=true, x2=4})
					frame.RankBar.Border:SetTexture(nil)
					-- DON'T skin RankBar
					self:skinObject("frame", {obj=frame.DeclineOrderDialog.NoteEditBox, fType=ftype, kfs=true, fb=true, x1=30, y1=-28, x2=-30})
					self:skinObject("frame", {obj=frame.DeclineOrderDialog, fType=ftype, kfs=true})
					self:skinObject("frame", {obj=frame.CraftingOutputLog, fType=ftype, kfs=true})
					if self.modBtns then
						self:skinStdButton{obj=frame.OrderInfo.BackButton, fType=ftype}
						self:skinStdButton{obj=frame.OrderInfo.StartOrderButton, fType=ftype, sechk=true}
						self:skinStdButton{obj=frame.OrderInfo.DeclineOrderButton, fType=ftype}
						self:skinStdButton{obj=frame.OrderInfo.ReleaseOrderButton, fType=ftype}
						self:skinStdButton{obj=frame.CreateButton, fType=ftype, schk=true, sechk=true}
						self:skinStdButton{obj=frame.CompleteOrderButton, fType=ftype,}
						self:skinStdButton{obj=frame.StartRecraftButton, fType=ftype}
						self:skinStdButton{obj=frame.StopRecraftButton, fType=ftype}
						self:skinStdButton{obj=frame.DeclineOrderDialog.CancelButton, fType=ftype}
						self:skinStdButton{obj=frame.DeclineOrderDialog.ConfirmButton, fType=ftype}
						self:skinCloseButton{obj=frame.CraftingOutputLog.ClosePanelButton, fType=ftype}
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=frame.ConcentrationDisplay, fType=ftype, relTo=frame.ConcentrationDisplay.Icon, ofs=3}
						self:addButtonBorder{obj=frame.OrderInfo.SocialDropdown, fType=ftype, clr="gold", y1=1, y2=-1}
						for _, btn in _G.pairs(frame.OrderInfo.NPCRewardsFrame.RewardItems) do
							self:addButtonBorder{obj=btn, fType=ftype, ibt=true}
						end
					end

					self:Unhook(frame, "OnShow")
				end)

				self:Unhook(fObj, "OnShow")
			end)

			_G.EventRegistry:UnregisterCallback("ProfessionsFrame.Show", self)
		end
		_G.EventRegistry:RegisterCallback("ProfessionsFrame.Show", skinProfFrame, self)

	end

	aObj.blizzLoDFrames[ftype].ProfessionsBook = function(self)
		if not self.prdb.ProfessionsBook or self.initialized.ProfessionsBook then return end
		self.initialized.ProfessionsBook = true

		self:SecureHookScript(_G.ProfessionsBookFrame, "OnShow", function(this)
			self:skinMainHelpBtn(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})

			local function skinProf(type, times)
				local objName, obj
				for i = 1, times do
					objName = type .. "Profession" .. i
					obj =_G[objName]
					if type == "Primary" then
						_G[objName .. "IconBorder"]:Hide()
						-- make icon square
						aObj:makeIconSquare(obj, "icon")
						if not obj.missingHeader:IsShown() then
							obj.icon:SetDesaturated(nil) -- show in colour
							if aObj.modBtnBs then
								aObj:clrBtnBdr(obj)
							end
						else
							if aObj.modBtnBs then
								aObj:clrBtnBdr(obj, "disabled")
							end
						end
					else
						obj.missingHeader:SetTextColor(aObj.HT:GetRGB())
					end
					obj.missingText:SetTextColor(aObj.BT:GetRGB())
					local pBtn
					for j = 1, 2 do
						pBtn = obj["SpellButton" .. j]
						pBtn:DisableDrawLayer("BACKGROUND")
						pBtn.subSpellString:SetTextColor(aObj.BT:GetRGB())
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=pBtn, sft=true}
						end
					end
					aObj:removeRegions(obj.statusBar, {2, 3, 4, 5, 6})
					aObj:skinObject("statusbar", {obj=obj.statusBar, fi=0})
					obj.statusBar:SetStatusBarColor(0, 1, 0, 1)
					obj.statusBar:SetHeight(12)
					obj.statusBar.rankText:SetPoint("CENTER", 0, 0)
					aObj:moveObject{obj=obj.statusBar, x=-12}
				end
			end
			skinProf("Primary", 2)
			skinProf("Secondary", 3)
			if self.modBtnBs then
				self:SecureHook("ProfessionsBookFrame_Update", function()
					local prof1, prof2, _, _, _ = _G.GetProfessions()
					self:clrBtnBdr(_G.PrimaryProfession1, not prof1 and "disabled")
					self:clrBtnBdr(_G.PrimaryProfession2, not prof2 and "disabled")
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].ProfessionsCustomerOrders = function(self)
		if not self.prdb.Professions or self.initialized.ProfessionsCustomerOrders then return end

		if not _G.ProfessionsCustomerOrdersFrame then
			_G.C_Timer.After(0.1, function()
				self.blizzLoDFrames[ftype].ProfessionsCustomerOrders(self)
			end)
			return
		end

		self.initialized.ProfessionsCustomerOrders = true

		self:SecureHookScript(_G.ProfessionsCustomerOrdersFrame, "OnShow", function(this)
			self:removeInset(this.MoneyFrameInset)
			self:removeNineSlice(this.MoneyFrameBorder)
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, fType=ftype, lod=self.isTT and true, track=false})
			if self.isTT then
				self:SecureHook(this, "SelectMode", function(fObj, mode)
					for idx, tab in _G.ipairs(fObj.Tabs) do
						if idx == mode then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
					end
				end)
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, y2=1})

			self:SecureHookScript(this.Form, "OnShow", function(fObj)
				self:removeRegions(fObj, {1}) -- RecipeHeader
				self:skinObject("frame", {obj=fObj.LeftPanelBackground, fType=ftype, kfs=true, rns=true, fb=true, x1=-5})
				self:skinObject("frame", {obj=fObj.RightPanelBackground, fType=ftype, kfs=true, rns=true, fb=true, x2=5})
				self:skinObject("ddbutton", {obj=fObj.MinimumQuality.Dropdown, fType=ftype})
				self:skinObject("ddbutton", {obj=fObj.OrderRecipientDropdown, fType=ftype})
				self:skinObject("editbox", {obj=fObj.OrderRecipientTarget, fType=ftype})
				self:skinObject("frame", {obj=fObj.PaymentContainer.NoteEditBox, fType=ftype, kfs=true, fb=true, ofs=-16})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.CopperBox, fType=ftype, y2=4})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.SilverBox, fType=ftype, y2=4})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.GoldBox, fType=ftype, y2=4})
				self:skinObject("ddbutton", {obj=fObj.PaymentContainer.DurationDropdown, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=fObj.BackButton, fType=ftype}
					self:skinStdButton{obj=fObj.PaymentContainer.ListOrderButton, fType=ftype, sechk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.OrderRecipientDisplay.SocialDropdown, fType=ftype, ofs=1, x1=-1}
					self:addButtonBorder{obj=fObj.PaymentContainer.ViewListingsButton, fType=ftype, ofs=1, x1=-1}
					skinRecraftSlot(fObj.RecraftSlot)
					self:SecureHook(fObj, "UpdateReagentSlots", function(frame)
						skinReagentBtns(frame)
					end)
					skinReagentBtns(fObj)
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.TrackRecipeCheckbox.Checkbox, fType=ftype}
					self:skinCheckButton{obj=fObj.AllocateBestQualityCheckbox, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.Form.QualityDialog, "OnShow", function(fObj)
				skinQualityDialog(fObj)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.Form.CurrentListings, "OnShow", function(fObj)
				skinHdrs(fObj)
				self:skinObject("scrollbar", {obj=fObj.OrderList.ScrollBar, fType=ftype})
				fObj.OrderList.Background:SetTexture(nil)
				self:removeNineSlice(fObj.OrderList.NineSlice)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.CloseButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.BrowseOrders, "OnShow", function(fObj)
				self:skinObject("editbox", {obj=fObj.SearchBar.SearchBox, fType=ftype, si=true})
				self:skinObject("ddbutton", {obj=fObj.SearchBar.FilterDropdown, fType=ftype, filter=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.SearchBar.FavoritesSearchButton, fType=ftype, ofs=-2}
					self:skinStdButton{obj=fObj.SearchBar.SearchButton, fType=ftype, schk=true}
				end

				self:SecureHook(fObj, "SetupTable", function(frame, _)
					skinHdrs(frame)
				end)
				skinHdrs(fObj)

				self:SecureHookScript(fObj.CategoryList, "OnShow", function(frame)
					frame:DisableDrawLayer("BACKGROUND")
					self:removeNineSlice(frame.NineSlice)
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
					local function skinCategory(...)
						local _, element
						if _G.select("#", ...) == 2 then
							element, _ = ...
						else
							_, element, _ = ...
						end
						if element.isSpacer then
							for _, region in _G.ipairs(element.spacerRegions) do
								region:SetShown(false)
							end
							return
						end
						aObj:keepRegions(element, {3, 4, 6}) -- N.B. region 3 is highlight, 4 is selected, 6 is text
						if element.categoryInfo then
							aObj.modUIBtns:skinStdButton{obj=element, fType=ftype, ignoreHLTex=true}
							element.sb:ClearAllPoints()
							if element.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Primary then
								element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", -2, 2)
								element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
							elseif element.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Secondary  then
								element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", 10, 1)
								element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
							end
							element.sb:SetShown(element.categoryInfo.type ~= _G.Enum.CraftingOrderCustomerCategoryType.Tertiary)
						else -- Start Recrafting Order button
							aObj.modUIBtns:skinStdButton{obj=element, fType=ftype, ignoreHLTex=true, ofs=2, x2=-4}
						end
					end
					_G.ScrollUtil.AddInitializedFrameCallback(frame.ScrollBox, skinCategory, aObj, true)

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.CategoryList)

				self:SecureHookScript(fObj.RecipeList, "OnShow", function(frame)
					frame.Background:SetTexture(nil)
					self:removeNineSlice(frame.NineSlice)
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.RecipeList)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.BrowseOrders)

			self:SecureHookScript(this.MyOrdersPage, "OnShow", function(fObj)
				fObj.OrderList.Background:SetTexture(nil)
				skinHdrs(fObj)
				self:removeNineSlice(fObj.OrderList.NineSlice)
				self:skinObject("scrollbar", {obj=fObj.OrderList.ScrollBar, fType=ftype})
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.RefreshButton, fType=ftype, ofs=-2, x1=1, clr="gold", sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MyOrdersPage)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ProfessionsCustomerOrdersFrame)

	end

	aObj.blizzFrames[ftype].PVPHonorSystem = function(self)
		if not self.prdb.PVEFrame or self.initialized.PVPHonorSystem then return end
		self.initialized.PVPHonorSystem = true

		self:SecureHookScript(_G.HonorLevelUpBanner, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PrestigeLevelUpBanner, "OnShow", function(this)
			this.BG1:SetTexture(nil)
			this.BG2:SetTexture(nil)

			self:Unhook(this, "OnShow")
		end)

	end

	local function skinHonorLevelDisplay(hld)
		hld:DisableDrawLayer("BORDER")
		aObj:removeRegions(hld.NextRewardLevel, {2, 4}) -- IconCover & RingBorder
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=hld.NextRewardLevel, relTo=hld.NextRewardLevel.RewardIcon, clr="gold"}
			aObj:SecureHook(hld, "Update", function(fObj)
				if fObj.NextRewardLevel.RewardIcon:IsDesaturated() then
					aObj:clrBtnBdr(fObj.NextRewardLevel, "disabled")
				else
					aObj:clrBtnBdr(fObj.NextRewardLevel, "gold")
				end
			end)
		end
	end
	aObj.blizzLoDFrames[ftype].PVPUI = function(self)
		if not self.prdb.PVEFrame or self.initialized.PVPUI then return end
		self.initialized.PVPUI = true

		local pvpFrames = { "HonorFrame", "ConquestFrame", "LFGListPVPStub" }

		self:SecureHookScript(_G.PVPQueueFrame, "OnShow", function(this)
			if not aObj.isMnlnBeta then
				for i = 1, #pvpFrames do
					this["CategoryButton" .. i].Background:SetTexture(nil)
					this["CategoryButton" .. i].Ring:SetTexture(nil)
					self:changeTex(this["CategoryButton" .. i]:GetHighlightTexture())
					-- make Icon square
					self:makeIconSquare(this["CategoryButton" .. i], "Icon")
				end
			else
				for _, btn in _G.pairs(this.CategoryButtons) do
					btn.Background:SetTexture(nil)
					btn.Ring:SetTexture(nil)
					self:changeTex(btn:GetHighlightTexture())
					-- make Icon square
					self:makeIconSquare(btn, "Icon")
				end
			end
			if self.modBtnBs then
				-- hook this to change button border colour
				self:SecureHook("PVPQueueFrame_SetCategoryButtonState", function(btn, _)
					if btn.sbb then
						self:clrBtnBdr(btn)
					end
				end)
			end
			-- hook this to change selected texture
			self:SecureHook("PVPQueueFrame_SelectButton", function(index)
				for i = 1, #pvpFrames do
					if i == index then
						self:changeTex(this["CategoryButton" .. i].Background, true)
					else
						this["CategoryButton" .. i].Background:SetTexture(nil)
					end
				end
			end)
			_G.PVPQueueFrame_SelectButton(1) -- select Honor button

			self:SecureHookScript(this.HonorInset, "OnShow", function(fObj)
				self:removeInset(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				skinHonorLevelDisplay(fObj.CasualPanel.HonorLevelDisplay)
				skinHonorLevelDisplay(fObj.RatedPanel.HonorLevelDisplay)
				if aObj.isMnlnBeta then
					skinHonorLevelDisplay(fObj.TrainingGroundsPanel.HonorLevelDisplay)
				end
				local srf =fObj.RatedPanel.SeasonRewardFrame
				srf.Ring:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=srf, fType=ftype, relTo=srf.Icon, clr="gold"}
					self:SecureHook(srf, "Update", function(fObj)
						if fObj.Icon:IsDesaturated() then
							self:clrBtnBdr(fObj, "disabled")
						else
							self:clrBtnBdr(fObj, "gold")
						end
					end)
				end

			    self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.HonorInset)

			self:SecureHookScript(this.NewSeasonPopup, "OnShow", function(fObj)
				fObj.NewSeason:SetTextColor(self.HT:GetRGB())
				fObj.SeasonRewardText:SetTextColor(self.BT:GetRGB())
				fObj.SeasonDescriptionHeader:SetTextColor(self.BT:GetRGB())
				for _, line in _G.pairs(fObj.SeasonDescriptions) do
					line:SetTextColor(self.BT:GetRGB())
				end
				fObj.SeasonRewardFrame.Ring:SetTexture(nil)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-13})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Leave, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)

		local function skinCommon(frame)
			frame.ConquestBar:DisableDrawLayer("BORDER")
			aObj:skinObject("statusbar", {obj=frame.ConquestBar, fi=0, bg=frame.ConquestBar.Background})
			frame.ConquestBar.Reward.Ring:SetTexture(nil)
			aObj:removeInset(frame.Inset)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.ConquestBar.Reward, relTo=frame.ConquestBar.Reward.Icon, reParent={frame.ConquestBar.Reward.CheckMark}, clr="gold"}
			end
			if aObj.modChkBtns then
				if not aObj.isMnlnBeta then
					aObj:skinCheckButton{obj=frame.HealerIcon.checkButton}
					aObj:skinCheckButton{obj=frame.TankIcon.checkButton}
					aObj:skinCheckButton{obj=frame.DPSIcon.checkButton}
				else
					aObj:skinCheckButton{obj=frame.RoleList.HealerIcon.checkButton}
					aObj:skinCheckButton{obj=frame.RoleList.TankIcon.checkButton}
					aObj:skinCheckButton{obj=frame.RoleList.DPSIcon.checkButton}
				end
			end
		end
		self:SecureHookScript(_G.HonorFrame, "OnShow", function(this) -- a.k.a. Quick Match
			skinCommon(this)
			self:skinObject("ddbutton", {obj=this.TypeDropdown, fType=ftype})
			self:skinObject("scrollbar", {obj=this.SpecificScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					element.Bg:SetTexture(nil)
					element.Border:SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.SpecificScrollBox, skinElement, aObj, true)
			local btn
			for _, bName in _G.pairs{"RandomBG", "RandomEpicBG", "Arena1", "Brawl", "SpecialEvent"} do
				if bName == "SpecialEvent" then
					btn = this.BonusFrame["BrawlButton2"]
				else
					btn = this.BonusFrame[bName .. "Button"]
				end
				btn.NormalTexture:SetTexture(nil)
				btn:GetPushedTexture():SetTexture(nil)
				btn.Reward.Border:SetTexture(nil)
				btn.Reward.EnlistmentBonus:DisableDrawLayer("ARTWORK") -- ring texture
				if self.modBtnBs then
					self:addButtonBorder{obj=btn.Reward, fType=ftype, relTo=btn.Reward.Icon, reParent={btn.Reward.EnlistmentBonus}}
				end
			end
			if self.modBtnBs then
				self:SecureHook("HonorFrameBonusFrame_Update", function()
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.RandomBGButton.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.RandomEpicBGButton.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.Arena1Button.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.BrawlButton.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.BrawlButton2.Reward, "gold")
				end)
			end
			this.BonusFrame:DisableDrawLayer("BACKGROUND")
			this.BonusFrame.ShadowOverlay:DisableDrawLayer("OVERLAY")
			self:removeMagicBtnTex(this.QueueButton)
			if self.modBtns then
				self:skinStdButton{obj=this.QueueButton, fType=ftype, schk=true}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.HonorFrame)

		self:SecureHookScript(_G.ConquestFrame, "OnShow", function(this)
			skinCommon(this)
			this:DisableDrawLayer("BACKGROUND")
			this:DisableDrawLayer("BORDER")
			for _, btn in _G.pairs(_G.CONQUEST_BUTTONS) do
				btn.NormalTexture:SetTexture(nil)
				btn.Reward.Border:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn.Reward, fType=ftype, relTo=btn.Reward.Icon, reParent={btn.Reward.EnlistmentBonus}}
				end
			end
			if self.modBtnBs then
				self:SecureHook("ConquestFrame_Update", function(_)
					for _, btn in _G.pairs(_G.CONQUEST_BUTTONS) do
						self:clrBtnBdr(btn.Reward, "gold")
					end
				end)
			end
			this.ShadowOverlay:DisableDrawLayer("OVERLAY")
			self:skinObject("glowbox", {obj=this.NoSeason, fType=ftype})
			self:skinObject("glowbox", {obj=this.Disabled, fType=ftype})
			self:removeMagicBtnTex(this.JoinButton)
			if self.modBtns then
				 self:skinStdButton{obj=this.JoinButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		if aObj.isMnlnBeta then
			self:SecureHookScript(_G.TrainingGroundsFrame, "OnShow", function(this)
				skinCommon(this)
				self:skinObject("ddbutton", {obj=this.TypeDropdown, fType=ftype})
				self:skinObject("scrollbar", {obj=this.SpecificTrainingGroundList.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element.Bg:SetTexture(nil)
						element.Border:SetTexture(nil)
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(this.SpecificTrainingGroundList.ScrollBox, skinElement, aObj, true)
				this.BonusTrainingGroundList:DisableDrawLayer("BACKGROUND")
				for _, btn in _G.pairs(this.BonusTrainingGroundList.BonusTrainingGroundButtons) do
					btn.NormalTexture:SetTexture(nil)
					btn:GetPushedTexture():SetTexture(nil)
					btn.Reward.Border:SetTexture(nil)
					btn.Reward.EnlistmentBonus:DisableDrawLayer("ARTWORK") -- ring texture
					if self.modBtnBs then
						self:addButtonBorder{obj=btn.Reward, fType=ftype, relTo=btn.Reward.Icon, reParent={btn.Reward.EnlistmentBonus}, clr="gold"}
					end
				end
				this.BonusTrainingGroundList.ShadowOverlay:DisableDrawLayer("OVERLAY")
				self:removeMagicBtnTex(this.QueueButton)
				if self.modBtns then
					self:skinStdButton{obj=this.QueueButton, fType=ftype, schk=true}
				end

			    self:Unhook(this, "OnShow")
			end)

			-- PlunderstormFrame

		end

		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.ConquestTooltip)
		end)

	end

	aObj.blizzLoDFrames[ftype].RemixArtifactUI = function(self)
		if not self.prdb.RemixArtifactUI or self.initialized.RemixArtifactUI then return end

		if not _G.RemixArtifactFrame then
			_G.C_Timer.After(0.1, function()
				self.blizzLoDFrames[ftype].RemixArtifactUI(self)
			end)
			return
		end
		self.initialized.RemixArtifactUI = true

		self:SecureHookScript(_G.RemixArtifactFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this.BorderContainer:DisableDrawLayer("OVERLAY")
			this.ButtonsParent.Overlay:DisableDrawLayer("OVERLAY")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=4})
			if self.modBtns then
				self:skinStdButton{obj=this.CommitConfigControls.CommitButton, fType=ftype, sechk=true}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.RemixArtifactFrame)

	end

end

aObj.SetupMainline_PlayerFramesOptions = function(self)

	local optTab = {
		["Artifact UI"]          = true,
		["Azerite Essence UI"]   = true,
		["Azerite UI"]           = true,
		["Character Customize"]  = {suff = "Frame"},
		["Currency Transfer"]    = true,
		["Damage Meter"]         = true,
		["Equipment Flyout"]     = true,
		["Guild Control UI"]     = true,
		["Guild Invite"]         = {suff = "Frame"},
		["Guild UI"]             = true,
		["Player Spells"]        = {desc = "Talents & Spellbook"},
		["Professions"]          = {desc = "Trade Skills UI"},
		["Professions Book"]     = {desc = "Professions"},
		["Remix Artifact UI"]    = true,
	}
	self:setupFramesOptions(optTab, "Player")
	_G.wipe(optTab)

	local db = self.db.profile
	local dflts = self.db.defaults.profile

	dflts.ObjectiveTracker = {skin = false, popups = true, headers=true, animapowers=true, modules=true, rewards=true}
	if db.ObjectiveTracker == nil then
		db.ObjectiveTracker = {skin = false, popups = true, headers=true, animapowers=true, modules=true, rewards=true}
	else
		if db.ObjectiveTracker.popups == nil then
			db.ObjectiveTracker.popups = true
		end
		if db.ObjectiveTracker.headers == nil then
			db.ObjectiveTracker.headers = true
		end
		if db.ObjectiveTracker.animapowers == nil then
			db.ObjectiveTracker.animapowers = true
		end
		if db.ObjectiveTracker.modules == nil then
			db.ObjectiveTracker.modules = true
		end
		if db.ObjectiveTracker.rewards == nil then
			db.ObjectiveTracker.rewards = true
		end
	end
	self.optTables["Player Frames"].args.ObjectiveTracker = {
		type = "group",
		order = -1,
		inline = true,
		name = self.L["ObjectiveTracker Frame"],
		get = function(info) return db.ObjectiveTracker[info[#info]] end,
		set = function(info, value) db.ObjectiveTracker[info[#info]] = value end,
		args = {
			skin = {
				type = "toggle",
				order = 1,
				name = self.L["Skin Frame"],
			},
			popups = {
				type = "toggle",
				order = 2,
				name = self.L["AutoPopUp Frames"],
			},
			headers = {
				type = "toggle",
				order = 3,
				name = self.L["Header Blocks"],
			},
			animapowers = {
				type = "toggle",
				order = 5,
				name = self.L["Anima Powers"],
			},
			modules = {
				type = "toggle",
				order = 4,
				name = self.L["Modules"],
			},
			rewards = {
				type = "toggle",
				order = 6,
				name = self.L["Rewards"],
			},
		},
	}

end
