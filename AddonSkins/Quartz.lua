
function Skinner:Quartz() -- Quartz3

	local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3", true)
	if not Quartz3 then return end

	local function skinSBs()

		local kids = {UIParent:GetChildren()}
		for _, child in ipairs(kids) do
			-- if this is a Quartz Mirror/Buff Bar then skin it
			if child:IsObjectType('StatusBar') and child.timetext then
				if not Skinner.skinned[child]then
					child:SetBackdrop(nil)
					Skinner:glazeStatusBar(child, 0)
					child.SetStatusBarTexture = function() end
				end
			end
		end
		kids = nil

	end

	local qModules = {"Player", "Target", "Focus", "Pet", "Swing"}
	for _, modName in pairs(qModules) do
		local mod = Quartz3:GetModule(modName, true)
		if mod and mod:IsEnabled() then
			local bar = modName == "Player" and "Cast" or modName
			self:applySkin(_G["Quartz3"..bar.."Bar"])
			self:glazeStatusBar(self:getChild(_G["Quartz3"..bar.."Bar"], 1))
		end
	end
	local mod = Quartz3:GetModule("Latency", true)
	if mod and mod:IsEnabled() then
		mod.lagbox:SetTexture(self.sbTexture)
	end
-->>-- Mirror Status Bars
	local qMirror = Quartz3:GetModule("Mirror", true)
	if qMirror then
		self:SecureHook(qMirror, "ApplySettings", function()
			skinSBs()
		end)
		skinSBs()
	end
-->>-- Buff Status Bars
	local qBuff = Quartz3:GetModule("Buff", true)
	if qBuff then
		self:SecureHook(qBuff, "ApplySettings", function()
			skinSBs()
		end)
		skinSBs()
	end

end
