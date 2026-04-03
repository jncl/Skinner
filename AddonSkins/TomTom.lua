local _, aObj = ...
if not aObj:isAddonEnabled("TomTom") then return end
local _G = _G

aObj.addonsToSkin.TomTom = function(self) -- v4.2.24-release

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

	_G.RunNextFrame(function()
		self:add2Table(self.ttList, "a", _G.TomTomTooltip)
	end)

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			aObj:keepFontStrings(fObj.TitleContainer)
			aObj:skinObject("frame", {obj=fObj.EditBox, kfs=true, fb=true})
			aObj:skinObject("frame", {obj=fObj, kfs=true})
			if aObj.modBtns then
				aObj:skinStdButton{obj=fObj.CloseButton}
				aObj:skinStdButton{obj=fObj.PasteButton}
				aObj:skinStdButton{obj=fObj.ExportButton}
			end
		end)
	end}, "TomTomPaste")

end
