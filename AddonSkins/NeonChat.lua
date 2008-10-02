
function Skinner:NeonChat()
	if not self.db.profile.ChatEditBox.skin then return end

	local ncEB = self:getChild(ChatFrameEditBox, 2)

	self:applySkin(ncEB)
	self:Hook(ncEB, "SetBackdropColor", function() end, true)

end
