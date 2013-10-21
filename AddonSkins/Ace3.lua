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

function aObj:Ace3()
	if self.initialized.Ace3 then return end
	self.initialized.Ace3 = true

	local bC = self.bColour
	local bbC = self.bbColour

	local function skinAceGUI(obj, objType)

		local objVer = AceGUI.GetWidgetVersion and AceGUI:GetWidgetVersion(objType) or 0
		-- if not objType:find("CollectMe") then
		-- 	aObj:Debug("skinAceGUI: [%s, %s, %s]", obj, objType, objVer)
		-- end
		-- if objType:find("TSM") then
			-- aObj:Debug("skinAceGUI: [%s, %s, %s, %s, %s, %s]", obj, objType, objVer, rawget(aObj.skinned, obj), objType:find("TSM"), obj.sknrTSM)
		-- end

		if obj
		and (not aObj.skinned[obj] or (objType:find("TSM") and not obj.sknrTSM)) -- check objType as TSM overlays existing objects
		then
			if objType == "BlizOptionsGroup" then
				aObj:applySkin{obj=obj.frame, kfs=true}
			elseif objType == "Dropdown" then
				aObj:skinDropDown{obj=obj.dropdown, rp=true, y2=0}
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
			elseif objType == "EditBox"
			or objType == "NumberEditBox"
			then
				aObj:skinEditBox{obj=obj.editbox, regs={9}, noHeight=true}
				aObj:RawHook(obj.editbox, "SetTextInsets", function(this, left, right, top, bottom)
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
					aObj:skinScrollBar{obj=obj.scrollframe}
					aObj:applySkin{obj=obj.backdrop}
				else
					aObj:skinScrollBar{obj=obj.scrollFrame}
					aObj:applySkin{obj=aObj:getChild(obj.frame, 2)} -- backdrop frame
				end
			elseif objType == "Slider" then
				aObj:skinEditBox{obj=obj.editbox, regs={9}, noHeight=true}
				obj.editbox:SetHeight(20)
				obj.editbox:SetWidth(60)
			elseif objType == "Frame" then
				aObj:applySkin{obj=obj.frame, kfs=true}
				if objVer < 20 then
					aObj:skinButton{obj=obj.closebutton, y1=1}
					aObj:applySkin{obj=obj.statusbg}
				else
					aObj:skinButton{obj=aObj:getChild(obj.frame, 1), y1=1}
					aObj:applySkin{obj=aObj:getChild(obj.frame, 2)} -- backdrop frame
				end
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "Window" then
				aObj:applySkin{obj=obj.frame, kfs=true}
				aObj:skinButton{obj=obj.closebutton, cb=true}
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "ScrollFrame" then
				aObj:keepRegions(obj.scrollbar, {1})
				aObj:skinUsingBD{obj=obj.scrollbar}
			elseif objType == "TreeGroup" then
				aObj:keepRegions(obj.scrollbar, {1})
				aObj:skinUsingBD{obj=obj.scrollbar}
				aObj:applySkin{obj=obj.border}
				aObj:applySkin{obj=obj.treeframe}
				if aObj.modBtns then
					-- hook to manage changes to button textures
					aObj:SecureHook(obj, "RefreshTree", function(this)
						local btn
						for i = 1, #this.buttons do
							btn = this.buttons[i]
							if not aObj.skinned[btn.toggle] then
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

			-- Snowflake objects (Producer AddOn)
			elseif objType == "SnowflakeGroup" then
				aObj:applySkin{obj=obj.frame}
				aObj:skinSlider{obj=obj.slider, size=2}
				-- hook this for frame refresh
				aObj:SecureHook(obj, "Refresh", function(this)
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
				obj.SetBorder = function() end -- disable background changes

			-- ListBox object (AuctionLite)
			elseif objType == "ListBox" then
				for _, child in _G.pairs{obj.box:GetChildren()} do -- find scroll bar
					if child:IsObjectType("ScrollFrame") then
						child:SetBackdrop(nil)
						aObj:skinScrollBar{obj=child}
						break
					end
				end
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
    				obj.frame.DMiddle:SetHeight(19)
    				obj.frame.DMiddle:SetTexture(aObj.itTex)
    				obj.frame.DMiddle:SetTexCoord(0, 1, 0, 1)
    				obj.frame.DMiddle:ClearAllPoints()
    				obj.frame.DMiddle:SetPoint("LEFT", obj.frame, "RIGHT")
    				obj.frame.DMiddle:SetPoint("RIGHT", obj.frame, "LEFT")
					if aObj.db.profile.DropDownButtons then
						local xOfs1, yOfs1, xOfs2, yOfs2
						if objType == "LSM30_Background"
						or objType == "LSM30_Border"
						then
							xOfs1, yOfs1, xOfs2, yOfs2 = 41, -17, 2, 1
						elseif objType == "LSM30_Font"
						or objType == "LSM30_Sound"
						or objType == "LSM30_Statusbar"
						then
							xOfs1, yOfs1, xOfs2, yOfs2 = -3, -18, 2, 0
						end
						aObj:addSkinFrame{obj=obj.frame, aso={ng=true}, rp=true, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
						-- add a button border around the dd button
						aObj:addButtonBorder{obj=obj.frame.dropButton, es=12, ofs=-2}
					end
    			end

			-- WeakAuras objects
			elseif objType == "WeakAurasLoadedHeaderButton" then
				aObj:skinButton{obj=obj.expand, mp2=true, as=true}
				aObj:SecureHook(obj.expand, "SetNormalTexture", function(this, nTex)
					aObj.modUIBtns:checkTex{obj=this, nTex=nTex, mp2=true}
				end)
			elseif objType == "WeakAurasDisplayButton" then
				aObj:skinEditBox{obj=obj.renamebox, regs={9}, noHeight=true}
				obj.renamebox:SetHeight(18)
				aObj:skinButton{obj=obj.expand, mp2=true, plus=true, as=true}
				obj.expand:SetDisabledFontObject(aObj.modUIBtns.fontDP)
				aObj:SecureHook(obj.expand, "SetNormalTexture", function(this, nTex)
					aObj.modUIBtns:checkTex{obj=this, nTex=nTex, mp2=true}
				end)

            -- TradeSkillMaster (TSM) objects
            elseif objType == "TSMMainFrame" then
                aObj:applySkin{obj=obj.frame}
                aObj:skinButton{obj=aObj:getChild(obj.frame, 1), x1=-2, y1=2, x2=2, y2=-2} -- close button
                aObj:getChild(obj.frame, 1):SetBackdrop(nil)
                obj.sknrTSM = true
            elseif objType == "TSMInlineGroup"
            -- or objType == "TSMInlineGroupNoTitle"
            then
                obj.HideBorder = function() end
                obj.SetBackdrop = function() end
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
                self:applySkin{obj=obj.leftFrame}
                self:skinScrollBar{obj=obj.leftScrollFrame}
                self:applySkin{obj=obj.rightFrame}
                self:skinScrollBar{obj=obj.rightScrollFrame}
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

			-- AuctionMaster object
			elseif objType == "ScrollableSimpleHTML" then
				self:skinScrollBar{obj=obj.scrollFrame}

			-- ignore these types for now
			elseif objType == "CheckBox"
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
			or objType == "WeakAurasTextureButton"
			or objType == "WeakAurasIconButton"
			or objType == "WeakAurasNewHeaderButton"
			or objType == "WeakAurasNewButton"
			-- ReagentRestocker object
			or objType == "DragDropTarget"
			-- TradeSkillMaster objects
			or objType == "TSMCheckBox"
			or objType == "TSMColorPicker"
			or objType == "TSMDropdown"
			or objType == "TSMDropdown-Item-Execute"
			or objType == "TSMDropdown-Item-Toggle"
			or objType == "TSMDropdown-Pullout"
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
