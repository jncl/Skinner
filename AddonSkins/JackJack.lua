local _, aObj = ...
if not aObj:isAddonEnabled("JackJack") then return end
local _G = _G

aObj.addonsToSkin.JackJack = function(self) -- v JackJack-2.0-retail9.2.7.45745

	self:SecureHookScript(_G.JJWindow, "OnShow", function(this)
		this.obj.type = "JJWindow"
		self:skinAceOptions(this)

		-- Create Tabs and flip them to force all contained objects to be skinned
		this.obj.children[1]:BuildTabs()
		this.obj.children[1]:SelectTab("directions")
		this.obj.children[1]:SelectTab("locations")

		self:Unhook(this, "OnShow")
	end)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.JackJackLocationTooltip)
	end)

end
