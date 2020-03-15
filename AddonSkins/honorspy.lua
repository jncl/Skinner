local _, aObj = ...
if not aObj:isAddonEnabled("honorspy") then return end
local _G = _G

aObj.addonsToSkin.honorspy = function(self) -- v 1.7.3

	self:SecureHook(_G.HonorSpy, "ExportCSV", function(this)
		self:skinSlider{obj=_G.ARLCopyScroll.ScrollBar}--, rt="artwork", wdth=-4, size=3, hgt=-10}
		self:addSkinFrame{obj=_G.ARLCopyFrame, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(_G.ARLCopyFrame, 2)}
		end

		self:Unhook(this, "ExportCSV")
	end)

	-- call this to skin the frame
	_G.HonorSpy:ExportCSV()
	_G.ARLCopyFrame:Hide()

end
