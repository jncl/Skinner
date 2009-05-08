
function Skinner:BetterBindingFrame()
	if not self.db.profile.MenuFrames then return end

	local bbf = self:getChild(KeyBindingFrame, 24) -- this is the HeadersFrame
	
	self:removeRegions(BetterBindingFrame_HeadersScrollFrame)
	self:skinScrollBar(BetterBindingFrame_HeadersScrollFrame)
	self:skinEditBox{obj=BBF_SearchEditBox, regs={9}, move=true}
	self:addSkinFrame{obj=bbf, ftype=ftype, kfs=true, bg=true, y1=-4, x2=-45, y2=4}
	
end
