
function Skinner:Enchantrix()

-->>-- Manifest frame
	self:SecureHook(Enchantrix_Manifest, "ShowMessage", function(this, msg)
		self:addSkinFrame{obj=Enchantrix_Manifest.messageFrame, kfs=true}
		self:Unhook(Enchantrix_Manifest, "ShowMessage")
	end)
	
-->>-- AutoDisenchant prompt	
	local auto_de_prompt = self:findFrame2(UIParent, "Frame", 130, 400)
	self:addSkinFrame{obj=auto_de_prompt, kfs=true}

end
