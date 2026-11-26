local _, aObj = ...
if not aObj:isAddonEnabled("Questie")
and not aObj:isAddonEnabled("QuestieTrace")
then
	return
end
local _G = _G

if aObj:isAddonEnabled("Questie") then
	aObj.addonsToSkin.Questie = function(self) -- v 12.6.4

		local qMods = _G.QuestieLoader._modules

		-- hook and skin Tutorial frames
		local function hookAndSkinFrame(method, frame)
			aObj:SecureHook(qMods.Tutorial, method, function(_)
				aObj:skinObject("frame", {obj=_G[frame], ofs=-4})
				if aObj.modBtns then
					for _, child in _G.ipairs_reverse{_G[frame]:GetChildren()} do
						if child:IsObjectType("Frame")
						and child.layoutType
						and child.layoutType == "Dialog" --DialogBorderDarkTemplate
						then
							child:SetAlpha(0)
						elseif child:IsObjectType("Button")
						and child:GetNumRegions() > 1
						then
							aObj:skinStdButton{obj=child}
						end
					end
				end
				aObj:Unhook(qMods.Tutorial, method)
			end)
		end
		if ((qMods.Expansions.Current >= qMods.Expansions.Wotlk)
			or _G.Questie.IsForever)
		and not _G.Questie.db.global.tutorialObjectiveTypeChosen
		and _G.GetCVar("questPOI") ~= nil
		then
			hookAndSkinFrame("CreateChooseObjectiveTypeFrame", "QuestieTutorialChooseObjectiveType")
		end
	    if _G.Questie.IsSoD
		and not _G.Questie.db.profile.tutorialShowRunesDone
		then
			hookAndSkinFrame("ShowRunes", "QuestieTutorialShowRunes")
	    end
	    if not _G.Questie.db.profile.tutorialRejectInBattlegroundsDone
	    and not _G.Questie.IsForever
		then
			hookAndSkinFrame("AutoRejectInBattlegroundsFrame", "QuestieTutorialAutoRejectInBattlegrounds")
	    end

		if qMods.QuestieDebugOffer then
			self:SecureHook(qMods.QuestieDebugOffer, "ShowOffer", function(_, _)
				self:skinObject("editbox", {obj=_G.QuestieDebugOfferFrame.discordLinkEditBox})
				self:skinObject("frame", {obj=_G.QuestieDebugOfferFrame, kfs=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=_G.QuestieDebugOfferFrame.dismissButton}
				end

				self:Unhook(qMods.QuestieDebugOffer, "ShowOffer")
			end)
		end

		if qMods.QuestieOptionsEngine then
			self:SecureHook(qMods.QuestieOptionsEngine, "ShowFrame", function(this)
				self:skinObject("frame", {obj=this.popup, kfs=true, cb=true})

				self:Unhook(qMods.QuestieOptionsEngine, "ShowFrame")
			end)
		end

		if qMods.WaypointHover then
			self:SecureHook(qMods.WaypointHover, "Set", function(_)
				aObj:Debug("WaypointHover: [%s, %s]", _G.QuestieWaypointMinimapTooltip)
				if _G.QuestieWaypointMinimapTooltip then
					self:removeNineSlice(_G.QuestieWaypointMinimapTooltip.NineSlice)
				    self:add2Table(self.ttList, "a", _G.QuestieWaypointMinimapTooltip)
					self:Unhook(qMods.WaypointHover, "Set")
				end
			end)
		end

		-- TODO: skin questie options, standalone & Settings

	end
end

if aObj:isAddonEnabled("QuestieTrace") then
	aObj.addonsToSkin.QuestieTrace = function(self) -- v 1.9.1

		self:SecureHookScript(_G.QuestieTraceConsentFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			self:skinObject("frame", {obj=this, kfs=true})
			this.AlertIcon:SetAlpha(1)
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton}
				self:skinStdButton{obj=this.DeclineButton}
			end

			self:Unhook(_G.QuestieTraceConsentFrame, "OnShow")
		end)
		self:checkShown(_G.QuestieTraceConsentFrame)

		if _G.QuestieTraceCore then
			self:SecureHook(_G.QuestieTraceCore, "ShowExportWindow", function(_)
				local frame = _G.QuestieTraceExportFrame
				self:skinObject("editbox", {obj=frame.urlEditBox})
				self:skinObject("editbox", {obj=frame.editBox})
				self:skinObject("frame", {obj=_G.frame, kfs=true})
				if self.modBtns then
					self:skinStdButton{obj=self:getChild(frame, 4)} -- closeButton
					self:skinStdButton{obj=frame.reportedButton}
				end

				self:Unhook(_G.QuestieTraceCore, "ShowExportWindow")
			end)
		end

	end
end
