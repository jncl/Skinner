
function Skinner:AutoPartyButtons()

	self:addSkinFrame{obj=AutoPartyButtonsMainFrame}
	
	self:RawHook(AutoPartyButtons, "MakeButton", function(this, ...)
		local btn = self.hooks[AutoPartyButtons].MakeButton(this, ...)
		self:addSkinFrame{obj=btn, kfs=true}
		return btn
	end, true)

end
