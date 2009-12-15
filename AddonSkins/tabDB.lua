
function Skinner:tabDB()

	for i = 1, TABDB_MAX_TABS do
		local tabObj = _G["tabDBtab"..i]
		self:removeRegions(tabObj, {1}) -- N.B. other regions are icon and highlight
	end

end
