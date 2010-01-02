
function Skinner:SexyGroup()

-->>-- User Info frame
	local sgUsr = LibStub("AceAddon-3.0"):GetAddon("SexyGroup", true):GetModule("Users", true)
	if not sgUsr then return end
	self:SecureHook(sgUsr, "CreateUI", function(this)
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
		self:Unhook(sgUsr, "CreateUI")
	end)

-->>-- Summary frame
	local sgSmry = LibStub("AceAddon-3.0"):GetAddon("SexyGroup", true):GetModule("Summary", true)
	if not sgSmry then return end
	self:SecureHook(sgSmry, "CreateUI", function(this)
		local frame = this.frame
		self:moveObject{obj=frame.title, y=-6}
		self:skinAllButtons{obj=frame}
		self:addSkinFrame{obj=frame, kfs=true}--, x1=10, y1=-12, x2=-32, y2=71}
		self:Unhook(sgSmry, "CreateUI")
	end)

end
