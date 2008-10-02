
function Skinner:sRaidFrames()

	self:SecureHook(sRaidFrames, "CreateUnitFrame", function(this, f)
-- 		self:Debug("sRaidFrames_CUF: [%s, %s]", f, f:GetName() or "???")
		if not f.skinned then
			self:glazeStatusBar(f.hpbar)
			self:glazeStatusBar(f.mpbar)
			self:applySkin(f)
			self:Hook(f, "SetBackdropColor", function() end, true)
			self:Hook(f, "SetBackdropBorderColor", function() end, true)
			f.skinned = true
		end
	end)

	for _, f in ipairs(sRaidFrames.frames) do
-- 		self:Debug("sRaidFrames: [%s, %s]", f:GetName(), #sRaidFrames.frames)
		self:glazeStatusBar(f.hpbar)
		self:glazeStatusBar(f.mpbar)
		self:applySkin(f)
		self:Hook(f, "SetBackdropColor", function() end, true)
		self:Hook(f, "SetBackdropBorderColor", function() end, true)
		f.skinned = true
	end

end
