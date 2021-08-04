-- This is a Library
local aName, aObj = ...
local _G = _G

function aObj:tektip()
	if not self.db.profile.Tooltips.skin or self.initialized.tektip then return end
	self.initialized.tektip = true

	print("tektip skin loaded")

	local lib = _G.LibStub("tektip-1.0")

	-- hook this to skin new tooltips
	self:RawHook(lib, "new", function(...)
		local ttip = self.hooks[lib].new(...)
		self:add2Table(self.ttList, ttip)
		return ttip
	end, true)

	-- skin existing tooltips
	self.RegisterCallback("tektip", "UIParent_GetChildren", function(this, child)
		if child:GetFrameStrata() == "TOOLTIP"
		and child.AddLine
		and child.Clear
		then
			self:add2Table(self.ttList, child)
		end
	end)

end
