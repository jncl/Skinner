local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["ScrollingTable"] = function(self) -- v ScrollingTable, 149
	if self.initialized.ScrollingTable then return end
	self.initialized.ScrollingTable = true

	local ST = _G.LibStub:GetLibrary("ScrollingTable", true)

	if ST then
		self:RawHook(ST, "CreateST", function(this, cols, numRows, rowHeight, highlight, parent)
			local st = self.hooks[this].CreateST(this, cols, numRows, rowHeight, highlight, parent)
			self:skinSlider{obj=st.scrollframe.ScrollBar}
			_G[st.frame:GetName() .. "ScrollTrough"].background:SetTexture(nil)
			_G[st.frame:GetName() .. "ScrollTroughBorder"].background:SetTexture(nil)
			self:addSkinFrame{obj=st.frame, ft="a", kfs=true, nb=true, y1=2, y2=-1}
			return st
		end, true)
	end

end
