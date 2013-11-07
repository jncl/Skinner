-- This is a Library
local aName, aObj = ...

function aObj:LibTradeSkillScan()
	if self.initialized.LibTradeSkillScan then return end
	self.initialized.LibTradeSkillScan = true

	local ltss = LibStub("LibTradeSkillScan", true)
	local ltl = LibStub("LibTradeLinks-1.0", true)

	if ltss
	and ltss.Scan
	then
		self:SecureHook(ltss, "Scan", function(this, ...)
			self:addSkinFrame{obj=self:findFrame2(UIParent, "Frame", 30, 310)}
			self:Unhook(ltss, "Scan")
		end)
	elseif ltl then
		self:addSkinFrame{obj=self:findFrame2(UIParent, "Frame", 30, 310)}
	end

end
