local aName, aObj = ...
if not aObj:isAddonEnabled("TomTom") then return end
local _G = _G

aObj.addonsToSkin.TomTom = function(self) -- v 800001-1.0.0

	-- skin the Coordinate block
	if _G.TomTomBlock then
		self:addSkinFrame{obj=_G.TomTomBlock, ft="a", nb=true, ofs=-3}
	else
		self:SecureHook(_G.TomTom, "ShowHideCoordBlock", function(this)
			self:addSkinFrame{obj=_G.TomTomBlock, ft="a", nb=true, ofs=-3}
			self:Unhook(this, "ShowHideCoordBlock")
		end)
	end

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.TomTomTooltip)
	end)
	self.ttHook[_G.TomTomTooltip] = true

end
