local aName, aObj = ...
if not aObj:isAddonEnabled("Spew") then return end

function aObj:Spew()

	-- hook OnShow event as textures not seen until shown
	self:SecureHookScript(SpewPanel, "OnShow", function(this)
		self:addSkinFrame{obj=this, kfs=true, x1=10, y1=-11, y2=8}
		self:Unhook(SpewPanel, "OnShow")
	end)

end