-- This is a Library
local aName, aObj = ...
local _G = _G

function aObj:tektip()
	if self.initialized.tektip then return end
	self.initialized.tektip = true

	local lib = _G.LibStub("tektip-1.0")

	local function skinTT(ttip)

		if aObj.db.profile.Tooltips.skin then
			aObj:add2Table(aObj.ttList, "ttip")
		end

	end

	-- hook this to skin new tooltips
	self:RawHook(lib, "new", function(...)
		local ttip = self.hooks[lib].new(...)
		skinTT(ttip)
		return ttip
	end, true)

	-- skin existing tooltips
	local kids = {_G.UIParent:GetChildren()}
	for _, child in _G.ipairs(kids) do
		if child:GetFrameStrata() == "TOOLTIP"
		and child.AddLine
		and child.Clear
		then
			skinTT(child)
		end
	end
	kids = _G.null

end
