
Skinner.ignoreLQTT = {}

function Skinner:LibQTip()
	if not self.db.profile.Tooltips.skin or self.initialized.LibQTip then return end
	self.initialized.LibQTip = true

	-- handle tomQuest2 Tracker & Achievements tooltips (frames)
	if IsAddOnLoaded("tomQuest2") and not self.db.profile.TrackerFrame.skin then
		self.ignoreLQTT["tomQuest2Tracker"] = true
		self.ignoreLQTT["tomQuest2Achievements"] = true
	end
	
	local function skinLTTooltips(ttLib)
	
		for key, tooltip in LibStub(ttLib):IterateTooltips() do
-- 			Skinner:Debug("%s:[%s, %s]", ttLib, key, tooltip)
			-- ignore tooltips if required
			if self.ignoreLQTT[key] then return end
			if not Skinner.skinned[tooltip] then
				Skinner:applySkin{obj=tooltip}
			end
		end
		
	end
	
	local lt = {"LibTooltip-1.0", "LibQTip-1.0", "LibQTipClick-1.1"}

	for _, lib in pairs(lt) do
		if LibStub(lib, true) then
			-- hook this to handle new tooltips
			self:SecureHook(LibStub(lib), "Acquire", function(this, key, ...)
				skinLTTooltips(lib)
			end)
			-- hook this to handle tooltips being released
			self:SecureHook(LibStub(lib), "Release", function(this, tt)
				if tt then self.skinned[tt] = nil end
			end)
			-- skin any existing ones
			skinLTTooltips(lib)
		end
	end
	lt = nil

end
