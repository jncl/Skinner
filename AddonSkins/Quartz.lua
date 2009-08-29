
function Skinner:Quartz()

	local function addShieldAndSkin(parent, type) -- add a shield to the casting bar

		local db = Quartz:AcquireDBNamespace(type).profile
		local nibTex = Skinner.LSM:Fetch('border', db.noInterruptBorder)
		local csb = Skinner:getChild(parent, 1)

		parent.shld = csb:CreateTexture(nil, "OVERLAY")
		parent.shld:SetHeight(db.h + 22)
		parent.shld:SetWidth(db.h + 22)
		parent.shld:SetTexture([[Interface\AchievementFrame\UI-Achievement-Progressive-Shield]])
		parent.shld:SetTexCoord(0, 0.75, 0, 0.75)
		parent.shld:SetPoint("CENTER", csb, "CENTER")
		parent.shld:Hide()

		self:applySkin(parent)
		self:glazeStatusBar(csb)

		parent.SetBackdrop = function(this, bd)
--			Skinner:Debug("aSaS: [%s, %s, %s]", this, bd.edgeFile, nibTex)
			if bd.edgeFile == nibTex then
				this.shld:Show()
			else
				this.shld:Hide()
			end
		end
		parent.SetBackdropColor = function() end
		parent.SetBackdropBorderColor = function() end

	end

	local function skinSBs()

		for i = 1, UIParent:GetNumChildren() do
			local obj = select(i, UIParent:GetChildren())
			-- if this is a Quartz Mirror/Buff Bar then skin it
			if obj:IsObjectType('StatusBar') and obj.timetext then
				if not Skinner.skinned[obj]then
					obj:SetBackdrop(nil)
					Skinner:glazeStatusBar(obj, 0)
					obj.SetStatusBarTexture = function() end
				end
			end
		end

	end

	if Quartz:HasModule('Player') and Quartz:IsModuleActive('Player') then
		self:applySkin(QuartzCastBar)
		self:glazeStatusBar(self:getChild(QuartzCastBar, 1))
	end
	if Quartz:HasModule('Target') and Quartz:IsModuleActive('Target') then
		addShieldAndSkin(QuartzTargetBar, "Target")
	end
	if Quartz:HasModule('Focus') and Quartz:IsModuleActive('Focus') then
		addShieldAndSkin(QuartzFocusBar, "Focus")
	end
-->>-- Mirror Status Bars
	if Quartz:HasModule('Mirror') and Quartz:IsModuleActive('Mirror') then
		self:SecureHook(Quartz:GetModule('Mirror'), "ApplySettings", function()
			skinSBs()
		end)
		skinSBs()
	end
-->>-- Buff Status Bars
	if Quartz:HasModule('Buff') and Quartz:IsModuleActive('Buff') then
		self:SecureHook(Quartz:GetModule('Buff'), "ApplySettings", function()
			skinSBs()
		end)
		skinSBs()
	end

end
