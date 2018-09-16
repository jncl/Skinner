local aName, aObj = ...
if not aObj:isAddonEnabled("ZygorGuidesViewer") then return end
local _G = _G

aObj.addonsToSkin.ZygorGuidesViewer = function(self) -- v 6.1.18339

	local ZGV = _G.ZygorGuidesViewer

	-- Hook this to skin frames
	self:RawHook(ZGV.UI, "Create", function(this, uiType, parent, name, ...)
		-- aObj:Debug("ZGV.UI Create: [%s, %s, %s, %s, %s]", this, uiType, parent, name, ...)
		local obj = self.hooks[this].Create(this, uiType, parent, name, ...)
		if uiType == "Frame" then
			self:addSkinFrame{obj=obj, ft="a", kfs=true, nb=true, ofs=4}
		elseif (uiType == "Button" and obj:GetParent().acceptbutton) then -- this is a popup
			self:skinStdButton{obj=obj}
			self:skinStdButton{obj=obj:GetParent().acceptbutton}
		end
		return obj
	end, true)
	self:RawHook(ZGV, "ChainCall", function(obj)
		-- aObj:Debug("ZGV ChainCall: [%s, %s]", obj, obj:GetObjectType())
		local object = self.hooks[ZGV].ChainCall(obj)
		if obj:GetObjectType() == "Frame"
		and (obj:GetName() and not obj:GetName():find("PointerOverlay"))
		then
			self:addSkinFrame{obj=obj, ft="a", kfs=true, nb=true, ofs=4}
			obj.SetBackdrop = _G.nop
		end
		return object
	end, true)

	-- Notification_Center
	self:SecureHook(ZGV.NotificationCenter, "CreateNotificationFrame", function(this)
		self:addSkinFrame{obj=_G.Zygor_Notification_Center, ft="a", kfs=true, nb=true, ofs=4}
		self:Unhook(this, "CreateNotificationFrame")
	end)

	-- Viewer frame
	_G.ZygorGuidesViewerFrame:SetBackdrop(nil)
	_G.ZygorGuidesViewerFrame_Border:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.ZygorGuidesViewerFrame, ft="a", kfs=true, nb=true, ofs=4}

	-- Gear Finder
	_G.CharacterFrame:HookScript("OnShow", function() -- N.B. CharacterFrame OnShow script already hooked elsewhere
		if _G.ZygorGearFinderFrame
		and not _G["PaperDollSidebarTab" .. 4]
		then
			_G["PaperDollSidebarTab" .. 4] = _G.ZGVCharacterGearFinderButton -- set here so .sbb is shown
			local tab = _G["PaperDollSidebarTab" .. 4]
			-- use a button border to indicate the active tab
			self.modUIBtns:addButtonBorder{obj=tab, relTo=tab.Icon, x1=-6, y1=9, x2=7, y2=-4} -- use module function here to force creation
			self:keepFontStrings(_G.ZygorGearFinderFrame)
			self:skinSlider{obj=_G.ZygorGearFinderFrameScrollBar}
			for i = 1, #_G.ZygorGearFinderFrame.Items do
				local btn = _G.ZygorGearFinderFrame.Items[i]
				btn.BgTop:SetTexture(nil)
				btn.BgBottom:SetTexture(nil)
				btn.BgMiddle:SetTexture(nil)
			end
			_G.PAPERDOLL_SIDEBARS[4].IsActive = function() return true end
			tab = nil
		end
	end)

	-- Maintenance Frame
	self:addSkinFrame{obj=_G.ZygorGuidesViewerMaintenanceFrame, ft="a", kfs=true, nb=true}

	-- DropDownForkLists
	_G.DropDownForkList1MenuBackdrop:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.DropDownForkList1, ft="a", kfs=true, nb=true}
	_G.DropDownForkList2MenuBackdrop:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.DropDownForkList2, ft="a", kfs=true, nb=true}

	-- minimap button
	_G.ZygorGuidesViewerMapIcon:SetSize(32, 32)
	self.mmButs["ZygorGuidesViewer"] = _G.ZygorGuidesViewerMapIcon

end

aObj.otherAddons.Ace3Z = function(self)
	if self.initialized.Ace3Z then return end
	self.initialized.Ace3Z = true

	local AceGUIZ = _G.LibStub("AceGUI-3.0-Z", true)

	local function skinAceGUIZ(obj, objType)

		local objVer = AceGUIZ.GetWidgetVersion and AceGUIZ:GetWidgetVersion(objType) or 0

		if obj
		and not obj.sknd
		then
			if objType == "Dropdown-Z" then
				aObj:skinDropDown{obj=obj.dropdown, rp=true, y2=0}
				aObj:applySkin{obj=obj.pullout.frame}
			elseif objType == "Dropdown-Pullout-Z" then
				aObj:applySkin{obj=obj.frame}
			elseif objType == "EditBox-Z" then
				aObj:skinEditBox{obj=obj.editbox, regs={9}, noHeight=true}
				if not aObj:IsHooked(obj.editbox, "SetTextInsets") then
					aObj:RawHook(obj.editbox, "SetTextInsets", function(this, left, right, top, bottom)
						return left + 6, right, top, bottom
					end, true)
				end
				aObj:skinButton{obj=obj.button, as=true}
			elseif objType == "MultiLineEditBox-Z" then
				aObj:skinStdButton{obj=obj.button, as=true}
				aObj:skinSlider{obj=obj.scrollFrame.ScrollBar, adj=-4, size=3}
				aObj:applySkin{obj=aObj:getChild(obj.frame, 2)} -- backdrop frame
			elseif objType == "Button-Z" then
				aObj:skinStdButton{obj=obj.frame, as=true} -- just skin it otherwise text is hidden
			elseif objType == "SliderLabeled-Z" then
				aObj:skinSlider{obj=obj.slider}
			elseif objType == "CheckBox-Z" then
				aObj:addButtonBorder{obj=obj.frame, ofs=-2, y2=3, relTo=obj.checkbg, reParent={obj.check}}
				obj.checkbg:SetTexture(nil)
			-- ignore these types for now
			elseif objType == "Dropdown-Item-Toggle-Z"
			or objType == "Label-Z"
			or objType == "ScrollFrame-Z"
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
