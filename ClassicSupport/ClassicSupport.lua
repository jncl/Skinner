if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then return end

local aName, aObj = ...

local _G = _G

aObj.SetupClassic = function(self)

	-- remove UnitFrames module options
	local ufDB = self.db:GetNamespace("UnitFrames", true)
	if ufDB then
		ufDB.profile.focus = nil
		ufDB.profile.arena = nil
		ufDB.defaults.profile.focus = nil
		ufDB.defaults.profile.arena = nil
	end
	self.optTables["Modules"].args[aName .. "_UnitFrames"].args.focus = nil
	self.optTables["Modules"].args[aName .. "_UnitFrames"].args.arena = nil
	self:GetModule("UnitFrames", true).skinFocusF = _G.nop

	-- NOP functions that are not required and cause errors
	self.skinGlowBox = _G.nop

end
