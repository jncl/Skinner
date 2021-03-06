local _, aObj = ...

local _G = _G

aObj.SetupClassic_UIFrames = function()
	local ftype = "u"

	aObj.blizzFrames[ftype].BattlefieldFrame = function(self)
		if not self.prdb.BattlefieldFrame or self.initialized.BattlefieldFrame then return end
		self.initialized.BattlefieldFrame = true

		self:SecureHookScript(_G.BattlefieldFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.BattlefieldListScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-11, x2=-32, y2=71})
			if self.modBtns then
				self:skinStdButton{obj=_G.BattlefieldFrameCancelButton, fType=ftype}
				self:skinStdButton{obj=_G.BattlefieldFrameJoinButton, fType=ftype}
				self:skinStdButton{obj=_G.BattlefieldFrameGroupJoinButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].ChatButtons = function(self)
		if not self.prdb.ChatButtons or self.initialized.ChatButtons then return end
		self.initialized.ChatButtons = true

		if self.modBtnBs then
			for i = 1, _G.NUM_CHAT_WINDOWS do
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.bottomButton, ofs=-2, x1=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.downButton, ofs=-2, x1=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.upButton, ofs=-2, x1=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.minimizeButton, ofs=-2, x=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].ScrollToBottomButton, ofs=-1, reParent={_G["ChatFrame" .. i].ScrollToBottomButton.Flash}}
			end
			self:addButtonBorder{obj=_G.ChatFrameChannelButton, ofs=1, clr="grey"}
			self:addButtonBorder{obj=_G.ChatFrameMenuButton, ofs=-2, x1=1, clr="grey"}
			if self.isClsc then
				self:addButtonBorder{obj=_G.TextToSpeechButton, ofs=1, clr="grey"}
			end
		end

	end

	if not aObj.isClscBC then
		aObj.blizzLoDFrames[ftype].GMSurveyUI = function(self)
			if not self.prdb.GMSurveyUI or self.initialized.GMSurveyUI then return end
			self.initialized.GMSurveyUI = true

			self:SecureHookScript(_G.GMSurveyFrame, "OnShow", function(this)
				self:skinObject("slider", {obj=_G.GMSurveyScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				for i = 1, _G.MAX_SURVEY_QUESTIONS do
					self:skinObject("frame", {obj=_G["GMSurveyQuestion" .. i], fType=ftype, kfs=true, fb=true})
					_G["GMSurveyQuestion" .. i].SetBackdropColor = _G.nop
					_G["GMSurveyQuestion" .. i].SetBackdropBorderColor = _G.nop
				end
				self:skinObject("slider", {obj=_G.GMSurveyCommentScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=_G.GMSurveyCommentFrame, fType=ftype, kfs=true, fb=true})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true, y1=-6, x2=-45})

				self:Unhook(this, "OnShow")
			end)

		end
	end

	if aObj.isClscBC
	or (_G.C_LFGList.IsLookingForGroupEnabled
	and _G.C_LFGList.IsLookingForGroupEnabled())
	then
		aObj.blizzFrames[ftype].LFGFrame = function(self)
			if not self.prdb.LFGLFM or self.initialized.LFGFrame then return end
			self.initialized.LFGFrame = true

			self:SecureHookScript(_G.LFGParentFrame, "OnShow", function(this)
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true, offsets={x1=6, y1=0, x2=-6, y2=2}})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-11, x2=-29, y2=70})
				if self.modBtns then
					self:skinCloseButton{obj=self:getChild(this, 3), fType=ftype}
				end

				self:SecureHookScript(_G.LFMFrame, "OnShow", function(fObj)
					self:skinObject("dropdown", {obj=_G.LFMFrameEntryDropDown, fType=ftype})
					self:removeInset(_G.LFMFrameInset)
					self:skinObject("dropdown", {obj=_G.LFMFrameTypeDropDown, fType=ftype})
					self:skinObject("dropdown", {obj=_G.LFMFrameActivityDropDown, fType=ftype})
					for i = 1, 4 do
						_G["LFMFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
						self:skinObject("frame", {obj=_G["LFMFrameColumnHeader" .. i], fType=ftype, ofs=0})
					end
					self:skinObject("slider", {obj=_G.LFMListScrollFrame.ScrollBar, fType=ftype})
					self:moveObject{obj=_G.LFMFrameGroupInviteButton, x=-4}
					if self.modBtns then
						self:skinStdButton{obj=_G.LFMFrameGroupInviteButton, fType=ftype}
						self:skinStdButton{obj=_G.LFMFrameSendMessageButton, fType=ftype}
						self:skinStdButton{obj=_G.LFMFrameSearchButton, fType=ftype}
						self:SecureHook(_G.LFMFrameGroupInviteButton, "SetEnabled", function(btn)
							self:clrBtnBdr(btn)
						end)
						self:SecureHook(_G.LFMFrameSendMessageButton, "SetEnabled", function(btn)
							self:clrBtnBdr(btn)
						end)
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.LFMFrame)

				self:SecureHookScript(_G.LFGFrame, "OnShow", function(fObj)
					for _, dd in _G.pairs(fObj.TypeDropDown) do
						self:skinObject("dropdown", {obj=dd, fType=ftype})
					end
					for _, dd in _G.pairs(fObj.ActivityDropDown) do
						self:skinObject("dropdown", {obj=dd, fType=ftype})
					end
					self:skinObject("editbox", {obj=fObj.Comment, fType=ftype, chginset=false, x1=-5})
					self:moveObject{obj=_G.LFGFramePostButton, x=-10}
					if self.modBtns then
						self:skinStdButton{obj=_G.LFGFrameClearAllButton, fType=ftype}
						self:skinStdButton{obj=_G.LFGFramePostButton, fType=ftype}
						self:SecureHook(_G.LFGFramePostButton, "SetEnabled", function(btn, _)
							self:clrBtnBdr(btn)
						end)
					end
					if self.modBtnBs then
						for i = 1, 3 do
							self:addButtonBorder{obj=_G["LFGSearchIcon" .. i .. "Shine"], fType=ftype, x1=-6, y1=3, x2=6, y2=-4, clr="grey"}
						end
						self:SecureHook(fObj, "UpdateActivityIcon", function(frame, i)
							local activityID = _G.UIDropDownMenu_GetSelectedValue(frame.ActivityDropDown[i])
							if activityID then
								self:clrBtnBdr(_G["LFGSearchIcon" .. i .. "Shine"])
							else
								self:clrBtnBdr(_G["LFGSearchIcon" .. i .. "Shine"], "grey")
							end
						end)
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.LFGFrame)

				self:Unhook(this, "OnShow")
			end)

			if self.prdb.MinimapButtons.skin then
				self:skinObject("button", {obj=_G.MiniMapLFGFrameIcon, fType=ftype, ofs=2})
			end

		end
	end

	aObj.blizzFrames[ftype].MainMenuBar = function(self)
		if self.initialized.MainMenuBar then return end
		self.initialized.MainMenuBar = true

		if _G.IsAddOnLoaded("Dominos") then
			self.blizzFrames[ftype].MainMenuBar = nil
			return
		end

		if self.prdb.MainMenuBar.skin then
			local function skinMultiBarBtns(type)
				local btn
				for i = 1, _G.NUM_MULTIBAR_BUTTONS do
					btn = _G["MultiBar" .. type .. "Button" .. i]
					btn.FlyoutBorder:SetTexture(nil)
					btn.FlyoutBorderShadow:SetTexture(nil)
					btn.Border:SetAlpha(0) -- texture changed in blizzard code
					if not btn.noGrid then
						_G[btn:GetName() .. "FloatingBG"]:SetAlpha(0)
					end
					aObj:addButtonBorder{obj=btn, sabt=true, ofs=3}
				end
			end
			self:SecureHookScript(_G.MainMenuBar, "OnShow", function(this)
				_G.ExhaustionTick:GetNormalTexture():SetTexture(nil)
				_G.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
				_G.MainMenuExpBar:DisableDrawLayer("OVERLAY")
				_G.MainMenuExpBar:SetSize(1011, 13)
				self:moveObject{obj=_G.MainMenuExpBar, x=1, y=2}
				self:skinObject("statusbar", {obj=_G.MainMenuExpBar, bg=self:getRegion(_G.MainMenuExpBar, 6), other={_G.ExhaustionLevelFillBar}})
				_G.MainMenuBarMaxLevelBar:DisableDrawLayer("BACKGROUND")
				_G.MainMenuBarArtFrame:DisableDrawLayer("BACKGROUND")
				_G.MainMenuBarLeftEndCap:SetTexture(nil)
				_G.MainMenuBarRightEndCap:SetTexture(nil)
				local rwbSB = _G.ReputationWatchBar.StatusBar
				self:removeRegions(rwbSB, {1, 2, 3, 4, 5, 6, 7, 8, 9})
				self:skinObject("statusbar", {obj=rwbSB, bg=rwbSB.Background, other={rwbSB.Underlay, rwbSB.Overlay}})
				if self.modBtnBs then
					for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
						_G["ActionButton" .. i].FlyoutBorder:SetTexture(nil)
						_G["ActionButton" .. i].FlyoutBorderShadow:SetTexture(nil)
						self:addButtonBorder{obj=_G["ActionButton" .. i], sabt=true, ofs=3}
					end
					self:addButtonBorder{obj=_G.ActionBarUpButton, ofs=-4, clr="gold"}
					self:addButtonBorder{obj=_G.ActionBarDownButton, ofs=-4, clr="gold"}
					skinMultiBarBtns("BottomLeft")
					skinMultiBarBtns("BottomRight")
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.MainMenuBar)

			if self.modBtnBs then
				skinMultiBarBtns("Right")
				skinMultiBarBtns("Left")
				for _, bName in _G.pairs(_G.MICRO_BUTTONS) do
					self:addButtonBorder{obj=_G[bName], es=24, ofs=2, y1=-18, reParent={_G[bName].QuickKeybindHighlightTexture, _G[bName].Flash}, clr="grey"}
				end

				self:addButtonBorder{obj=_G.MainMenuBarBackpackButton, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.CharacterBag0Slot, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.CharacterBag1Slot, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.CharacterBag2Slot, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.CharacterBag3Slot, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.KeyRingButton, ofs=2, clr="grey"}
			end
		end

		-- this is done here as other AddOns may require it to be skinned
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MainMenuBarVehicleLeaveButton, clr="grey"}
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

	aObj.blizzFrames[ftype].PVPHelper = function(self)

		self:SecureHookScript(_G.PVPFramePopup, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			_G.PVPFramePopupRing:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=0})
			if self.modBtns then
				self:skinOtherButton{obj=this.closeButton, text=self.modUIBtns.minus}
				self:skinStdButton{obj=_G.PVPFramePopupAcceptButton}
				self:skinStdButton{obj=_G.PVPFramePopupDeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PVPReadyDialog, "OnShow", function(this)
			this.Separator:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=this.enterButton}
				self:skinStdButton{obj=this.hideButton}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.PVPReadyDialog)

	end

	aObj.blizzFrames[ftype].QuestLog = function(self)
		if not self.prdb.QuestLog or self.initialized.QuestLog then return end
		self.initialized.QuestLog = true

		if _G.IsAddOnLoaded("QuestLogEx") then
			self.blizzFrames[ftype].QuestLog = nil
			return
		end

		self:SecureHookScript(_G.QuestLogFrame, "OnShow", function(this)
			_G.QuestLogCollapseAllButton:DisableDrawLayer("BACKGROUND")
			self:keepFontStrings(_G.EmptyQuestLogFrame)
			if self.isClscBC then
				self:keepFontStrings(_G.QuestLogCount)
			end
			self:skinObject("slider", {obj=_G.QuestLogListScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("slider", {obj=_G.QuestLogDetailScrollFrame.ScrollBar, fType=ftype})
			_G.QuestLogQuestTitle:SetTextColor(self.HT:GetRGB())
			_G.QuestLogObjectivesText:SetTextColor(self.BT:GetRGB())
			_G.QuestLogTimerText:SetTextColor(self.BT:GetRGB())
			for i = 1, _G.MAX_OBJECTIVES do
				_G["QuestLogObjective" .. i]:SetTextColor(self.BT:GetRGB())
			end
			_G.QuestLogRequiredMoneyText:SetTextColor(self.BT:GetRGB())
			if self.isClscBC then
				_G.QuestLogSuggestedGroupNum:SetTextColor(self.BT:GetRGB())
			end
			_G.QuestLogDescriptionTitle:SetTextColor(self.HT:GetRGB())
			_G.QuestLogQuestDescription:SetTextColor(self.BT:GetRGB())
			_G.QuestLogRewardTitleText:SetTextColor(self.HT:GetRGB())
			_G.QuestLogItemChooseText:SetTextColor(self.BT:GetRGB())
			_G.QuestLogItemReceiveText:SetTextColor(self.BT:GetRGB())
			_G.QuestLogSpellLearnText:SetTextColor(self.BT:GetRGB())
			for i = 1, _G.MAX_NUM_ITEMS do
				_G["QuestLogItem" .. i .. "NameFrame"]:SetTexture(nil)
				if self.modBtns then
					 self:addButtonBorder{obj=_G["QuestLogItem" .. i], libt=true, clr="grey"}
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
				self:skinStdButton{obj=_G.QuestLogFrameAbandonButton, fType=ftype, x1=2, x2=-2}
				self:skinStdButton{obj=_G.QuestFrameExitButton, fType=ftype}
				self:skinStdButton{obj=_G.QuestFramePushQuestButton, fType=ftype, x1=2, x2=-2}
				self:SecureHook(_G.QuestFramePushQuestButton, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(_G.QuestFramePushQuestButton, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
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

	end

	aObj.blizzFrames[ftype].QuestTimer = function(self)
		if not self.prdb.QuestTimer or self.initialized.QuestTimer then return end
		self.initialized.QuestTimer = true

		self:SecureHookScript(_G.QuestTimerFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=20, y1=4, x2=-20, y2=10})

			self:Unhook(this, "OnShow")
		end)

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
			self:skinObject("slider", {obj=_G.RaidInfoScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=_G.RaidInfoFrame, fType=ftype, kfs=true, hdr=true})
			if self.modBtns then
				self:skinCloseButton{obj=_G.RaidInfoCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.RaidFrameConvertToRaidButton, fType=ftype}
				self:skinStdButton{obj=_G.RaidFrameRaidInfoButton, fType=ftype}
				self:SecureHook("RaidFrame_Update", function()
					self:clrBtnBdr(_G.RaidFrameConvertToRaidButton)
				end)
				self:SecureHook(_G.RaidFrameRaidInfoButton, "Disable", function(btn, _)
					self:clrBtnBdr(btn)
				end)
				self:SecureHook(_G.RaidFrameRaidInfoButton, "Enable", function(btn, _)
					self:clrBtnBdr(btn)
				end)
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.RaidFrameAllAssistCheckButton, fType=ftype}
			end

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
				for i = 1, 10 do
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
			if not _G.IsAddOnLoaded("Mapster")
			and not _G.IsAddOnLoaded("AlleyMap")
			then
				self:keepFontStrings(_G.WorldMapFrame)
				self:skinObject("frame", {obj=_G.WorldMapFrame.BorderFrame, fType=ftype, kfs=true, ofs=1})
				-- make sure map textures are displayed
				_G.WorldMapFrame.BorderFrame.sf:SetFrameStrata("LOW")
			end

			self:skinObject("dropdown", {obj=_G.WorldMapContinentDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.WorldMapZoneDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.WorldMapZoneMinimapDropDown, fType=ftype})
			if self.modBtns then
				self:skinCloseButton{obj=_G.WorldMapFrameCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.WorldMapZoomOutButton, fType=ftype}
			end

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

	-- TODO:
		-- UnitPopup

	-- VideoOptionsFrame, wait for variable to be populated
	if aObj.modBtns then
		_G.C_Timer.After(1, function()
			aObj:skinStdButton{obj=_G.VideoOptionsFrameClassic, fType=ftype}
		end)
	end

end

aObj.SetupClassic_UIFramesOptions = function(self)

	local optTab = {
		["Battlefield Frame"]       = true,
		["GM Survey UI"]            = not self.isClscBC and true or nil,
		["LFGLFM"]                  = (self.isClscBC or _G.C_LFGList.IsLookingForGroupEnabled and _G.C_LFGList.IsLookingForGroupEnabled()) and {desc = "Looking for Group/More Frame"} or nil,
		["Product Choice"]          = {suff = "Frame"},
		["Quest Log"]               = true,
		["Quest Timer"]             = true,
		["World State Score Frame"] = {desc = "Battle Score Frame"},
	}
	self:setupFramesOptions(optTab, "UI")
	_G.wipe(optTab)

end

