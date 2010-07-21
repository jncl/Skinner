if not Skinner:isAddonEnabled("BasicChatMods") then return end

function Skinner:BasicChatMods()

	self:skinScrollBar{obj=BCMCopyScroll}
	self:addSkinFrame{obj=BCMCopyFrame}
	
end
