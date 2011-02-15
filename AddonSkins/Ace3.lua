-- This is a Framework
local aName, aObj = ...

aObj.ItemPimper = true -- to stop IP skinning its frame

local objectsToSkin = {}
local AceGUI = LibStub("AceGUI-3.0", true)

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

	local bCr, bCg, bCb, bCa = unpack(self.bColour)
	local bbCr, bbCg, bbCb, bbCa = unpack(self.bbColour)

	local function skinAceGUI(obj, objType)

		local objVer = AceGUI.GetWidgetVersion and AceGUI:GetWidgetVersion(objType) or 0
--        aObj:Debug("skinAceGUI: [%s, %s, %s]", obj, objType, objVer)
		if obj and not aObj.skinned[obj] then
			if objType == "BlizOptionsGroup" then
				aObj:keepFontStrings(obj.frame)
				aObj:applySkin(obj.frame)
			elseif objType == "Dropdown" then
				aObj:skinDropDown{obj=obj.dropdown}
				aObj:applySkin(obj.pullout.frame)
			elseif objType == "Dropdown-Pullout" then
				aObj:applySkin(obj.frame)
			elseif objType == "DropdownGroup"
			or objType == "InlineGroup"
			or objType == "TabGroup"
			then
				if objVer < 20 then
					aObj:keepFontStrings(obj.border)
					aObj:applySkin(obj.border)
				else
					aObj:keepFontStrings(obj.content:GetParent())
					aObj:applySkin(obj.content:GetParent())
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
					aObj:applySkin(obj.backdrop)
				else
					aObj:skinScrollBar{obj=obj.scrollFrame}
					aObj:applySkin{obj=aObj:getChild(obj.frame, 2)} -- backdrop frame
				end
			elseif objType == "Slider" then
				aObj:skinEditBox{obj=obj.editbox, regs={9}, noHeight=true}
				obj.editbox:SetHeight(20)
				obj.editbox:SetWidth(60)
			elseif objType == "Frame" then
				aObj:keepFontStrings(obj.frame)
				aObj:applySkin(obj.frame)
				if objVer < 20 then
					aObj:skinButton{obj=obj.closebutton, y1=1}
					aObj:applySkin(obj.statusbg)
				else
					aObj:skinButton{obj=aObj:getChild(obj.frame, 1), y1=1}
					aObj:applySkin{obj=aObj:getChild(obj.frame, 2)} -- backdrop frame
				end
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "Window" then
				aObj:keepFontStrings(obj.frame)
				aObj:applySkin(obj.frame)
				aObj:skinButton{obj=obj.closebutton, cb=true}
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "ScrollFrame" then
				aObj:keepRegions(obj.scrollbar, {1})
				aObj:skinUsingBD{obj=obj.scrollbar}
			elseif objType == "TreeGroup" then
				aObj:keepRegions(obj.scrollbar, {1})
				aObj:skinUsingBD{obj=obj.scrollbar}
				aObj:applySkin(obj.border)
				aObj:applySkin(obj.treeframe)
				if aObj.modBtns then
					-- hook to manage changes to button textures
					aObj:SecureHook(obj, "RefreshTree", function()
						local btn
						for i = 1, #obj.buttons do
							btn = obj.buttons[i]
							if not aObj.skinned[btn.toggle] then
								aObj:skinButton{obj=btn.toggle, mp2=true, plus=true} -- default to plus
							end
						end
					end)
				end
			elseif objType == "Button" then
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
					this.frame:SetBackdropColor(bCr, bCg, bCb, bCa)
					this.frame:SetBackdropBorderColor(bbCr, bbCg, bbCb, bbCa)
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
				for _, child in pairs{obj.box:GetChildren()} do -- find scroll bar
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
			    if not aObj.db.profile.TexturedDD then
			        aObj:keepFontStrings(obj.frame)
			    else
    				obj.frame.DLeft:SetAlpha(0)
    				obj.frame.DRight:SetAlpha(0)
    				obj.frame.DMiddle:SetHeight(20)
    				obj.frame.DMiddle:SetTexture(aObj.itTex)
    				obj.frame.DMiddle:SetTexCoord(0, 1, 0, 1)
    				obj.frame.DMiddle:ClearAllPoints()
    				obj.frame.DMiddle:SetPoint("BOTTOMLEFT", obj.frame.DLeft, "RIGHT", -6, -8)
    				obj.frame.DMiddle:SetPoint("BOTTOMRIGHT", obj.frame.DRight, "LEFT", 6, -8)
    			end

			-- WeakAuras objects
			elseif objType == "WeakAurasTextureButton" then
			elseif objType == "WeakAurasIconButton" then
			elseif objType == "WeakAurasNewHeaderButton" then
			elseif objType == "WeakAurasLoadedHeaderButton" then
				aObj:skinButton{obj=obj.expand, mp2=true, as=true}
				aObj:SecureHook(obj.expand, "SetNormalTexture", function(this, nTex)
					aObj.modUIBtns:checkTex{obj=this, nTex=nTex, mp2=true}
				end)

			elseif objType == "WeakAurasNewButton" then
			elseif objType == "WeakAurasDisplayButton" then
				aObj:skinEditBox{obj=obj.renamebox, regs={9}, noHeight=true}
				obj.renamebox:SetHeight(18)
				aObj:skinButton{obj=obj.expand, mp2=true, plus=true, as=true}
				obj.expand:SetDisabledFontObject(aObj.modUIBtns.fontDP)
				aObj:SecureHook(obj.expand, "SetNormalTexture", function(this, nTex)
					aObj.modUIBtns:checkTex{obj=this, nTex=nTex, mp2=true}
				end)

			-- ignore these types for now
			elseif objType == "CheckBox"
			or objType == "Dropdown-Item-Execute"
			or objType == "Dropdown-Item-Toggle"
			or objType == "Label"
			or objType == "Heading"
			or objType == "ColorPicker"
			or objType == "SnowflakeButton"
			or objType == "SnowflakeEscape"
			or objType == "SnowflakePlain"
			or objType == "SnowflakeTitle"
			or objType == "SimpleGroup"
			or objType == "Icon"
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
	for obj in pairs(objectsToSkin) do
		skinAceGUI(obj, objectsToSkin[obj])
	end
	wipe(objectsToSkin)

	-- hook this to skin AGSMW dropdown frame(s)
	local AGSMW = LibStub("AceGUISharedMediaWidgets-1.0", true)
	if AGSMW then
		self:RawHook(AGSMW, "GetDropDownFrame", function(this)
			local frame = self.hooks[this].GetDropDownFrame(this)
			local bdrop = frame:GetBackdrop()
			if bdrop.edgeFile:find("UI-DialogBox-Border", 1, true) then -- if default backdrop
				frame:SetBackdrop(nil)
				if not self.skinFrame[frame] then
					self:skinSlider{obj=frame.slider, size=4}
					self:addSkinFrame{obj=frame, x1=6, y1=-5, x2=-6, y2=5}
				end
			end
			return frame
		end, true)
	end

end
