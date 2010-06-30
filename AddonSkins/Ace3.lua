-- This is a Framework

Skinner.ItemPimper = true -- to stop IP skinning its frame

local AceGUI = LibStub("AceGUI-3.0")
local objectsToSkin = {}

if AceGUI then
	Skinner:RawHook(AceGUI, "Create", function(this, objType)
		local obj = Skinner.hooks[this].Create(this, objType)
		objectsToSkin[obj] = objType
		return obj
	end, true)
end

function Skinner:Ace3()

	local function skinAceGUI(obj, objType)

		local objVer = AceGUI.GetWidgetVersion and AceGUI:GetWidgetVersion(objType) or 0
--		self:Debug("skinAceGUI: [%s, %s, %s]", obj, objType, objVer)
		if obj and not self.skinned[obj] then
			if objType == "BlizOptionsGroup" then
				self:keepFontStrings(obj.frame)
				self:applySkin(obj.frame)
			elseif objType == "Dropdown" then
				self:skinDropDown{obj=obj.dropdown}
				self:applySkin(obj.pullout.frame)
			elseif objType == "Dropdown-Pullout" then
				self:applySkin(obj.frame)
			elseif objType == "DropdownGroup"
			or objType == "InlineGroup"
			or objType == "TabGroup"
			then
				self:keepFontStrings(obj.border)
				self:applySkin(obj.border)
			elseif objType == "EditBox"
			or objType == "NumberEditBox"
			then
				self:skinEditBox{obj=obj.editbox, regs={9}, noHeight=true}
				self:RawHook(obj.editbox, "SetTextInsets", function(this, left, right, top, bottom)
					return left + 6, right, top, bottom
				end, true)
				self:skinButton{obj=obj.button, as=true}
				if objType == "NumberEditBox" then
					self:skinButton{obj=obj.minus, as=true}
					self:skinButton{obj=obj.plus, as=true}
				end
			elseif objType == "MultiLineEditBox" then
				self:skinButton{obj=obj.button, as=true}
				if objVer < 20 then
					self:skinScrollBar{obj=obj.scrollframe}
					self:applySkin(obj.backdrop)
				else
					self:skinScrollBar{obj=obj.scrollFrame}
					self:applySkin{obj=self:getChild(obj.frame, 2)} -- backdrop frame
				end
			elseif objType == "Slider" then
				self:skinEditBox{obj=obj.editbox, regs={9}, noHeight=true}
				obj.editbox:SetHeight(20)
				obj.editbox:SetWidth(60)
			elseif objType == "Frame" then
				self:keepFontStrings(obj.frame)
				self:applySkin(obj.frame)
				if objVer < 20 then
					self:skinButton{obj=obj.closebutton, y1=1}
					self:applySkin(obj.statusbg)
				else
					self:skinButton{obj=self:getChild(obj.frame, 1), y1=1}
					self:applySkin{obj=self:getChild(obj.frame, 2)} -- backdrop frame
				end
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "Window" then
				self:keepFontStrings(obj.frame)
				self:applySkin(obj.frame)
				self:skinButton{obj=obj.closebutton, cb=true}
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -6)
			elseif objType == "ScrollFrame" then
				self:keepRegions(obj.scrollbar, {1})
				self:skinUsingBD{obj=obj.scrollbar}
			elseif objType == "TreeGroup" then
				self:keepRegions(obj.scrollbar, {1})
				self:skinUsingBD{obj=obj.scrollbar}
				self:applySkin(obj.border)
				self:applySkin(obj.treeframe)
				if self.modBtns then
					-- hook to manage changes to button textures
					self:SecureHook(obj, "RefreshTree", function()
						for i = 1, #obj.buttons do
							local button = obj.buttons[i]
							if not self.skinned[button.toggle] then
								self:skinButton{obj=button.toggle, mp2=true, plus=true} -- default to plus
							end
						end
					end)
				end
			elseif objType == "Button" then
				self:skinButton{obj=obj.frame, as=true} -- just skin it otherwise text is hidden
			elseif objType == "Keybinding" then
				self:skinButton{obj=obj.button, as=true}
				self:applySkin{obj=obj.msgframe}

			-- Snowflake objects
			elseif objType == "SnowflakeGroup" then
				self:applySkin{obj=obj.frame}
				self:skinSlider{obj=obj.slider, size=2}
				-- hook this for frame refresh
				self:SecureHook(obj, "Refresh", function(this)
					this.frame:SetBackdrop(self.Backdrop[1])
					local bCr, bCg, bCb, bCa = unpack(self.bColour)
					local bbCr, bbCg, bbCb, bbCa = unpack(self.bbColour)
					this.frame:SetBackdropColor(bCr, bCg, bCb, bCa)
					this.frame:SetBackdropBorderColor(bbCr, bbCg, bbCb, bbCa)
				end)
			elseif objType == "SnowflakeEditBox" then
				self:skinEditBox{obj=obj.box, regs={9}, noHeight=true}

			-- Producer objects
			elseif objType == "ProducerHead" then
				self:applySkin{obj=obj.frame}
				self:skinButton{obj=obj.close, cb2=true}
				obj.SetBorder = function() end -- disable background changes

			-- ListBox object (AuctionLite)
			elseif objType == "ListBox" then
				for _, child in pairs{obj.box:GetChildren()} do -- find scroll bar
					if child:IsObjectType("ScrollFrame") then
						child:SetBackdrop(nil)
						self:skinScrollBar{obj=child}
						break
					end
				end
				self:applySkin{obj=obj.box, kfs=true}
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
			then
			-- any other types
			else
				self:Debug("AceGUI, unmatched type - %s", objType)
			end
		end

	end

	if self:IsHooked(AceGUI, "Create") then
		self:Unhook(AceGUI, "Create")
	end

	self:RawHook(AceGUI, "Create", function(this, objType)
		local obj = self.hooks[this].Create(this, objType)
		skinAceGUI(obj, objType)
		return obj
	end, true)

	-- skin any objects created earlier
	for obj in pairs(objectsToSkin) do
		skinAceGUI(obj, objectsToSkin[obj])
	end
	objectsToSkin = nil

end
