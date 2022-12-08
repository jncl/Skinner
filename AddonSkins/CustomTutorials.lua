local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["CustomTutorials-2.1"] = function(self) -- v 2.1, 12
	if self.initialized["CustomTutorials-2.1"] then return end
	self.initialized["CustomTutorials-2.1"] = true

	local cTut = _G.LibStub:GetLibrary("CustomTutorials-2.1", true)

	if cTut then
		for _, frame in _G.pairs(cTut.frames) do
			self:skinObject("frame", {obj=frame, kfs=true, ri=true, cb=true, ofs=2, x2=0})
			if self.modBtns then
				self:addButtonBorder{obj=frame.prev, ofs=-1, clr="gold", schk=true}
				self:addButtonBorder{obj=frame.next, ofs=-1, clr="gold", schk=true}
			end
		end
	end

end
