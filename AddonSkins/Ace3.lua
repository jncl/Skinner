
function Skinner:Ace3()

	self:Hook(LibStub("AceGUI-3.0"), "Create", function(this, objType)
		local obj = self.hooks[this].Create(this, objType)
--		self:Debug("Ace3GUI_Create: [%s, %s, %s]", this, objType, obj)
		if obj and not obj.skinned then
			if objType == "BlizOptionsGroup" then
				self:keepFontStrings(obj.frame)
				self:applySkin(obj.frame)
			elseif objType == "Dropdown" then
				self:skinDropDown(obj.dropdown)
				self:applySkin(obj.pullout.frame)
			elseif objType == "DropdownGroup"
				or objType == "InlineGroup"
				or objType == "TabGroup" then
				self:keepFontStrings(obj.border)
				self:applySkin(obj.border)
			elseif objType == "EditBox" then
				self:skinEditBox(obj.editbox, {9}, nil, true)
				self:Hook(obj.editbox, "SetTextInsets", function(this, left, right, top, bottom)
					return left + 6, right, top, bottom
				end, true)
			elseif objType == "MultiLineEditBox" then
				self:applySkin(obj.backdrop)
				for i = 1, select("#", obj.backdrop:GetChildren()) do
					local child = select(i, obj.backdrop:GetChildren())
					if child:IsObjectType("ScrollFrame") then
						self:removeRegions(child)
						self:skinScrollBar(child)
						break
					end
				end
			elseif objType == "Slider" then
				obj.editbox.bg:SetAlpha(0)
				self:skinEditBox(obj.editbox, {9}, nil, true)
				obj.editbox:SetHeight(20)
				obj.editbox:SetWidth(60)
			elseif objType == "Frame" then
				self:keepFontStrings(obj.frame)
				obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -8)
				self:applySkin(obj.frame)
				self:applySkin(obj.statusbg)
			elseif objType == "ScrollFrame" then
				self:keepRegions(obj.scrollbar, {1})
				self:skinUsingBD2(obj.scrollbar)
			elseif objType == "TreeGroup" then
				self:keepRegions(obj.scrollbar, {1})
				self:skinUsingBD2(obj.scrollbar)
				self:applySkin(obj.border)
				self:applySkin(obj.treeframe)
				self:SecureHook(obj, "RefreshTree", function()
					for i = 1, #obj.buttons do
						local button = obj.buttons[i]
						if button and button:GetNormalTexture() then
						    button:GetNormalTexture():SetAlpha(0)
						end
					end
				end)
			end
			obj.skinned = true
		end
		return obj
	end, true)

end
