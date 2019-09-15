local aName, aObj = ...
if not aObj:isAddonEnabled("quantify") then return end
local _G = _G

aObj.addonsToSkin.quantify = function(self) -- v 1.1b-classic

	self:SecureHookScript(_G.QuantifyWatchList, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.QuantifyWatchList)

	self:SecureHookScript(_G.QuantifyContainer_Frame, "OnShow", function(this)
		_G.QuantifyBottomBar:SetBackdrop(nil)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.QuantifyCloseButton}
		end

		self:Unhook(this, "OnShow")
	end)

end
