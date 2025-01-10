local _, aObj = ...
if not aObj:isAddonEnabled("TomTom") then return end
local _G = _G

aObj.addonsToSkin.TomTom = function(self) -- v4.0.5-release

	-- skin the Coordinate block
	local oFs = -2
	if _G.TomTomBlock then
		self:skinObject("frame", {obj=_G.TomTomBlock, kfs=true, ofs=oFs})
	else
		self:SecureHook(_G.TomTom, "ShowHideCoordBlock", function(this)
			self:skinObject("frame", {obj=_G.TomTomBlock, kfs=true, ofs=oFs})

			self:Unhook(this, "ShowHideCoordBlock")
		end)
	end

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.TomTomTooltip)
	end)

	-- skin TomTomPaste
	self:SecureHookScript(_G.TomTomPaste, "OnShow", function(this)

		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this, 2)}
			self:skinStdButton{obj=self:getChild(this, 3)}
		end

		self:Unhook(this, "OnShow")
	end)

end
