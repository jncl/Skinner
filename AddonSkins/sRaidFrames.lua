
function Skinner:sRaidFrames()

	self:SecureHook(sRaidFrames, "CreateUnitFrame", function(this, frame)
-- 		self:Debug("sRaidFrames_CUF: [%s, %s]", frame, frame:GetName() or "???")
		if not self.skinned[frame] then
			self:glazeStatusBar(frame.hpbar)
			self:glazeStatusBar(frame.mpbar)
			self:applySkin(frame)
			self:RawHook(frame, "SetBackdropColor", function() end, true)
			self:RawHook(frame, "SetBackdropBorderColor", function() end, true)
		end
	end)

	for _, frame in ipairs(sRaidFrames.frames) do
-- 		self:Debug("sRaidFrames: [%s, %s]", frame:GetName(), #sRaidFrames.frames)
		self:glazeStatusBar(frame.hpbar)
		self:glazeStatusBar(frame.mpbar)
		self:applySkin(frame)
		self:RawHook(frame, "SetBackdropColor", function() end, true)
		self:RawHook(frame, "SetBackdropBorderColor", function() end, true)
		self.skinned[frame] = true
	end

end
