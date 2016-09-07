local aName, aObj = ...
-- This is a Library
local _G = _G

aObj.ignoreLQTT = {}

function aObj:LibQTip()
	if not self.db.profile.Tooltips.skin or self.initialized.LibQTip then return end
	self.initialized.LibQTip = true

	local lqt = _G.LibStub("LibQTip-1.0", true)
	if lqt then
		local function skinLTTooltips(lib)

			for key, tooltip in lib:IterateTooltips() do
	 			-- aObj:Debug("skinLTTooltips:[%s, %s, %s]", lib, key, tooltip)
				-- ignore tooltips if required
				if not aObj.ignoreLQTT[key] then
					if not tooltip.sknd then
						tooltip.sknd = true
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
			-- aObj:Debug("lqt Release: [%s, %s, %s]", this, tt, tt.sknd)
			-- handle already skinned
			if tt.sknd then
				tt.sknd = nil
			end
		end)
		-- skin any existing ones
		skinLTTooltips(lqt)
	end

end
