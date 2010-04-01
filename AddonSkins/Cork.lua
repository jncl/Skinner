if not Skinner:isAddonEnabled("Cork") then return end

function Skinner:Cork()

	self:applySkin(Cork.anchor)
	self:SecureHook(Corkboard, "Show", function(this, ...)
		self:applySkin(Corkboard)
	end)
	self:applySkin(Corkboard)
	
end
