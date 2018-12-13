local aName, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTracker") then return end
local _G = _G

aObj.addonsToSkin.WorldQuestTracker = function(self) -- v8.0.1.332-RC4

	if self.modBtnBs then
		self:SecureHook("ToggleQuestLog", function()
			_G.C_Timer.After(1, function()
				if _G.WorldQuestTrackerGoToHordeButton then
					self:addButtonBorder{obj=_G.WorldQuestTrackerGoToHordeButton}
					self:addButtonBorder{obj=_G.WorldQuestTrackerGoToAllianceButton}
				end
			end)
			self:Unhook(this, "ToggleQuestLog")
		end)
	end

	self:SecureHook("ToggleWorldMap", function()
		if _G.WorldQuestTrackerSummaryUpPanel
		and _G.WorldQuestTrackerSummaryUpPanel.CharsQuestsScroll
		and not _G.WorldQuestTrackerSummaryUpPanel.CharsQuestsScroll.ScrollBar.sknd
		then
			self:skinSlider{obj=_G.WorldQuestTrackerSummaryUpPanel.CharsQuestsScroll.ScrollBar, adj=-4, size=3}
		end
		if _G.WorldQuestTrackerZoneSummaryFrame
		then
			_G.WorldQuestTrackerZoneSummaryFrame.Header.Background:SetTexture(nil)
			_G.WorldQuestTrackerSummaryHeader.BlackBackground:SetTexture(nil)
		end
		if self.modBtns then
			if _G.WorldQuestTrackerCloseSummaryButton then
				_G.WorldQuestTrackerCloseSummaryButton.Background:SetTexture(nil)
				self:skinOtherButton{obj=_G._G.WorldQuestTrackerCloseSummaryButton, font=self.fontS, text="Close"}
			end
			if _G.WorldQuestTrackerToggleQuestsSummaryButton then
				_G.WorldQuestTrackerToggleQuestsSummaryButton.Background:SetTexture(nil)
				self:skinStdButton{obj=_G._G.WorldQuestTrackerToggleQuestsSummaryButton, x1=4, x2=-4}
			end
			if _G.WorldQuestTrackerToggleQuestsButton then
				_G.WorldQuestTrackerToggleQuestsButton.Background:SetTexture(nil)
				self:skinStdButton{obj=_G._G.WorldQuestTrackerToggleQuestsButton, x1=4, x2=-4}
			end
			if _G.WorldQuestTrackerGoToHordeButton then
				self:addButtonBorder{obj=_G.WorldQuestTrackerGoToHordeButton}
				self:addButtonBorder{obj=_G.WorldQuestTrackerGoToAllianceButton}
			end
		end
	end)

	_G.WorldQuestTrackerQuestsHeader.Background:SetTexture(nil)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.WorldQuestTrackerQuestsHeaderMinimizeButton, es=12, ofs=0}
	end

	-- WorldQuestTrackerFinderFrame
	self:SecureHookScript(_G.WorldQuestTrackerFinderFrame, "OnShow", function(this)
		this.TitleBar:SetBackdrop(nil)
		this.OpenGroupFinderButton:SetBackdrop(nil)
		this.InvitePlayersButton:SetBackdrop(nil)
		this.LeaveButton:SetBackdrop(nil)
		this.IgnoreQuestButton:SetBackdrop(nil)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, ofs=4, y1=1}

		if self.modBtns then
			-- hook this to skin GroupFinder buttons
			self:SecureHook(this, "UpdateButtonAnchorOnBBlock", function(block, button)
				if not button.sbb then
					self:addButtonBorder{obj=button, ofs=-2}
				end
			end)
		end
		self:Unhook(this, "OnShow")
	end)
	-- WorldQuestTrackerRareFrame (only holds data, not a displayed frame)

	if self.modBtns then
		self:SecureHookScript(_G.WorldQuestTrackerFinderFrame.OpenGroupFinderButton, "OnMouseUp", function(this, bType)
			if _G.WorldQuestTrackerGroupFinderPopup then
				self:skinCloseButton{obj=_G.WorldQuestTrackerGroupFinderPopup.CloseButton, noSkin=true}
				self:Unhook(this, "OpenGroupFinderForQuest")
			end
		end)
		if _G.WorldQuestTrackerAddon.db.profile.TutorialPopupID == 4 then
			-- no more steps
		else
			self:SecureHook(_G.WorldQuestTrackerAddon, "ShowTutorialAlert", function()
				if _G.WorldQuestTrackerAddon.db.profile.TutorialPopupID == 1 then
					_G.C_Timer.After(4.25, function()
						if _G.WorldQuestTrackerTutorialAlert1 then
							self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert1.CloseButton, noSkin=true}
						end
					end)
				end
				if _G.WorldQuestTrackerAddon.db.profile.TutorialPopupID == 2 then
					_G.C_Timer.After(.75, function()
						if _G.WorldQuestTrackerTutorialAlert2 then
							self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert2.CloseButton, noSkin=true}
						end
					end)
				end
				if _G.WorldQuestTrackerAddon.db.profile.TutorialPopupID == 3 then
					_G.C_Timer.After(.75, function()
						if _G.WorldQuestTrackerTutorialAlert3 then
							self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert3.CloseButton, noSkin=true}
						end
					end)
				end
				if _G.WorldQuestTrackerAddon.db.profile.TutorialPopupID == 4 then
					_G.C_Timer.After(.75, function()
						if _G.WorldQuestTrackerTutorialAlert4 then
							self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert4.CloseButton, noSkin=true}
						end
					end)
				end
				if _G.WorldQuestTrackerAddon.db.profile.TutorialPopupID >= 4 then
					self:Unhook(this, "ShowTutorialAlert")
				end
			end)
		end
		self:SecureHook(_G.WorldQuestTrackerAddon, "TAXIMAP_OPENED", function(this)
			if _G.WorldQuestTrackerTaxyTutorial then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTaxyTutorial.CloseButton, noSkin=true}
				self:Unhook(this, "TAXIMAP_OPENED")
			end
		end)
	end

	if _G.WorldQuestTrackerAddon.db.profile.use_quest_summary then
		self:SecureHook(_G.WorldQuestTrackerAddon, "UpdateZoneSummaryFrame", function()
			if not _G.WorldQuestTrackerAddon.CanShowZoneSummaryFrame() then
				return
			end
			for i = 1, #_G.WorldQuestTrackerAddon.ZoneSumaryWidgets do
				self:getRegion(_G.WorldQuestTrackerAddon.ZoneSumaryWidgets[i], 1):SetTexture(nil) -- art texture
				_G.WorldQuestTrackerAddon.ZoneSumaryWidgets[i].BlackBackground:SetTexture(nil)
			end
		end)
	end

	-- skin WorldQuestTrackerFrame, if required
	if self.prdb.ObjectiveTracker.skin then
		self:addSkinFrame{obj=_G.WorldQuestTrackerScreenPanel_QuestHolder, ft="a", kfs=true, nb=true, x1=-25, y1=4, x2=3}
		self:SecureHook(_G.WorldQuestTrackerAddon, "UpdateTrackerScale", function()
			_G.WorldQuestTrackerScreenPanel_QuestHolder.sf:SetScale(_G.WorldQuestTrackerAddon.db.profile.tracker_scale)
		end)
	end

	self:SecureHook(_G.WorldQuestTrackerAddon, "RefreshTrackerWidgets", function()
		if _G.WorldQuestTrackerScreenPanel_QuestHolder.sf then
			_G.WorldQuestTrackerScreenPanel_QuestHolder.sf:SetShown(_G.WorldQuestTrackerQuestsHeader:IsShown())
		end
		if self.modBtns then
			if _G.WorldQuestTrackerAddon.db.profile.TutorialTracker == 2
			and _G.WorldQuestTrackerTrackerTutorialAlert1
			then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTrackerTutorialAlert1.CloseButton, noSkin=true}
			end
		end
	end)

end
