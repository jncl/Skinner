local aName, aObj = ...
if not aObj:isAddonEnabled("DBM-Core") then return end


function aObj:DBMGUI()

	-- (BUGFIX for DBM): reparent the Huge Bar statusBar
	for bar in DBM.Bars:GetBarIterator() do
		if bar.id == "dummy3" then
			local relTo = select(2, bar.frame:GetPoint())
			bar.frame:SetParent(relTo)
			break
		end
	end

	local modelDD, titleText, barSetup
	local function skinSubPanels(panel)

		for _, subPanel in pairs(panel.areas) do
			if not aObj.skinned[subPanel] then
				aObj:applySkin(subPanel.frame) -- use apply skin so panel contents are visible
			end
			-- check to see if any children are dropdowns or buttons
			for _, child in ipairs{subPanel.frame:GetChildren()} do
				if aObj:isDropDown(child) then
					aObj:skinDropDown{obj=child, rp=true, x2=35}
					-- check to see if this is the 3D model Dropdown
					if child.titletext
					and child.titletext:GetText() == DBM_GUI_Translations.ModelSoundOptions
					then
						modelDD = child
					end
				elseif child:IsObjectType("Button")
				and not child.GetChecked
				then
					self:skinButton{obj=child, as=true} -- make sure text is above button skin
				end
			end
			titleText = _G[subPanel.framename.."Title"]:GetText()
			-- print("titleText", titleText)
			-- (BUGFIX) reparent sliders
			if titleText == DBM_GUI_Translations.AreaTitle_BarSetup then
				barSetup = subPanel.frame
			elseif titleText == DBM_GUI_Translations.AreaTitle_BarSetupSmall then
				if barSetup then
					-- reparent the sliders
					-- work backwards as the reparenting shortens the table
					for i = barSetup:GetNumChildren(), 1, -1 do
						local child = select(i, barSetup:GetChildren())
						if child:IsObjectType("Slider") then
							child:SetParent(subPanel.frame)
						end
					end
				end
			-- check to see if this is the pizza timer option subPanel
			elseif titleText == DBM_GUI_Translations.PizzaTimer_Headline then
				local si, ei, fNo = subPanel.framename:find("DBM_GUI_Option_(%d+)")
				-- next four option frames are editboxes
				for i = fNo + 1, fNo + 4 do
					aObj:skinEditBox(_G["DBM_GUI_Option_"..i], {9})
				end
			-- (BUGFIX) reparent 3D Model DD
			elseif titleText == DBM_GUI_Translations.ModelOptions then
				modelDD:SetParent(subPanel.frame)
			end
		end

	end

-->>--	Options Frame
	-- the tabs skinning code is here so tab buttons don't get skinned twice
	-- Options Frame Tabs
	for i = 1, 2 do
		tab = _G["DBM_GUI_OptionsFrameTab"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=-2}
		tabSF.ignore = true -- ignore size changes
		tabSF.up = true -- tabs grow upwards
		-- set textures here first time thru as it's LoD
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
		if self.isTT then
			self:SecureHookScript(tab, "OnClick", function(this)
				for i = 1, 2 do
					local tabSF = self.skinFrame[_G["DBM_GUI_OptionsFrameTab"..i]]
					if i == this:GetID() then self:setActiveTab(tabSF) else self:setInactiveTab(tabSF) end
				end
			end, true)
		end
	end
	-- skin toggle buttons
	local frame, btn
	for _, v in pairs{"BossMods", "DBMOptions"} do
		frame = _G["DBM_GUI_OptionsFrame"..v]
		for i = 1, #frame.buttons do
			btn = _G["DBM_GUI_OptionsFrame"..v.."Button"..i.."Toggle"]
			self:skinButton{obj=btn, mp2=true, plus=i==1 and true or nil}
		end
	end

	self:skinSlider{obj=DBM_GUI_OptionsFrameBossModsListScrollBar}
	self:addSkinFrame{obj=DBM_GUI_OptionsFrameBossMods, kfs=true}
	self:addSkinFrame{obj=DBM_GUI_OptionsFrameDBMOptions, kfs=true}
	self:skinScrollBar{obj=DBM_GUI_OptionsFramePanelContainerFOV}
	self:addSkinFrame{obj=DBM_GUI_OptionsFramePanelContainer, bas=true}
	self:addSkinFrame{obj=DBM_GUI_OptionsFrame, kfs=true, hdr=true}
	-- skin dropdown
	self:addSkinFrame{obj=DBM_GUI_DropDown}

	-- hook this to skin sub panels
	self:SecureHook(DBM_GUI, "CreateNewPanel", function(this, ...)
		for _, panel in pairs(DBM_GUI.panels) do
			if not panel.hooked then
				self:SecureHook(panel, "CreateArea", function(this, ...)
					skinSubPanels(panel)
				end)
				panel.hooked = true
			end
		end
	end)

	-- hook this to skin dropdowns
	self:RawHook(DBM_GUI, "CreateDropdown", function(this, ...)
		local dd = self.hooks[DBM_GUI].CreateDropdown(this, ...)
		self:skinDropDown{obj=dd, rp=true, x2=35}
		return dd
	end, true)

	-- loop through all the existing panels
	for _, panel in pairs(DBM_GUI.panels) do
		if panel.areas then
			skinSubPanels(panel)
		else
			if not panel.hooked then
				self:SecureHook(panel, "CreateArea", function(this, ...)
					skinSubPanels(panel)
				end)
				panel.hooked = true
			end
		end
	end

	-- skin the Bosses LoadAddOn buttons
	for k,addon in ipairs(DBM.AddOns) do
		if addon.panel.frame:GetNumChildren() == 1 then
			self:skinButton{obj=self:getChild(addon.panel.frame, 1)}
		end
	end

end

function aObj:DBMCore()

	-- hook this to skin the RangeCheck frame (actually a tooltip)
	self:SecureHook(DBM.RangeCheck, "Show", function(this, ...)
		self:addSkinFrame{obj=DBMRangeCheck}
		self:Unhook(DBM.RangeCheck, "Show")
	end)
	-- hook this to skin the InfoFrame frame (actually a tooltip)
	self:SecureHook(DBM.InfoFrame, "Show", function(this, ...)
		self:addSkinFrame{obj=DBMInfoFrame}
		self:Unhook(DBM.InfoFrame, "Show")
	end)
	-- hook these to skin the BossHealth Bars
	local bhFrame
	self:SecureHook(DBM.BossHealth, "Show", function(this, name)
		bhFrame = DBMBossHealthDropdown:GetParent()
		self:Unhook(DBM.BossHealth, "Show")
	end)
	self:SecureHook(DBM.BossHealth, "AddBoss", function(this, ...)
		if not bhFrame then return end
		for _, child in ipairs{bhFrame:GetChildren()} do
			local cName = child:GetName().."Bar"
			if cName:find("DBM_BossHealth_Bar_")
			and	not self.skinned[child]
			then
				_G[cName.."Border"]:SetAlpha(0) -- hide border
				self:glazeStatusBar(_G[cName], 0, _G[cName.."Background"])
			end
		end
	end)
	-- hook this to skin UpdateReminder frame
	self:SecureHook(DBM, "ShowUpdateReminder", function(this, ...)
		local frame = self:findFrame2(UIParent, "Frame", 155, 430)
		if frame then
			self:addSkinFrame{obj=frame}
			self:skinEditBox{obj=self:getChild(frame, 1), regs={9}}
		end
		self:Unhook(DBM, "ShowUpdateReminder")
	end)

	-- set default Timer bar texture
	DBT_SavedOptions.Texture = self.db.profile.StatusBar.texture
	-- apply the change
	DBM.Bars:SetOption("Texture", self.sbTexture)

	-- minimap button
	if self.db.profile.MinimapButtons.skin then
		DBMMinimapButton:GetNormalTexture():SetTexCoord(.3, .7, .3, .7)
		DBMMinimapButton:GetPushedTexture():SetTexCoord(.3, .7, .3, .7)
		DBMMinimapButton:SetWidth(22)
		DBMMinimapButton:SetHeight(22)
		self:addSkinButton{obj=DBMMinimapButton, parent=DBMMinimapButton}
	end

end
