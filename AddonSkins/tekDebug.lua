
function Skinner:tekDebug()

	self:SecureHookScript(tekDebugPanel, "OnShow", function(this)
		local kids = {tekDebugPanel:GetChildren()}
		for k, child in pairs(kids) do
			if child:IsObjectType("Button") then
				if k == 1 then self:skinButton{obj=child, cb=true}
				else child:SetNormalTexture(nil) end -- remove button's background texture
			end
		end
		kids = nil
		self:Unhook(tekDebugPanel, "OnShow")
	end)
	self:addSkinFrame{obj=tekDebugPanel, kfs=true, y1=-11}

end
