local _, aObj = ...
if not aObj:isAddonEnabled("TomTom") then return end
local _G = _G

aObj.addonsToSkin.TomTom = function(self) -- v 800001-1.0.0/3.0.2

	-- skin the Coordinate block
	if _G.TomTomBlock then
		self:skinObject("frame", {obj=_G.TomTomBlock, kfs=true, ofs=-4})
	else
		self:SecureHook(_G.TomTom, "ShowHideCoordBlock", function(this)
			self:skinObject("frame", {obj=_G.TomTomBlock, kfs=true, ofs=-4})

			self:Unhook(this, "ShowHideCoordBlock")
		end)
	end

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.TomTomTooltip)
	end)

end
