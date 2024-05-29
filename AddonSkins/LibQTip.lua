local _, aObj = ...
local _G = _G
-- This is a Library

aObj.ignoreQT = {}
local function skinQT(key, tTip)
	-- ignore tooltips if required
	if not aObj.ignoreQT[key] then
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
local function skinAndHook(lib)
	for key, tTip in lib:IterateTooltips() do
		skinQT(key, tTip)
	end
	aObj:RawHook(lib, "Acquire", function(this, key, ...)
		local tTip = aObj.hooks[this].Acquire(this, key, ...)
		skinQT(key, tTip)
		return tTip
	end, true)
end

local libsToSkin = {
	"LibQTip-1.0",
	"LibQTip-1.0RS",
}

do
	for _, lib in _G.pairs(libsToSkin) do
		aObj.libsToSkin[lib] = function(self)
			if not self.prdb.Tooltips.skin or self.initialized[lib] then return end
			self.initialized[lib] = true
			local lQT = _G.LibStub:GetLibrary(lib, true)
			if lQT then
				skinAndHook(lQT)
			end
		end
	end
end
