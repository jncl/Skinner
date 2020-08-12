local aName, aObj = ...

if not aObj.isBeta then return end

local _G = _G

-- NPC Frames additions
ftype = "n"

-- Player Frames additions
ftype = "p"

-- UI Frames additions
ftype = "u"
-- WeeklyRewardsFrame (Hall of Holding - Oribos)
aObj.blizzLoDFrames[ftype].WeeklyRewards = function(self)
	if not self.prdb.WeeklyRewards or self.initialized.WeeklyRewards then return end
	self.initialized.WeeklyRewards = true

	self:SecureHookScript(_G.WeeklyRewardsFrame, "OnShow", function(this)

		self:removeNineSlice(this.NineSlice)
		this.HeaderFrame:DisableDrawLayer("BACKGROUND")
		this.HeaderFrame:DisableDrawLayer("BORDER")
		for _, frame in pairs{"RaidFrame", "MythicFrame", "PVPFrame"} do
			self:addFrameBorder{obj=this[frame], ft=ftype, ofs=3, aso={bbclr="sepia"}}
			this[frame].Background:SetAlpha(1)
		end
		for i, frame in ipairs(this.Activities) do
			-- _G.Spew("", frame)
			self:addFrameBorder{obj=frame, ft=ftype, ofs=3, x1=3, y1=-3, aso={bbclr="grey"}}
			-- show required textures
			if frame.Background then
				frame.Background:SetAlpha(1)
				frame.Orb:SetAlpha(1)
				frame.LockIcon:SetAlpha(1)
			end
			-- .ItemFrame
			-- .UnselectedFrame
			self:SecureHook(frame, "Refresh", function(this)
				if this.unlocked or this.hasRewards then
				end
			end)
		end
		-- .ConcessionFrame
			-- .RewardsFrame
			-- .UnselectedFrame

		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-5}
		if self.modBtns then
			self:skinStdButton{obj=this.SelectRewardButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].TutorialPointerFrame = function(self)
	if not self.prdb.Tutorial or self.initialized.TutorialPointerFrame then return end
	self.initialized.TutorialPointerFrame = true

	self:RawHook(_G.NPE_TutorialPointerFrame, "Show", function(this, ...)
		local id = self.hooks[this].Show(this, ...)
		local frame = this.InUseFrames[id]
		self:skinGlowBox(frame.Content)
		frame.Glow:SetBackdrop(nil)
		frame = nil
		return id
	end, true)

end
