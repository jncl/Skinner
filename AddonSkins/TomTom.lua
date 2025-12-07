local _, aObj = ...
if not aObj:isAddonEnabled("TomTom") then return end
local _G = _G

aObj.addonsToSkin.TomTom = function(self) -- v4.2.4-release

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

end

-- add skinning of TomTomPaste frame to repeating timer table
aObj.repTimer["TomTomPaste"] = function(fObj)
	aObj:keepFontStrings(fObj.TitleContainer)
	aObj:skinObject("frame", {obj=fObj.EditBox, kfs=true, fb=true})
	aObj:skinObject("frame", {obj=fObj, kfs=true})
	if aObj.modBtns then
		aObj:skinStdButton{obj=fObj.CloseButton}
		aObj:skinStdButton{obj=fObj.PasteButton}
	end
end
