
function Skinner:Talented()
	self:SecureHook(Talented, "CreateBaseFrame", function()
		self:applySkin(Talented.base)
	end)
end
