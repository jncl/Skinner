local aName, aObj = ...
if not aObj:isAddonEnabled("Bagnon_Forever") then return end

function aObj:Bagnon_Forever()
	if not self.db.profile.ContainerFrames then return end

	self:SecureHook(BagnonDB, "ToggleDropdown", function(this)
		self:keepFontStrings(BagnonDBCharSelect)
		self:Unhook(BagnonDB, "ToggleDropdown")
	end)

end
