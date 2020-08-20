local aName, aObj = ...

if not aObj.isBeta then return end

local _G = _G

-- NPC Frames additions
local ftype = "n"

-- Player Frames additions
local ftype = "p"

-- UI Frames additions
local ftype = "u"
-- WeeklyRewardsFrame (Hall of Holding - Oribos)
aObj.blizzLoDFrames[ftype].WeeklyRewards = function(self)
	if not self.prdb.WeeklyRewards or self.initialized.WeeklyRewards then return end
	self.initialized.WeeklyRewards = true

	self:SecureHookScript(_G.WeeklyRewardsFrame, "OnShow", function(this)

		self:removeNineSlice(this.NineSlice)
		this.HeaderFrame:DisableDrawLayer("BACKGROUND")
		this.HeaderFrame:DisableDrawLayer("BORDER")
		for _, frame in _G.pairs{"RaidFrame", "MythicFrame", "PVPFrame"} do
			self:addFrameBorder{obj=this[frame], ft=ftype, ofs=3, aso={bbclr="sepia"}}
			this[frame].Background:SetAlpha(1)
		end
		for i, frame in _G.ipairs(this.Activities) do
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
