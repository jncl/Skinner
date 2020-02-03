local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibTextDump-1.0"] = function(self) -- v LibTextDump-1.0 4
	if self.initialized.LibTextDump then return end
	self.initialized.LibTextDump = true

	local lTD = _G.LibStub:GetLibrary("LibTextDump-1.0", true)

	if lTD then
		-- create function to be used in other skins
		function self:skinTextDump(instance)
			local frame = lTD.frames[instance]
			self:skinSlider{obj=frame.scrollArea.ScrollBar}
			self:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true}
			if self.modBtns then
				self:skinCloseButton{obj=_G[frame:GetName() .. "Close"]}
			end
			frame = nil
		end
		self:RawHook(lTD, "New", function(this, frameTitle, width, height, save)
			local instance = self.hooks[this].New(this, frameTitle, width, height, save)
			self:skinTextDump(instance)
			return instance
		end, true)
	else
		self.skinTextDump = _G.nop
	end

end
