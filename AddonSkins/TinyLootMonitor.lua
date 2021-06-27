local _, aObj = ...
if not aObj:isAddonEnabled("TinyLootMonitor") then return end
local _G = _G

aObj.addonsToSkin.TinyLootMonitor = function(self) -- v 0.4.2-Release

	self:skinObject("frame", {obj=_G.TinyLootMonitorAnchor, kfs=true})
	
	self:RawHook(_G.TinyLootMonitor.pool, "Acquire", function(this)
		local frame = self.hooks[this].Acquire(this)
		self:skinObject("frame", {obj=frame, rb=true})
		return frame
	end, true)

	for frame in _G.TinyLootMonitor.pool:EnumerateActive() do
		self:skinObject("frame", {obj=frame, rb=true})
	end

end
