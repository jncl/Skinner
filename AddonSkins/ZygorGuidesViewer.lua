local _, aObj = ...
if not aObj:isAddonEnabled("ZygorGuidesViewer") then return end
local _G = _G

aObj.addonsToSkin.ZygorGuidesViewer = function(self) -- v 9.5.32183

	local ZGV = _G.ZygorGuidesViewer

	-- Hook this to skin frames
	self:RawHook(ZGV.UI, "Create", function(this, uiType, parent, name, ...)
		-- aObj:Debug("ZGV.UI Create: [%s, %s, %s, %s, %s]", this, uiType, parent, name, ...)
		local obj = self.hooks[this].Create(this, uiType, parent, name, ...)
		if uiType == "Frame" then
			_G.C_Timer.After(0.2, function()
				if _G.Round(obj:GetHeight()) > 12 then -- N.B. DON't skin separator line(s) or progress bar BG
					self:removeBackdrop(obj, true)
					self:skinObject("frame", {obj=obj, kfs=true})
				end
			end)
		end
		return obj
	end, true)

	self:skinObject("frame", {obj=_G.ZygorGuidesViewerFrame, kfs=true, ofs=4})

	self:SecureHookScript(_G.ZygorGuidesViewerMaintenanceFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=4, x2=7})
		if self.modBtns then
			self:skinCloseButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_CloseButton}
			self:skinStdButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_Bug}
		end
		if self.modChkBtns then
			for i = 1, 12 do
				self:skinCheckButton{obj=_G["ZygorGuidesViewerMaintenanceFrame_But" .. i:format("%02d")]}
			end
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ZygorGuidesViewerMaintenanceFrame)

	if ZGV.ItemScore.GearFinder then
		self:SecureHook(ZGV.ItemScore.GearFinder, "CreateMainFrame", function(this)
			if this.BlizzardTab then
				self:skinObject("tabs", {obj=this.MainFrame, tabs={this.BlizzardTab}, lod=self.isTT and true, offsets={x1=8, y1=self.isTT and 2 or -3, x2=-8, y2=2}, track=false})
				self:setInactiveTab(this.BlizzardTab.sf)
				_G.CharacterFrame.numTabs = 4
			end
			self:removeBackdrop(this.MainFrame.CenterColumn)
			self:skinObject("frame", {obj=this.MainFrame, kfs=true, cbns=true})
			if self.modBtnBs then
				for _, btn in _G.pairs(this.MainFrame.Buttons) do
					self:addButtonBorder{obj=btn.tooltiphandler}
				end
			end

			self:Unhook(ZGV.ItemScore.GearFinder, "CreateMainFrame")
		end)
	end

	self.mmButs["ZygorGuidesViewer"] = _G.ZygorGuidesViewerMapIcon

	-- skin frame buttons here as required
	if self.modBtns then
		self:SecureHook(ZGV.BugReport.StepFeedback, "CreateFrame", function(this)
			self:skinStdButton{obj=this.Frame.buttonsubmit}

			self:Unhook(ZGV.BugReport.StepFeedback, "CreateFrame")
		end)
	end

	self:SecureHook(ZGV.GuideMenu, "CreateFrames", function(this)
		self:skinObject("frame", {obj=this.MainFrame.MenuGuides.SearchEdit.back, bd=4, ng=true, ofs=2, clr="slider"})

		_G.C_Timer.After(1, function()
			local ddFrame = this.MainFrame.FullColumnFeatured.Dropdown.dropdown
			ddFrame.sf:ClearAllPoints()
			ddFrame.sf:SetPoint("TOPLEFT", ddFrame, "TOPLEFT", 12, 2)
			ddFrame.sf:SetPoint("BOTTOMRIGHT", ddFrame, "BOTTOMRIGHT", -17, -2)
			if self.modBtnBs then
				local ddButton = _G[ddFrame:GetName() .. "Button"]
				ddButton.sbb:ClearAllPoints()
				ddButton.sbb:SetPoint("TOPLEFT", ddButton, "TOPLEFT", 2, 0)
				ddButton.sbb:SetPoint("BOTTOMRIGHT", ddButton, "BOTTOMRIGHT", 2, 0)
			end
			if ddFrame.ddTex then
				ddFrame.ddTex:ClearAllPoints()
				ddFrame.ddTex:SetPoint("TOPLEFT", ddFrame.sf, "TOPLEFT", 4, -4)
				ddFrame.ddTex:SetPoint("BOTTOMRIGHT", ddFrame.sf, "BOTTOMRIGHT", -4, 4)
			end
		end)

		self:Unhook(this, "CreateFrames")
	end)

	self:skinObject("ddlist", {obj=_G.DropDownForkList1, nop=true})
	self:skinObject("ddlist", {obj=_G.DropDownForkList2, nop=true})

	self:SecureHook("UIDropDownFork_CreateFrames", function(level, _)
		for i = 1, level do
			self:skinObject("ddlist", {obj=_G["DropDownForkList" .. i], nop=true})
		end
	end)

end

aObj.otherAddons.Ace3Z = function(self) -- v 41
	if self.initialized.Ace3Z then return end
	self.initialized.Ace3Z = true

	local AceGUIZ = _G.LibStub:GetLibrary("AceGUI-3.0-Z", true)

	local function skinAceGUIZ(obj, objType)
		-- local objVer = AceGUIZ.GetWidgetVersion and AceGUIZ:GetWidgetVersion(objType) or 0
		if obj
		-- and not obj.sknd
		then
			if objType == "Button-Z" then
				if aObj.modBtns then
					aObj:removeBackdrop(obj.frame, true)
					aObj:skinStdButton{obj=obj.frame, schk=true}
				end
			elseif objType == "Dropdown-Z" then
				aObj:skinAceDropdown(obj, nil, 1)
			elseif objType == "Dropdown-Pullout-Z" then
				aObj:skinObject("slider", {obj=obj.slider})
				-- ensure skinframe is behind thumb texture
				obj.slider.sf.SetFrameLevel = _G.nop
			elseif objType == "EditBox-Z" then
				aObj:skinObject("editbox", {obj=obj.editbox, ofs=0, x1=-2})
				-- hook this as insets are changed
				aObj:rawHook(obj.editbox, "SetTextInsets", function(this, left, ...)
					return left + 6, ...
				end, true)
				if aObj.modBtns then
					aObj:removeBackdrop(obj.button, true)
					aObj:skinStdButton{obj=obj.button}
				end
			elseif objType == "MultiLineEditBox-Z" then
				aObj:skinObject("slider", {obj=obj.scrollBar})
				aObj:removeBackdrop(obj.scrollBG, true)
				aObj:skinObject("frame", {obj=obj.scrollBG, fb=true})
				if aObj.modBtns then
					aObj:removeBackdrop(obj.button, true)
					aObj:skinStdButton{obj=obj.button, ofs=0, y1=-2, y2=-2, schk=true}
				end
			elseif objType == "ScrollFrame-Z" then
				aObj:skinObject("slider", {obj=obj.scrollbar})
			elseif objType == "SliderLabeled-Z" then
				aObj:removeBackdrop(obj.slider, true)
				aObj:skinObject("slider", {obj=obj.slider})
			-- ignore these types for now
			elseif objType == "CheckBox-Z"
			or objType == "Dropdown-Item-Execute-Z"
			or objType == "Dropdown-Item-Toggle-Z"
			or objType == "Label-Z"
			or objType == "SimpleGroup-Z"
			then
				-- aObj:Debug("Ignoring: [%s]", objType)
				_G.nop()
			else
				aObj:Debug("AceGUIZ, unmatched type - %s", objType)
			end
		end

	end

	self:RawHook(AceGUIZ, "Create", function(this, objType)
		local obj = self.hooks[this].Create(this, objType)
		skinAceGUIZ(obj, objType)
		return obj
	end, true)

end

_G.C_Timer.After(0.1, function()
	aObj:checkAndRun("Ace3Z", "o")
end)
