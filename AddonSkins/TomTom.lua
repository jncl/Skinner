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

	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.TomTomTooltip)
	end)

end

-- Start a 1 second Repeating Timer to skin the frame
local myTimer = _G.C_Timer.NewTicker(1, function(self)
	if _G["TomTomPaste"] then
		aObj:keepFontStrings(_G["TomTomPaste"].TitleContainer)
		aObj:skinObject("frame", {obj=_G["TomTomPaste"].EditBox, kfs=true, fb=true})
		aObj:skinObject("frame", {obj=_G["TomTomPaste"], kfs=true})
		if aObj.modBtns then
			aObj:skinStdButton{obj=_G["TomTomPaste"].CloseButton}
			aObj:skinStdButton{obj=_G["TomTomPaste"].PasteButton}
		end
		self:Cancel()
	end
end)
