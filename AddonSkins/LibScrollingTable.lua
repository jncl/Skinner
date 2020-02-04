local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["ScrollingTable"] = function(self) -- v ScrollingTable, 40300
	if self.initialized.ScrollingTable then return end
	self.initialized.ScrollingTable = true

	local ST = _G.LibStub:GetLibrary("ScrollingTable", true)

	if ST then
		-- create function to be used in other skins
		function self:skinScrollingTable(obj)
			self:skinSlider{obj=obj.scrollframe.ScrollBar}
			_G[obj.frame:GetName() .. "ScrollTrough"].background:SetTexture(nil)
			_G[obj.frame:GetName() .. "ScrollTroughBorder"].background:SetTexture(nil)
			self:addSkinFrame{obj=obj.frame, ft="a", kfs=true, nb=true, y1=2, y2=-1}
		end
		self:RawHook(ST, "CreateST", function(this, ...)
			local st = self.hooks[this].CreateST(this, cols, ...)
			self:skinScrollingTable(st)
			return st
		end, true)
	else
		self.skinScrollingTable = _G.nop
	end

end
