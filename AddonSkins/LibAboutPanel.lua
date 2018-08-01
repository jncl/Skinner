local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.aboutPanels = {["About"] = true}
aObj.libsToSkin["LibAboutPanel"] = function(self) -- v 1.52
	if self.initialized.LibAboutPanel then return end
	self.initialized.LibAboutPanel = true

	local lAP = _G.LibStub("LibAboutPanel", true)
	if lAP then
		self:skinEditBox{obj=lAP.editbox, regs={6}} -- 6 is text
		-- hook this to move editbox to the left
		self:RawHook(lAP.editbox, "SetPoint", function(this, point, relTo)
			if point == "LEFT" then
				self.hooks[this].SetPoint(this, point, relTo, point, -4, 0)
			else
				self.hooks[this].SetPoint(this, point, relTo)
			end
		end, true)
	end

	-- this is to stop the Email & Website buttons being skinned
	self.RegisterCallback("LibAboutPanel", "IOFPanel_Before_Skinning", function(this, panel)
		if not self.aboutPanels[panel.name] then return end
		self.iofSkinnedPanels[panel] = true
	end)

end
