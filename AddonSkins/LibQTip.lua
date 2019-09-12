local aName, aObj = ...
-- This is a Library
local _G = _G

aObj.ignoreLQTT = {}
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
local function hookFuncs(lib)
	-- hook this to handle new tooltips
	aObj:RawHook(lib, "Acquire", function(this, key, ...)
		local tt = aObj.hooks[this].Acquire(this, key, ...)
		skinTT(key, tt)
		return tt
	end, true)
	-- hook this to handle tooltips being released
	aObj:SecureHook(lib, "Release", function(this, tt)
		-- handle already skinned
		if tt and tt.sknd then
			tt.sknd = nil
		end
	end)
	-- skin existing tooltips
	for key, tt in lib:IterateTooltips() do
		skinTT(key, tt)
	end
end

aObj.libsToSkin["LibQTip-1.0"] = function(self) -- v LibQTip-1.0, 44
	if not self.db.profile.Tooltips.skin or self.initialized.LibQTip then return end
	self.initialized.LibQTip = true

	local lqt = _G.LibStub("LibQTip-1.0", true)
	if lqt then
		hookFuncs(lqt)
	end

end

aObj.libsToSkin["LibQTip-1.0RS"] = function(self) -- v LibQTip-1.0RS, 44
	if not self.db.profile.Tooltips.skin or self.initialized.LibQTipRS then return end
	self.initialized.LibQTipRS = true

	local lqt = _G.LibStub("LibQTip-1.0RS", true)
	if lqt then
		hookFuncs(lqt)
	end

end
