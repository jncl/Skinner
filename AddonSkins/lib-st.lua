local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["ScrollingTable"] = function(self) -- v ScrollingTable, 149
	if self.initialized.ScrollingTable then return end
	self.initialized.ScrollingTable = true

	local ST = _G.LibStub:GetLibrary("ScrollingTable", true)

	if ST then
		self:RawHook(ST, "CreateST", function(this, cols, numRows, rowHeight, highlight, parent)
			aObj:Debug("lib-st CreateST: [%s, %s, %s, %s, %s, %s]", this, cols, numRows, rowHeight, highlight, parent)
			local st = self.hooks[this].CreateST(this, cols, numRows, rowHeight, highlight, parent)
			self:addSkinFrame{obj=st.frame, ft="a", kfs=true, nb=true}
			-- scrollframe st.scrollframe
			-- scrolltrough
			-- scrolltroughborder
			return st
		end, true)
	end

end
