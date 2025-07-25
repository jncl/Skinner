if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then return end

local _, aObj = ...

local _G = _G

aObj.SetupClassic_UIFrames = function()
	local ftype = "u"

	if not aObj.isClsc then
		aObj.blizzFrames[ftype].BattlefieldFrame = function(self)
			if not self.prdb.BattlefieldFrame or self.initialized.BattlefieldFrame then return end
			self.initialized.BattlefieldFrame = true

			self:SecureHookScript(_G.BattlefieldFrame, "OnShow", function(this)
				if not aObj.isClsc then
					self:skinObject("slider", {obj=_G.BattlefieldListScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				else
					self:skinObject("slider", {obj=_G.BattlefieldFrameTypeScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
					self:skinObject("slider", {obj=_G.BattlefieldFrameInfoScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
					_G.BattlefieldFrameInfoScrollFrameChildFrameDescription:SetTextColor(self.BT:GetRGB())
					_G.BattlefieldFrameInfoScrollFrameChildFrameRewardsInfoTitle:SetTextColor(self.BT:GetRGB())
					_G.BattlefieldFrameInfoScrollFrameChildFrameRewardsInfoRewardsLabel:SetTextColor(self.BT:GetRGB())
				end
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=12, y1=-12, x2=-32, y2=74})
				_G.BattlefieldFrameCloseButton:Hide()
				if self.modBtns then
					self:skinStdButton{obj=_G.BattlefieldFrameCancelButton, fType=ftype}
					self:skinStdButton{obj=_G.BattlefieldFrameJoinButton, fType=ftype}
					self:skinStdButton{obj=_G.BattlefieldFrameGroupJoinButton, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzLoDFrames[ftype].BindingUI = function(self)
		if not self.prdb.BindingUI or self.initialized.BindingUI then return end
		self.initialized.BindingUI = true

		self:SecureHookScript(_G.KeyBindingFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this.categoryList, fType=ftype, kfs=true, fb=true})
			self:skinObject("frame", {obj=this.bindingsContainer, fType=ftype, kfs=true, fb=true})
			self:skinObject("slider", {obj=this.scrollFrame.ScrollBar, fType=ftype, rpTex={"background", "border"}})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true})
			if self.modBtns then
				for _, row in _G.pairs(this.keyBindingRows) do
					self:skinStdButton{obj=row.key1Button, fType=ftype}
					self:skinStdButton{obj=row.key2Button, fType=ftype}
					row.key1Button.sb:SetAlpha(row.key1Button:GetAlpha())
					row.key2Button.sb:SetAlpha(row.key2Button:GetAlpha())
				end
				self:skinStdButton{obj=this.unbindButton, fType=ftype}
				self:skinStdButton{obj=this.okayButton, fType=ftype}
				self:skinStdButton{obj=this.cancelButton, fType=ftype}
				self:skinStdButton{obj=this.defaultsButton, fType=ftype}
				-- hook this to handle custom buttons (e.g. Voice Chat: Push to Talk)
				self:SecureHook("BindingButtonTemplate_SetupBindingButton", function(_, button)
					if button.GetCustomBindingType then
						self:skinStdButton{obj=button, fType=ftype}
					end
				end)
				self:SecureHook("KeyBindingFrame_Update", function()
					for _, row in _G.pairs(_G.KeyBindingFrame.keyBindingRows) do
						self:clrBtnBdr(row.key2Button)
						row.key1Button.sb:SetAlpha(row.key1Button:GetAlpha())
						row.key2Button.sb:SetAlpha(row.key2Button:GetAlpha())
					end
				end)
				self:SecureHook("KeyBindingFrame_UpdateUnbindKey", function()
					self:clrBtnBdr(_G.KeyBindingFrame.unbindButton)
				end)
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.characterSpecificButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].ChatButtons = function(self)
		if not self.prdb.ChatButtons or self.initialized.ChatButtons then return end
		self.initialized.ChatButtons = true

		if self.modBtnBs then
			for i = 1, _G.NUM_CHAT_WINDOWS do
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.bottomButton, fType=ftype, ofs=-2, x1=1}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.downButton, fType=ftype, ofs=-2, x1=1}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.upButton, fType=ftype, ofs=-2, x1=1}
				if not aObj.isClsc then
					self:addButtonBorder{obj=_G["ChatFrame" .. i].minimizeButton, fType=ftype, ofs=-2, x=1}
				end
				self:addButtonBorder{obj=_G["ChatFrame" .. i].ScrollToBottomButton, fType=ftype, ofs=-1}
			end
			self:addButtonBorder{obj=_G.ChatFrameChannelButton, fType=ftype, ofs=1}
			self:addButtonBorder{obj=_G.ChatFrameMenuButton, fType=ftype, ofs=-2, x1=1}
			self:addButtonBorder{obj=_G.TextToSpeechButton, fType=ftype, ofs=1}
			self:addButtonBorder{obj=_G.FriendsMicroButton, fType=ftype, x1=1, x2=-2}
		end

	end

	aObj.blizzFrames[ftype].ColorPicker = function(self)
		if not self.prdb.ColorPicker or self.initialized.ColorPicker then return end
		self.initialized.ColorPicker = true

		self:SecureHookScript(_G.ColorPickerFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.OpacitySliderFrame, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, hdr=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=_G.ColorPickerOkayButton, fType=ftype}
				self:skinStdButton{obj=_G.ColorPickerCancelButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.OpacityFrame, "OnShow", function(this)
			-- used by BattlefieldMinimap amongst others
			self:skinObject("slider", {obj=_G.OpacityFrameSlider, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-1})

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].LevelUpDisplay = function(self)
		if not self.prdb.LevelUpDisplay or self.initialized.LevelUpDisplay then return end
		self.initialized.LevelUpDisplay = true

		self:SecureHookScript(_G.LevelUpDisplay, "OnShow", function(this)
			self:keepFontStrings(this)
			if self.modBtnBs then
				self:addButtonBorder{obj=this.spellFrame, fType=ftype, relTo=this.spellFrame.icon}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].Nameplates = function(self)
		if not self.prdb.Nameplates or self.initialized.Nameplates then return end
		self.initialized.Nameplates = true

		if _G.C_AddOns.IsAddOnLoaded("Plater") then
			self.blizzFrames[ftype].Nameplates = nil
			return
		end

		local function skinNamePlate(frame)
			-- aObj:Debug("skinNamePlate: [%s, %s]", frame, frame:IsForbidden())
			if not frame -- happens when called again after combat and frame doesn't exist any more
			or frame:IsForbidden()
			then
				return
			end
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinNamePlate, {frame}})
			    return
			end
			local nP = frame.UnitFrame or aObj:getChild(frame, 1)
			if nP
			and nP.healthBar
			and not nP.classNamePlatePowerBar
			then
				local nHb, nCb = nP.healthBar, nP.castBar or nP.CastBar
				nHb.border:DisableDrawLayer("ARTWORK")
				aObj:skinObject("statusbar", {obj=nHb, fType=ftype, bg=nHb.background})
				if aObj.isClsc then
					aObj:removeRegions(nCb, {2, 3})
					aObj:skinObject("statusbar", {obj=nCb, fType=ftype, bg=aObj:getRegion(nCb, 1)})
				end
				-- N.B. WidgetContainer objects managed in UIWidgets code
			end
		end
		self:SecureHook(_G.NamePlateDriverFrame, "OnNamePlateAdded", function(_, namePlateUnitToken)
			skinNamePlate(_G.C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, _G.issecure()))
		end)
		for _, frame in _G.pairs(_G.C_NamePlate.GetNamePlates(_G.issecure())) do
			skinNamePlate(frame)
		end

	end

	aObj.blizzFrames[ftype].ProductChoice = function(self)
		if not self.prdb.ProductChoice or self.initialized.ProductChoice then return end
		self.initialized.ProductChoice = true

		self:SecureHookScript(_G.ProductChoiceFrame, "OnShow", function(this)
			for _, btn in _G.pairs(this.Inset.Buttons) do
				btn.IconBorder:SetTexture(nil)
				self:skinObject("frame", {obj=btn, fType=ftype, kfs=true, fb=true})
				btn.Icon:SetAlpha(1)
			end
			self:skinObject("frame", {obj=this.Inset.NoTakeBacksies.Dialog, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.Inset.NoTakeBacksies.Dialog.AcceptButton, fType=ftype}
				self:skinStdButton{obj=this.Inset.NoTakeBacksies.Dialog.DeclineButton, fType=ftype}
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=1})
			if self.modBtns then
				self:skinStdButton{obj=this.Inset.ClaimButton, fType=ftype}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Inset.PrevPageButton, fType=ftype, ofs=-2, y1=-3, x2=-3, clr="gold"}
				self:addButtonBorder{obj=this.Inset.NextPageButton, fType=ftype, ofs=-2, y1=-3, x2=-3, clr="gold"}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	if not aObj.isClsc then
		aObj.blizzFrames[ftype].PVPFrame = function(self)
			if not self.prdb.PVPFrame or self.initialized.PVPFrame then return end
			self.initialized.PVPFrame = true

			self:SecureHookScript(_G.PVPFrame, "OnShow", function(this)
				-- Currency
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true, regions={7}})
				_G.PVPFrameConquestBar:DisableDrawLayer("BORDER")
				self:removeInset(this.topInset)
				self:removeMagicBtnTex(_G.PVPFrameLeftButton)
				self:removeMagicBtnTex(_G.PVPFrameRightButton)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x2=1})
				if self.modBtns then
					self:skinStdButton{obj=_G.PVPFrameLeftButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.PVPFrameRightButton, fType=ftype, schk=true}
					-- hook this to hide LeftButton when War Games panel shown
					self:RawHook("PVPFrame_TabClicked", function(fObj)
						self.hooks.PVPFrame_TabClicked(fObj)
						if fObj:GetID() == 4 then -- War games
							_G.PVPFrameLeftButton:Hide()
						end
					end, true)
				end
				if self.modChkBtns then
					for _, name in _G.pairs{"Tank", "Healer", "DPS"} do
						self:skinCheckButton{obj=this[name .. "Icon"].checkButton, fType=ftype}
						this[name .. "Icon"].checkButton:SetSize(26, 26)
					end
				end

				self:SecureHookScript(_G.PVPHonorFrame, "OnShow", function(fObj)
					fObj:DisableDrawLayer("ARTWORK")
					self:skinObject("scrollbar", {obj=fObj.bgTypeScrollBar, fType=ftype, x1=1, x2=5})
					self:skinObject("scrollbar", {obj=_G.PVPHonorFrameInfoScrollFrame.ScrollBar, fType=ftype, x1=1, x2=5})
					_G.PVPHonorFrameInfoScrollFrame.scrollBarBackground:SetTexture(nil)
					_G.PVPHonorFrameInfoScrollFrame.scrollBarArtTop:SetTexture(nil)
					_G.PVPHonorFrameInfoScrollFrame.scrollBarArtBottom:SetTexture(nil)
					_G.PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(self.BT:GetRGB())
					_G.PVPHonorFrameInfoScrollFrameChildFrameRewardsInfoDescription:SetTextColor(self.BT:GetRGB())

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.PVPHonorFrame)

				self:SecureHookScript(_G.PVPConquestFrame, "OnShow", function(fObj)
					fObj:DisableDrawLayer("ARTWORK")
					fObj.infoButton:DisableDrawLayer("BORDER")

					self:Unhook(fObj, "OnShow")
				end)

				self:SecureHookScript(_G.PVPTeamManagementFrame, "OnShow", function(fObj)
					self:keepFontStrings(fObj)
					self:keepFontStrings(_G.PVPTeamManagementFrameWeeklyDisplay)
					if self.modBtnBs then
						self:addButtonBorder{obj=_G.PVPFrameToggleButton, fType=ftype, clr="gold", ofs=-1, x2=-2, y2=2}
					end

					self:SecureHookScript(_G.PVPTeamDetails, "OnShow", function(frame)
						frame:SetFrameLevel(_G.PVPFrame:GetFrameLevel() + 10)
						self:skinObject("dropdown", {obj=_G.PVPDropDown, fType=ftype})
						for i = 1, 5 do
							self:removeRegions(_G["PVPTeamDetailsFrameColumnHeader" .. i], {1, 2, 3})
							if self.modBtns then
								 self:skinStdButton{obj=_G["PVPTeamDetailsFrameColumnHeader" .. i], fType=ftype}
							end
						end
						self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, ofs=-2})
						if self.modBtns then
							self:skinStdButton{obj=_G.PVPTeamDetailsAddTeamMember, fType=ftype}
						end
						if self.modBtnBs then
							self:addButtonBorder{obj=_G.PVPTeamDetailsToggleButton, fType=ftype, ofs=-2, y1=-1, clr="gold"}
						end

						self:Unhook(frame, "OnShow")
					end)
					self:Unhook(fObj, "OnShow")
				end)

				self:SecureHookScript(_G.WarGamesFrame, "OnShow", function(fObj)
					fObj:DisableDrawLayer("BACKGROUND")
					fObj:DisableDrawLayer("ARTWORK")
					self:skinObject("scrollbar", {obj=fObj.scrollBar, fType=ftype, x1=1, x2=5})
					local function skinElement(...)
						local _, element
						if _G.select("#", ...) == 2 then
							element, _ = ...
						else
							_, element, _ = ...
						end
						if element.Bg then
							element.Bg:SetTexture(nil)
							element.Border:SetTexture(nil)
						else
							if aObj.modBtns then
								aObj:skinExpandButton{obj=element, fType=ftype, onSB=true}
							end
						end
					end
					_G.ScrollUtil.AddInitializedFrameCallback(fObj.scrollBox, skinElement, aObj, true)
					self:skinObject("scrollbar", {obj=_G.WarGamesFrameInfoScrollFrame.ScrollBar, fType=ftype, x1=1, x2=5})
					_G.WarGamesFrameInfoScrollFrame.scrollBarBackground:SetTexture(nil)
					_G.WarGamesFrameInfoScrollFrame.scrollBarArtTop:SetTexture(nil)
					_G.WarGamesFrameInfoScrollFrame.scrollBarArtBottom:SetTexture(nil)
					_G.WarGamesFrameDescription:SetTextColor(self.BT:GetRGB())
					self:removeMagicBtnTex(_G.WarGameStartButton)
					if self.modBtns then
						self:skinStdButton{obj=_G.WarGameStartButton, fType=ftype, schk=true}
					end

					self:Unhook(fObj, "OnShow")
				end)

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.PVPFrame.lowLevelFrame, "OnShow", function(this)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, clr="gold"})

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzFrames[ftype].PVPHelper = function(self)
		if not self.prdb.PVPFrame or self.initialized.PVPHelper then return end
		self.initialized.PVPHelper = true

		self:SecureHookScript(_G.PVPFramePopup, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			_G.PVPFramePopupRing:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=0})
			if self.modBtns then
				if self.isClscERA then
					self:skinOtherButton{obj=this.closeButton, fType=ftype, text=self.modUIBtns.minus}
				else
					self:skinOtherButton{obj=this.minimizeButton, fType=ftype, text=self.modUIBtns.minus}
				end
				self:skinStdButton{obj=_G.PVPFramePopupAcceptButton, fType=ftype}
				self:skinStdButton{obj=_G.PVPFramePopupDeclineButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PVPReadyDialog, "OnShow", function(this)
			this.Separator:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=this.enterButton, fType=ftype}
				self:skinStdButton{obj=this.hideButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.PVPReadyDialog)

	end

	aObj.blizzFrames[ftype].QuestLog = function(self)
		if not self.prdb.QuestLog or self.initialized.QuestLog then return end
		self.initialized.QuestLog = true

		if _G.C_AddOns.IsAddOnLoaded("QuestLogEx") then
			self.blizzFrames[ftype].QuestLog = nil
			return
		end

		if self.isClscERA then
			self:SecureHookScript(_G.QuestLogFrame, "OnShow", function(this)
				_G.QuestLogCollapseAllButton:DisableDrawLayer("BACKGROUND")
				self:keepFontStrings(_G.EmptyQuestLogFrame)
				self:skinObject("slider", {obj=_G.QuestLogListScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("slider", {obj=_G.QuestLogDetailScrollFrame.ScrollBar, fType=ftype})
				_G.QuestLogQuestTitle:SetTextColor(self.HT:GetRGB())
				_G.QuestLogObjectivesText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogTimerText:SetTextColor(self.BT:GetRGB())
				for i = 1, _G.MAX_OBJECTIVES do
					_G["QuestLogObjective" .. i]:SetTextColor(self.BT:GetRGB())
				end
				_G.QuestLogRequiredMoneyText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogDescriptionTitle:SetTextColor(self.HT:GetRGB())
				_G.QuestLogQuestDescription:SetTextColor(self.BT:GetRGB())
				_G.QuestLogRewardTitleText:SetTextColor(self.HT:GetRGB())
				_G.QuestLogItemChooseText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogItemReceiveText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogSpellLearnText:SetTextColor(self.BT:GetRGB())
				for i = 1, _G.MAX_NUM_ITEMS do
					_G["QuestLogItem" .. i .. "NameFrame"]:SetTexture(nil)
					if self.modBtns then
						 self:addButtonBorder{obj=_G["QuestLogItem" .. i], fType=ftype, libt=true}
					end
				end
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-11, x2=-33, y2=48})
				if self.modBtns then
					self:skinExpandButton{obj=_G.QuestLogCollapseAllButton, fType=ftype, onSB=true}
					for i = 1, _G.QUESTS_DISPLAYED do
						self:skinExpandButton{obj=_G["QuestLogTitle" .. i], fType=ftype, noddl=true, onSB=true}
						self:checkTex{obj=_G["QuestLogTitle" .. i]}
					end
					self:SecureHook("QuestLog_Update", function()
						for i = 1, _G.QUESTS_DISPLAYED do
							self:checkTex{obj=_G["QuestLogTitle" .. i]}
						end
					end)
					self:skinStdButton{obj=_G.QuestLogFrameAbandonButton, fType=ftype, schk=true, x1=2, x2=-2}
					self:skinStdButton{obj=_G.QuestFrameExitButton, fType=ftype}
					self:skinStdButton{obj=_G.QuestFramePushQuestButton, fType=ftype, schk=true, x1=2, x2=-2}
				end

				self:SecureHook("QuestLog_UpdateQuestDetails", function(_)
					for i = 1, _G.MAX_OBJECTIVES do
						_G["QuestLogObjective" .. i]:SetTextColor(self.BT:GetRGB())
					end
					_G.QuestLogRequiredMoneyText:SetTextColor(self.BT:GetRGB())
					_G.QuestLogRewardTitleText:SetTextColor(self.HT:GetRGB())
					_G.QuestLogItemChooseText:SetTextColor(self.BT:GetRGB())
					_G.QuestLogItemReceiveText:SetTextColor(self.BT:GetRGB())
				end)

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.QuestTimerFrame, "OnShow", function(this)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=0, x1=10, x2=-10})

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.QuestTimerFrame)
		else
			if self.modBtns then
				self:SecureHookScript(_G.QuestLogControlPanel, "OnShow", function(this)
					self:skinStdButton{obj=_G.QuestLogFrameAbandonButton, fType=ftype, schk=true, x1=2, x2=-2}
					self:skinStdButton{obj=_G.QuestLogFrameTrackButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.QuestFramePushQuestButton, fType=ftype, schk=true, x1=2, x2=-2}

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(_G.QuestLogControlPanel)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.QuestLogFrameShowMapButton, fType=ftype, relTo=_G.QuestLogFrameShowMapButton.texture, ofs=0, x1=2, x2=-2}
			end
			self:SecureHookScript(_G.QuestLogDetailFrame, "OnShow", function(this)
				self:skinObject("slider", {obj=_G.QuestLogDetailScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.QuestLogFrame, "OnShow", function(this)
				self:keepFontStrings(_G.EmptyQuestLogFrame)
				self:keepFontStrings(_G.QuestLogCount)
				self:skinObject("slider", {obj=_G.QuestLogListScrollFrame.scrollBar, fType=ftype, rpTex="background"})
				self:skinObject("slider", {obj=_G.QuestLogDetailScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
				if self.modBtns then
					for _, btn in _G.pairs(_G.QuestLogListScrollFrame.buttons) do
						self:skinExpandButton{obj=btn, fType=ftype, noddl=true, onSB=true}
						self:checkTex{obj=btn}
					end
					self:SecureHook("QuestLog_Update", function()
						for _, btn in _G.pairs(_G.QuestLogListScrollFrame.buttons) do
							self:checkTex{obj=btn}
						end
					end)
					self:skinStdButton{obj=_G.QuestLogFrameCancelButton, fType=ftype, x1=2, x2=-2}
				end

				self:Unhook(this, "OnShow")
			end)
		end

	end

	if aObj.isClsc then
		aObj.blizzFrames[ftype].QuestMapFrame = function(self)
			if not self.prdb.WorldMap.skin or self.initialized.QuestMapFrame then return end
			self.initialized.QuestMapFrame = true

			self:SecureHookScript(_G.QuestMapFrame, "OnShow", function(this)
				self:skinObject("dropdown", {obj=_G.QuestMapQuestOptionsDropDown, fType=ftype})
				self:skinObject("scrollbar", {obj=this.QuestsFrame.ScrollBar, fType=ftype, x1=1, x2=5})
				self:skinObject("slider", {obj=this.DetailsFrame.ScrollFrame.ScrollBar, fType=ftype})

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzFrames[ftype].RaidFrame = function(self)
		if not self.prdb.RaidFrame or self.initialized.RaidFrame then return end
		self.initialized.RaidFrame = true

		self:SecureHookScript(_G.RaidParentFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RaidFrame, "OnShow", function(this)
			self:skinObject("scrollbar", {obj=_G.RaidInfoFrame.ScrollBox.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=_G.RaidInfoFrame, fType=ftype, kfs=true, hdr=true})
			if self.modBtns then
				self:skinCloseButton{obj=_G.RaidInfoCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.RaidFrameConvertToRaidButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.RaidFrameRaidInfoButton, fType=ftype, schk=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.RaidFrameAllAssistCheckButton, fType=ftype}
			end

			-- hook this to stop title text being displayed twice
			self:SecureHook("FriendsFrame_ShowSubFrame", function(fName)
				if fName == "RaidFrame" then
					_G.FriendsFrame.TitleText:Hide()
				end
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].Tutorial = function(self)
		if not self.prdb.Tutorial or self.initialized.Tutorial then return end
		self.initialized.Tutorial = true

		self:SecureHookScript(_G.TutorialFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.TutorialFrameOkayButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.TutorialFrameCheckButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		if self.modBtns then
			_G.C_Timer.After(0.5, function()
				local btn
				for i = 1, _G.MAX_TUTORIAL_ALERTS do
					btn = _G["TutorialFrameAlertButton" .. i]
					self:moveObject{obj=btn:GetHighlightTexture(), x=3}
					self:skinOtherButton{obj=btn, fType=ftype, sap=true, font="ZoneTextFont", text="!"}
				end
			end)
		end

	end

	aObj.blizzFrames[ftype].WorldMap = function(self)
		if not self.prdb.WorldMap.skin or self.initialized.WorldMap then return end
		self.initialized.WorldMap = true

		self:SecureHookScript(_G.WorldMapFrame, "OnShow", function(this)
			if not _G.C_AddOns.IsAddOnLoaded("Mapster")
			and not _G.C_AddOns.IsAddOnLoaded("AlleyMap")
			then
				self:skinObject("frame", {obj=_G.WorldMapFrame.BorderFrame, fType=ftype, kfs=true, ofs=1}) -- full screen
				if self.isClscERA then
					self:skinObject("frame", {obj=_G.WorldMapFrame.MiniBorderFrame, fType=ftype, kfs=true, x1=15, y1=2, x2=-5, y2=24}) -- minimized
				else
					self:skinObject("frame", {obj=_G.WorldMapFrame.MiniBorderFrame, fType=ftype, kfs=true, x1=15, x2=-5}) -- minimized
				end
				if self.modBtns then
					self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MaximizeButton, fType=ftype, font=self.fontS, text=self.nearrow}
					self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MinimizeButton, fType=ftype, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
				end
				if self.isClsc then
					if self.modChkBtns then
						self:skinCheckButton{obj=_G.WorldMapTrackQuest, fType=ftype}
						self:skinCheckButton{obj=_G.WorldMapQuestShowObjectives, fType=ftype}
						self:skinCheckButton{obj=_G.WorldMapShowDigsites, fType=ftype}
					end
				end
			end

			self:skinObject("ddbutton", {obj=this.ContinentDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=this.ZoneDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=this.MinimapDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=this.WorldMapLevelDropDown, fType=ftype})
			if self.isClsc then
				self:skinObject("ddbutton", {obj=this.WorldMapOptionsDropDown, fType=ftype})
			end
			if self.modBtns then
				self:skinCloseButton{obj=_G.WorldMapFrameCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.WorldMapZoomOutButton, fType=ftype, schk=true}
			end
			-- tooltip
			self.ttHook["WorldMapTooltip"] = true
			self:add2Table(self.ttList, "WorldMapTooltip")

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].WorldStateScoreFrame = function(self)
		if not self.prdb.WorldStateScoreFrame or self.initialized.WorldStateScoreFrame then return end
		self.initialized.WorldStateScoreFrame = true

		self:SecureHookScript(_G.WorldStateScoreFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.WorldStateScoreScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=12, y1=-15, x2=-114, y2=70})
			if self.modBtns then
				self:skinStdButton{obj=_G.WorldStateScoreFrameLeaveButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	-- TODO: UnitPopup

	-- VideoOptionsFrame, wait for variable to be populated
	if aObj.modBtns then
		_G.C_Timer.After(1, function()
			aObj:skinStdButton{obj=_G.VideoOptionsFrameClassic, fType=ftype}
		end)
	end

end

aObj.SetupClassic_UIFramesOptions = function(self)

	local optTab = {
		["Battlefield Frame"]       = self.isClscERA and true or nil,
		["Binding UI"]              = {desc = "Key Bindings UI"},
		["Level Up Display"]        = self.isClsc and true or nil,
		["Nameplates"]              = true,
		["Product Choice"]          = {suff = "Frame"},
		["PVP Frame"]               = self.isClsc and {desc = "Player vs. Player"} or nil,
		["Quest Log"]               = true,
		["World State Score Frame"] = {desc = "Battle Score Frame"},
	}
	self:setupFramesOptions(optTab, "UI")
	_G.wipe(optTab)

end
