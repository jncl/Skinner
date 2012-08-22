if not Skinner:isAddonEnabled("POMAssist") then return end

function Skinner:POMAssist()

	self:glazeStatusBar(POMStatusBar, 0,  nil)
	self:addSkinFrame{obj=POMAssistFrame}

end
