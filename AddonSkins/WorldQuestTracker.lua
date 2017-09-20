local aName, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTracker") then return end
local _G = _G

aObj.addonsToSkin.WorldQuestTracker = function(self) -- v7.3.0.237-release

	local skincnt = 0
	self:SecureHook("ToggleWorldMap", function()
		if _G.WorldQuestTrackerGoToBIButton then
			_G.WorldQuestTrackerGoToBIButton.Background:SetTexture(nil)
			self:skinButton{obj=_G._G.WorldQuestTrackerGoToBIButton, ob4="World\nQuests", y1=2, y2=-1}
			skincnt = skincnt + 1
		end
		if _G.WorldQuestTrackerCloseSummaryButton then
			_G.WorldQuestTrackerCloseSummaryButton.Background:SetTexture(nil)
			self:skinButton{obj=_G._G.WorldQuestTrackerCloseSummaryButton, ob3="Close"}
			skincnt = skincnt + 1
		end
		if _G.WorldQuestTrackerSummaryUpPanel then
			self:skinSlider{obj=_G.WorldQuestTrackerSummaryUpPanelChrQuestsScrollScrollBar, adj=-4, size=3}
			skincnt = skincnt + 1
		end
		if _G.WorldQuestTrackerShipmentsReadyFrame then
			self:removeRegions(_G.WorldQuestTrackerShipmentsReadyFrame, {1, 2})
			self:addSkinFrame{obj=_G.WorldQuestTrackerShipmentsReadyFrame, ofs=5, x1=10, x2=12}
			skincnt = skincnt + 1
		end
		if _G.WorldQuestTrackerToggleQuestsButton then
			_G.WorldQuestTrackerToggleQuestsButton.Background:SetTexture(nil)
			self:skinButton{obj=_G._G.WorldQuestTrackerToggleQuestsButton, x1=4, x2=-4}
			skincnt = skincnt + 1
		end
		if _G.WorldQuestTrackerTutorial then
			_G.C_Timer.After(0.2, function()
				self:removeRegions(_G.WorldQuestTrackerTutorial, {1, 2, 3, 4, 5})
			end)
			local cb = self:getChild(_G.WorldQuestTrackerTutorial, 1)
			cb.texture:SetTexture(nil)
			self:skinButton{obj=cb}
			cb = nil
			self:addSkinFrame{obj=_G.WorldQuestTrackerTutorial, ofs=3, y2=-38}
			skincnt = skincnt + 1
		end
		if skincnt == 6 then
			self:Unhook("ToggleWorldMap")
		end
	end)

	_G.WorldQuestTrackerQuestsHeader.Background:SetTexture(nil)
	self:addButtonBorder{obj=_G.WorldQuestTrackerQuestsHeaderMinimizeButton, es=12, ofs=0}

	-- find and skin the FindGroup frame
	self.RegisterCallback("WorldQuestTracker", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and self:getInt(child:GetWidth()) == 240
		and self:getInt(child:GetHeight()) == 100
		and child.TickFrame
		then
			child.TitleBar:SetBackdrop(nil)
			child.ClickArea:SetBackdrop(nil)
			self:glazeStatusBar(child.ProgressBar, 0, child.ProgressBar.background)
			child.ProgressBar.timer_texture.SetTexture = _G.nop
			child.ProgressBar.background.SetTexture = _G.nop
			self:skinButton{obj=self:getChild(child, 6)} -- skin secondaryInteractionButton
			self:addSkinFrame{obj=child, ofs=2}

			-- hook this to skin GroupFinder buttons
			self:SecureHook(child, "UpdateButtonAnchorOnBBlock", function(block, button)
				if not button.sbb then
					self:addButtonBorder{obj=button, ofs=-2}
				end
			end)

			-- hook this to skin tutorial alert close button
			if _G.WorldQuestTrackerAddon.db.profile.groupfinder.tutorial == 0 then
				self:SecureHookScript(child, "OnShow", function(this)
					self:skinButton{obj=_G.WorldQuestTrackerGroupFinderTutorialAlert1.CloseButton, cb=true}
					self:Unhook(this, "OnShow")
				end)
			end
		end
	end)

	if _G.WorldQuestTrackerAddon.db.profile.AlertTutorialStep
	and _G.WorldQuestTrackerAddon.db.profile.AlertTutorialStep == 5
	then
	else
		self:SecureHook(_G.WorldQuestTrackerAddon, "ShowTutorialAlert", function()
			local db = _G.WorldQuestTrackerAddon.db.profile
			if not db.GotTutorial then return end

			-- N.B. this counter has already been incremented when we see it
			if db.AlertTutorialStep == 2 then
				self:skinButton{obj=_G.WorldQuestTrackerTutorialAlert1.CloseButton, cb=true}
			elseif db.AlertTutorialStep == 3 then
				self:skinButton{obj=_G.WorldQuestTrackerTutorialAlert2.CloseButton, cb=true}
			elseif db.AlertTutorialStep == 4 then
				self:skinButton{obj=_G.WorldQuestTrackerTutorialAlert3.CloseButton, cb=true}
			elseif db.AlertTutorialStep == 5 then
				self:skinButton{obj=_G.WorldQuestTrackerTutorialAlert4.CloseButton, cb=true}
				self:Unhook(_G.WorldQuestTrackerAddon, "ShowTutorialAlert")
			end
			db = nil
		end)
	end

	if not _G.WorldQuestTrackerAddon.db.profile.TutorialTaxyMap then
		self:SecureHook(_G.WorldQuestTrackerAddon, "TAXIMAP_OPENED", function()
			self:skinButton{obj=_G.WorldQuestTrackerTaxyTutorial.CloseButton, cb=true}
			self:Unhook(this, "TAXIMAP_OPENED")
		end)
	end

end
