if _G.WOW_PROJECT_ID ~= _G.WOW_PROJECT_MAINLINE then return end

local _, aObj = ...

local _G = _G

aObj.SetupMainline_NPCFrames = function()
	local ftype = "n"

	aObj.blizzLoDFrames[ftype].AlliedRacesUI = function(self)
		if not self.prdb.AlliedRacesUI or self.initialized.AlliedRacesUI then return end
		self.initialized.AlliedRacesUI = true

		self:SecureHookScript(_G.AlliedRacesFrame, "OnShow", function(this)
			this.ModelScene:DisableDrawLayer("BORDER")
			this.ModelScene:DisableDrawLayer("ARTWORK")
			this.RaceInfoFrame.ScrollFrame.Child.RaceDescriptionText:SetTextColor(self.BT:GetRGB())
			this.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame.Description:SetTextColor(self.BT:GetRGB())
			this.RaceInfoFrame.ScrollFrame.Child.RacialTraitsLabel:SetTextColor(self.HT:GetRGB())
			this.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame.HeaderBackground:SetTexture(nil)
			this.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame:DisableDrawLayer("BACKGROUND")
			self:skinObject("scrollbar", {obj=this.RaceInfoFrame.ScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			this.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(self.HT:GetRGB())
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, y1=1})
			if self.modBtnBs then
				self:addButtonBorder{obj=this.ModelScene.AlliedRacesMaleButton, ofs=0}
				self:addButtonBorder{obj=this.ModelScene.AlliedRacesFemaleButton, ofs=0}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHook(_G.AlliedRacesFrame, "LoadRaceData", function(this, _)
			for ability in this.abilityPool:EnumerateActive() do
				ability.Text:SetTextColor(self.BT:GetRGB())
				self:getRegion(ability, 3):SetTexture(nil) -- Border texture
				if self.modBtnBs then
					self:addButtonBorder{obj=ability, relTo=ability.Icon}
				end
			end
		end)

	end

	aObj.blizzLoDFrames[ftype].AzeriteRespecUI = function(self)
		if not self.prdb.AzeriteRespecUI or self.initialized.AzeriteRespecUI then return end
		self.initialized.AzeriteRespecUI = true

		self:SecureHookScript(_G.AzeriteRespecFrame, "OnShow", function(this)
			self.modUIBtns:addButtonBorder{obj=this.ItemSlot} -- use module function
			this.ButtonFrame:DisableDrawLayer("BORDER")
			self:removeMagicBtnTex(this.ButtonFrame.AzeriteRespecButton)
			this.ButtonFrame.MoneyFrameEdge:DisableDrawLayer("BACKGROUND")
			this.ButtonFrame.AzeriteRespecButton:SetPoint("BOTTOMRIGHT", -6, 5)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.ButtonFrame.AzeriteRespecButton}
				self:SecureHook(this, "UpdateAzeriteRespecButtonState", function(fObj)
					self:clrBtnBdr(fObj.ButtonFrame.AzeriteRespecButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].BankFrame = function(self)
		if not self.prdb.BankFrame or self.initialized.BankFrame then return end
		self.initialized.BankFrame = true

		local function skinSideTabs(frame)
			for tab in frame.bankTabPool:EnumerateActive() do
				tab.Border:SetTexture(nil)
				if aObj.modBtnBs then
					 aObj:addButtonBorder{obj=tab, relTo=tab.Icon}
				end
			end
		end
		if not _G.C_AddOns.IsAddOnLoaded("LiteBag") then
			if self.modBtnBs then
				self:SecureHook(_G.AccountBankPanel or _G.BankFrame.BankPanel, "GenerateItemSlotsForSelectedTab", function(frame)
					self:skinItemSlots(frame, ftype)
				end)
			end
			self:SecureHookScript(_G.BankFrame, "OnShow", function(this)
				self:skinObject("tabs", {obj=this.TabSystem,  pool=true, fType=ftype, ignoreSize=true, track=false})
				self:skinObject("editbox", {obj=_G.BankItemSearchBox, fType=ftype, si=true})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true})

				self:SecureHookScript(this.BankPanel, "OnShow", function(fObj)
					fObj.PurchaseTab.Border:SetTexture(nil)
					self:removeNineSlice(fObj.NineSlice)
					fObj.EdgeShadows:DisableDrawLayer("BORDER")

					if self.modBtns then
						self:skinStdButton{obj=fObj.WithdrawButton, fType=ftype}
						self:skinStdButton{obj=fObj.DepositButton, fType=ftype}
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=fObj.AutoSortButton, fType=ftype, ofs=0}
						self:addButtonBorder{obj=fObj.PurchaseTab, relTo=fObj.PurchaseTab.Icon}
					end

					self:SecureHook(fObj, "RefreshBankTabs", function(frame)
						skinSideTabs(frame)
					end)

					self:SecureHookScript(fObj.MoneyFrame, "OnShow", function(frame)
						self:keepFontStrings(frame.Border)
						if self.modBtns then
							self:skinStdButton{obj=frame.WithdrawButton, fType=ftype, sechk=true}
							self:skinStdButton{obj=frame.DepositButton, fType=ftype, sechk=true}
						end

						self:Unhook(frame, "OnShow")
					end)
					self:checkShown(fObj.MoneyFrame)
					self:SecureHookScript(fObj.AutoDepositFrame, "OnShow", function(frame)
						if self.modBtns then
							self:skinStdButton{obj=frame.DepositButton, fType=ftype}
						end
						if self.modChkBtns then
							self:skinCheckButton{obj=frame.IncludeReagentsCheckbox, fType=ftype, size=24}
						end

						self:Unhook(frame, "OnShow")
					end)
					self:checkShown(fObj.AutoDepositFrame)

					self:SecureHookScript(fObj.PurchasePrompt, "OnShow", function(frame)
						self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, clr="gold"})
						if self.modBtns then
							self:skinStdButton{obj=frame.TabCostFrame.PurchaseButton, fType=ftype}
						end

						self:Unhook(frame, "OnShow")
					end)
					self:checkShown(fObj.PurchasePrompt)

					self:SecureHookScript(fObj.LockPrompt, "OnShow", function(frame)
						self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, x1=4, y1=0, x2=-4, y2=1, clr="gold"})
						frame.Background:SetAlpha(1)
						frame:SetFrameLevel(4) -- ensure the AutoSort button border is hidden

						self:Unhook(frame, "OnShow")
					end)
					self:checkShown(fObj.LockPrompt)

					self:skinTabSettingsMenu(fObj, ftype)

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.BankPanel)

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.BankCleanUpConfirmationPopup, "OnShow", function(this)
				self:keepFontStrings(this.Border)
				self:skinObject("frame", {obj=this, fType=ftype, ofs=-4})
				if self.modBtns then
					self:skinStdButton{obj=this.AcceptButton, fType=ftype}
					self:skinStdButton{obj=this.CancelButton, fType=ftype}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=this.HidePopupCheckbox.Checkbox, fType=ftype, size=24}
				end

				self:Unhook(this, "OnShow")
			end)
		end

	end

	aObj.blizzLoDFrames[ftype].ChromieTimeUI = function(self)
		if not self.prdb.ChromieTimeUI or self.initialized.ChromieTimeUI then return end
		self.initialized.ChromieTimeUI = true

		self:SecureHookScript(_G.ChromieTimeFrame, "OnShow", function(this)
			this.Background:DisableDrawLayer("BACKGROUND")
			self:keepFontStrings(this.Title)
			this.CloseButton.Border:SetTexture(nil)
			this.CurrentlySelectedExpansionInfoFrame:DisableDrawLayer("BACKGROUND")
			this.CurrentlySelectedExpansionInfoFrame:DisableDrawLayer("ARTWORK")
			this.CurrentlySelectedExpansionInfoFrame.Name:SetTextColor(self.HT:GetRGB())
			this.CurrentlySelectedExpansionInfoFrame.Description:SetTextColor(self.BT:GetRGB())
			for btn in this.ExpansionOptionsPool:EnumerateActive() do
				btn:GetNormalTexture():SetTexture(nil) -- remove border texture
				self:SecureHook(btn, "SetNormalAtlas", function(bObj, name, _)
					if name == "ChromieTime-Button-Frame" then
						bObj:GetNormalTexture():SetTexture(nil) -- remove border texture
					end
				end)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, ofs=-4, es=20, clr="gold", ca=0.4}
				end
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, ofs=2, y1=1})
			if self.modBtns then
				self:skinStdButton{obj=this.SelectButton}
				self:SecureHook(this.SelectButton, "UpdateButtonState", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].CovenantPreviewUI = function(self)
		if not self.prdb.CovenantPreviewUI or self.initialized.CovenantPreviewUI then return end
		self.initialized.CovenantPreviewUI = true

		self:SecureHook(_G.CovenantPreviewFrame, "SetupFramesWithTextureKit", function(this)
			if this.sf then
				self:clrCovenantBdr(this.ModelSceneContainer, this.uiTextureKit)
				self:clrCovenantBdr(this, this.uiTextureKit)
			end
		end)

		self:SecureHookScript(_G.CovenantPreviewFrame, "OnShow", function(this)
			this.BorderFrame:DisableDrawLayer("BORDER")
			this.Background.BackgroundTile:SetTexture(nil)
			this.Title:DisableDrawLayer("BACKGROUND")
			this.ModelSceneContainer.ModelSceneBorder:SetTexture(nil)
			self:skinObject("frame", {obj=this.ModelSceneContainer, fType=ftype, fb=true})
			self:clrCovenantBdr(this.ModelSceneContainer, this.uiTextureKit)
			_G.RaiseFrameLevelByTwo(this.ModelSceneContainer.sf) -- make sure it covers border of background
			this.ModelSceneContainer.Background:SetAlpha(1) -- make it visible
			this.InfoPanel:DisableDrawLayer("BACKGROUND")
			this.InfoPanel.Name:SetTextColor(self.HT:GetRGB())
			this.InfoPanel.Location:SetTextColor(self.BT:GetRGB())
			this.InfoPanel.Description:SetTextColor(self.BT:GetRGB())
			this.InfoPanel.AbilitiesFrame.AbilitiesLabel:SetTextColor(self.HT:GetRGB())
			this.InfoPanel.AbilitiesFrame.Border:SetTexture(nil)
			this.InfoPanel.SoulbindsFrame.SoulbindsLabel:SetTextColor(self.HT:GetRGB())
			this.InfoPanel.CovenantFeatureFrame.Label:SetTextColor(self.HT:GetRGB())
			this.InfoPanel.CovenantFeatureFrame.CovenantFeatureButton:GetNormalTexture():SetTexture(nil)
			for btn in this.AbilityButtonsPool:EnumerateActive() do
				btn.IconBorder:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, fType=ftype, ofs=3.5, clr="white"}
				end
			end
			for btn in this.SoulbindButtonsPool:EnumerateActive() do
				btn.Border:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, ofs=-8}
				end
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			self:clrCovenantBdr(this, this.uiTextureKit)
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseButton, noSkin=true}
				self:skinStdButton{obj=this.SelectButton}

			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].CovenantRenown = function(self)
		if not self.prdb.CovenantRenown or self.initialized.CovenantRenown then return end
		self.initialized.CovenantRenown = true

		self:SecureHook(_G.CovenantRenownFrame, "SetUpCovenantData", function(this)
			if this.sf then
				self:clrCovenantBdr(this)
			end
		end)

		local function skinRewards(frame)
			for reward in frame.rewardsPool:EnumerateActive() do
				aObj:skinObject("frame", {obj=reward, fType=ftype, kfs=true, fb=true, ofs=-14, clr="sepia"})
				reward.Check:SetAlpha(1) -- make Checkmark visible
				reward.Icon:SetAlpha(1) -- make Icon visible
			end
		end
		self:SecureHookScript(_G.CovenantRenownFrame, "OnShow", function(this)
			this.HeaderFrame.Background:SetTexture(nil)
			self:moveObject{obj=this.HeaderFrame, y=-6}
			-- .CelebrationModelScene
			-- .TrackFrame
				-- N.B. the level background is part of the border atlas and CANNOT be changed ;(
			-- .FinalToast
			-- .FinalToast.IconSwirlModelScene
			-- .FinalToast.SlabTexture
			self:SecureHook(this, "SetRewards", function(fObj, _)
				skinRewards(fObj)
			end)
			skinRewards(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, ofs=0})
			self:clrCovenantBdr(this)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].CovenantSanctum = function(self)
		if not self.prdb.CovenantSanctum or self.initialized.CovenantSanctum then return end
		self.initialized.CovenantSanctum = true

		self:SecureHookScript(_G.CovenantSanctumFrame, "OnShow", function(this)
			this.LevelFrame.Background:SetTexture(nil)
			local list = this.UpgradesTab.TalentsList
			list:DisableDrawLayer("BACKGROUND")
			list:DisableDrawLayer("BORDER")
			list.IntroBox:DisableDrawLayer("BORDER")
			local function skinTalents(tList)
				for talentFrame in tList.talentPool:EnumerateActive() do
					aObj:removeRegions(talentFrame, {1, 2})
					if talentFrame.TierBorder then
						aObj:changeTandC(talentFrame.TierBorder)
					end
					aObj:skinObject("frame", {obj=talentFrame, fType=ftype, ofs=2.5, y2=-2, clr="gold"})
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=talentFrame, relTo=talentFrame.Icon, reParent={talentFrame.TierBorder}}
						aObj:clrBtnBdr(talentFrame, talentFrame.Icon:IsDesaturated() and "disabled" or "gold")
					end
				end
			end
			-- hook this as the talentPool is released and refilled
			self:SecureHook(list, "Refresh", function(fObj)
				skinTalents(fObj)
				if self.modBtns then
					self:clrBtnBdr(fObj.UpgradeButton, "sepia")
				end
			end)
			skinTalents(list)
			for _, frame in _G.pairs(this.UpgradesTab.Upgrades) do
				if frame.Border then
					frame.Border:SetTexture(nil)
				end
				if frame.TierBorder then
					self:changeTandC(frame.TierBorder)
				end
			end
			this.UpgradesTab.CurrencyBackground:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, ofs=-3})
			self:clrCovenantBdr(this)
			if self.modBtns then
				self:skinStdButton{obj=this.UpgradesTab.TalentsList.UpgradeButton, fType=ftype}
				self:skinStdButton{obj=this.UpgradesTab.DepositButton, fType=ftype}
				self:SecureHook(this.UpgradesTab, "UpdateDepositButton", function(fObj)
					self:clrBtnBdr(fObj.DepositButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHook(_G.CovenantSanctumFrame, "SetCovenantInfo", function(this)
			if this.sf then
				self:clrCovenantBdr(this)
			end
		end)

	end

	aObj.blizzLoDFrames[ftype].FlightMap = function(self)
		if not self.prdb.FlightMap or self.initialized.FlightMap then return end
		self.initialized.FlightMap = true

		-- this AddOn changes the FlightMapFrame reference to point to the WorldMapFrame
		if _G.C_AddOns.IsAddOnLoaded("WorldFlightMap") then
			self.blizzLoDFrames[ftype].FlightMap = nil
			return
		end

		self:SecureHookScript(_G.FlightMapFrame, "OnShow", function(this)
			-- remove ZoneLabel background texture
			for dP, _ in _G.pairs(this.dataProviders) do
				if dP.ZoneLabel then
					dP.ZoneLabel.TextBackground:SetTexture(nil)
					break
				end
			end
			 -- set frame strata to 'LOW' to allow map textures to be visible
			self:skinObject("frame", {obj=this.BorderFrame, fType=ftype, kfs=true, bg=true, sfs="LOW", rns=true, cb=true, ofs=3, y1=2})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.FlightMapFrame)

	end

	aObj.blizzFrames[ftype].GuildRenameFrame = function(self)
		if not self.prdb.GuildRegistrar or self.initialized.GuildRenameFrame then return end
		self.initialized.GuildRenameFrame = true

		self:SecureHookScript(_G.GuildRenameFrame, "OnShow", function(this)
			this.TitleFlow.Description:SetTextColor(aObj.BT:GetRGB())
			self:skinObject("editbox", {obj=this.RenameFlow.NameBox, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.ContextButton, fType=ftype, sechk=true}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHook(_G.GuildRenameFrame, "UpdateFontStrings", function(this, _)
			for fontString in _G.pairs(this.fontStrings) do
				fontString:SetTextColor(aObj.BT:GetRGB())
			end
		end)

	end

	aObj.blizzLoDFrames[ftype].ItemInteractionUI = function(self) -- a.k.a. Titanic Purification/Runecarver reclaim soulessence/Creation Catalyst
		if not self.prdb.ItemInteractionUI or self.initialized.ItemInteractionUI then return end
		self.initialized.ItemInteractionUI = true

		self:SecureHookScript(_G.ItemInteractionFrame, "OnShow", function(this)
			this.ItemConversionFrame.ItemConversionInputSlot.ButtonFrame:SetAlpha(0) -- N.B. Texture changed in code
			this.ItemConversionFrame.ItemConversionOutputSlot.ButtonFrame:SetAlpha(0) -- N.B. Texture changed in code
			this.ButtonFrame:DisableDrawLayer("BORDER")
			this.ButtonFrame.MoneyFrameEdge:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=3})
			if self.modBtns then
				self:skinStdButton{obj=this.ButtonFrame.ActionButton}
				self:SecureHook(this, "UpdateActionButtonState", function(fObj)
					self:clrBtnBdr(fObj.ButtonFrame.ActionButton)
				end)
			end
			if self.modBtnBs then
				-- N.B.: can cause ADDON_ACTION_FORBIDDEN when clicked
				self:addButtonBorder{obj=this.ItemConversionFrame.ItemConversionInputSlot, fType=ftype, ibt=true, ignTex=true}
				self:addButtonBorder{obj=this.ItemConversionFrame.ItemConversionOutputSlot, fType=ftype, ibt=true, ignTex=true}
				-- TODO: colour button borders based upon item quality ?
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].ItemUpgradeUI = function(self)
		if not self.prdb.ItemUpgradeUI or self.initialized.ItemUpgradeUI then return end
		self.initialized.ItemUpgradeUI = true

		self:SecureHookScript(_G.ItemUpgradeFrame, "OnShow", function(this)
			this.UpgradeItemButton.ButtonFrame:SetTexture(nil)
			self:skinObject("ddbutton", {obj=this.ItemInfo.Dropdown, fType=ftype})
			self:skinObject("frame", {obj=this.LeftItemPreviewFrame, fType=ftype, fb=true})
			self:skinObject("frame", {obj=this.RightItemPreviewFrame, fType=ftype, fb=true})
			this.PlayerCurrenciesBorder:DisableDrawLayer("background")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
			if self.modBtns then
				self:skinStdButton{obj=this.UpgradeButton, fType=ftype, sechk=true}
			end
			if self.modBtnBs then
				-- N.B.: can cause ADDON_ACTION_FORBIDDEN when clicked
				self:addButtonBorder{obj=this.UpgradeItemButton, fType=ftype, ibt=true, ignTex=true}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].NewPlayerExperienceGuide = function(self)
		if not self.prdb.TutorialUI or self.initialized.NewPlayerExperienceGuide then return end
		self.initialized.NewPlayerExperienceGuide = true

		self:SecureHookScript(_G.GuideFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this.Title:SetTextColor(self.HT:GetRGB())
			this.ScrollFrame.Child.Text:SetTextColor(self.BT:GetRGB())
			this.ScrollFrame.Child.ObjectivesFrame:DisableDrawLayer("BORDER")
			this.ScrollFrame.Child.ObjectivesFrame:DisableDrawLayer("BACKGROUND")
			self:skinObject("scrollbar", {obj=this.ScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.ScrollFrame.ConfirmationButton}
				self:SecureHook(this, "SetStateInternal", function(fObj)
					self:clrBtnBdr(fObj.ScrollFrame.ConfirmationButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].PerksProgram = function(self) -- a.k.a. Trading Post Frame
		if not self.prdb.PerksProgram or self.initialized.PerksProgram then return end
		self.initialized.PerksProgram = true

		self:SecureHookScript(_G.PerksProgramFrame, "OnShow", function(this)

			self:SecureHookScript(this.ProductsFrame, "OnShow", function(fObj)
				self:skinObject("ddbutton", {obj=fObj.PerksProgramFilter, fType=ftype, filter=true})
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.PerksProgramCurrencyFrame, fType=ftype, relTo=fObj.PerksProgramCurrencyFrame.Icon}
				end

				self:SecureHookScript(fObj.ProductsScrollBoxContainer, "OnShow", function(frame)
					self:removeNineSlice(frame.Border)
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, x1=-4})
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
					local function skinProduct(...)
						local _, element, elementData, new
						if _G.select("#", ...) == 2 then
							element, elementData = ...
						elseif _G.select("#", ...) == 3 then
							element, elementData, new = ...
						else
							_, element, elementData, new = ...
						end
						if new ~= false then
							if aObj.modBtnBs
							and elementData.isItemInfo
							then
								aObj:addButtonBorder{obj=element.ContentsContainer, relTo=element.ContentsContainer.Icon, fType=ftype}
								aObj:addButtonBorder{obj=element.ContentsContainer.CartToggleButton, fType=ftype, es=28, ofs=3, clr="grey"}
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinProduct, aObj, true)
					self:removeNineSlice(frame.PerksProgramHoldFrame.NineSlice)

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.ProductsScrollBoxContainer)

				self:SecureHookScript(fObj.PerksProgramProductDetailsContainerFrame, "OnShow", function(frame)
					self:removeNineSlice(frame.Border)
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true})

					self:skinObject("scrollbar", {obj=frame.SetDetailsScrollBoxContainer.ScrollBar, fType=ftype})
					local y1Ofs, y2Ofs
					local function skinDetails(...)
						local _, element, elementData
						if _G.select("#", ...) == 2 then
							element, elementData = ...
						else
							_, element, elementData = ...
						end
						if elementData.isFirstSetItem then
							y1Ofs = -19
							y2Ofs = nil
						elseif elementData.isLastSetItem then
							y1Ofs = nil
							y2Ofs = 19
						else
							y1Ofs = nil
							y2Ofs = 1
						end
						element.BackgroundTexture:SetTexture(nil)
						aObj:skinObject("frame", {obj=element, fb=true, clr="grey", y1=y1Ofs, y2=y2Ofs})
						-- TODO: add button border to icon
					end
					_G.ScrollUtil.AddInitializedFrameCallback(frame.SetDetailsScrollBoxContainer.ScrollBox, skinDetails, aObj, true)

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.PerksProgramProductDetailsContainerFrame)

				self:SecureHookScript(fObj.PerksProgramShoppingCartFrame, "OnShow", function(frame)
					-- TODO: skin ItemList entries
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true})
					if self.modBtns then
						frame.CloseButton:SetFrameLevel(1001)
						self:skinStdButton{obj=frame.PurchaseCartButton, fType=ftype, ofs=-4}
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=frame.ClearCartButton, fType=ftype, es=36, x1=-3, x2=3}
					end

					self:Unhook(frame, "OnShow")
				end)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.ProductsFrame)

			self:SecureHookScript(this.ModelSceneContainerFrame, "OnShow", function(fObj)
				self:removeRegions(fObj.ToyOverlayFrame, {1, 3})
				self:skinObject("frame", {obj=fObj.ToyOverlayFrame, fType=ftype, x1=785, y1=-295, x2=-625, y2=295})
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.ToyOverlayFrame, fType=ftype, relTo=fObj.ToyOverlayFrame.Icon, clr="gold", es=24, ofs=3}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.ModelSceneContainerFrame)

			self:SecureHookScript(this.FooterFrame, "OnShow", function(fObj)
				if self.modBtns then
					self:skinStdButton{obj=fObj.LeaveButton, fType=ftype, ofs=-4}
					self:skinStdButton{obj=fObj.PurchaseButton, fType=ftype, sechk=true, ofs=0, y2=-1}
					self:skinStdButton{obj=fObj.RefundButton, fType=ftype, ofs=-4}
					self:skinStdButton{obj=fObj.AddToCartButton, fType=ftype, ofs=-4}
					self:skinStdButton{obj=fObj.RemoveFromCartButton, fType=ftype, ofs=-4}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.RotateButtonContainer.RotateLeftButton, fType=ftype, ofs=-3}
					self:addButtonBorder{obj=fObj.RotateButtonContainer.RotateRightButton, fType=ftype, ofs=-3}
					self:addButtonBorder{obj=fObj.ViewCartButton, fType=ftype, reParent={fObj.ViewCartButton.ItemCountBG, fObj.ViewCartButton.ItemCountText}, es=28, sechk=true}
					self:changeTandC(fObj.ViewCartButton.ItemCountBG)
					self:moveObject{obj=fObj.ViewCartButton.ItemCountText, y=-3}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.TogglePlayerPreview, fType=ftype}
					self:skinCheckButton{obj=fObj.ToggleMountSpecial, fType=ftype}
					self:skinCheckButton{obj=fObj.ToggleHideArmor, fType=ftype}
					self:skinCheckButton{obj=fObj.ToggleAttackAnimation, fType=ftype}
				end
				-- ErrorIndicator
				-- PurchasedHistoryFrame

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.FooterFrame)


			self:SecureHookScript(this.ThemeContainer, "OnShow", function(fObj)
				fObj.ProductList:DisableDrawLayer("BACKGROUND")
				fObj.ProductDetails:DisableDrawLayer("BACKGROUND")

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.ThemeContainer)

			self:Unhook(this, "OnShow")
		end)

		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.PerksProgramTooltip)
		end)

	end

	aObj.blizzLoDFrames[ftype].RuneForgeUI = function(self)
		if not self.prdb.RuneForgeUI or self.initialized.RuneForgeUI then return end
		self.initialized.RuneForgeUI = true

		self:SecureHookScript(_G.RuneforgeFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this.CraftingFrame.ModifierFrame.Selector, fType=ftype, kfs=true, ofs=-10, y1=-20, y2=20})
			self:skinObject("frame", {obj=this.CraftingFrame.PowerFrame, fType=ftype, kfs=true, ofs=0, y1=-10, y2=10})
			this.BackgroundModelScene:Hide()
			self:removeBackdrop(this.ResultTooltip.PulseOverlay)
			this.CloseButton.CustomBorder:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cbns=true, ofs=-40, y1=-75, y2=100})
			if self.modBtns then
				self:skinStdButton{obj=this.CreateFrame.CraftItemButton}
				self:SecureHook(this.CreateFrame.CraftItemButton, "SetCraftState", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.CraftingFrame.PowerFrame.PageControl.BackwardButton, clr="gold", ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=this.CraftingFrame.PowerFrame.PageControl.ForwardButton, clr="gold", ofs=-2, y1=-3, x2=-3}
				self:SecureHook(this.CraftingFrame.PowerFrame.PageControl, "RefreshPaging", function(fObj)
					self:clrBtnBdr(fObj.BackwardButton, "gold")
					self:clrBtnBdr(fObj.ForwardButton, "gold")
				end)
			end

			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, this.ResultTooltip)
				this.ResultTooltip.TopOverlay:SetAlpha(1)
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].StableUI = function(self)
		if not self.prdb.StableUI or self.initialized.StableUI then return end
		self.initialized.StableUI = true

		self:SecureHookScript(_G.StableFrame, "OnShow", function(this)
			self:skinMainHelpBtn(this)
			this.PetModelScene:DisableDrawLayer("BACKGROUND")
			this.PetModelScene:DisableDrawLayer("ARTWORK")
			self:removeInset(this.PetModelScene.Inset)
			this.PetModelScene.PetModelSceneShadow:DisableDrawLayer("OVERLAY")
			self:skinObject("ddbutton", {obj=this.PetModelScene.PetInfo.Specialization, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.StableTogglePetButton, fType=ftype, schk=true, sechk=true}
				self:skinStdButton{obj=this.ReleasePetButton, fType=ftype, schk=true, sechk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.PetModelScene.PetInfo.NameBox.EditButton, fType=ftype, ofs=-1}
			end

			local function changePetButton(btn, active)
				if active then
					btn.Background:SetTexture(nil)
					btn.BackgroundMask:SetTexture(nil)
					btn.Highlight:SetSize(75, 75)
					btn.Highlight:SetTexture(aObj.tFDIDs.cbH)
				end
				btn.Border:SetAlpha(0)
				aObj:makeIconSquare(btn, "Icon", active and "grey" or "gold", not active and {btn.FavoriteIcon} or {})
			end
			self:SecureHookScript(this.StabledPetList, "OnShow", function(fObj)
				self:keepFontStrings(fObj)
				fObj.ListCounter:DisableDrawLayer("BACKGROUND")
				fObj.ListCounter:DisableDrawLayer("BORDER")
				self:removeInset(fObj.Inset)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinStabledPet(...)
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
						if element.Portrait then
							changePetButton(element.Portrait)
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinStabledPet, aObj, true)
				self:skinObject("editbox", {obj=fObj.FilterBar.SearchBox, fType=ftype, si=true})
				self:skinObject("ddbutton", {obj=fObj.FilterBar.FilterDropdown, fType=ftype, filter=true})

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.StabledPetList)

			self:SecureHookScript(this.ActivePetList, "OnShow", function(fObj)
				fObj.ActivePetListBG:SetTexture(nil)
				fObj.ActivePetListBGBar:SetTexture(nil)
				for _, btn in _G.pairs(fObj.PetButtons) do
					changePetButton(btn, true)
				end
				changePetButton(fObj.BeastMasterSecondaryPetButton, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.ActivePetList)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].TaxiFrame = function(self)
		if not self.prdb.TaxiFrame or self.initialized.TaxiFrame then return end
		self.initialized.TaxiFrame = true

		self:SecureHookScript(_G.TaxiFrame, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			self:removeRegions(this, {1, 2, 3}) -- 1st 3 overlay textures
			-- resize map to fit skin frame
			this.InsetBg:SetPoint("TOPLEFT", 0, -24)
			this.InsetBg:SetPoint("BOTTOMRIGHT", 0 ,0)
			self:skinObject("frame", {obj=this, fType=ftype, cb=true})

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].TrainerUI = function(self)
		if not self.prdb.TrainerUI or self.initialized.TrainerUI then return end
		self.initialized.TrainerUI = true

		self:SecureHookScript(_G.ClassTrainerFrame, "OnShow", function(this)
			_G.ClassTrainerStatusBarLeft:SetAlpha(0)
			_G.ClassTrainerStatusBarRight:SetAlpha(0)
			_G.ClassTrainerStatusBarMiddle:SetAlpha(0)
			_G.ClassTrainerStatusBarSkillRank:SetPoint("CENTER", _G.ClassTrainerStatusBar) -- Blizzard bug
			self:skinObject("statusbar", {obj=_G.ClassTrainerStatusBar, fi=0, bg=_G.ClassTrainerStatusBarBackground})
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype, filter=true})
			self:removeMagicBtnTex(_G.ClassTrainerTrainButton)
			this.skillStepButton:GetNormalTexture():SetTexture(nil)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
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
					element:GetNormalTexture():SetTexture(nil)
					element.disabledBG:SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, relTo=element.icon}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:removeInset(this.bottomInset)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.ClassTrainerTrainButton, fType=ftype, sechk=true}
				if _G.C_AddOns.IsAddOnLoaded("Leatrix_Plus")
				and _G.LeaPlusDB["ShowTrainAllButton"] == "On"
				then
					self:skinStdButton{obj=_G.LeaPlusGlobalTrainAllButton, fType=ftype, sechk=true} -- Train All button
				end
			end
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.skillStepButton, fType=ftype, relTo=this.skillStepButton.icon}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].VoidStorageUI = function(self)
		if not self.prdb.VoidStorageUI or self.initialized.VoidStorageUI then return end
		self.initialized.VoidStorageUI = true

		self:SecureHookScript(_G.VoidStorageFrame, "OnShow", function(this)
			for _, type in _G.pairs{"Deposit", "Withdraw", "Storage", "Cost"} do
				self:removeNineSlice(_G["VoidStorage" .. type .. "Frame"].NineSlice)
				_G["VoidStorage" .. type .. "Frame"]:DisableDrawLayer("BACKGROUND")
			end
			self:keepFontStrings(_G.VoidStorageBorderFrame)
			self:skinObject("editbox", {obj=_G.VoidItemSearchBox, fType=ftype, si=true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x2=1})
			if self.modBtns then
				self:skinStdButton{obj=_G.VoidStorageTransferButton, fType=ftype, schk=true}
				self:skinCloseButton{obj=_G.VoidStorageBorderFrame.CloseButton, fType=ftype}
				self:skinStdButton{obj=_G.VoidStoragePurchaseButton, fType=ftype}
				self:SecureHook("VoidStorageFrame_Update", function()
					self:clrBtnBdr(_G.VoidStoragePurchaseButton)
				end)
			end
			if self.modBtnBs then
				local VOID_DEPOSIT_MAX = 9
				for i = 1, VOID_DEPOSIT_MAX do
					self:addButtonBorder{obj=_G["VoidStorageDepositButton" .. i], fType=ftype}
					self:addButtonBorder{obj=_G["VoidStorageWithdrawButton" .. i], fType=ftype}
				end
				local VOID_STORAGE_MAX = 80
				for i = 1, VOID_STORAGE_MAX do
					self:addButtonBorder{obj=_G["VoidStorageStorageButton" .. i], fType=ftype}
				end
			end
			self:skinObject("frame", {obj=_G.VoidStoragePurchaseFrame, fType=ftype, kfs=true, ofs=0})
			-- Tabs
			local VOID_STORAGE_PAGES = 2
			for i = 1, VOID_STORAGE_PAGES do
				_G.VoidStorageFrame["Page" .. i]:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:addButtonBorder{obj=_G.VoidStorageFrame["Page" .. i]}
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

end

aObj.SetupMainline_NPCFramesOptions = function(self)

	local optTab = {
		["Allied Races UI"]             = true,
		["Azerite Respec UI"]           = true,
		["Chromie Time UI"]             = true,
		["Covenant Preview UI"]         = true,
		["Covenant Renown"]             = true,
		["Covenant Sanctum"]            = true,
		["Flight Map"]                  = true,
		["Item Interaction UI"]         = true,
		["Item Upgrade UI"]             = true,
		["Perks Program"] 				= {desc = "Trading Post"},
		["Rune Forge UI"]               = true,
		["Stable UI"]                   = {desc = "Stable Frame"},
		["Void Storage UI"]             = true,
	}
	self:setupFramesOptions(optTab, "NPC")
	_G.wipe(optTab)

end
