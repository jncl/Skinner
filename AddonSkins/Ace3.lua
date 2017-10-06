-- This is a Framework
local aName, aObj = ...
local _G = _G

aObj.ItemPimper = true -- to stop IP skinning its frame

local objectsToSkin = {}
local AceGUI = _G.LibStub("AceGUI-3.0", true)

if AceGUI then
	aObj:RawHook(AceGUI, "Create", function(this, objType)
		local obj = aObj.hooks[this].Create(this, objType)
		objectsToSkin[obj] = objType
		return obj
	end, true)
end

aObj.libsToSkin["AceGUI-3.0"] = function(self) -- v AceGUI-3.0, 34
	if self.initialized.Ace3 then return end
	self.initialized.Ace3 = true

	local bC = self.bColour
	local bbC = self.bbColour

	local function skinAceGUI(obj, objType)

		local objVer = AceGUI.GetWidgetVersion and AceGUI:GetWidgetVersion(objType) or 0
		-- if not objType:find("CollectMe") then
			-- aObj:Debug("skinAceGUI: [%s, %s, %s]", obj, objType, objVer)
		-- end
		-- if objType:find("TSM") then
			-- aObj:Debug("skinAceGUI: [%s, %s, %s, %s, %s, %s]", obj, objType, objVer, obj.sknd, objType:find("TSM"), obj.sknrTSM)
		-- end

		if obj
		and not obj.sknd
		and not (objType:find("TSM") and obj.sknrTSM) -- check objType as TSM overlays existing objects
		then
			-- aObj:Debug("Skinning: [%s, %s]", obj, objType)
			if objType == "Dropdown" then
				aObj:skinDropDown{obj=obj.dropdown, rp=true, y2=1}
				aObj:applySkin{obj=obj.pullout.frame}
			elseif objType == "Dropdown-Pullout" then
				aObj:applySkin{obj=obj.frame}
			elseif objType == "DropdownGroup"
			or objType == "InlineGroup"
			or objType == "TabGroup"
			then
				if objVer < 20 then
					aObj:applySkin{obj=obj.border, kfs=true}
				else
					aObj:applySkin{obj=obj.content:GetParent(), kfs=true}
				end
				-- skin TabGroup's tabs, if required
				if objType == "TabGroup"
				then
					aObj:secureHook(obj, "BuildTabs", function(this)
						this.frame.numTabs = #obj.tabs
						aObj:skinTabs{obj=this.frame, name="AceGUITabGroup" .. this.num, up=true, ignore=true, lod=true, ignht=true, x1=8, y1=-2, x2=-8, y2=-6}
						-- don't check for automatic tab changes
						aObj.tabFrames[this.frame] = nil
						aObj:Unhook(this, "BuildTabs")
					end)
					if aObj.isTT then
						aObj:secureHook(obj, "SelectTab", function(this, value)
							for i, v in ipairs(this.tabs) do
								if v.value == value then
									aObj:setActiveTab(_G["AceGUITabGroup" .. this.num .. "Tab" .. i].sf)
								else
									aObj:setInactiveTab(_G["AceGUITabGroup" .. this.num .. "Tab" .. i].sf)
								end
							end
						end)
					end
				end
			elseif objType == "EditBox"
			or objType == "NumberEditBox"
			then
				aObj:skinEditBox{obj=obj.editbox, noHeight=true}
				aObj:rawHook(obj.editbox, "SetTextInsets", function(this, left, right, top, bottom)
					return left + 6, right, top, bottom
				end, true)
				aObj:skinButton{obj=obj.button, as=true}
				if objType == "NumberEditBox" then
					aObj:skinButton{obj=obj.minus, as=true}
					aObj:skinButton{obj=obj.plus, as=true}
				end
			elseif objType == "MultiLineEditBox" then
				aObj:skinButton{obj=obj.button, as=true}
				if objVer < 20 then
					aObj:skinSlider{obj=obj.scrollframe.ScrollBar, wdth=-4, size=3}
					aObj:applySkin{obj=obj.backdrop}
				else
					aObj:skinSlider{obj=obj.scrollFrame.ScrollBar, wdth=-4, size=3}
					aObj:applySkin{obj=aObj:getChild(obj.frame, 2)} -- backdrop frame
				end
			elseif objType == "Slider" then
				aObj:skinEditBox{obj=obj.editbox, noHeight=true}
				obj.editbox:SetSize(60, 20)
				aObj:skinSlider{obj=obj.slider}
			elseif objType == "Frame" then
				aObj:applySkin{obj=obj.frame, kfs=true}
				if objVer < 20 then
					aObj:skinButton{obj=obj.closebutton, y1=1}
					aObj:applySkin{obj=obj.statusbg}
				else
					aObj:skinButton{obj=aObj:getChild(obj.frame, 1), y1=1}
					aObj:applySkin{obj=aObj:getChild(obj.frame, 2)} -- status frame
				end
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "Window" then
				aObj:applySkin{obj=obj.frame, kfs=true}
				aObj:skinButton{obj=obj.closebutton, cb=true}
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "ScrollFrame" then
				aObj:skinSlider{obj=obj.scrollbar}
			elseif objType == "TreeGroup" then
				aObj:skinSlider{obj=obj.scrollbar}
				aObj:applySkin{obj=obj.border}
				aObj:applySkin{obj=obj.treeframe}
				if aObj.modBtns then
					-- hook to manage changes to button textures
					aObj:secureHook(obj, "RefreshTree", function(this)
						local btn
						for i = 1, #this.buttons do
							btn = this.buttons[i]
							if not btn.toggle.sb then
								aObj:skinButton{obj=btn.toggle, mp2=true, plus=true} -- default to plus
							end
						end
					end)
				end
			elseif objType == "Button" then
				-- _G.print("Ace3 Button", obj.frame.GetName and obj.frame:GetName(), aObj:getInt(obj.frame:GetHeight()))
				aObj:skinButton{obj=obj.frame, as=true} -- just skin it otherwise text is hidden
			elseif objType == "Keybinding" then
				aObj:skinButton{obj=obj.button, as=true}
				aObj:applySkin{obj=obj.msgframe}
			elseif objType == "CheckBox" then
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=obj.frame, ofs=-2, y2=3, relTo=obj.checkbg, reParent={obj.check}}
					obj.checkbg:SetTexture(nil)
					-- hide button border if Radio Button
					aObj:secureHook(obj, "SetType", function(this, type)
						if aObj:getInt(this.checkbg:GetWidth()) == 16 then
							this.check:SetParent(this.frame)
							this.frame.sbb:Hide()
						else
							this.check:SetParent(this.frame.sbb)
							this.frame.sbb:Show()
						end
					end)
				end
			-- Snowflake objects (Producer AddOn)
			elseif objType == "SnowflakeGroup" then
				aObj:applySkin{obj=obj.frame}
				aObj:skinSlider{obj=obj.slider, size=2}
				-- hook this for frame refresh
				aObj:secureHook(obj, "Refresh", function(this)
					this.frame:SetBackdrop(aObj.Backdrop[1])
					this.frame:SetBackdropColor(bC.r, bC.g, bC.b, bC.a)
					this.frame:SetBackdropBorderColor(bbC.r, bbC.g, bbC.b, bbC.a)
				end)
			elseif objType == "SnowflakeEditBox" then
				aObj:skinEditBox{obj=obj.box, regs={9}, noHeight=true}

			-- Producer objects
			elseif objType == "ProducerHead" then
				aObj:applySkin{obj=obj.frame}
				aObj:skinButton{obj=obj.close, cb2=true}
				obj.SetBorder = _G.nop

			-- ListBox object (AuctionLite)
			elseif objType == "ListBox" then
				local kids, child = {obj.box:GetChildren()}
				for i = 1, #kids do
					child = kids[i]
					if child:IsObjectType("ScrollFrame") then
						child:SetBackdrop(nil)
						aObj:skinScrollBar{obj=child}
						break
					end
				end
				kids, child = nil, nil
				aObj:applySkin{obj=obj.box, kfs=true}

			-- LibSharedMedia objects
			elseif objType == "LSM30_Background"
			or objType == "LSM30_Border"
			or objType == "LSM30_Font"
			or objType == "LSM30_Sound"
			or objType == "LSM30_Statusbar"
			then
			    if not aObj.db.profile.TexturedDD
				and not aObj.db.profile.DropDownButtons
				then
			        aObj:keepFontStrings(obj.frame)
			    else
    				obj.frame.DLeft:SetAlpha(0)
    				obj.frame.DRight:SetAlpha(0)
    				obj.frame.DMiddle:SetHeight(18)
    				obj.frame.DMiddle:SetTexture(aObj.itTex)
    				obj.frame.DMiddle:SetTexCoord(0, 1, 0, 1)
    				obj.frame.DMiddle:ClearAllPoints()
    				obj.frame.DMiddle:SetPoint("LEFT", obj.frame.DLeft, "RIGHT", -5, 2)
    				obj.frame.DMiddle:SetPoint("RIGHT", obj.frame.DRight, "LEFT", 5, 2)
					if aObj.db.profile.DropDownButtons then
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
						end
						aObj:addSkinFrame{obj=obj.frame, aso={ng=true, bd=5}, rp=true, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
						-- add a button border around the dd button
						aObj:addButtonBorder{obj=obj.frame.dropButton, es=12, ofs=-2, x1=1}
					end
    			end

			-- WeakAuras objects
			elseif objType == "WeakAurasLoadedHeaderButton" then
				obj.frame.background:SetTexture(nil)
				if aObj.modBtns then
					aObj:skinButton{obj=obj.expand, mp2=true, as=true}
					aObj:secureHook(obj.expand, "SetNormalTexture", function(this, nTex)
						aObj.modUIBtns:checkTex{obj=this, nTex=nTex, mp2=true}
					end)
				end
			elseif objType == "WeakAurasDisplayButton" then
				aObj:skinEditBox{obj=obj.renamebox, regs={9}, noHeight=true}
				obj.renamebox:SetHeight(18)
				obj.background:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=obj.frame, relTo=obj.frame.icon}
					-- make sure button border frame is visible
					aObj:secureHook(obj, "SetIcon", function(this, icon)
						_G.RaiseFrameLevel(this.frame.sbb)
					end)
					aObj:addButtonBorder{obj=obj.group, es=10, ofs=0}
				end
				if aObj.modBtns then
					aObj:skinButton{obj=obj.expand, mp2=true, plus=true, as=true}
					obj.expand:SetDisabledFontObject(aObj.modUIBtns.fontDP)
					aObj:secureHook(obj.expand, "SetNormalTexture", function(this, nTex)
						aObj.modUIBtns:checkTex{obj=this, nTex=nTex, mp2=true}
					end)
				end
			elseif objType == "WeakAurasNewButton" then
				obj.background:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=obj.frame, relTo=obj.frame.icon}
					-- make sure button border frame is visible
					aObj:secureHook(obj, "SetIcon", function(this, icon)
						_G.RaiseFrameLevel(this.frame.sbb)
					end)
				end
			elseif objType == "WeakAurasNewHeaderButton" then
				obj.frame.background:SetTexture(nil)

			elseif objType == "WeakAurasSortedDropdown" then
				aObj:skinDropDown{obj=obj.dropdown, rp=true, y2=0}
				aObj:applySkin{obj=obj.pullout.frame}

            -- TradeSkillMaster (TSM) objects
            elseif objType == "TSMMainFrame" then
                aObj:applySkin{obj=obj.frame}
                aObj:skinButton{obj=aObj:getChild(obj.frame, 1), x1=-2, y1=2, x2=2, y2=-2} -- close button
                aObj:getChild(obj.frame, 1):SetBackdrop(nil)
                obj.sknrTSM = true
            elseif objType == "TSMInlineGroup"
            then
                obj.HideBorder = _G.nop
                obj.SetBackdrop = _G.nop
                obj.border:Hide()
                obj.titletext:ClearAllPoints()
                obj.titletext:SetPoint("TOPLEFT", 10, -6)
                obj.titletext:SetPoint("TOPRIGHT", -14, -6)
                aObj:applySkin{obj=obj.frame}
                obj.sknrTSM = true
            elseif objType == "TSMTabGroup"
            then
                aObj:applySkin{obj=obj.content:GetParent()}
                obj.sknrTSM = true
            elseif objType == "TSMTreeGroup" then
                aObj:applySkin{obj=obj.border}
                aObj:applySkin{obj=obj.treeframe}
                obj.sknrTSM = true
            elseif objType == "TSMButton" then
                aObj:skinButton{obj=obj.frame, as=true} -- just skin it otherwise text is hidden
                obj.btn:SetBackdrop(nil)
                obj.sknrTSM = true
            elseif objType == "TSMSelectionList" then
                aObj:applySkin{obj=obj.leftFrame}
                aObj:skinScrollBar{obj=obj.leftScrollFrame}
                aObj:applySkin{obj=obj.rightFrame}
                aObj:skinScrollBar{obj=obj.rightScrollFrame}
                obj.sknrTSM = true
            elseif objType == "TSMMacroButton"
            or objType == "TSMFastDestroyButton"
            then
                aObj:skinButton{obj=obj.frame}
                obj.frame:SetBackdrop(nil)
                obj.sknrTSM = true
            elseif objType == "TSMWindow" then
                aObj:applySkin{obj=obj.frame, kfs=true}
                aObj:skinButton{obj=obj.closebutton, cb=true}
                obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
                obj.sknrTSM = true
            elseif objType == "TSMEditBox" then
                aObj:skinButton{obj=obj.button, as=true}
                obj.sknrTSM = true
            elseif objType == "TSMScrollingTable" then
                aObj:addSkinFrame{obj=obj.frame, ofs=2}
                obj.sknrTSM = true
			elseif objType == "TSMDropdown" then
				aObj:skinDropDown{obj=obj.dropdown, rp=true, x2=0, y2=0}
				aObj:applySkin{obj=obj.pullout.frame}
                obj.sknrTSM = true
			elseif objType == "TSMDropdown-Pullout" then
				aObj:applySkin{obj=obj.frame}
                obj.sknrTSM = true

			-- AuctionMaster objects
			elseif objType == "ScrollableSimpleHTML" then
				aObj:skinScrollBar{obj=obj.scrollFrame}
			elseif objType == "EditDropdown" then
				aObj:addButtonBorder{obj=obj.button, es=12, ofs=-2}

			-- CompactMissions objects
			elseif objType == "Follower" then
			elseif objType == "Mission" then
				aObj:skinButton{obj=obj.startbutton, as=true}
				aObj:applySkin{obj=obj.frame, kfs=true}
				-- obj.startbutton

			-- ignore these types for now
			elseif objType == "BlizOptionsGroup"
			or objType == "CheckBox"
			or objType == "Dropdown-Item-Execute"
			or objType == "Dropdown-Item-Header"
			or objType == "Dropdown-Item-Menu"
			or objType == "Dropdown-Item-Separator"
			or objType == "Dropdown-Item-Toggle"
			or objType == "Label"
			or objType == "Heading"
			or objType == "ColorPicker"
			or objType == "SimpleGroup"
			or objType == "Icon"
			or objType == "InteractiveLabel"
			-- Snowflake objects
			or objType == "SnowflakeButton"
			or objType == "SnowflakeEscape"
			or objType == "SnowflakePlain"
			or objType == "SnowflakeTitle"
			-- WeakAuras objects
			or objType == "WeakAurasIconButton"
			or objType == "WeakAurasImportButton"
			or objType == "WeakAurasTextureButton"
			or objType == "WeakAurasTemplateGroup"
			-- ReagentRestocker object
			or objType == "DragDropTarget"
			-- TradeSkillMaster objects
			or objType == "TSMCheckBox"
			or objType == "TSMColorPicker"
			or objType == "TSMDropdown-Item-Execute"
			or objType == "TSMDropdown-Item-Toggle"
			or objType == "TSMImage"
			or objType == "TSMLabel"
			or objType == "TSMMultiLabel"
			or objType == "TSMScrollFrame"
			or objType == "TSMSimpleGroup"
			or objType == "TSMSlider"
			or objType == "TSMGroupBox"
			or objType == "TSMInteractiveLabel"
			-- CollectMe objects
			or objType == "CollectMeLabel"
			then
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
		if not objectsToSkin[obj] then skinAceGUI(obj, objType) end -- Bugfix: ignore objects awaiting skinning
		return obj
	end, true)

	-- skin any objects created earlier
	for obj in _G.pairs(objectsToSkin) do
		skinAceGUI(obj, objectsToSkin[obj])
	end
	_G.wipe(objectsToSkin)

	-- hook this to skin AGSMW dropdown frame(s)
	local AGSMW = _G.LibStub("AceGUISharedMediaWidgets-1.0", true)
	if AGSMW then
		self:RawHook(AGSMW, "GetDropDownFrame", function(this)
			local frame = self.hooks[this].GetDropDownFrame(this)
			local bdrop = frame:GetBackdrop()
			if bdrop.edgeFile:find("UI-DialogBox-Border", 1, true) then -- if default backdrop
				frame:SetBackdrop(nil)
				if not frame.sf then
					self:skinSlider{obj=frame.slider, size=4}
					self:addSkinFrame{obj=frame, x1=6, y1=-5, x2=-6, y2=5}
				end
			end
			return frame
		end, true)
	end

end
