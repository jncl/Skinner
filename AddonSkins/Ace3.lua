local _, aObj = ...
-- This is a Framework
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.ItemPimper = true -- to stop IP skinning its frame

local objectsToSkin = {}
local AceGUI = _G.LibStub:GetLibrary("AceGUI-3.0", true)
if AceGUI then
	aObj:RawHook(AceGUI, "Create", function(this, objType)
		local obj = aObj.hooks[this].Create(this, objType)
		objectsToSkin[obj] = objType
		return obj
	end, true)
end

local skinAceGUI
aObj.libsToSkin["AceGUI-3.0"] = function(self) -- v AceGUI-3.0, 41
	if self.initialized.Ace3 then return end
	self.initialized.Ace3 = true

	function skinAceGUI(obj, objType)
		-- local objVer = AceGUI.GetWidgetVersion and AceGUI:GetWidgetVersion(objType) or 0
		-- if not objType:find("CollectMe") then
			-- aObj:Debug("skinAceGUI: [%s, %s, %s]", obj, objType, objVer)
		-- end
		-- if objType:find("TSM") then
			-- aObj:Debug("skinAceGUI: [%s, %s, %s, %s, %s, %s]", obj, objType, objVer, obj.sknd, objType:find("TSM"), obj.sknrTSM)
		-- end
		if obj
		-- and not obj.sknd
		-- and not (objType:find("TSM") and obj.sknrTSM) -- check objType as TSM overlays existing objects
		then
			-- aObj:Debug("Ace3 Skinning: [%s, %s, %s]", obj, objType)

			if objType == "Button" then
				if aObj.modBtns then
					-- TODO: handle PowerRaid reskinning buttons, DON't just nil out .sb as gradient is overloaded
					aObj:skinStdButton{obj=obj.frame, schk=true, x1=5, x2=-5}
				end

			elseif objType == "CheckBox" then
				if aObj.modChkBtns then
					-- force creation of button border so check texture can be reparented
					aObj.modUIBtns:addButtonBorder{obj=obj.frame, ofs=-2, relTo=obj.checkbg, reParent={obj.check}, clr="grey"}
					-- hide button border if Radio Button
					aObj:secureHook(obj, "SetType", function(this, type)
						if type == "radio"
						or _G.Round(this.checkbg:GetWidth()) == 16
						then
							this.check:SetParent(this.frame)
							this.frame.sbb:Hide()
						else
							this.check:SetParent(this.frame.sbb)
							this.frame.sbb:Show()
						end
					end)
					obj.checkbg:SetTexture(nil)
				end

			elseif objType == "ColorPicker" then
				obj.alignoffset = 10 -- align to neighbouring DropDowns

			elseif objType == "Dropdown" then
				aObj:skinAceDropdown(obj, nil, 1)

			elseif objType == "Dropdown-Pullout" then
				aObj:skinObject("slider", {obj=obj.slider})
				-- ensure skinframe is behind thumb texture
				obj.slider.sf.SetFrameLevel = _G.nop

			elseif objType == "DropdownGroup"
			or objType == "InlineGroup"
			or objType == "TabGroup"
			then
				aObj:skinObject("frame", {obj=obj.border or obj.content:GetParent(), kfs=true, fb=true, ofs=0})
				if objType == "TabGroup"
				and aObj.modBtns
				then
					aObj:secureHook(obj, "BuildTabs", function(this)
						aObj:skinObject("tabs", {obj=this.frame, tabs=obj.tabs, lod=self.isTT and true, upwards=true, regions=aObj.isRtl and {7} or nil, noCheck=true, track=false, offsets={x1=6, x2=-6, y2=-5}})
						aObj:Unhook(this, "BuildTabs")
					end)
					if aObj.isTT then
						aObj:secureHook(obj, "SelectTab", function(tgObj, value)
							for _, tab in _G.ipairs(tgObj.tabs) do
								if tab.value == value then
									aObj:setActiveTab(tab.sf)
								else
									aObj:setInactiveTab(tab.sf)
								end
							end
						end)
					end
				end

			elseif objType == "EditBox"
			or objType == "NumberEditBox"
			then
				aObj:skinObject("editbox", {obj=obj.editbox, ofs=0, x1=-2})
				-- hook this as insets are changed
				aObj:rawHook(obj.editbox, "SetTextInsets", function(_, left, ...)
					return left + 6, ...
				end, true)
				if aObj.modBtns then
					aObj:skinStdButton{obj=obj.button, as=true}
					if objType == "NumberEditBox" then
						aObj:skinStdButton{obj=obj.minus, as=true}
						aObj:skinStdButton{obj=obj.plus, as=true}
					end
				end

			elseif objType == "Frame" then
				-- status frame
				aObj:skinObject("frame", {obj=aObj:getChild(obj.frame, 2), fb=true, ofs=0, x1=2})
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
				aObj:skinObject("frame", {obj=obj.frame, kfs=true, rb=not aObj.isKC, ofs=0}) -- handle KongConfig backdrop issue
				if aObj.modBtns then
					aObj:skinStdButton{obj=aObj:getChild(obj.frame, 1), y1=1}
				end

			elseif objType == "Keybinding" then
				aObj:skinObject("frame", {obj=obj.msgframe})
				if aObj.modBtns then
					aObj:skinStdButton{obj=obj.button, as=true}
				end

			elseif objType == "MultiLineEditBox" then
				aObj:skinObject("slider", {obj=obj.scrollBar})
				aObj:removeBackdrop(obj.scrollBG)
				if aObj.modBtns then
					aObj:skinStdButton{obj=obj.button, schk=true, ofs=0, y1=-2, y2=-2}
				end

			elseif objType == "ScrollFrame" then
				aObj:removeRegions(obj.scrollbar, {2}) -- background texture
				aObj:skinObject("slider", {obj=obj.scrollbar})

			elseif objType == "Slider" then -- horizontal slider with editbox
				aObj:skinObject("editbox", {obj=obj.editbox})
				aObj:skinObject("slider", {obj=obj.slider})

			elseif objType == "TreeGroup" then
				aObj:skinObject("slider", {obj=obj.scrollbar})
				aObj:skinObject("frame", {obj=obj.border, fb=true, ofs=0})
				aObj:skinObject("frame", {obj=obj.treeframe, fb=true, ofs=0})
				if aObj.modBtns then
					-- hook to manage changes to button textures
					aObj:secureHook(obj, "RefreshTree", function(this)
						for _, btn in _G.pairs(this.buttons) do
							if not btn.toggle.sb then
								aObj:skinExpandButton{obj=btn.toggle, onSB=true}
							end
							aObj:checkTex(btn.toggle)
						end
					end)
				end

			elseif objType == "Window" then
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
				aObj:skinObject("frame", {obj=obj.frame, kfs=true, ofs=-1, y1=-2})
				if aObj.modBtns
				and obj.closebutton
				then
					aObj:skinCloseButton{obj=obj.closebutton}
				end

			-- handle HybridScrollFrame child (created by HonorSpy [Classic])
			elseif objType == "SimpleGroup" then
				if obj.frame:GetNumChildren() == 2
				and aObj:getChild(obj.frame, 2):IsObjectType("ScrollFrame") then
					aObj:skinObject("slider", {obj=aObj:getChild(obj.frame, 2).scrollBar, rpTex="artwork"})
				end

			-- ListBox object (AuctionLite)
			elseif objType == "ListBox" then
				for _, child in _G.ipairs{obj.frame:GetChildren()} do
					if child:IsObjectType("ScrollFrame") then
						child:SetBackdrop(nil)
						aObj:skinObject("slider", {obj=_G[child:GetName() .. "ScrollBar"]})
						break
					end
				end
				aObj:skinObject("skin", {obj=obj.box, kfs=true})

			-- LibSharedMedia objects
			elseif objType == "LSM30_Background"
			or objType == "LSM30_Border"
			or objType == "LSM30_Font"
			or objType == "LSM30_Sound"
			or objType == "LSM30_Statusbar"
			or objType == "RS_Markers" -- RareScanner
			then
				if not aObj.db.profile.TabDDTextures.textureddd then
					aObj:keepFontStrings(obj.frame)
				else
					obj.alignoffset = 29 -- align to neighbouring DropDowns
					local xOfs1, yOfs1, xOfs2, yOfs2
					if objType == "LSM30_Background"
					or objType == "LSM30_Border"
					then
						xOfs1, yOfs1, xOfs2, yOfs2 = 41, -18, 1, 2
					elseif objType == "LSM30_Font"
					or objType == "LSM30_Sound"
					or objType == "LSM30_Statusbar"
					then
						xOfs1, yOfs1, xOfs2, yOfs2 = 0, -19, 1, 1
					elseif objType == "RS_Markers" then
						xOfs1, yOfs1, xOfs2, yOfs2 = 0, -18, 1, 0
					end
					aObj:skinObject("dropdown", {obj=obj.frame, regions={2, 3, 4}, rpc=true, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2})
					aObj:secureHook(obj, "SetDisabled", function(this, disabled)
						aObj:checkDisabledDD(this.frame, disabled)
					end)
				end
				aObj:secureHookScript(obj.frame.dropButton, "OnClick", function(_)
					if obj.dropdown then
						if not obj.dropdown.sf then
							aObj:skinObject("slider", {obj=obj.dropdown.slider})
							aObj:skinObject("frame", {obj=obj.dropdown, ofs=0})
							_G.RaiseFrameLevel(obj.dropdown)
						else
							aObj:removeBackdrop(obj.dropdown)
						end
					end
				end)

			-- WeakAuras objects
			elseif objType == "WeakAurasDisplayButton" then
				aObj:skinObject("editbox", {obj=obj.renamebox})
				obj.background:SetTexture(nil)
				if aObj.modBtns then
					aObj:skinExpandButton{obj=obj.expand, onSB=true}
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=obj.frame, relTo=obj.frame.icon}
					-- make sure button border frame is visible
					aObj:secureHook(obj, "SetIcon", function(this, _)
						_G.RaiseFrameLevel(this.frame.sbb)
					end)
					aObj:addButtonBorder{obj=obj.group, es=10, ofs=0}
				end

			elseif objType == "WeakAurasLoadedHeaderButton" then
				obj.frame.background:SetTexture(nil)
				if aObj.modBtns then
					aObj:skinExpandButton{obj=obj.expand, onSB=true}
				end

			elseif objType == "WeakAurasMultiLineEditBox" then
				aObj:skinObject("frame", {obj=obj.scrollBG, kfs=true, fb=true})
				if aObj.modBtns then
					-- wait for the extra buttons to be created
					_G.C_Timer.After(0.05, function()
						for _, btn in _G.pairs(obj.extraButtons) do
							aObj:skinStdButton{obj=btn}
						end
					end)
				end

			elseif objType == "WeakAurasNewButton" then
				obj.background:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=obj.frame, relTo=obj.frame.icon}
					-- make sure button border frame is visible
					aObj:secureHook(obj, "SetIcon", function(this, _)
						_G.RaiseFrameLevel(this.frame.sbb)
					end)
				end

			elseif objType == "WeakAurasNewHeaderButton" then
				obj.frame.background:SetTexture(nil)

			elseif objType == "WeakAurasSnippetButton" then
				aObj:skinObject("editbox", {obj=obj.renameEditBox, ofs=3})
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=obj.deleteButton, es=10, ofs=-1, x1=2.5, y2=3.5}
				end

			-- AuctionMaster objects
			elseif objType == "ScrollableSimpleHTML" then
				aObj:skinObject("slider", {obj=obj.scrollFrame.ScrollBar})
			elseif objType == "EditDropdown" then
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=obj.button, es=12, ofs=-2}
				end

			-- CompactMissions objects
			elseif objType == "Mission" then
				aObj:skinObject("skin", {obj=obj.frame, kfs=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=obj.startbutton, as=true}
				end

			-- GarrisonMissionCommander/OrderHallCommander/ChampionCommander objects
			elseif objType == "GMCLayer" then
				aObj:skinObject("frame", {obj=obj.frame, ofs=-4})
			elseif objType == "GMCMissionButton"
			or objType == "GMCSlimMissionButton"
			or objType == "OHCMissionButton"
			or objType == "BFAMissionButton"
			then
				obj.frame:DisableDrawLayer("BACKGROUND")
				obj.frame:DisableDrawLayer("BORDER")
				-- extend the top & bottom highlight texture
				obj.frame.HighlightT:ClearAllPoints()
				obj.frame.HighlightT:SetPoint("TOPLEFT", 0, 4)
				obj.frame.HighlightT:SetPoint("TOPRIGHT", 0, 4)
				obj.frame.HighlightB:ClearAllPoints()
				obj.frame.HighlightB:SetPoint("BOTTOMLEFT", 0, -4)
				obj.frame.HighlightB:SetPoint("BOTTOMRIGHT", 0, -4)
				aObj:removeRegions(obj.frame, {13, 14, 23, 24, 25, 26}) -- LocBG, RareOverlay, Highlight corners
				if aObj.modBtnBs then
					aObj:secureHook(obj, "SetMission", function(this)
						for _, reward in _G.pairs(this.frame.Rewards) do
							aObj:removeRegions(reward, {1}) -- rewards shadow
							if aObj.modBtns then
								aObj:addButtonBorder{obj=reward, relTo=reward.Icon, reParent={reward.Quantity}}
							end
						end
					end)
				end

			-- GarrisonCommander objects
			elseif objType == "GMCGUIContainer" then
				obj.frame.GarrCorners:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=obj.frame, kfs=true, cb=true, ofs=2, x2=1})

			-- OrderHallCommander/ChampionCommander objects
			elseif objType == "OHCGUIContainer"
			or objType == "BFAGUIContainer"
			then
				aObj:skinObject("frame", {obj=obj.frame, kfs=true, cb=true})

			-- quantify
			elseif objType == "QuantifyInlineGroup" then
				-- aObj:applySkin{obj=obj.border, kfs=true}
				aObj:skinObject("skin", {obj=obj.border, kfs=true})

			-- AdiBags
			elseif objType == "ItemList" then
				aObj:skinObject("frame", {obj=obj.content:GetParent(), kfs=true})

			-- JackJack
			elseif objType == "JJWindow" then
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
				aObj:skinObject("frame", {obj=obj.frame, kfs=true, ofs=-1, y1=-2})
				if aObj.modBtns
				and obj.hidebutton
				then
					aObj:skinOtherButton{obj=obj.hidebutton, text=self.modUIBtns.minus}
				end
			elseif objType == "IconButton" then
				if aObj.modBtns then
					aObj:skinStdButton{obj=obj.frame, schk=true}
				end

			-- ignore these types for now
			elseif objType == "BlizOptionsGroup"
			or objType == "Dropdown-Item-Execute"
			or objType == "Dropdown-Item-Header"
			or objType == "Dropdown-Item-Menu"
			or objType == "Dropdown-Item-Separator"
			or objType == "Dropdown-Item-Toggle"
			or objType == "Heading"
			or objType == "Icon"
			or objType == "InteractiveLabel"
			or objType == "Label"
			-- LSM30 objects
			or objType == "LSM30_Statusbar_Overlay"
			or objType == "LSM30_Statusbar_Overlay-Item-Toggle"
			-- WeakAuras objects
			or objType == "WeakAurasInlineGroup"
			or objType == "WeakAurasTreeGroup"
			or objType == "WeakAurasAnchorButtons"
			or objType == "WeakAurasExpandAnchor"
			or objType == "WeakAurasExpandSmall"
			or objType == "WeakAurasIcon"
			or objType == "WeakAurasIconButton"
			or objType == "WeakAurasImportButton"
			or objType == "WeakAurasMiniTalent_Dragonflight"
			or objType == "WeakAurasMiniTalent_Wrath"
			or objType == "WeakAurasPendingInstallButton"
			or objType == "WeakAurasPendingUpdateButton"
			or objType == "WeakAurasProgressBar"
			or objType == "WeakAurasTextureButton"
			or objType == "WeakAurasToolbarButton"
			or objType == "WeakAurasTwoColumnDropdown"
			or objType == "WeakAurasScrollArea"
			or objType == "WeakAurasExpand"
			or objType == "WeakAurasSpinBox"
			-- ReagentRestocker object
			or objType == "DragDropTarget"
			-- CollectMe objects
			or objType == "CollectMeLabel"
			-- CompactMissions objects
			or objType == "Follower"
			-- GarrisonMissionCommander objects
			or objType == "GCMCList"
			-- OrderHallCommander objects
			or objType == "OHCMissionsList"
			-- ChampionCommander objects
			or objType == "BFAMissionsList"
			-- ElvUI
			or objType == "ColorPicker-ElvUI"
			-- DDI [Dropdown ITems (used by oRA3)]
			or objType == "DDI-Statusbar"
			or objType == "DDI-Font"
			-- quantify
			or objType == "QuantifyContainerWrapper"
			or objType == "QuantifyInlineGroup"
			-- AdiBags
			or objType == "ItemListElement"
			-- KongConfig
			or objType == "CollapsibleGroup"
			or objType == "EasyMenuDropDown"
			then -- luacheck: ignore 542 (empty if branch)
				-- aObj:Debug("Ignoring: [%s]", objType)
			-- any other types
			else
				aObj:Debug("AceGUI, unmatched type - %s", objType)
			end
		end
	end

	if self:IsHooked(AceGUI, "Create") then
		self:Unhook(AceGUI, "Create")
	end

	self:RawHook(AceGUI, "Create", function(this, objType)
		local obj = self.hooks[this].Create(this, objType)
		-- Bugfix: ignore objects awaiting skinning
		if not objectsToSkin[obj] then
			skinAceGUI(obj, objType)
		end
		return obj
	end, true)

	-- skin any objects created earlier
	for obj in _G.ipairs(objectsToSkin) do
		skinAceGUI(obj, objectsToSkin[obj])
	end
	_G.wipe(objectsToSkin)

	-- tooltips
	self.ACD.tooltip:DisableDrawLayer("OVERLAY")
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.AceGUITooltip)
		self:add2Table(self.ttList, self.ACD.tooltip)
	end)

end

aObj.iofSkinnedPanels = {}
aObj.ACD = _G.LibStub:GetLibrary("AceConfigDialog-3.0", true)
if aObj.ACD then
	-- hook this to manage IOF panels that have already been skinned by Ace3 skin
	aObj:RawHook(aObj.ACD, "AddToBlizOptions", function(this, ...)
		local frame, name = aObj.hooks[this].AddToBlizOptions(this, ...)
		aObj.iofSkinnedPanels[frame] = true
		return frame, name
	end, true)
	aObj:SecureHookScript(aObj.ACD.popup, "OnShow", function(this)
		if aObj.isRtl then
			aObj:keepFontStrings(aObj:getChild(this, 1))
		end
		aObj:skinObject("frame", {obj=this, kfs=true, ofs=-4})
		if aObj.modBtnBs then
			aObj:skinStdButton{obj=this.accept}
			aObj:skinStdButton{obj=this.cancel}
		end

		aObj:Unhook(this, "OnShow")
	end)
end

-- expose function to skin already created Ace3 GUI objects
-- used by JackJack & TLDRMissions AddOns (03.10.22)
function aObj:skinAceOptions(fObj)

	if fObj.type then
		skinAceGUI(fObj, fObj.type)
		if fObj.children then
			for _, child in _G.ipairs(fObj.children) do
				self:skinAceOptions(child)
			end
		end
	elseif fObj.obj then
		self:skinAceOptions(fObj.obj)
	end

end
