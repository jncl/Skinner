local _, aObj = ...
if not aObj:isAddonEnabled("Stash") then return end
local _G = _G

aObj.addonsToSkin.Stash = function(self) -- v 1.0.3

	local function skinPanel(pObj)
		aObj:removeInset(pObj.Top)
		aObj:removeInset(pObj.Bottom)
		if pObj.List then
			aObj:removeInset(pObj.List.Background)
			aObj:skinObject("slider", {obj=pObj.List.ScrollFrame.ScrollBar})
		elseif pObj.Content then
			aObj:removeInset(pObj.Content)
		end
		if aObj.modBtns
		and pObj.Bottom.BackButton
		then
			aObj:skinStdButton{obj=pObj.Bottom.BackButton}
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=pObj.Top.SettingsToggle, ofs=1, clr="grey"}
		end
	end
	local function skinDD(ddObj)
		ddObj.LeftTexture = aObj:getRegion(ddObj, 1)
		ddObj.RightTexture = aObj:getRegion(ddObj, 2)
		aObj:skinObject("dropdown", {obj=ddObj, noBB=true, x1=0, y1=0, x2=0, y2=0})
		ddObj.ddTex:SetPoint("LEFT", ddObj.LeftTexture, "RIGHT", -20, 0)
		ddObj.ddTex:SetPoint("RIGHT", ddObj.RightTexture, "LEFT", 3, 0)
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=ddObj, relTo=ddObj.DownButton, clr="grey"}
		end
		aObj:removeNineSlice(ddObj.subMenu.NineSlice)
		aObj:skinObject("frame", {obj=ddObj.subMenu})
		aObj:removeNineSlice(ddObj.subMenu.subMenu.NineSlice)
		aObj:skinObject("frame", {obj=ddObj.subMenu.subMenu})
		aObj:removeNineSlice(ddObj.subMenu.subMenu.subMenu.NineSlice)
		aObj:skinObject("frame", {obj=ddObj.subMenu.subMenu.subMenu})
	end
	self:SecureHookScript(_G.StashFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=1})
		skinPanel(this.itemsPanel)
		self:skinObject("editbox", {obj=this.itemsPanel.Top.SearchBox, ofs=0, mix=24, inset=0})
		if self.modBtnBs then
			self:addButtonBorder{obj=this.itemsPanel.Top.FilterToggle, ofs=1, clr="grey"}
		end
		skinPanel(this.settingsPanel)
		self:SecureHook(this.settingsPanel.List, "Update", function(sfObj)
			for _, btn in _G.pairs(sfObj.ScrollFrame.Buttons) do
				if self.modBtns then
					self:skinStdButton{obj=btn.ResetButton}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=btn.CheckButton}
				end
			end
		end)
		skinPanel(this.moneyPanel)
		skinPanel(this.confirmPanel)
		if self.modBtns then
			self:skinStdButton{obj=this.confirmPanel.Bottom.AcceptButton}
		end
		local fPanel = this.itemsPanel.Top.FilterPanel
		skinDD(fPanel.LocationDropDown)
		skinDD(fPanel.TypeDropDown)
		if self.modBtns then
			self:skinStdButton{obj=fPanel.ResetButton.Button}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=fPanel.SearchTypesCheckButton.CheckButton}
			self:skinCheckButton{obj=fPanel.CurrentRealmCheckButton.CheckButton}
			self:skinCheckButton{obj=fPanel.SortByRarityCheckButton.CheckButton}
		end

		self:Unhook(this, "OnShow")
	end)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.StashGameTooltip)
		self:add2Table(self.ttList, _G.StashMoneyTooltip)
	end)

end
