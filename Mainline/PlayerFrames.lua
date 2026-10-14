local _, aObj = ...

local _G = _G

aObj.SetupMainline_PlayerFrames = function()
	local ftype = "p"

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
		self:checkShown(_G.ArtifactFrame)

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
		self:checkShown(_G.AzeriteEmpoweredItemUI)

	end

	aObj.blizzFrames[ftype].CurrencyTransfer = function(self)
		if not self.prdb.CurrencyTransfer or self.initialized.CurrencyTransfer then return end
		self.initialized.CurrencyTransfer = true

		self:SecureHookScript(_G.CurrencyTransferMenu, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

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
		self:checkShown(_G.CurrencyTransferMenu)

	end

	aObj.blizzFrames[ftype].DressUpFrame = function(self)
		if _G.C_AddOns.IsAddOnLoaded("DressUp") then
			self.blizzFrames[ftype].DressUpFrame = nil
			return
		end

		if not self.prdb.DressUpFrame or self.initialized.DressUpFrame then return end
		self.initialized.DressUpFrame = true

		self:SecureHookScript(_G.SideDressUpFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:removeRegions(_G.SideDressUpFrameCloseButton, {5}) -- corner texture
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=-3, y1=-3, x2=-2})
			_G.LowerFrameLevel(this) -- make it appear behind parent frame
			if self.modBtns then
				self:skinStdButton{obj=_G.SideDressUpFrame.ResetButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.SideDressUpFrame)

		self:SecureHookScript(_G.DressUpFrame, "OnShow", function(this)
			self:skinObject("ddbutton", {obj=this.CustomSetDropdown, fType=ftype})
			self:skinObject("frame", {obj=this.OutfitDetailsPanel, fType=ftype, kfs=true, ofs=-7})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, y2=-4})
			if self.prdb.DUTexture then
				this.ModelBackground:SetDrawLayer("ARTWORK")
				this.ModelBackground:SetAlpha(1)
			else
				this.ModelBackground:SetAlpha(0)
			end
			if self.modBtns then
				self:skinStdButton{obj=this.CustomSetDropdown.SaveButton, fType=ftype}
				self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MaximizeButton, fType=ftype, font=self.fontS, text=self.nearrow}
				self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MinimizeButton, fType=ftype, font=self.fontS, text=self.swarrow}
				self:skinStdButton{obj=_G.DressUpFrameCancelButton, fType=ftype}
				self:skinStdButton{obj=this.ResetButton, fType=ftype}
				self:skinStdButton{obj=this.LinkButton, fType=ftype}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.ToggleCustomSetDetailsButton, fType=ftype}
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

			self:SecureHookScript(this.CustomSetDetailsPanel, "OnShow", function(fObj)
			    self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-4})

			    self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CustomSetDetailsPanel)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.DressUpFrame)

		if self.modChkBtns then
			self:SecureHookScript(_G.TransmogAndMountDressupFrame, "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				self:skinCheckButton{obj=this.ShowMountCheckButton, fType=ftype}

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.TransmogAndMountDressupFrame)
		end

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
		self:checkShown(_G.GuildControlUI)

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
		self:checkShown(_G.ProfessionsBookFrame)

	end

	aObj.blizzLoDFrames[ftype].RemixArtifactUI = function(self)
		if not self.prdb.RemixArtifactUI or self.initialized.RemixArtifactUI then return end

		if not _G.RemixArtifactFrame then
			_G.RunNextFrame(function()
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
		["Currency Transfer"]    = true,
		["Guild Control UI"]     = true,
		["Guild UI"]             = true,
		["Professions Book"]     = {desc = "Professions"},
		["Remix Artifact UI"]    = true,
	}
	self:setupFramesOptions(optTab, "Player")
	_G.wipe(optTab)

end

aObj.SetupMainline_PlayerFramesDefaults = function(_)

end
