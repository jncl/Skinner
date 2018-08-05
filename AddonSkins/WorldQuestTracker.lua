local aName, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTracker") then return end
local _G = _G

aObj.addonsToSkin.WorldQuestTracker = function(self) -- v8.0.1.295

	local db = _G.WorldQuestTrackerAddon.db.profile

	self:SecureHook("ToggleWorldMap", function()
		if _G.WorldQuestTrackerCloseSummaryButton
		and not _G.WorldQuestTrackerCloseSummaryButton.sb
		then
			_G.WorldQuestTrackerCloseSummaryButton.Background:SetTexture(nil)
			self:skinOtherButton{obj=_G._G.WorldQuestTrackerCloseSummaryButton, font=self.fontS, text="Close"}
		end
		if _G.WorldQuestTrackerSummaryUpPanel
		and not _G.WorldQuestTrackerSummaryUpPanelChrQuestsScrollScrollBar.sknd
		then
			self:skinSlider{obj=_G.WorldQuestTrackerSummaryUpPanelChrQuestsScrollScrollBar, adj=-4, size=3}
		end
		if _G.WorldQuestTrackerToggleQuestsButton
		and not _G.WorldQuestTrackerToggleQuestsButton.sb
		then
			_G.WorldQuestTrackerToggleQuestsButton.Background:SetTexture(nil)
			self:skinStdButton{obj=_G._G.WorldQuestTrackerToggleQuestsButton, x1=4, x2=-4}
			s5 = true
		end
		if _G.WorldQuestTrackerZoneSummaryFrame
		then
			_G.WorldQuestTrackerZoneSummaryFrame.Header.Background:SetTexture(nil)
			_G.WorldQuestTrackerSummaryHeader.BlackBackground:SetTexture(nil)
		end
		if self.modBtnBs then
			if _G.WorldQuestTrackerGoToHordeButton
			and not _G.WorldQuestTrackerGoToHordeButton.sbb
			then
				self:addButtonBorder{obj=_G.WorldQuestTrackerGoToHordeButton}
				self:addButtonBorder{obj=_G.WorldQuestTrackerGoToAllianceButton}
			end
		end
	end)

	_G.WorldQuestTrackerQuestsHeader.Background:SetTexture(nil)
	self:addButtonBorder{obj=_G.WorldQuestTrackerQuestsHeaderMinimizeButton, es=12, ofs=0}

	-- find and skin the FindGroup frame
	self.RegisterCallback("WorldQuestTracker", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and _G.Round(child:GetWidth()) == 240
		and _G.Round(child:GetHeight()) == 100
		and child.TickFrame
		then
			child.TitleBar:SetBackdrop(nil)
			child.ClickArea:SetBackdrop(nil)
			self:skinStatusBar{obj=child.ProgressBar.statusbar, fi=0, bgTex=child.ProgressBar.background}
			child.ProgressBar.timer_texture.SetTexture = _G.nop
			child.ProgressBar.background.SetTexture = _G.nop
			self:skinStdButton{obj=self:getChild(child, 6)} -- skin secondaryInteractionButton
			self:addSkinFrame{obj=child, ft="a", ofs=2}

			-- hook this to skin GroupFinder buttons
			self:SecureHook(child, "UpdateButtonAnchorOnBBlock", function(block, button)
				if not button.sbb then
					self:addButtonBorder{obj=button, ofs=-2}
				end
			end)

			-- hook this to skin tutorial alert close button
			if _G.WorldQuestTrackerAddon.db.profile.groupfinder.tutorial == 0 then
				self:SecureHookScript(child, "OnShow", function(this)
					self:skinCloseButton{obj=_G.WorldQuestTrackerGroupFinderTutorialAlert1.CloseButton,}
					self:Unhook(this, "OnShow")
				end)
			end
		end
	end)

	if db.TutorialPopupID == 4 then
		-- no more steps
	else
		self:SecureHook(_G.WorldQuestTrackerAddon, "ShowTutorialAlert", function()
			-- aObj:Debug("WQTA ShowTutorialAlert: [%s]", db.TutorialPopupID)

			-- N.B. this counter has already been incremented when we see it
			if db.TutorialPopupID == 2 then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert1.CloseButton}
			elseif db.TutorialPopupID == 3 then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert2.CloseButton}
			elseif db.TutorialPopupID == 4 then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert3.CloseButton}
				self:Unhook(this, "ShowTutorialAlert")
			end
			db = nil
		end)
	end

	self:SecureHook(_G.WorldQuestTrackerAddon, "TAXIMAP_OPENED", function(this)
		if _G.WorldQuestTrackerTaxyTutorial then
			self:skinCloseButton{obj=_G.WorldQuestTrackerTaxyTutorial.CloseButton}
			self:Unhook(this, "TAXIMAP_OPENED")
		end
	end)

	if _G.WorldQuestTrackerAddon.db.profile.use_quest_summary then
		self:SecureHook(_G.WorldQuestTrackerAddon, "UpdateZoneSummaryFrame", function()
			if not _G.WorldQuestTrackerAddon.CanShowZoneSummaryFrame() then
				return
			end
			for i = 1, #_G.WorldQuestTrackerAddon.ZoneSumaryWidgets do
				self:getRegion(_G.WorldQuestTrackerAddon.ZoneSumaryWidgets[i], 1):SetTexture(nil) -- art texture
				_G.WorldQuestTrackerAddon.ZoneSumaryWidgets[i].BlackBackground:SetTexture(nil)
				_G.WorldQuestTrackerAddon.ZoneSumaryWidgets[i].LineUp:SetTexture(nil)
				_G.WorldQuestTrackerAddon.ZoneSumaryWidgets[i].LineDown:SetTexture(nil)
			end
		end)
	end

	-- skin WorldQuestTrackerFrame, if required
	if self.prdb.ObjectiveTracker.skin then
		self:addSkinFrame{obj=_G.WorldQuestTrackerScreenPanel_QuestHolder, ft="a", kfs=true, nb=true, x1=-25, y1=4, x2=3}
		self:SecureHook(_G.WorldQuestTrackerAddon, "UpdateTrackerScale", function()
			_G.WorldQuestTrackerScreenPanel_QuestHolder.sf:SetScale(_G.WorldQuestTrackerAddon.db.profile.tracker_scale)
		end)
		self:SecureHook(_G.WorldQuestTrackerAddon, "RefreshTrackerWidgets", function()
			_G.WorldQuestTrackerScreenPanel_QuestHolder.sf:SetShown(_G.WorldQuestTrackerQuestsHeader:IsShown())
			if _G.WorldQuestTracker.db.profile.TutorialTracker == 2
			and not _G.WorldQuestTrackerTrackerTutorialAlert1.CloseButton.sb
			then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTrackerTutorialAlert1.CloseButton}
			end
		end)
	end

	-- WorldQuestTrackerFinderFrame
	self:SecureHookScript(_G.WorldQuestTrackerFinderFrame, "OnShow", function(this)
		if _G.WorldQuestTracker.db.profile.groupfinder.tutorial == 1 then
			self:skinCloseButton{obj=_G.WorldQuestTrackerGroupFinderTutorialAlert1.CloseButton}
			self:Unhook(this, "OnShow")
		end
	end)
	-- WorldQuestTrackerRareFrame

end
