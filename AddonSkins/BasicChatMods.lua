local _, aObj = ...
if not aObj:isAddonEnabled("BasicChatMods") then return end
local _G = _G

aObj.addonsToSkin.BasicChatMods = function(self) -- v 9.0.2

	-- handle module not enabled
	if not _G.bcmDB.BCM_ChatCopy then
		self:SecureHookScript(_G.BCMCopyFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.BCMCopyScroll.ScrollBar})
			self:skinObject("frame", {obj=this})
			if self.modBtns then
				self:skinCloseButton{obj=_G.BCMCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.BCMtooltip)
		end)
	end

	-- Config changes
	self.iofDD["BCM_ChanName_Drop"] = 124
	self.iofDD["BCM_EditBoxPosition"] = 94
	self.iofDD["BCM_FontName"] = 94
	self.iofDD["BCM_FontFlag"] = 94
	self.iofDD["BCM_Sticky_Drop"] = 109

end
