local aName, aObj = ...
if not aObj:isAddonEnabled("ProfessionsVault") then return end

function aObj:ProfessionsVault()

	-- tooltip
	-- get the ldb dataobject
	local pv = LibStub('LibDataBroker-1.1'):GetDataObjectByName("ProfessionsVault")
	self:SecureHook(pv, "OnEnter", function(this)
		if self.db.profile.Tooltips.skin then
			self:add2Table(self.ttList, "PVLDBTT")
		end
		self:Unhook(pv, "OnEnter")
	end)

end