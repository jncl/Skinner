if not Skinner:isAddonEnabled("NeonChat") then return end

function Skinner:NeonChat()
	if not self.db.profile.ChatEditBox.skin then return end

	local ncEB = self:getChild(ChatFrameEditBox, 2)

	self:applySkin(ncEB)
	ncEB.SetBackdropColor = function() end

end
