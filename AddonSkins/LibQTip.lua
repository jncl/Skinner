local aName, aObj = ...
-- This is a Library

aObj.ignoreLQTT = {}

function aObj:LibQTip()
	if not self.db.profile.Tooltips.skin or self.initialized.LibQTip then return end
	self.initialized.LibQTip = true

	local lqt = LibStub("LibQTip-1.0", true)
	if lqt then
		local function skinLTTooltips(lib)
	
			for key, tooltip in lib:IterateTooltips() do
--	 			aObj:Debug("%s:[%s, %s]", lib, key, tooltip)
				-- ignore tooltips if required
				if not aObj.ignoreLQTT[key] then
					if not aObj.skinned[tooltip] then
						aObj:applySkin{obj=tooltip}
					end
				end
			end
		
		end
		-- hook this to handle new tooltips
		self:SecureHook(lqt, "Acquire", function(this, key, ...)
			skinLTTooltips(this)
		end)
		-- hook this to handle tooltips being released
		self:SecureHook(lqt, "Release", function(this, tt)
			if tt then self.skinned[tt] = nil end
		end)
		-- skin any existing ones
		skinLTTooltips(lqt)
	end

end
