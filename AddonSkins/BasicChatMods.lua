if not Skinner:isAddonEnabled("BasicChatMods") then return end

function Skinner:BasicChatMods()

	self:SecureHookScript(BCMCopyChat, "OnClick", function(this)
		self:skinScrollBar{obj=BCMCopyScroll}
		self:addSkinFrame{obj=BCMCopyFrame}
		self:Unhook(BCMCopyChat, "OnClick")
	end)
	
end
