
function Skinner:ZOMGBuffs()

	--	Hook this to skin some of the frames
	local LZF = LibStub:GetLibrary('ZFrame-1.0', true)
	if LZF then
		self:Hook(LZF, "Create", function(this, ...)
			local frame = self.hooks[this].Create(this, ...)
--			self:Debug("ZFrame Create:[%s]", frame)
			self:moveObject(frame.ZMain.title, nil, nil, "-", 0, frame.ZMain)
			self:moveObject(frame.ZMain.close, "-", 1, "+", 9, frame.ZMain)
			self:applySkin(frame.ZMain)
			return frame
		end, true)
	end
	self:Hook(ZOMGBuffs, "CreateHelpFrame", function(this)
		local hf = self.hooks[this].CreateHelpFrame(this)
		self:applySkin(hf)
		self:Unhook(ZOMGBuffs, "CreateHelpFrame")
		return hf
	end, true)

	-- if there's a border around the icon then skin it
	if ZOMGBuffs.menu.border then self:applySkin(ZOMGBuffs.menu.border) end

	-- set the bar texture
	ZOMGBuffs.db.profile.bartexture = self.db.profile.StatusBar.texture

end

function Skinner:ZOMGBuffs_BlessingsManager()

	local ZBM = ZOMGBuffs:GetModule("ZOMGBlessingsManager")
	if ZBM then
		self:SecureHook(ZBM, "SplitInitialize", function(this)
--			self:Debug("ZBM SplitInitialize")
			local frame = this.splitframe
			for i = 1, #frame.column do
				self:applySkin(frame.column[i])
			end
		end)
	end

end
