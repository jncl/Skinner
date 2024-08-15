local _, aObj = ...
if not aObj:isAddonEnabled("RareScanner") then return end
local _G = _G

aObj.addonsToSkin.RareScanner = function(self) -- v 11.0.2.2/4.4.0.5

	-- EditBox on WorldMapFrame
	self.RegisterCallback("RareScanner", "WorldMapFrame_GetChildren", function(_, child, _)
		if child.EditBox then
			self:skinObject("editbox", {obj=child.EditBox, ofs=0})
			self:adjHeight{obj=child.EditBox, adj=-10}
			if self.isRtl then
				self:moveObject{obj=child.EditBox, y=10}
			end
			self.UnregisterCallback("RareScanner", "WorldMapFrame_GetChildren")
		end
	end)
	self:scanChildren("WorldMapFrame")

	self:SecureHookScript(_G.RSExplorerFrame, "OnShow", function(this)
		if self.isRtl then
			this.Border:DisableDrawLayer("OVERLAY")
		end
		this.OverlayElements.CloseButtonBorder:SetTexture(nil)
		self:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=self.isRtl and 0 or 2})
		if self.modBtns then
			self:skinStdButton{obj=this.ScanRequired.StartScanningButton}
		end

		self:SecureHookScript(this.Filters, "OnShow", function(fObj)
			if self.isRtl then
				aObj:skinObject("ddbutton", {obj=fObj.FilterDropDown, filter=true})
				aObj:skinObject("ddbutton", {obj=fObj.ContinentDropDown})
			else
				aObj:skinObject("dropdown", {obj=fObj.FilterDropDown})
				aObj:skinObject("dropdown", {obj=fObj.ContinentDropDown})
			end
			if self.modBtns then
				self:skinStdButton{obj=fObj.RestartScanningButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.Filters.LockCurrentZoneCheckButton}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Filters)

		self:SecureHookScript(this.RareNPCList, "OnShow", function(fObj)
			fObj.background:SetTexture(nil)
			self:skinObject("slider", {obj=fObj.listScroll.scrollBar})
			fObj.ElevatedFrame:DisableDrawLayer("OVERLAY")
			self:skinObject("frame", {obj=fObj, fb=true, ofs=0})
			for _, btn in _G.pairs(fObj.listScroll.buttons) do
				btn.RareNPC.BG:SetTexture(nil)
				btn.RareNPC.NameBG:SetTexture(nil)
			end
			if self.modBtnBs then
				local function skinLIBtns()
					for btn in this.lootItemsPool:EnumerateActive() do
						aObj:addButtonBorder{obj=btn}
						-- TODO: Colour the button border ?
					end
				end
				self:SecureHook(fObj, "SelectNpc", function(_, _)
					skinLIBtns()
				end)
				skinLIBtns()
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.RareNPCList)

		self:SecureHookScript(this.RareInfo, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BORDER")
			local rareTypes = {"Mounts", "Pets", "Toys", "Custom", "Appearances"}
			if self.isRtl then
				fObj.Border:DisableDrawLayer("OVERLAY")
				self:add2Table(rareTypes, "Drakewatcher")
			else
				fObj.Header:SetPoint("TOPLEFT", 4, 0)
			end
			for _, type	in _G.pairs(rareTypes) do
				fObj[type].Background1:SetTexture(nil)
			end
			self:skinObject("frame", {obj=fObj, fb=true, ofs=self.isClsc and 1 or 0, x2=self.isClsc and 5 or nil})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.RareInfo)

		self:SecureHookScript(this.Control, "OnShow", function(fObj)
			if self.modBtns then
				self:skinStdButton{obj=this.Control.ApplyFiltersButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.Control.AutoFilterCheckButton}
				self:skinCheckButton{obj=this.Control.CreateProfilesBackupCheckButton}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Control)

		self:SecureHookScript(this.CustomLoot, "OnShow", function(fObj)
			if self.isRtl then
				fObj.Border:DisableDrawLayer("OVERLAY")
				self:skinObject("ddbutton", {obj=fObj.ControlFrame.LootGroupDropDown})
			else
				self:skinObject("dropdown", {obj=fObj.ControlFrame.LootGroupDropDown})
			end
			self:skinObject("editbox", {obj=fObj.ControlFrame.NewGroup})
			self:skinObject("editbox", {obj=fObj.ControlFrame.ItemList})
			self:skinObject("slider", {obj=fObj.GroupList.listScroll.scrollBar})
			-- TODO: skin the scroll buttons ?
			fObj.GroupList.ElevatedFrame:DisableDrawLayer("OVERLAY")
			fObj.GroupInfo.BG:SetTexture(nil)
			fObj.GroupInfo.NoItems:SetTextColor(self.BT:GetRGB())
			self:skinObject("editbox", {obj=fObj.GroupInfo.EditGroupName})
			self:skinObject("frame", {obj=fObj, kfs=true, fb=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.GroupInfo.DeleteGroup}
			end
			if self.modBtnBs then
				local function skinGLBtns()
					for btn in fObj.GroupInfo.lootItemsPool:EnumerateActive() do
						aObj:addButtonBorder{obj=btn}
						-- TODO: Colour the button border ?
					end
				end
				self:SecureHook(fObj, "SelectGroup", function(_, _)
					skinGLBtns()
				end)
				skinGLBtns()
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CustomLoot)

		self:Unhook(this, "OnShow")
	end)

	local scanner_button = _G.RARESCANNER_BUTTON or _G.scanner_button
	self:SecureHookScript(scanner_button, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, sft=true, cbns=true})
		if self.modBtns then
			self:skinOtherButton{obj=this.FilterEntityButton, text=self.modUIBtns.minus, noSkin=true}
			-- self:skinOtherButton{obj=this.UnfilterEnabledButton, text=self.modUIBtns.plus, noSkin=true}
		end
		-- TODO: skin loot buttons

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(scanner_button)

	_G.C_Timer.After(0.1, function()
		if self.isRtl then
			self:add2Table(self.ttList, _G.RSExplorerFrame.Tooltip)
		else
			self:add2Table(self.ttList, _G.ExplorerTooltip)
		end
		self:add2Table(self.ttList, scanner_button.LootBar.LootBarToolTip)
		self:add2Table(self.ttList, scanner_button.LootBar.LootBarToolTipComp1)
		self:add2Table(self.ttList, scanner_button.LootBar.LootBarToolTipComp2)
		self:add2Table(self.ttList, _G.RSMapItemToolTip)
		self:add2Table(self.ttList, _G.RSMapItemToolTipComp1)
		self:add2Table(self.ttList, _G.RSMapItemToolTipComp2)
		if _G["AceConfigDialogTooltip-RSmod"] then
			self:add2Table(self.ttList, _G["AceConfigDialogTooltip-RSmod"])
		end
	end)

end
