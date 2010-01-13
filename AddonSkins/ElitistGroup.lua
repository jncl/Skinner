
function Skinner:ElitistGroup()

-->>-- User Info frame
	local egUsr = LibStub("AceAddon-3.0"):GetAddon("ElitistGroup", true):GetModule("Users", true)
	if not egUsr then return end
	self:SecureHook(egUsr, "CreateUI", function(this)
		local frame = this.frame
		self:moveObject{obj=frame.title, y=-6}
		self:skinAllButtons{obj=frame}
		self:addSkinFrame{obj=frame, kfs=true}--, x1=10, y1=-12, x2=-32, y2=71}
		-- Database frame (pullout on RHS)
		self:skinEditBox{obj=frame.databaseFrame.search, regs={9}}
		self:skinScrollBar{obj=frame.databaseFrame.scroll}
		self:addSkinFrame{obj=frame.databaseFrame, kfs=true}
		-- Equipment frame
		self:addSkinFrame{obj=frame.gearFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- User data container
		self:addSkinFrame{obj=frame.userFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- Dungeon suggested container
		self:skinScrollBar{obj=frame.dungeonFrame.scroll}
		self:addSkinFrame{obj=frame.dungeonFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- Parent container
		self:addSkinFrame{obj=frame.userTabFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- Achievement container
		self:skinScrollBar{obj=frame.achievementFrame.scroll}
		self:addSkinFrame{obj=frame.achievementFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		-- skin minus/plus buttons
		for i = 1, #frame.achievementFrame.rows do
			self:skinButton{obj=frame.achievementFrame.rows[i].toggle, mp2=true}
		end
		-- Notes container
		self:skinScrollBar{obj=frame.noteFrame.scroll}
		self:addSkinFrame{obj=frame.noteFrame, kfs=true, x1=-2, y1=2, x2=2, y2=-2}
		self:Unhook(egUsr, "CreateUI")
		-- extratooltip
		if self.db.profile.Tooltips.skin then
			for i = 1, 18 do -- have to hook all of them as any will create the tooltip
				self:SecureHookScript(frame.gearFrame.equipSlots[i], "OnEnter", function(this)
					if ElitistGroupUserTooltip then
						if self.db.profile.Tooltips.style == 3 then
							ElitistGroupUserTooltip:SetBackdrop(self.Backdrop[1])
						end
						self:SecureHookScript(ElitistGroupUserTooltip, "OnShow", function(this)
							self:skinTooltip(this)
						end)
						-- unhook them all
						for i = 1, 18 do
							self:Unhook(frame.gearFrame.equipSlots[i], "OnEnter")
						end
					end
				end)
			end
		end
	end)

-->>-- PartySummary frame
	local egPS = LibStub("AceAddon-3.0"):GetAddon("ElitistGroup", true):GetModule("PartySummary", true)
	if not egPS then return end
	self:SecureHook(egPS, "CreateUI", function(this)
		local frame = this.frame
		self:moveObject{obj=frame.title, y=-6}
		self:skinAllButtons{obj=frame}
		self:addSkinFrame{obj=frame, kfs=true}
		self:Unhook(egPS, "CreateUI")
	end)
-->>-- RaidSummary frame
	local egRS = LibStub("AceAddon-3.0"):GetAddon("ElitistGroup", true):GetModule("RaidSummary", true)
	if not egRS then return end
	self:SecureHook(egRS, "CreateUI", function(this)
		local frame = this.frame
		self:moveObject{obj=frame.title, y=-6}
		self:skinAllButtons{obj=frame}
		self:skinScrollBar{obj=frame.scroll}
		self:addSkinFrame{obj=frame, kfs=true}
		self:Unhook(egRS, "CreateUI")
	end)

end
