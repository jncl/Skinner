local aName, aObj = ...
if not aObj:isAddonEnabled("CollectMe") then return end

function aObj:CollectMe()

	local CM = LibStub("AceAddon-3.0"):GetAddon("CollectMe", true)
	
	if CM then
		self:moveObject{obj=CM.frame.titlebg, y=-6}
		self:applySkin{obj=CM.tabs.content:GetParent(), kfs=true}
		self:glazeStatusBar(CM.frame.statusbar, 0,  nil)
		self:addSkinFrame{obj=CM.frame.frame, kfs=true}
		-- tooltip
		if self.db.profile.Tooltips.skin then
			self:add2Table(self.ttList, "CollectMeTooltip")
		end
		--hook this to change dropdown skin
		self:RawHook(CM, "CreateMacroDropdown", function(this, ...)
			local frame = self.hooks[this].CreateMacroDropdown(this, ...)
			self.skinFrame[frame.dropdown]:SetPoint("BOTTOMRIGHT", frame.dropdown, "BOTTOMRIGHT", -15, 3)
			return frame
		end, true)
	end

end