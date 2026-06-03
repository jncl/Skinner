local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["Krowi_WorldMapButtons-1.4"] = function(self) -- v Krowi_WorldMapButtons-1.4, 9
	if self.initialized.Krowi_WorldMapButtons then return end
	self.initialized.Krowi_WorldMapButtons = true

	local lKWMB = _G.LibStub:GetLibrary("Krowi_WorldMapButtons-1.4", true)

	if lKWMB then
		local function skinButton(oFrame)
			oFrame:DisableDrawLayer("BACKGROUND")
			if oFrame.Border then -- bugfix #342
				oFrame.Border:SetTexture(nil)
			end
			if oFrame.ResetButton then
				aObj.modUIBtns:skinCloseButton{obj=oFrame.ResetButton, noSkin=true}
			end
			if aObj.modBtns then
				aObj:skinStdButton{obj=oFrame, ofs=-2, clr="gold"}
			end
		end
		self:RawHook(lKWMB, "Add", function(this, ...)
			local btn = self.hooks[this].Add(this, ...)
			skinButton(btn)
			return btn
		end, true)
		for _, btn in _G.pairs(lKWMB.Buttons) do
			skinButton(btn)
		end
	end

end
