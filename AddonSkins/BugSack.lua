
function Skinner:BugSack()

	-- handle new version
	local bs = LibStub("AceAddon-3.0"):GetAddon("BugSack", true)
	if bs and bs.UpdateSack then
		self:SecureHook(bs, "UpdateSack", function()
			local bsFrame = BugSackFrameScroll2:GetParent()
			self:skinScrollBar{obj=BugSackFrameScroll2}
			self:skinAllButtons(bsFrame)
			self:addSkinFrame{obj=bsFrame, kfs=true, x1=4, y1=-2, x2=-1, y2=4}
			self:Unhook(bs, "UpdateSack")
		end)
	else
		self:skinScrollBar{obj=BugSackFrameScroll}
		self:skinAllButtons(BugSackFrame)
		self:addSkinFrame{obj=BugSackFrame, kfs=true, y2=8}
	end

end
