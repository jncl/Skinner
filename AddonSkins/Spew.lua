local _, aObj = ...
if not aObj:isAddonEnabled("Spew") then return end

aObj.addonsToSkin.Spew = function(self) -- v 3.0.3.5

	self:SecureHookScript(_G.SpewPanel, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=-9, x2=2})
		this:SetFrameLevel(this:GetFrameLevel() + 10)
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(this, 1)}
			self:skinStdButton{obj=self:getChild(self:getChild(this, 4), 2)} --Clear button on ScrollingMessageFrame
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.SpewPanel)

end