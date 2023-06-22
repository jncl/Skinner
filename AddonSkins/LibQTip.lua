local _, aObj = ...
-- This is a Library
local _G = _G

aObj.ignoreLQTT = {}
local function skinTT(key, tTip)
	-- ignore tooltips if required
	if not aObj.ignoreLQTT[key] then
		aObj:skinObject("tooltip", {obj=tTip})
		_G.C_Timer.After(aObj.ttDelay, function() -- slight delay to allow for the tooltip to be populated
			aObj:applyTooltipGradient(tTip.sf)
		end)
		tTip:SetScript("OnUpdate", function(ttObj)
			_G.C_Timer.After(aObj.ttDelay, function() -- slight delay to allow for the tooltip to be populated
				aObj:applyTooltipGradient(ttObj.sf)
			end)
		end)
		aObj:hook(tTip, "UpdateScrolling", function(ttObj)
			if ttObj.slider then
				aObj:skinObject("slider", {obj=ttObj.slider})
			end
		end)
	end
end
local function hookFuncs(lib)
	aObj:RawHook(lib, "Acquire", function(this, key, ...)
		local tTip = aObj.hooks[this].Acquire(this, key, ...)
		skinTT(key, tTip)
		return tTip
	end, true)
	for key, tTip in lib:IterateTooltips() do
		skinTT(key, tTip)
	end
end

aObj.libsToSkin["LibQTip-1.0"] = function(self) -- v LibQTip-1.0, 44
	if not self.db.profile.Tooltips.skin or self.initialized.LibQTip then return end
	self.initialized.LibQTip = true

	local lqt = _G.LibStub:GetLibrary("LibQTip-1.0", true)
	if lqt then
		hookFuncs(lqt)
	end

end

aObj.libsToSkin["LibQTip-1.0RS"] = function(self) -- v LibQTip-1.0RS, 44
	if not self.db.profile.Tooltips.skin or self.initialized.LibQTipRS then return end
	self.initialized.LibQTipRS = true

	local lqt = _G.LibStub:GetLibrary("LibQTip-1.0RS", true)
	if lqt then
		hookFuncs(lqt)
	end

end
