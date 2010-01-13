
function Skinner:Ace3()

	self:RawHook(LibStub("AceGUI-3.0"), "Create", function(this, objType)
		local obj = self.hooks[this].Create(this, objType)
--		self:Debug("Ace3GUI_Create: [%s, %s, %s]", this, objType, obj)
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
				or objType == "TabGroup" then
				self:keepFontStrings(obj.border)
				self:applySkin(obj.border)
			elseif objType == "EditBox"
				or objType == "NumberEditBox" then
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
				self:applySkin(obj.backdrop)
				local kids = {obj.backdrop:GetChildren()}
				for _, child in ipairs(kids) do -- find scroll bar
					if child:IsObjectType("ScrollFrame") then
						self:skinScrollBar{obj=child}
						break
					end
				end
				kids = nil
				self:skinButton{obj=obj.button, as=true}
			elseif objType == "Slider" then
				self:skinEditBox{obj=obj.editbox, regs={9}, noHeight=true}
				obj.editbox:SetHeight(20)
				obj.editbox:SetWidth(60)
			elseif objType == "Frame" then
				self:keepFontStrings(obj.frame)
				self:applySkin(obj.frame)
				self:skinButton{obj=obj.closebutton, y1=1}
				self:applySkin(obj.statusbg)
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
				if self.db.profile.Buttons then
					-- hook to manage changes to button textures
					self:SecureHook(obj, "RefreshTree", function()
--						self:Debug("RefreshTree: [%s]", #obj.buttons)
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
			end
		end
		return obj
	end, true)

end
