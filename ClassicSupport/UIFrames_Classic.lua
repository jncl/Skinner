local _, aObj = ...

local _G = _G

aObj.SetupClassic_UIFrames = function()

	local ftype = "u"

	aObj.blizzFrames[ftype].BattlefieldFrame = function(self)
		if not self.prdb.BattlefieldFrame or self.initialized.BattlefieldFrame then return end
		self.initialized.BattlefieldFrame = true

		self:SecureHookScript(_G.BattlefieldFrame, "OnShow", function(this)
			self:skinSlider{obj=_G.BattlefieldListScrollFrame.ScrollBar, rt="artwork"}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-11, x2=-32, y2=71}
			if self.modBtns then
				self:skinCloseButton{obj=_G.BattlefieldFrameCloseButton, fType=ftype}
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
		end

	end

	if not aObj.isClscBC then
		aObj.blizzLoDFrames[ftype].GMSurveyUI = function(self)
			if not self.prdb.GMSurveyUI or self.initialized.GMSurveyUI then return end
			self.initialized.GMSurveyUI = true

			self:SecureHookScript(_G.GMSurveyFrame, "OnShow", function(this)
				self:skinSlider{obj=_G.GMSurveyScrollFrame.ScrollBar, rt="artwork"}
				for i = 1, _G.MAX_SURVEY_QUESTIONS do
					self:applySkin{obj=_G["GMSurveyQuestion" .. i], ft=ftype} -- must use applySkin otherwise text is behind gradient
					_G["GMSurveyQuestion" .. i].SetBackdropColor = _G.nop
					_G["GMSurveyQuestion" .. i].SetBackdropBorderColor = _G.nop
				end
				self:skinSlider{obj=_G.GMSurveyCommentScrollFrame.ScrollBar}
				self:applySkin{obj=_G.GMSurveyCommentFrame, ft=ftype} -- must use applySkin otherwise text is behind gradient
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, hdr=true, y1=-6, x2=-45}

				self:Unhook(this, "OnShow")
			end)

		end

		if not aObj.isClscERAPTR then
			aObj.blizzFrames[ftype].HelpFrame = function(self)
				if not self.prdb.HelpFrame or self.initialized.HelpFrame then return end
				self.initialized.HelpFrame = true

				self:SecureHookScript(_G.HelpFrame, "OnShow", function(this)
					self:removeInset(this.leftInset)
					self:removeInset(this.mainInset)
					self:addSkinFrame{obj=this, ft=ftype, kfs=true, hdr=true, ofs=0}
					-- widen buttons so text fits better
					for i = 1, 6 do
						this["button" .. i]:SetWidth(180)
						if self.modBtns then
							self:skinStdButton{obj=this["button" .. i], fType=ftype, x1=0, y1=2, x2=-3, y2=1}
						end
					end
					this.button16:SetWidth(180) -- Submit Suggestion button
					if self.modBtns then
						self:skinStdButton{obj=this.button16, fType=ftype, x1=0, y1=2, x2=-3, y2=1}
					end

					-- Account Security panel
					this.asec.ticketButton:GetNormalTexture():SetTexture(nil)
					this.asec.ticketButton:GetPushedTexture():SetTexture(nil)
					if self.modBtns then
						self:skinStdButton{obj=this.asec.ticketButton, fType=ftype, x1=0, y1=2, x2=-3, y2=1}
					end

					-- Character Stuck! panel
					if self.modBtnBs then
						self:addButtonBorder{obj=_G.HelpFrameCharacterStuckHearthstone, es=20}
					end
					if self.modBtns then
						self:skinStdButton{obj=_G.HelpFrameCharacterStuckStuck, fType=ftype}
					end

					local skinSubmit
					if self.modBtns then
						function skinSubmit(frame)
							aObj:skinStdButton{obj=frame.submitButton, fType=ftype}
							aObj:SecureHookScript(frame, "OnShow", function(fObj)
								aObj:clrBtnBdr(fObj.submitButton)
							end)
							aObj:SecureHookScript(frame.editbox, "OnTextChanged", function(fObj)
								aObj:clrBtnBdr(fObj.submitButton)
							end)
						end
					end
					-- Report Bug panel
					self:skinSlider{obj=_G.HelpFrameReportBugScrollFrame.ScrollBar}
					self:addFrameBorder{obj=self:getChild(this.bug, 3), ft=ftype}
					if self.modBtns then
						skinSubmit(this.bug)
					end

					-- Submit Suggestion panel
					self:skinSlider{obj=_G.HelpFrameSubmitSuggestionScrollFrame.ScrollBar}
					self:addFrameBorder{obj=self:getChild(this.suggestion, 3), ft=ftype}
					if self.modBtns then
						skinSubmit(this.suggestion)
					end

					-- Help Browser
					self:removeInset(_G.HelpBrowser.BrowserInset)
					if self.modBtns then
						self:skinStdButton{obj=_G.BrowserSettingsTooltip.CookiesButton, fType=ftype}
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=_G.HelpBrowser.settings, ofs=-2, x1=1, clr="gold"}
						self:addButtonBorder{obj=_G.HelpBrowser.home, ofs=-2, x1=1, clr="gold"}
						self:addButtonBorder{obj=_G.HelpBrowser.back, ofs=-2, x1=1, clr="gold"}
						self:addButtonBorder{obj=_G.HelpBrowser.forward, ofs=-2, x1=1, clr="gold"}
						self:addButtonBorder{obj=_G.HelpBrowser.reload, ofs=-2, x1=1, clr="gold"}
						self:addButtonBorder{obj=_G.HelpBrowser.stop, ofs=-2, x1=1, clr="gold"}
						self:SecureHookScript(_G.HelpBrowser, "OnButtonUpdate", function(btn)
							self:clrBtnBdr(btn.back, "gold")
							self:clrBtnBdr(btn.forward, "gold")
						end)
					end

					-- Knowledgebase (uses Browser frame)

					-- GM_Response
					self:skinSlider{obj=_G.HelpFrameGM_ResponseScrollFrame1.ScrollBar}
					self:skinSlider{obj=_G.HelpFrameGM_ResponseScrollFrame2.ScrollBar}
					self:addSkinFrame{obj=self:getChild(_G.HelpFrameGM_Response, 5), ft=ftype}
					self:addSkinFrame{obj=self:getChild(_G.HelpFrameGM_Response, 6), ft=ftype}

					-- BrowserSettings Tooltip
					_G.BrowserSettingsTooltip:DisableDrawLayer("BACKGROUND")
					self:addSkinFrame{obj=_G.BrowserSettingsTooltip, ft=ftype}

					-- HelpOpenTicketButton
					-- HelpOpenWebTicketButton

					-- ReportCheating Dialog
					self:removeNineSlice(_G.ReportCheatingDialog.Border)
					self:addSkinFrame{obj=_G.ReportCheatingDialog.CommentFrame, ft=ftype, kfs=true, y2=-2}
					_G.ReportCheatingDialog.CommentFrame.EditBox.InformationText:SetTextColor(self.BT:GetRGB())
					self:addSkinFrame{obj=_G.ReportCheatingDialog, ft=ftype}

					self:Unhook(this, "OnShow")
				end)

				self:SecureHookScript(_G.TicketStatusFrame, "OnShow", function(this)
					self:skinObject("frame", {obj=_G.TicketStatusFrameButton, fType=ftype})

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(_G.TicketStatusFrame)

			end
		end

	else
		aObj.blizzLoDFrames[ftype].GuildBankUI = function(self)
			if not self.prdb.GuildBankUI or self.initialized.GuildBankUI then return end
			self.initialized.GuildBankUI = true

			self:SecureHookScript(_G.GuildBankFrame, "OnShow", function(this)
				this.Emblem:Hide()
				for _, frame in _G.ipairs(this.Columns) do
					frame:DisableDrawLayer("BACKGROUND")
					if self.modBtnBs then
						for _, btn in _G.ipairs(frame.Buttons) do
							self:addButtonBorder{obj=btn, ibt=true, clr="grey", ca=0.85}
						end
					end
				end
				self:skinObject("tabs", {obj=this, tabs=this.FrameTabs, fType=ftype, lod=self.isTT and true, offsets={x1=9, y1=self.isTT and 2 or -3, x2=-9, y2=2}})
				-- Tabs (side)
				for _, tab in _G.ipairs(this.BankTabs) do
					tab:DisableDrawLayer("BACKGROUND")
					if self.modBtnBs then
						 self:addButtonBorder{obj=tab.Button, reParent={tab.Button.Count, tab.Button.SearchOverlay}, ofs=3}
						 self:SecureHook(tab.Button, "Disable", function(btn, _)
							self:clrBtnBdr(btn)
						 end)
						 self:SecureHook(tab.Button, "Enable", function(btn, _)
							self:clrBtnBdr(btn)
						 end)
					end
				end
				self:skinObject("slider", {obj=_G.GuildBankInfoScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, y1=-11, x2=0, y2=4})
				if self.modBtns then
					self:skinCloseButton{obj=self:getChild(this, 11), fType=ftype}
					self:skinStdButton{obj=this.DepositButton, fType=ftype, x1=0} -- don't overlap withdraw button
					self:skinStdButton{obj=this.WithdrawButton, fType=ftype, x2=0} -- don't overlap deposit button
					self:SecureHook(this.WithdrawButton, "Disable", function(btn, _)
						self:clrBtnBdr(btn)
					end)
					self:SecureHook(this.WithdrawButton, "Enable", function(btn, _)
						self:clrBtnBdr(btn)
					end)
					self:skinStdButton{obj=this.BuyInfo.PurchaseButton, fType=ftype}
					self:SecureHook(this.BuyInfo.PurchaseButton, "Disable", function(btn, _)
						self:clrBtnBdr(btn)
					end)
					self:SecureHook(this.BuyInfo.PurchaseButton, "Enable", function(btn, _)
						self:clrBtnBdr(btn)
					end)
					self:skinStdButton{obj=_G.GuildBankInfoSaveButton, fType=ftype}
				end
				-- send message when UI is skinned (used by oGlow skin)
				self:SendMessage("GuildBankUI_Skinned", self)

				self:Unhook(this, "OnShow")
			end)

			--	GuildBank Popup Frame
			self:SecureHookScript(_G.GuildBankPopupFrame, "OnShow", function(this)
				self:adjHeight{obj=this, adj=20}
				-- FIXME: BorderBox SHOULD be a child of the frame
				self:keepFontStrings(_G.BorderBox)
				self:skinObject("editbox", {obj=this.EditBox, fType=ftype})
				self:adjHeight{obj=this.ScrollFrame, adj=20} -- stretch to bottom of scroll area
				self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				for _, btn in _G.pairs(this.Buttons) do
					btn:DisableDrawLayer("BACKGROUND")
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={_G[btn:GetName() .. "Name"]}}
					end
				end
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-6})
				if self.modBtns then
					self:skinStdButton{obj=this.CancelButton}
					self:skinStdButton{obj=this.OkayButton}
				end

				self:Unhook(this, "OnShow")
			end)

		end

		aObj.blizzFrames[ftype].LFGFrame = function(self)
			if not self.prdb.LFGLFM or self.initialized.LFGFrame then return end
			self.initialized.LFGFrame = true

			self:SecureHookScript(_G.LFGParentFrame, "OnShow", function(this)
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true, offsets={x1=6, y1=0, x2=-6, y2=2}})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=17, y1=-11, x2=-29, y2=70})
				if self.modBtns then
					self:skinCloseButton{obj=self:getChild(this, 3), fType=ftype}
				end

				self:SecureHookScript(_G.LFMFrame, "OnShow", function(_)
					self:skinObject("dropdown", {obj=_G.LFMFrameEntryDropDown, fType=ftype})
					self:removeInset(_G.LFMFrameInset)
					self:skinObject("dropdown", {obj=_G.LFMFrameTypeDropDown, fType=ftype})
					self:skinObject("dropdown", {obj=_G.LFMFrameActivityDropDown, fType=ftype})
					self:skinColHeads("LFMFrameColumnHeader", nil, ftype)
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

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(_G.LFMFrame)

				self:SecureHookScript(_G.LFGFrame, "OnShow", function(frame)
					for _, dd in _G.pairs(frame.TypeDropDown) do
						self:skinObject("dropdown", {obj=dd, fType=ftype})
					end
					for _, dd in _G.pairs(frame.ActivityDropDown) do
						self:skinObject("dropdown", {obj=dd, fType=ftype})
					end
					self:skinObject("editbox", {obj=frame.Comment, fType=ftype, chginset=false, x1=-5})
					self:moveObject{obj=_G.LFGFramePostButton, x=-10}
					if self.modBtns then
						self:skinStdButton{obj=_G.LFGFrameClearAllButton, fType=ftype}
						self:skinStdButton{obj=_G.LFGFramePostButton, fType=ftype}
						self:SecureHook(_G.LFGFramePostButton, "SetEnabled", function(btn, _)
							self:clrBtnBdr(btn)
						end)
					end

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(_G.LFGFrame)

				self:Unhook(this, "OnShow")
			end)

			if self.prdb.MinimapButtons.skin then
				self:skinObject("button", {obj=_G.MiniMapLFGFrameIcon, fType=ftype, ofs=2})
			end

		end

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

		if self.isClscBC
		or aObj.isClscERAPTR
		then
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
			self:skinSlider{obj=_G.QuestLogListScrollFrame.ScrollBar}
			self:skinSlider{obj=_G.QuestLogDetailScrollFrame.ScrollBar}
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
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-11, x2=-33, y2=48}
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
				self:skinCloseButton{obj=_G.QuestLogFrameCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.QuestLogFrameAbandonButton, fType=ftype, x1=2, x2=-2}
				self:skinStdButton{obj=_G.QuestFrameExitButton, fType=ftype}
				self:skinStdButton{obj=_G.QuestFramePushQuestButton, fType=ftype, x1=2, x2=-2}
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

		self:addSkinFrame{obj=_G.QuestTimerFrame, ft=ftype, kfs=true, nb=true, x1=20, y1=4, x2=-20, y2=10}

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
			self:skinSlider{obj=_G.RaidInfoScrollFrame.ScrollBar}
			self:addSkinFrame{obj=_G.RaidInfoFrame, ft=ftype, kfs=true, nb=true, hdr=true}
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
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
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
			if self.isClscBC then
				self:skinObject("dropdown", {obj=_G.WorldMapZoneMinimapDropDown, fType=ftype})
			end
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
