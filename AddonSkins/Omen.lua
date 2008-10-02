
function Skinner:Omen()

	if Omen then
		self:applySkin(OmenTitle)
		self:applySkin(OmenBarList)
		self:applySkin(OmenModuleButtons)
		self:SecureHook(Omen, "UpdateDisplay", function()
			self:applySkin(OmenTitle)
			self:applySkin(OmenBarList)
			self:applySkin(OmenModuleButtons)
		end)
		if Omen.Anchor then
			self:SecureHook(OmenAnchor, "Show", function()
				self:applySkin(OmenTitle)
				self:applySkin(OmenBarList)
				self:applySkin(OmenModuleButtons)
			end)
		end
	end

end
