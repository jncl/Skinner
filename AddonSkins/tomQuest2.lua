local _G = _G
local floor = math.floor
local ipairs = ipairs

function Skinner:tomQuest2()

	-- handle tomQuest2 Tracker & Achievements tooltips (frames)
	if not self.db.profile.TrackerFrame.skin then
		self.ignoreLQTT["tomQuest2Tracker"] = true
		self.ignoreLQTT["tomQuest2Achievements"] = true
	end

-->>-- Parent Frame
	local info = LibStub("AceAddon-3.0"):GetAddon("tomQuest2", true):GetModule("informations", true)
	if info then
		self:SecureHook(info, "createLhGUI", function(this)
			self:skinScrollBar{obj=tomQuest2LhScrollFrame}
			self:addSkinFrame{obj=tomQuest2LhFrame}
			self:Unhook(info, "createLhGUI")
		end)
		self:SecureHook(info, "createQlGUI", function(this)
			self:skinScrollBar{obj=tomQuest2QlScrollFrame}
			self:addSkinFrame{obj=tomQuest2QlFrame}
			self:Unhook(info, "createQlGUI")
		end)
		self:SecureHook(info, "lockUnlockQlFrame", function()
			if tomQuest2ParentFrame then
				self:addSkinFrame{obj=tomQuest2ParentFrame}
				-- hook these to show/hide the individual skinFrames
				self:SecureHook(tomQuest2ParentFrame, "Show", function()
					self.skinFrame[tomQuest2LhFrame]:Hide()
					self.skinFrame[tomQuest2QlFrame]:Hide()
				end)
				self:SecureHook(tomQuest2ParentFrame, "Hide", function()
					self.skinFrame[tomQuest2LhFrame]:Show()
					self.skinFrame[tomQuest2QlFrame]:Show()
				end)
				self:Unhook(info, "lockUnlockQlFrame")
			end
		end)

		info.db.profile.backDropColor = CopyTable(self.bColour)
		info.db.profile.borderColor = CopyTable(self.bbColour)
	end

	local qTrkr = LibStub("AceAddon-3.0"):GetAddon("tomQuest2", true):GetModule("questsTracker", true)
	local aTrkr = LibStub("AceAddon-3.0"):GetAddon("tomQuest2", true):GetModule("achievementTracker", true)
	-- find the tracker anchors and skin them
	if qTrkr or aTrkr then
		local kids = {UIParent:GetChildren()}
		for _, child in ipairs(kids) do
			if child:IsObjectType("Button") and child:GetName() == nil then
				if floor(child:GetHeight()) == 24 and child:GetFrameStrata() == "MEDIUM" then
					local r, g, b, a = child:GetBackdropColor()
					if  ("%.2f"):format(r) == "0.09"
					and ("%.2f"):format(g) == "0.09"
					and ("%.2f"):format(b) == "0.19"
					and ("%.1f"):format(a) == "0.5" then
						self:addSkinFrame{obj=child, x1=-2, x2=2} -- tracker anchor frame
					end
				end
			end
		end
		kids = nil
	end

-->>-- Colour the Quest Tracker & Achievement Tracker if required
	if self.db.profile.TrackerFrame.skin then
		if qTrkr then
			qTrkr.db.profile.backDropColor = CopyTable(self.bColour)
			qTrkr.db.profile.borderColor = CopyTable(self.bbColour)
		end
		if aTrkr then
			aTrkr.db.profile.backDropColor = CopyTable(self.bColour)
			aTrkr.db.profile.borderColor = CopyTable(self.bbColour)
			aTrkr.db.profile.statusBarTexture = self.sbTexture
		end
	end

	local qG = LibStub("AceAddon-3.0"):GetAddon("tomQuest2"):GetModule("questsGivers")
	-- hook this and change text colour before level number added
	self:RawHook(qG, "QUEST_GREETING", function(this)
		for i = 1, MAX_NUM_QUESTS do
			local text = self:getRegion(_G["QuestTitleButton"..i], 3)
			text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		self.hooks[qG].QUEST_GREETING(this)
	end, true)

end
