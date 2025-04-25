local _, aObj = ...
if not aObj:isAddonEnabled("MinimapButtonButton") then return end
local _G = _G

aObj.addonsToSkin.MinimapButtonButton = function(self) -- v 1.21.3

	local buttonContainer = self:getChild(_G.MinimapButtonButtonButton, 1)

	self:skinObject("frame", {obj=_G.MinimapButtonButtonButton, rb="nop", ofs=0, ng=true, bclr="class", ba=0.5})

	self:SecureHookScript(buttonContainer, "OnShow", function(this)

		self:skinObject("frame", {obj=this, ofs=0})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(buttonContainer)

end
