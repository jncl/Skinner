local _, aObj = ...
if not aObj:isAddonEnabled("RareScanner") then return end
local _G = _G

aObj.addonsToSkin.RareScanner = function(self) -- v 10.0.2.6/3.4.0.1

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
			local function initFrames(frame)
				aObj:skinObject("dropdown", {obj=frame.Filters.FilterDropDown})
				aObj:skinObject("dropdown", {obj=frame.Filters.ContinentDropDown})
				for _, btn in _G.pairs(frame.RareNPCList.listScroll.buttons) do
					btn.RareNPC.BG:SetTexture(nil)
					btn.RareNPC.NameBG:SetTexture(nil)
				end
			end
			if not this.Filters.FilterDropDown then
				self:SecureHook(this, "Initialize", function(fObj)
					initFrames(fObj)
					self:Unhook(fObj, "Initialize")
				end)
			else
				initFrames(this)
			end
			this.RareNPCList.background:SetTexture(nil)
			self:skinObject("slider", {obj=this.RareNPCList.listScroll.scrollBar})
			this.RareNPCList.ElevatedFrame:DisableDrawLayer("OVERLAY")
			self:skinObject("frame", {obj=this.RareNPCList, fb=true, ofs=0})
			this.RareInfo:DisableDrawLayer("BORDER")
			this.RareInfo.RaisedFrameEdges:DisableDrawLayer("BORDER")
			for _, type	in _G.pairs{"Mounts", "Pets", "Toys", "Appearances"} do
				this.RareInfo[type].Background1:SetTexture(nil)
				this.RareInfo[type].NoItems:SetTextColor(self.BT:GetRGB())
			end
			self:skinObject("frame", {obj=this.RareInfo, fb=true, x1=-5, y1=6, x2=4, y2=-9})
			self:skinObject("frame", {obj=this.ScanRequired, kfs=true, cb=true})
			self:skinObject("frame", {obj=this, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.Filters.RestartScanningButton}
				self:skinStdButton{obj=this.Control.ApplyFiltersButton}
				self:skinStdButton{obj=this.ScanRequired.StartScanningButton}
			end
			if self.modBtnBs then
				local function skinBtns(frame)
					for btn in frame.lootItemsPool:EnumerateActive() do
						aObj:addButtonBorder{obj=btn, clr="grey"}
					end
				end
				self:SecureHook(this.RareNPCList, "SelectNpc", function(fObj, npcID)
					skinBtns(fObj:GetParent())
				end)
				skinBtns(this)
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
