
function Skinner:Quartz()

	if Quartz:HasModule('Player') and Quartz:IsModuleActive('Player') then
		self:applySkin(QuartzCastBar)
		self:glazeStatusBar(self:getChild(QuartzCastBar, 1))
	end
	if Quartz:HasModule('Target') and Quartz:IsModuleActive('Target') then
		self:applySkin(QuartzTargetBar)
		self:glazeStatusBar(self:getChild(QuartzTargetBar, 1))
	end
	if Quartz:HasModule('Focus') and Quartz:IsModuleActive('Focus') then
		self:applySkin(QuartzFocusBar)
		self:glazeStatusBar(self:getChild(QuartzFocusBar, 1))
	end

	if Quartz:HasModule('Mirror') and Quartz:IsModuleActive('Mirror') then
		local function skinMSBs()

			for i = 1, select("#", UIParent:GetChildren()) do
				local obj = select(i, UIParent:GetChildren())
				-- if this is a Quartz Mirror Bar then skin it
				if obj:IsObjectType('StatusBar') and obj.timetext then
					if not obj.skinned then
--						Skinner:Debug("skinMSBs: [%s]", obj)
						obj:SetBackdrop(nil)
						Skinner:glazeStatusBar(obj, 0)
						obj.skinned = true
					end
				end
			end

		end
		self:SecureHook(Quartz:GetModule('Mirror'), "ApplySettings", function()
			skinMSBs()
		end)
		skinMSBs()
	end

end
