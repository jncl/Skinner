local _, aObj = ...
local _G = _G
-- This is a Library

local function hookFuncs(lib)
	aObj:RawHook(lib, "OpenAce3Menu", function(this, t, parent)
		if parent == nil and t.args then
			-- creation pass of the function
			local frame = aObj.hooks[this].OpenAce3Menu(this, t, parent)
			aObj:skinObject("frame", {obj=frame, kfs=true, ofs=0})
			return frame
		else
			-- setup pass of the function, second and subsequent calls
			aObj.hooks[this].OpenAce3Menu(this, t, parent)
			aObj:removeBackdrop(parent)
			aObj:skinObject("frame", {obj=parent, kfs=true, ofs=0})
		end
	end, true)
	aObj:SecureHook(lib, "Ace3MenuSelect", function(this, t, parent)
		aObj:skinObject("frame", {obj=parent, kfs=true})
	end)
	aObj:SecureHook(lib, "Ace3InputShow", function(_, _, parent)
		local eB = parent:GetParent().input
		aObj:skinObject("editbox", {obj=eB})
		-- aObj:skinEditBox{obj=parent:GetParent().input, regs={9}}
		eB.SetHeight = _G.nop -- stop height being reset
		aObj:skinObject("frame", {obj=parent, kfs=true})
	end, true)
end

aObj.libsToSkin["LibDropdown-1.0"] = function(self) -- v LibDropdown-1.0, 1
	if self.initialized.LibDropdown then return end
	self.initialized.LibDropdown = true

	local lDD = _G.LibStub:GetLibrary("LibDropdown-1.0", true)
	if lDD then
		hookFuncs(lDD)
	end

end

aObj.libsToSkin["LibDropdownMC-1.0"] = function(self) -- v LibDropdownMC-1.0, 1
	if self.initialized.LibDropdownMC then return end
	self.initialized.LibDropdownMC = true

	local lDD = _G.LibStub:GetLibrary("LibDropdownMC-1.0", true)
	if lDD then
		hookFuncs(lDD)
	end

end
