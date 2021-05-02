local _, aObj = ...
if not aObj:isAddonEnabled("LightHeaded") then return end
local _G = _G

aObj.addonsToSkin.LightHeaded = function(self) -- v90002-1.0.0
	if not self.prdb.QuestFrame then return end

	if not _G.LightHeadedFrameSub then
		_G.C_Timer.After(0.15, function()
			self.addonsToSkin.LightHeaded(self)
		end)
	end

	self:SecureHookScript(_G.LightHeadedFrameSub, "OnShow", function(this)
		self:skinObject("editbox", {obj=_G.LightHeadedSearchBox})
		self:skinObject("slider", {obj=_G.LightHeadedScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=_G.LightHeadedFrame, kfs=true, cb=true, y1=1})
		if self.modBtns then
			self:addButtonBorder{obj=_G.LightHeadedFrameSub.prev, ofs=-2, y1=-3, x2=-3}
			self:addButtonBorder{obj=_G.LightHeadedFrameSub.next, ofs=-2, y1=-3, x2=-3}
			self:SecureHook(_G.LightHeadedFrameSub.prev, "Disable", function(this, _)
				self:clrBtnBdr(this, "gold")
			end)
			self:SecureHook(_G.LightHeadedFrameSub.prev, "Enable", function(this, _)
				self:clrBtnBdr(this, "gold")
			end)
			self:SecureHook(_G.LightHeadedFrameSub.next, "Disable", function(this, _)
				self:clrBtnBdr(this, "gold")
			end)
			self:SecureHook(_G.LightHeadedFrameSub.next, "Enable", function(this, _)
				self:clrBtnBdr(this, "gold")
			end)
		end
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.LightHeadedTooltip)
		end)

		self:Unhook(_G.LightHeadedFrame, "OnShow")
	end)

end
