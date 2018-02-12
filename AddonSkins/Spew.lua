local aName, aObj = ...
if not aObj:isAddonEnabled("Spew") then return end

aObj.addonsToSkin.Spew = function(self) -- v 3.0.3.5

	-- hook OnShow event as textures not seen until shown
	self:SecureHookScript(_G.SpewPanel, "OnShow", function(this)
		self:skinCloseButton{obj=self:getChild(this, 1)}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, x1=10, y1=-11, y2=8}
		self:skinStdButton{obj=self:getChild(self:getChild(this, 2), 2)} --Clear button on ScrollingMessageFrame
		self:Unhook(this, "OnShow")
	end)
	if _G.SpewPanel:IsShown() then
		_G.SpewPanel:Hide()
		_G.SpewPanel:Show()
	end

end