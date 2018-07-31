local aName, aObj = ...
-- This is a Library
local _G = _G

aObj.ignoreLQTT = {}

aObj.libsToSkin["LibQTip-1.0"] = function(self) -- v LibQTip-1.0, 44
	if not self.db.profile.Tooltips.skin or self.initialized.LibQTip then return end
	self.initialized.LibQTip = true

	local lqt = _G.LibStub("LibQTip-1.0", true)
	if lqt then
		local function skinTT(key, tt)

			-- ignore tooltips if required
			if not aObj.ignoreLQTT[key] then
				aObj:applySkin{obj=tt}
				aObj:hook(tt, "UpdateScrolling", function(this)
					if tt.slider then
						aObj:skinSlider{obj=tt.slider, wdth=2}
					end
				end)
			end

		end
		-- hook this to handle new tooltips
		self:RawHook(lqt, "Acquire", function(this, key, ...)
			local tt = self.hooks[this].Acquire(this, key, ...)
			skinTT(key, tt)
			return tt
		end, true)
		-- hook this to handle tooltips being released
		self:SecureHook(lqt, "Release", function(this, tt)
			-- handle already skinned
			if tt and tt.sknd then
				tt.sknd = nil
			end
		end)
		-- skin existing tooltips
		for key, tt in lqt:IterateTooltips() do
			skinTT(key, tt)
		end

	end

end
