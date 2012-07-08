local aName, aObj = ...
if not aObj:isAddonEnabled("Acheron") then return end

function aObj:Acheron()

	local obj = Acheron.frame
	local AceGUI = LibStub("AceGUI-3.0", true)
	local objVer = AceGUI.GetWidgetVersion and AceGUI:GetWidgetVersion("Frame") or 0

	self:keepFontStrings(obj.frame)
	obj.titletext:SetPoint("TOP", obj.frame, "TOP", 0, -8)
	self:applySkin(obj.frame)
	if objVer < 20 then
		self:skinButton{obj=obj.closebutton, y1=1}
		self:applySkin(obj.statusbg) -- backdrop frame
	else
		self:skinButton{obj=self:getChild(obj.frame, 1), y1=1}
		self:applySkin{obj=self:getChild(obj.frame, 2)} -- backdrop frame
	end

	local kids = obj.children
	objVer = AceGUI.GetWidgetVersion and AceGUI:GetWidgetVersion("InlineGroup") or 0
	-- Filter options
	obj = kids[1] -- InlineGroup object
	if objVer < 20 then
		self:keepFontStrings(obj.border)
		self:applySkin(obj.border)
	else
		self:keepFontStrings(obj.content:GetParent())
		self:applySkin(obj.content:GetParent())
	end
	obj = kids[1].children[1] -- Dropdown object
	self:skinDropDown{obj=obj.dropdown, y2=0}
	self:applySkin(obj.pullout.frame)

	-- Report options
	obj = kids[2] -- InlineGroup object
	if objVer < 20 then
		self:keepFontStrings(obj.border)
		self:applySkin(obj.border)
	else
		self:keepFontStrings(obj.content:GetParent())
		self:applySkin(obj.content:GetParent())
	end
	obj = kids[2].children[2] -- Dropdown object
	self:skinDropDown{obj=obj.dropdown, y2=0}
	self:applySkin(obj.pullout.frame)
	obj = kids[2].children[3] -- EditBox object
	self:skinEditBox(obj.editbox, {9}, nil, true)
	self:RawHook(obj.editbox, "SetTextInsets", function(this, left, right, top, bottom)
		return left + 6, right, top, bottom
	end, true)

	-- Buttons
	self:skinButton{obj=kids[3].frame}
	self:skinButton{obj=kids[4].frame}

	-- Death Report panels
	obj = kids[6] -- TreeGroup object
	self:keepRegions(obj.scrollbar, {1})
	self:skinUsingBD2(obj.scrollbar)
	self:applySkin(obj.border)
	self:applySkin(obj.treeframe)
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook(obj, "RefreshTree", function()
			local btn
			for i = 1, #obj.buttons do
				btn = obj.buttons[i]
				if not self.skinned[btn.toggle] then
					self:skinButton{obj=btn.toggle, mp2=true, plus=true} -- default to plus
				end
			end
		end)
	end

end
