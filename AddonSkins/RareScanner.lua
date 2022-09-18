local _, aObj = ...
if not aObj:isAddonEnabled("RareScanner") then return end
local _G = _G

aObj.addonsToSkin.RareScanner = function(self) -- v 9.2.7/3.4.0.1

	if self.isRtl then
		-- EditBox on WorldMapFrame
		for _, child in _G.pairs{_G.WorldMapFrame:GetChildren()} do
			if child.EditBox then
				self:skinObject("editbox", {obj=child.EditBox, ofs=0})
				self:adjHeight{obj=child.EditBox, adj=-10}
				break
			end
		end
		self:SecureHookScript(_G.RSExplorerFrame, "OnShow", function(this)
			this.OverlayElements.CloseButtonBorder:SetTexture(nil)
			self:removeNineSlice(this.RaisedBorder)
			self:skinObject("dropdown", {obj=_G.FilterDropDown})
			self:skinObject("dropdown", {obj=_G.ContinentDropDown})
			this.RareNPCList.background:SetTexture(nil)
			self:skinObject("slider", {obj=this.RareNPCList.listScroll.scrollBar})
			this.RareNPCList.ElevatedFrame:DisableDrawLayer("OVERLAY")
			for _, btn in _G.pairs(this.RareNPCList.listScroll.buttons) do
				btn.RareNPC.BG:SetTexture(nil)
			end
			self:skinObject("frame", {obj=this.RareNPCList, fb=true})
			this.RareInfo:DisableDrawLayer("BORDER")
			this.RareInfo.RaisedFrameEdges:DisableDrawLayer("BORDER")
			for _, type	in _G.pairs{"Mounts", "Pets", "Toys", "Appearances"} do
				this.RareInfo[type].Background1:SetTexture(nil)
				this.RareInfo[type].NoItems:SetTextColor(self.BT:GetRGB())
				-- TODO: Add quality button border to icon(s)
			end
			self:skinObject("frame", {obj=this.RareInfo, fb=true, x1=-5, y1=-1, x2=0, y2=-7})
			self:skinObject("frame", {obj=this, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.Filters.RestartScanningButton}
				self:skinStdButton{obj=this.Control.ApplyFiltersButton}
				self:skinStdButton{obj=this.ScanRequired.StartScanningButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.Control.AutoFilterCheckButton}
				self:skinCheckButton{obj=this.Control.FilterWorldmapCheckButton}
				self:skinCheckButton{obj=this.Control.CreateProfilesBackupCheckButton}
			end

			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHookScript(_G.scanner_button, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, sft=true, cbns=true})
		if self.modBtns then
			self:skinOtherButton{obj=this.FilterDisabledButton, text=self.modUIBtns.minus, noSkin=true}
			self:skinOtherButton{obj=this.FilterEnabledButton, text=self.modUIBtns.plus, noSkin=true}
		end
		-- TODO: skin loot buttons

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.scanner_button)

	_G.C_Timer.After(0.1, function()
		if self.isRtl then
			self:add2Table(self.ttList, _G.RSExplorerFrame.Tooltip)
		end
		self:add2Table(self.ttList, _G.scanner_button.LootBar.LootBarToolTip)
		self:add2Table(self.ttList, _G.scanner_button.LootBar.LootBarToolTipComp1)
		self:add2Table(self.ttList, _G.scanner_button.LootBar.LootBarToolTipComp2)
		self:add2Table(self.ttList, _G.RSMapItemToolTip)
		self:add2Table(self.ttList, _G.RSMapItemToolTipComp1)
		self:add2Table(self.ttList, _G.RSMapItemToolTipComp2)
	end)

end
