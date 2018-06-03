local aName, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTracker") then return end
local _G = _G

aObj.addonsToSkin.WorldQuestTracker = function(self) -- v7.3.0.237-release

	local s1, s2, s3, s4, s5, s6, s7
	self:SecureHook("ToggleWorldMap", function()
		if _G.WorldQuestTrackerGoToBIButton
		and not s1
		then
			_G.WorldQuestTrackerGoToBIButton.Background:SetTexture(nil)
			self:skinOtherButton{obj=_G._G.WorldQuestTrackerGoToBIButton, font="GameFontNormal",text="World\nQuests", y1=2, y2=-1}
			self:RaiseFrameLevelByFour(_G._G.WorldQuestTrackerGoToBIButton)
			s1 =true
		end
		if _G.WorldQuestTrackerCloseSummaryButton
		and not s2
		then
			_G.WorldQuestTrackerCloseSummaryButton.Background:SetTexture(nil)
			self:skinOtherButton{obj=_G._G.WorldQuestTrackerCloseSummaryButton, font=self.fontS, text="Close"}
			s2 = true
		end
		if _G.WorldQuestTrackerSummaryUpPanel
		and not s3
		then
			self:skinSlider{obj=_G.WorldQuestTrackerSummaryUpPanelChrQuestsScrollScrollBar, adj=-4, size=3}
			s3 = true
		end
		if _G.WorldQuestTrackerShipmentsReadyFrame
		and not s4
		then
			self:removeRegions(_G.WorldQuestTrackerShipmentsReadyFrame, {1, 2})
			self:addSkinFrame{obj=_G.WorldQuestTrackerShipmentsReadyFrame, ft="a", ofs=5, x1=10, x2=12}
			s4 = true
		end
		if _G.WorldQuestTrackerToggleQuestsButton
		and not s5
		then
			_G.WorldQuestTrackerToggleQuestsButton.Background:SetTexture(nil)
			self:skinStdButton{obj=_G._G.WorldQuestTrackerToggleQuestsButton, x1=4, x2=-4}
			s5 = true
		end
		if _G.WorldQuestTrackerTutorial
		and not s6
		then
			_G.C_Timer.After(0.2, function()
				self:removeRegions(_G.WorldQuestTrackerTutorial, {1, 2, 3, 4, 5})
			end)
			local cb = self:getChild(_G.WorldQuestTrackerTutorial, 1)
			cb.texture:SetTexture(nil)
			self:skinStdButton{obj=cb}
			cb = nil
			self:addSkinFrame{obj=_G.WorldQuestTrackerTutorial, ft="a", ofs=3, y2=-38}
			s6 = true
		end
		if _G.WorldQuestTrackerZoneSummaryFrame
		and not s7
		then
			_G.WorldQuestTrackerZoneSummaryFrame.Header.Background:SetTexture(nil)
			_G.WorldQuestTrackerSummaryHeader.BlackBackground:SetTexture(nil)
		end
		if s1 and s2 and s3 and s4 and s5 and s6 and s7 then
			self:Unhook("ToggleWorldMap")
			s1, s2, s3, s4, s5, s6, s7 = nil, nil, nil, nil, nil, nil, nil
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

	if _G.WorldQuestTrackerAddon.db.profile.AlertTutorialStep
	and _G.WorldQuestTrackerAddon.db.profile.AlertTutorialStep == 5
	then
		-- no more steps
	else
		self:SecureHook(_G.WorldQuestTrackerAddon, "ShowTutorialAlert", function(this)
			local db = this.db.profile
			if not db.GotTutorial then return end

			-- N.B. this counter has already been incremented when we see it
			if db.AlertTutorialStep == 2 then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert1.CloseButton}
			elseif db.AlertTutorialStep == 3 then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert2.CloseButton}
			elseif db.AlertTutorialStep == 4 then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert3.CloseButton}
			elseif db.AlertTutorialStep == 5 then
				self:skinCloseButton{obj=_G.WorldQuestTrackerTutorialAlert4.CloseButton}
				self:Unhook(this, "ShowTutorialAlert")
			end
			db = nil
		end)
	end

	if not _G.WorldQuestTrackerAddon.db.profile.TutorialTaxyMap then
		self:SecureHook(_G.WorldQuestTrackerAddon, "TAXIMAP_OPENED", function(this)
			self:skinCloseButton{obj=_G.WorldQuestTrackerTaxyTutorial.CloseButton}
			self:Unhook(this, "TAXIMAP_OPENED")
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
		end)
	end

end
