local ceil = math.ceil
local floor = math.floor
local select = select

function Skinner:tomQuest2()

-->>-- Parent Frame
	local info = LibStub("AceAddon-3.0"):GetAddon("tomQuest2", true):GetModule("informations", true)
	if info then
		self:SecureHook(info, "createLhGUI", function(this)
			self:skinScrollBar{obj=tomQuest2LhScrollFrame}
			self:addSkinFrame{obj=tomQuest2LhFrame}
			if self.db.profile.Tooltips.skin then
				self:skinTooltip(tomQuest2LhTooltip)
				if self.db.profile.Tooltips.style == 3 then tomQuest2LhTooltip:SetBackdrop(self.Backdrop[1]) end
			end
			self:Unhook(info, "createLhGUI")
		end)
		self:SecureHook(info, "createQlGUI", function(this)
			self:skinScrollBar{obj=tomQuest2QlScrollFrame}
			self:addSkinFrame{obj=tomQuest2QlFrame}
			if self.db.profile.Tooltips.skin then
				self:skinTooltip(tomQuest2QlTooltip)
				if self.db.profile.Tooltips.style == 3 then tomQuest2QlTooltip:SetBackdrop(self.Backdrop[1]) end
			end
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
-->>-- Colour the Quest Tracker
	local qTrkr = LibStub("AceAddon-3.0"):GetAddon("tomQuest2", true):GetModule("questsTracker", true)
	if qTrkr then
		qTrkr.db.profile.backDropColor = CopyTable(self.bColour)
		qTrkr.db.profile.borderColor = CopyTable(self.bbColour)
	end
-->>-- Colour the Achievement Tracker
	local aTrkr = LibStub("AceAddon-3.0"):GetAddon("tomQuest2", true):GetModule("achievementTracker", true)
	if aTrkr then
		aTrkr.db.profile.backDropColor = CopyTable(self.bColour)
		aTrkr.db.profile.borderColor = CopyTable(self.bbColour)
	end

	-- find the tracker anchors and skin them
	if qTrkr or aTrkr then
		for i = 1, UIParent:GetNumChildren() do
			local obj = select(i, UIParent:GetChildren())
			if obj:GetName() == nil then
				if obj:IsObjectType("Button") then
					if floor(obj:GetHeight()) == 24 and obj:GetFrameStrata() == "MEDIUM" then
						local r, g, b, a = obj:GetBackdropColor()
						if  ("%.2f"):format(r) == "0.09"
						and ("%.2f"):format(g) == "0.09"
						and ("%.2f"):format(b) == "0.19"
						and ("%.1f"):format(a) == "0.5" then
							self:addSkinFrame{obj=obj, x1=-2, x2=2} -- tracker anchor frame
						end
					end
				end
			end
		end
	end

end
