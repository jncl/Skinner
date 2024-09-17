local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["ScrollingTable"] = function(self) -- v ScrollingTable, 40300
	if self.initialized.ScrollingTable then return end
	self.initialized.ScrollingTable = true

	local lST = _G.LibStub:GetLibrary("ScrollingTable", true)

	if lST then
		self:RawHook(lST, "CreateST", function(this, ...)
			local st = self.hooks[this].CreateST(this, ...)
			self:skinObject("slider", {obj=st.scrollframe.ScrollBar})
			_G[st.frame:GetName() .. "ScrollTrough"].background:SetTexture(nil)
			_G[st.frame:GetName() .. "ScrollTroughBorder"].background:SetTexture(nil)
			self:skinObject("frame", {obj=st.frame, kfs=true, fb=true, ofs=0})
			return st
		end, true)
	end

end
