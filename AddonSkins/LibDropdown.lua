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
	aObj:SecureHook(lib, "Ace3MenuSelect", function(_, _, parent)
		aObj:skinObject("frame", {obj=parent, kfs=true})
	end)
	aObj:SecureHook(lib, "Ace3InputShow", function(_, _, parent)
		local eB = parent:GetParent().input
		aObj:skinObject("editbox", {obj=eB})
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

aObj.libsToSkin["LibDropDown"] = function(self) -- v LibDropDown, 6
	if self.initialized.LibDropDown then return end
	self.initialized.LibDropDown = true

	local lDD = _G.LibStub:GetLibrary("LibDropDown", true)
	if lDD then
		local function skinDD(menu)
			aObj:removeBackdrop(menu.Backdrop)
			aObj:skinObject("frame", {obj=menu, kfs=true, ofs=6})
			_G.RaiseFrameLevelByTwo(menu)
		end
		self:RawHook(lDD, "NewMenu", function(this, parent, name)
			local menu = self.hooks[this].NewMenu(this, parent, name)
			skinDD(menu)
			return menu
		end, true)
		for menu, _ in _G.pairs(lDD.dropdowns) do
			skinDD(menu)
		end
	end

end
