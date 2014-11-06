local aName, aObj = ...
if not aObj:isAddonEnabled("Enchantrix") then return end
local _G = _G

function aObj:Enchantrix()

	-- N.B. this code will be called when the corresponding module is loaded by Stubby

	-- Manifest frame
	self:SecureHook(Enchantrix_Manifest, "ShowMessage", function(this, msg)
		self:addSkinFrame{obj=Enchantrix_Manifest.messageFrame, kfs=true}
		self:Unhook(Enchantrix_Manifest, "ShowMessage")
	end)

	-- AutoDisenchant prompt
	local need2call = false
	-- if callback events have been cleared, set flag
	if #self.callbacks.events["UIParent_GetChildren"] == 0 then
		need2call = true
	end
	-- skin auto_de_prompt frame
	self.RegisterCallback("Enchantrix", "UIParent_GetChildren", function(this, child)
		if child.Drag
		and child.Item
		and child.Lines
		then
			self:addSkinFrame{obj=child, kfs=true}
			self.UnregisterCallback("Enchantrix", "UIParent_GetChildren")
		end
	end)
	-- call scan function if required
	if need2call then self:scanUIParentsChildren() end

end
