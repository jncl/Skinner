local _, aObj = ...
if not aObj:isAddonEnabled("ACP") then return end
local _G = _G

aObj.addonsToSkin.ACP = function(self) -- v 3.5.7

	self:SecureHookScript(_G.ACP_AddonList, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.ACP_AddonListSortDropDown, x2=109})
		self:skinObject("slider", {obj=_G.ACP_AddonList_ScrollFrame.ScrollBar, rpTex="background"})
		self:skinObject("frame", {obj=this, kfs=true, hdr=true, cb=true, ofs=-6, x2=-45, y2=12})
		self:moveObject{obj=_G.ACP_AddonListHeader, y=-3}
		if self.modBtns then
			local function checkTex(btn, tex)
				if tex:find("ZoomInButton") then
					btn:SetText(aObj.modUIBtns.plus)
				else
					btn:SetText(aObj.modUIBtns.minus)
				end
			end
			self:skinStdButton{obj=_G.ACP_AddonListDisableAll}
			self:skinStdButton{obj=_G.ACP_AddonListEnableAll}
			self:skinStdButton{obj=_G.ACP_AddonListSetButton}
			self:skinStdButton{obj=_G.ACP_AddonList_ReloadUI}
			self:skinStdButton{obj=_G.ACP_AddonListBottomClose}
			self:skinExpandButton{obj=_G["ACP_AddonListCollapseAll"], ofs=0, noHook=true}
			self:SecureHook(_G["ACP_AddonListCollapseAllIcon"], "SetTexture", function(this, nTex)
				checkTex(_G["ACP_AddonListCollapseAll"], nTex)
			end)
			for i = 1, 20 do
				self:skinStdButton{obj=_G["ACP_AddonListEntry" .. i .. "LoadNow"]}
				self:adjHeight{obj=_G["ACP_AddonListEntry" .. i .. "LoadNow"], adj=4}
				self:skinExpandButton{obj=_G["ACP_AddonListEntry" .. i .. "Collapse"], ofs=0, noHook=true}
				self:SecureHook(_G["ACP_AddonListEntry" .. i .. "CollapseIcon"], "SetTexture", function(this, nTex)
					checkTex(_G["ACP_AddonListEntry" .. i .. "Collapse"], nTex)
				end)
			end
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.ACPAddonListForceLoad}
			self:skinCheckButton{obj=_G.ACP_AddonList_NoRecurse}
			for i = 1, 20 do
				self:skinCheckButton{obj=_G["ACP_AddonListEntry" .. i .. "Enabled"]}
				_G["ACP_AddonListEntry" .. i .. "Enabled"]:SetSize(24, 24)
				self:RawHook(_G["ACP_AddonListEntry" .. i .. "Enabled"], "SetWidth", function(this, width)
					self.hooks[this].SetWidth(this, 24)
				end, true)
				self:RawHook(_G["ACP_AddonListEntry" .. i .. "Enabled"], "SetHeight", function(this, height)
					self.hooks[this].SetHeight(this, 24)
				end, true)
			end
		end

		self:Unhook(this, "OnShow")
	end)

end
