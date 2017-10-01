local aName, aObj = ...
local _G = _G
-- This is a Library

local function hookFuncs(lib)

	aObj:RawHook(lib, "OpenAce3Menu", function(this, tab, parent)
		if parent == nil and tab.args then
			-- creation pass of the function
			local frame = aObj.hooks[this].OpenAce3Menu(this, tab, parent)
			aObj:applySkin{obj=frame} -- N.B. use applySkin
			return frame
		else
			-- setup pass of the function, second and subsequent calls
			aObj.hooks[this].OpenAce3Menu(this, tab, parent)
			aObj:applySkin{obj=parent} -- N.B. use applySkin
		end
	end, true)
	aObj:SecureHook(lib, "Ace3InputShow", function(this, tab, parent)
		aObj:skinEditBox{obj=parent:GetParent().input, regs={9}}
		parent:GetParent().input.SetHeight = _G.nop -- stop height being reset
		aObj:applySkin{obj=parent} -- N.B. use applySkin
	end, true)

end

aObj.libsToSkin["LibDropdown-1.0"] = function(self) -- v LibDropdown-1.0, 1
	if self.initialized.LibDropdown then return end
	self.initialized.LibDropdown = true

	local lDD = _G.LibStub("LibDropdown-1.0", true)

	if lDD then
		hookFuncs(lDD)
	end

end

aObj.libsToSkin["LibDropdownMC-1.0"] = function(self) -- v LibDropdownMC-1.0, 1
	if self.initialized.LibDropdownMC then return end
	self.initialized.LibDropdownMC = true

	local lDD = _G.LibStub("LibDropdownMC-1.0", true)

	if lDD then
		hookFuncs(lDD)
	end

end
