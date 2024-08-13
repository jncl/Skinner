-- luacheck: ignore 631 (line is too long)
local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["DetailsFramework-1.0"] = function(self) -- v 367
	if self.initialized.DetailsFramework then return end
	self.initialized.DetailsFramework = true

	local DF = _G.LibStub("DetailsFramework-1.0", true)
	if not DF then return end

	-- addon ()

	-- button (parent, container, name, member, w, h, func, param1, param2, texture, text, short_method, button_template, text_template)
	if self.modBtns then
		self:RawHook(DF, "NewButton", function(this, ...)
			local varCnt = _G.select("#", ...)
			local btnObj = self.hooks[this].NewButton(this, ...)
			-- check to see if a button template is specified
			if varCnt == 13 then
				if btnObj.param2 == "param2" then
					-- colour pick button
					_G.nop()
				elseif _G.select(5, ...) == 20
				or _G.select(5, ...) == 21
				then
					-- icon button
					_G.nop()
				else
					self:skinStdButton{obj=btnObj.button}
				end
			-- non template button
			elseif varCnt == 12
			and _G.select(11, ...) ~= ""
			then
				self:skinStdButton{obj=btnObj.button}
				btnObj.button.SetBackdrop = _G.nop
				btnObj.button.SetBackdropColor = _G.nop
				btnObj.button.SetBackdropBorderColor = _G.nop
				-- if it has 6 params, name contains slider, width is 60 then it's a checkbox
			elseif varCnt == 6
			and _G.select(4, ...)
			and (_G.select(4, ...):find("Slider")
			or _G.select(4, ...):find("Switch"))
			then
				self:skinStdButton{obj=btnObj.button}
				if btnObj.button.sb.tfade then
					btnObj.button.sb.tfade:SetTexture(nil)
				end
			end
			return btnObj
		end, true)
	end

	-- colorpickerbutton (name, member, callback, alpha, button_template)

	-- coooltip
	local function skinCooltip(frame)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		aObj:skinObject("frame", {obj=frame, kfs=true, x1=-3, x2=3})
	end
	if _G.GameCooltip2 then
		_G.GameCooltip2.SetBackdrop = _G.nop
		skinCooltip(_G.GameCooltip2.frame1)
		skinCooltip(_G.GameCooltip2.frame2)
	else
		-- obj.frame1 -> GameCooltipFrame1
		-- obj.frame2 -> GameCooltipFrame2
		self:RawHook(DF, "CreateCoolTip", function(this)
			local obj = self.hooks[this].CreateCoolTip(this)
			obj.SetBackdrop = _G.nop
			skinCooltip(obj.frame1)
			skinCooltip(obj.frame2)
			self:Unhook(this, "CreateCoolTip")
			return obj
		end, true)
	end

	-- dropdown (parent, name)
	self:RawHook(DF, "CreateNewDropdownFrame", function(this, ...)
		local button = self.hooks[this].CreateNewDropdownFrame(this, ...)
		self:removeBackdrop(button.dropdownframe:GetScrollChild())
		self:skinObject("frame", {obj=button.dropdownborder, kfs=true, ofs=4})
		return button
	end, true)
	-- dropdownbutton (parent, name)

	-- help (parent, width, height, x, y, buttonWidth, buttonHeight, name)
	-- label (parent, text, size, color, font, member, name, layer)
	-- normal_bar (parent, texture, w, h, value, member, name)
	-- panel (parent, container, name, member, w, h, backdrop, backdropcolor, bordercolor)

	-- newfillpanel (parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
	self:RawHook(DF, "NewFillPanel", function(this, ...)
		local obj = self.hooks[this].NewFillPanel(this, ...)
		self:skinObject("slider", {obj=obj.scrollframe.ScrollBar})
		return obj
	end, true)

	-- IconPick ()
	-- ShowPanicWarning ()
	-- CreateScaleBar ()

	-- simplepanel (parent, w, h, title, name, panel_options, db)
	self:RawHook(DF, "CreateSimplePanel", function(this, ...)
		local frame = self.hooks[this].CreateSimplePanel(this, ...)
		self:removeBackdrop(frame.TitleBar)
		self:skinObject("frame", {obj=frame, kfs=true, ofs=4})
		frame.SetBackdrop = _G.nop
		frame.SetBackdropColor = _G.nop
		frame.SetBackdropBorderColor = _G.nop
		return frame
	end, true)

	-- 1pxpanel (parent, w, h, title, name, config, title_anchor, no_special_frame)

	-- prompt_panel (message, func_true, func_false, no_repeated, width)
	self:SecureHook(DF, "ShowPromptPanel", function(this, _)
		if not DF.prompt_panel then
			DF.prompt_panel = DF.promtp_panel -- N.B. TYPO!!
		end
		self:removeBackdrop(DF.prompt_panel.TitleBar)
		self:skinObject("frame", {obj=DF.prompt_panel, kfs=true})

		self:Unhook(this, "ShowPromptPanel")
	end)

	-- text_prompt_panel (message, callback)
	self:SecureHook(DF, "ShowTextPromptPanel", function(this, _)
		self:removeBackdrop(DF.text_prompt_panel.TitleBar)
		self:skinObject("frame", {obj=DF.text_prompt_panel, kfs=true})

		self:Unhook(this, "ShowTextPromptPanel")
	end)

	-- CreateOptionsButton ()
	-- CreateFeedbackButton ()
	-- ShowFeedbackPanel ()
	-- CreateChartPanel ()
	-- CreateGFrame ()
	-- CreateButtonContainer ()
	-- CreateTabContainer ()
	-- CreateSimpleListBox ()
	-- CreateScrollBox ()

	-- picture (parent, texture, w, h, layer, coords, member, name)
	local texture
	self:RawHook(DF, "NewImage", function(this, ...)
		local obj = self.hooks[this].NewImage(this, ...)
		texture = _G.select(2, ...)
		if texture
		and _G.type(texture) == "String"
		and (texture:find("PaperDollSidebarTabs")
		or texture:find("BookCompletedLeft")
		or texture:find("StatsBackground"))
		then
			obj.image:SetTexture(nil)
		end
		return obj
	end, true)

	-- pictureedit ()
	-- DetailsFrameworkImageEdit ()

	-- scrollbar (master, slave, x, y)
	self:RawHook(DF, "NewScrollBar", function(this, ...)
		local slider = self.hooks[this].NewScrollBar(this, ...)
		slider.bg:SetTexture(nil)
		self:skinObject("slider", {obj=slider})
		return slider
	end, true)

	-- switch (parent, container, name, member, w, h, ltext, rtext, default_value, color_inverted, switch_func, return_func, with_label, switch_template, label_template)

	-- split_bar (parent, w, h, member, name)

	-- textentry (parent, container, name, member, w, h, func, param1, param2, space, with_label, entry_template, label_template)
	self:RawHook(DF, "NewTextEntry", function(this, ...)
		local obj = self.hooks[this].NewTextEntry(this, ...)
		self:removeBackdrop(obj.editbox)
		self:skinObject("editbox", {obj=obj.editbox, regions={3, 4, 5, 6, 7, 8, 9, 10, 11}})
		obj.editbox.SetBackdropColor = _G.nop
		obj.editbox.SetBackdropBorderColor = _G.nop
		return obj
	end, true)

	-- NewSpellEntry (parent, w, h, member, name, nointent)
	self:RawHook(DF, "NewSpecialLuaEditorEntry", function(this, ...)
		local frame = self.hooks[this].NewSpecialLuaEditorEntry(this, ...)
		self:skinObject("slider", {obj=frame.scroll.ScrollBar})
		self:skinObject("frame", {obj=frame, kfs=true, x2=22})
		frame.SetBackdrop = _G.nop
		frame.SetBackdropColor = _G.nop
		frame.SetBackdropBorderColor = _G.nop
		return frame
	end, true)

end
