
function Skinner:BugSack()

	-- handle new version
	local bs = LibStub("AceAddon-3.0"):GetAddon("BugSack", true)
	if bs and bs.UpdateSack then
		self:SecureHook(bs, "UpdateSack", function()
			self:skinScrollBar{obj=BugSackFrameScroll2}
			self:skinAllButtons(BugSackFrame2)
			self:addSkinFrame{obj=BugSackFrame2}
			self:Unhook(bs, "UpdateSack")
		end)
	else
		self:skinScrollBar{obj=BugSackFrameScroll}
		self:skinAllButtons(BugSackFrame)
		self:addSkinFrame{obj=BugSackFrame, kfs=true, y2=8}
	end

end
