local _, aObj = ...
if not aObj:isAddonEnabled("Questie") then return end
local _G = _G

aObj.addonsToSkin.Questie = function(self) -- v 9.4.5

	local qMods = _G.QuestieLoader._modules

	if self.modBtns then
		self:SecureHook(qMods.WorldMapButton, "Initialize", function(this)
			_G.Questie.WorldMap.Button.Border:SetTexture(nil)
			self:skinStdButton{obj=_G.Questie.WorldMap.Button}

			self:Unhook(this, "Initialize")
		end)
		self:SecureHook(qMods.QuestieOptions, "OpenConfigWindow", function(this)
			self:skinStdButton{obj=self:getLastChild(_G.QuestieConfigFrame.frame)}
			if not _G.QuestieConfigFrame.frame.sf then
				self:skinAceOptions(_G.QuestieConfigFrame)
			end

			self:Unhook(this, "OpenConfigWindow")
		end)
		self:SecureHook(qMods.TrackerLinePool, "Initialize", function(this)
			-- TODO skin TrackedQuests expandQuest buttons
			for i = 1, _G.C_QuestLog.GetMaxNumQuestsCanAccept() do
				self:addButtonBorder{obj=_G["Questie_ItemButton" .. i], sabt=true, clr="grey"}
			end

			self:Unhook(this, "Initialize")
		end)
	end

	if _G.Questie.IsWotlk
	and _G.GetCVar("questPOI") ~= nil
	and not _G.Questie.db.global.tutorialObjectiveTypeChosen
	then
		self:SecureHook(qMods.Tutorial, "CreateChooseObjectiveTypeFrame", function(this)
			self:skinObject("frame", {obj=_G.QuestieTutorialChooseObjectiveType})
			if self.modBtns then
				for _, child in _G.ipairs_reverse{_G.QuestieTutorialChooseObjectiveType:GetChildren()} do
					if child:IsObjectType("Button") then
						self:skinStdButton{obj=child}
					end
				end
			end

			self:Unhook(this, "CreateChooseObjectiveTypeFrame")
		end)
	end

    if _G.Questie.IsSoD
	and not _G.Questie.db.profile.tutorialShowRunesDone
	then
		self:SecureHook(qMods.Tutorial, "ShowRunes", function(this)
			self:skinObject("frame", {obj=_G.QuestieTutorialShowRunes})
			if self.modBtns then
				for _, child in _G.ipairs_reverse{_G.QuestieTutorialShowRunes:GetChildren()} do
					if child:IsObjectType("Button") then
						self:skinStdButton{obj=child}
					end
				end
			end

			self:Unhook(this, "ShowRunes")
		end)
    end

	if qMods.QuestieDebugOffer then
		self:SecureHook(qMods.QuestieDebugOffer, "ShowOffer", function(this, _)
			self:skinObject("editbox", {obj=_G.QuestieDebugOfferFrame.discordLinkEditBox})
			self:skinObject("frame", {obj=_G.QuestieDebugOfferFrame, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=_G.QuestieDebugOfferFrame.dismissButton}
			end

			self:Unhook(this, "ShowOffer")
		end)
	end

end
