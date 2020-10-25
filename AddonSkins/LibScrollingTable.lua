local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["ScrollingTable"] = function(self) -- v ScrollingTable, 40300
	if self.initialized.ScrollingTable then return end
	self.initialized.ScrollingTable = true

	if _G.LibStub:GetLibrary("ScrollingTable", true) then
		-- create function to be used in other skins
		function self:skinScrollingTable(obj)
			self:skinSlider{obj=obj.scrollframe.ScrollBar}
			_G[obj.frame:GetName() .. "ScrollTrough"].background:SetTexture(nil)
			_G[obj.frame:GetName() .. "ScrollTroughBorder"].background:SetTexture(nil)
			self:addFrameBorder{obj=obj.frame, ft="a", kfs=true, nb=true, y1=2, y2=-1}
		end
		self:RawHook(_G.LibStub:GetLibrary("ScrollingTable", true), "CreateST", function(this, ...)
			local st = self.hooks[this].CreateST(this, ...)
			self:skinScrollingTable(st)
			return st
		end, true)
	end

end
