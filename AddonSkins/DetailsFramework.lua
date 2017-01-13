local aName, aObj = ...
local _G = _G
-- This is a Library

local DF = _G.LibStub("DetailsFramework-1.0", true)

function aObj:DetailsFramework()
	if self.initialized.DetailsFramework then return end
	self.initialized.DetailsFramework = true

-->>-- addon

-->>-- button
	self:RawHook(DF, "CreateButton", function(this, parent, func, w, h, text, param1, param2, texture, member, name, short_method, button_template, text_template)
		-- print("DF CreateButton:", this, parent, func, w, h, text, param1, param2, texture, member, name, short_method, button_template, text_template)
		local button = self.hooks[this].CreateButton(this, parent, func, w, h, text, param1, param2, texture, member, name, short_method, button_template, text_template)
		return button
	end, true)
	self:RawHook(DF, "CreateColorPickButton", function(this, name, member, callback, alpha, button_template)
		-- print("DF CreateColorPickButton:", this, name, member, callback, alpha, button_template)
		local button = self.hooks[this].CreateColorPickButton(this, name, member, callback, alpha, button_template)
		return button
	end, true)

-->>-- coooltip
	local function skinCooltip(frame)

		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=frame}

	end
	if _G.GameCooltip2 then
		_G.GameCooltip2.SetBackdrop = _G.nop
		skinCooltip(_G.GameCooltip2.frame1)
		skinCooltip(_G.GameCooltip2.frame2)
	else
		-- obj.frame1 -> GameCooltipFrame1
		-- obj.frame2 -> GameCooltipFrame2
		self:RawHook(DF, "CreateCoolTip", function(this)
			-- print("DF CreateCoolTip:", this)
			local obj = self.hooks[this].CreateCoolTip(this)
			obj.SetBackdrop = _G.nop
			skinCooltip(obj.frame1)
			skinCooltip(obj.frame2)
			self:Unhook(this, "CreateCoolTip")
			return obj
		end, true)
	end
-->>-- dropdown
	-- obj.dropdown
	self:RawHook(DF, "NewDropDown", function(this, parent, func, default, w, h, member, name, template)
		-- print("DF NewDropDown:", this, parent, func, default, w, h, member, name, template)
		local obj = self.hooks[this].NewDropDown(this, parent, func, default, w, h, member, name, template)
		return obj
	end, true)
	self:RawHook(DF, "CreateNewDropdownFrame", function(this, parent, name)
		-- print("DF CreateNewDropdownFrame:", this, parent, name)
		local button = self.hooks[this].CreateNewDropdownFrame(this, parent, name)
		self:addSkinFrame{obj=button.dropdownborder}
		button.dropdownframe:GetScrollChild():SetBackdrop(nil)
		return button
	end, true)
	self:RawHook(DF, "CreateDropdownButton", function(this, parent, name)
		-- print("DF CreateDropdownButton:", this, parent, name)
		local button = self.hooks[this].CreateDropdownButton(this, parent, name)
		return button
	end, true)

-->>-- help
	self:RawHook(DF, "NewHelp", function(this, parent, width, height, x, y, buttonWidth, buttonHeight, name)
		-- print("DF NewHelp:", this, parent, width, height, x, y, buttonWidth, buttonHeight, name)
		local button = self.hooks[this].NewHelp(this, parent, width, height, x, y, buttonWidth, buttonHeight, name)
		return button
	end, true)

-->>-- label
	-- obj.label
	self:RawHook(DF, "NewLabel", function(this, parent, text, size, color, font, member, name, layer)
		-- print("DF NewLabel:", this, parent, text, size, color, font, member, name, layer)
		local obj = self.hooks[this].NewLabel(this, parent, text, size, color, font, member, name, layer)
		return obj
	end, true)

-->>-- normal_bar
	-- obj.statusbar
	self:RawHook(DF, "NewBar", function(this, parent, texture, w, h, value, member, name)
		-- print("DF NewBar:", this, parent, texture, w, h, value, member, name)
		local obj = self.hooks[this].NewBar(this, parent, texture, w, h, value, member, name)
		return obj
	end, true)

-->>-- panel
	-- obj.frame
	self:RawHook(DF, "NewPanel", function(this, parent, container, name, member, w, h, backdrop, backdropcolor, bordercolor)
		-- print("DF NewPanel:", this, parent, container, name, member, w, h, backdrop, backdropcolor, bordercolor)
		local obj = self.hooks[this].NewPanel(this, parent, container, name, member, w, h, backdrop, backdropcolor, bordercolor)
		-- self:addSkinFrame{obj=obj.frame, ofs=2}
		-- obj.frame.SetBackdrop = _G.nop
		-- obj.frame.SetBackdropColor = _G.nop
		-- obj.frame.SetBackdropBorderColor = _G.nop
		return obj
	end, true)
	self:RawHook(DF, "NewFillPanel", function(this, parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
		-- print("DF NewFillPanel:", this, parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
		local obj = self.hooks[this].NewFillPanel(this, parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
		self:skinScrollBar{obj=obj.scrollframe}
		return obj
	end, true)
	-- IconPick
	-- ShowPanicWarning
	-- CreateScaleBar
	self:RawHook(DF, "CreateSimplePanel", function(this, parent, w, h, title, name, panel_options, db)
		-- print("DF CreateSimplePanel:", this, parent, w, h, title, name, panel_options, db)
		local frame = self.hooks[this].CreateSimplePanel(this, parent, w, h, title, name, panel_options, db)
		frame.TitleBar:SetBackdrop(nil)
		frame.Close:SetSize(20, 20)
		self:skinButton{obj=frame.Close, cb=true}
		self:addSkinFrame{obj=frame, nb=true}
		return frame
	end, true)
	self:RawHook(DF, "Create1PxPanel", function(this, parent, w, h, title, name, config, title_anchor, no_special_frame)
		-- print("DF Create1PxPanel:", this, parent, w, h, title, name, config, title_anchor, no_special_frame)
		local frame = self.hooks[this].Create1PxPanel(this, parent, w, h, title, name, config, title_anchor, no_special_frame)
		return frame
	end, true)
	-- ShowPromptPanel
	-- ShowTextPromptPanel
	-- CreateOptionsButton
	-- CreateFeedbackButton
	-- ShowFeedbackPanel
	-- CreateChartPanel
	-- CreateGFrame
	-- CreateButtonContainer
	-- CreateTabContainer
	-- CreateSimpleListBox
	-- CreateScrollBox

-->>-- picture
	-- obj.image
	self:RawHook(DF, "NewImage", function(this, parent, texture, w, h, layer, coords, member, name)
		-- print("DF NewImage:", this, parent, texture, w, h, layer, coords, member, name)
		local obj = self.hooks[this].NewImage(this, parent, texture, w, h, layer, coords, member, name)
		if texture
		and (texture:find("PaperDollSidebarTabs")
		or texture:find("BookCompletedLeft")
		or texture:find("StatsBackground"))
		then
			obj.image:SetTexture(nil)
		end
		return obj
	end, true)

-->>-- pictureedit
	-- DetailsFrameworkImageEdit

-->>-- scrollbar
	self:RawHook(DF, "NewScrollBar", function(this, master, slave, x, y)
		-- print("DF NewScrollBar:", this, master, slave, x, y)
		local slider = self.hooks[this].NewScrollBar(this, master, slave, x, y)
		slider.bg:SetTexture(nil)
		self:skinSlider{obj=slider}
		return slider
	end, true)

-->>-- slider
	self:RawHook(DF, "NewSwitch", function(this, parent, container, name, member, w, h, ltext, rtext, default_value, color_inverted, switch_func, return_func, with_label, switch_template, label_template)
		-- print("DF NewSwitch:", this, parent, container, name, member, w, h, ltext, rtext, default_value, color_inverted, switch_func, return_func, with_label, switch_template, label_template)
		local button, label = self.hooks[this].NewSwitch(this, parent, container, name, member, w, h, ltext, rtext, default_value, color_inverted, switch_func, return_func, with_label, switch_template, label_template)
		return button, label
	end, true)

-->>-- split_bar
	self:RawHook(DF, "NewSplitBar", function(this, parent, w, h, member, name)
		-- print("DF NewSplitBar:", this, parent, w, h, member, name)
		local obj = self.hooks[this].NewSplitBarT(this, parent, w, h, member, name)
		return obj
	end, true)

-->>-- textentry
	-- obj.editbox
	self:RawHook(DF, "NewTextEntry", function(this, parent, func, w, h, member, name, with_label, entry_template, label_template)
		-- print("DF NewTextEntry:", this, parent, func, w, h, member, name, with_label, entry_template, label_template)
		local obj = self.hooks[this].NewTextEntry(this, parent, func, w, h, member, name, with_label, entry_template, label_template)
		obj.editbox:SetBackdrop(nil)
		self:skinEditBox{obj=obj.editbox, regs={3}, noHeight=true}
		obj.editbox.SetBackdropColor = _G.nop
		obj.editbox.SetBackdropBorderColor = _G.nop
		return obj
	end, true)
	-- NewSpellEntry
	self:RawHook(DF, "NewSpecialLuaEditorEntry", function(this, parent, w, h, member, name, nointent)
		-- print("DF NewSpecialLuaEditorEntry:", this, parent, w, h, member, name, nointent)
		local frame = self.hooks[this].NewSpecialLuaEditorEntry(this, parent, w, h, member, name, nointent)
		self:skinScrollBar{obj=frame.scroll}
		self:addSkinFrame{obj=frame}
		frame.SetBackdrop = _G.nop
		frame.SetBackdropColor = _G.nop
		frame.SetBackdropBorderColor = _G.nop
		return frame
	end, true)

end
