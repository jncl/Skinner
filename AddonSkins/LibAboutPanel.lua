local _, aObj = ...
local _G = _G
-- This is a Library

aObj.aboutPanels = {} -- TODO: remove usage of the table from MinimapButtonFrame skin
aObj.libsToSkin["LibAboutPanel-2.0"] = function(self) -- v 104
	if self.initialized.LibAboutPanel then return end
	self.initialized.LibAboutPanel = true

	local lAP = _G.LibStub("LibAboutPanel-2.0", true)
	if lAP then
		self:skinObject("editbox", {obj=lAP.editbox, y1=4, y2=-4})
	end

	-- this is to stop the Email & Website buttons being skinned
	self.RegisterCallabck("LibAboutPanel", "IOFPanel_Before_Skinning", function(_, panel)
		if lAP.aboutFrame[panel.name] then
			self.iofSkinnedPanels[panel] = true
		end
	end)

end
