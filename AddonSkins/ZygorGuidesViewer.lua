local aName, aObj = ...
if not aObj:isAddonEnabled("ZygorGuidesViewer") then return end
local _G = _G

aObj.addonsToSkin.ZygorGuidesViewer = function(self) -- v 8.0

	local ZGV = _G.ZygorGuidesViewer

	-- Hook this to skin frames
	self:RawHook(ZGV.UI, "Create", function(this, uiType, parent, name, ...)
		-- aObj:Debug("ZGV.UI Create: [%s, %s, %s, %s, %s]", this, uiType, parent, name, ...)
		local obj = self.hooks[this].Create(this, uiType, parent, name, ...)
		if uiType == "Frame" then
			self:removeBackdrop(obj, true)
			self:skinObject("frame", {obj=obj, kfs=true})
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
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But01}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But02}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But03}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But04}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But05}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But06}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But07}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But08}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But09}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But10}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But11}
			self:skinCheckButton{obj=_G.ZygorGuidesViewerMaintenanceFrame_But12}
		end
		
		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ZygorGuidesViewerMaintenanceFrame)

	if ZGV.ItemScore.GearFinder then
		self:SecureHook(ZGV.ItemScore.GearFinder, "CreateSystemTab", function(this)
			self:skinObject("tabs", {obj=this, tabs={this.BlizzardTab}, lod=self.isTT and true, offsets={x1=8, y1=self.isTT and 2 or -3, x2=-8, y2=2}, track=false})
			self:setInactiveTab(this.BlizzardTab.sf)
			_G.CharacterFrame.numTabs = 4
			
			self:Unhook(ZGV.ItemScore.GearFinder, "CreateSystemTab")
		end)
		self:SecureHook(ZGV.ItemScore.GearFinder, "CreateMainFrame", function(this)
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

	self:removeBackdrop(_G.DropDownForkList1MenuBackdrop, true)
	self:skinObject("frame", {obj=_G.DropDownForkList1, kfs=true})
	self:removeBackdrop(_G.DropDownForkList2MenuBackdrop, true)
	self:skinObject("frame", {obj=_G.DropDownForkList2, kfs=true})

	_G.ZygorGuidesViewerMapIcon:SetSize(32, 32)
	self.mmButs["ZygorGuidesViewer"] = _G.ZygorGuidesViewerMapIcon
	
	-- skin frame buttons here as required
	if self.modBtns then
		self:SecureHook(ZGV.BugReport.StepFeedback, "CreateFrame", function(this)
			self:skinStdButton{obj=this.Frame.buttonsubmit}
			
			self:Unhook(ZGV.BugReport.StepFeedback, "CreateFrame")
		end)
	end
	
	-- remove dropdown skin
	self:SecureHook(ZGV.GuideMenu, "CreateFrames", function(this)
		local dd = this.MainFrame.FullColumnFeatured.Dropdown.dropdown
		dd.sf:Hide()
		dd.ddTex:Hide()
		dd.Button.sbb:Hide()
		dd.sf = nil
		dd.ddTex = nil
		dd.Button.sbb = nil
		dd = nil
		
		self:Unhook(ZGV.GuideMenu, "CreateFrames")
	end)

end

aObj.otherAddons.Ace3Z = function(self) -- v 34
	if self.initialized.Ace3Z then return end
	self.initialized.Ace3Z = true

	local AceGUIZ = _G.LibStub("AceGUI-3.0-Z", true)

	local function skinAceGUIZ(obj, objType)

		local objVer = AceGUIZ.GetWidgetVersion and AceGUIZ:GetWidgetVersion(objType) or 0

		if obj
		and not obj.sknd
		then
			if objType == "Button-Z" then
				if aObj.modBtns then
					aObj:removeBackdrop(obj.frame)
					aObj:skinStdButton{obj=obj.frame}
					aObj:secureHook(obj.frame, "Disable", function(this, _)
						aObj:clrBtnBdr(this)
					end)
					aObj:secureHook(obj.frame, "Enable", function(this, _)
						aObj:clrBtnBdr(this)
					end)
				end
			elseif objType == "Dropdown-Z" then
				aObj:skinAceDropdown(obj, nil, 1)
			elseif objType == "Dropdown-Pullout-Z" then
				-- aObj:applySkin{obj=obj.frame}
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
					aObj:removeBackdrop(obj.button)
					aObj:skinStdButton{obj=obj.button}--, as=true}
				end
			elseif objType == "MultiLineEditBox-Z" then
				aObj:skinObject("slider", {obj=obj.scrollBar})
				aObj:removeBackdrop(obj.scrollBG, true)
				aObj:skinObject("frame", {obj=obj.scrollBG})
				if aObj.modBtns then
					aObj:removeBackdrop(obj.button)
					aObj:skinStdButton{obj=obj.button, ofs=0, y1=-2, y2=-2}
					aObj:secureHook(obj.button, "Disable", function(this, _)
						aObj:clrBtnBdr(this)
					end)
					aObj:secureHook(obj.button, "Enable", function(this, _)
						aObj:clrBtnBdr(this)
					end)
				end
			elseif objType == "ScrollFrame-Z" then
				aObj:skinObject("slider", {obj=obj.scrollbar})
			elseif objType == "SliderLabeled-Z" then
				aObj:removeBackdrop(obj.slider)
				aObj:skinObject("slider", {obj=obj.slider})
			-- ignore these types for now
			elseif objType == "CheckBox-Z"
			or objType == "Dropdown-Item-Execute-Z"
			or objType == "Dropdown-Item-Toggle-Z"
			or objType == "Label-Z"
			or objType == "SimpleGroup-Z"
			then
				-- aObj:Debug("Ignoring: [%s]", objType)
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
