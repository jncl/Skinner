local aName, aObj = ...
if not aObj:isAddonEnabled("DBM-Core") then return end
local _G = _G
local pairs, ipairs = _G.pairs, _G.ipairs
local DBM = _G.DBM

function aObj:DBMGUI() -- LoD

	local DBM_GUI, DBM_GUI_Translations = _G.DBM_GUI, _G.DBM_GUI_Translations

	-- (BUGFIX for DBM): reparent the Huge Bar statusBar
	for bar in DBM.Bars:GetBarIterator() do
		if bar.id == "dummy3" then
			local relTo = _G.select(2, bar.frame:GetPoint())
			bar.frame:SetParent(relTo)
			break
		end
	end

	local modelDD, titleText, barSetup
	local function skinSubPanels(panel)

		for _, subPanel in pairs(panel.areas) do
			if not subPanel.sknd then
				aObj:applySkin(subPanel.frame) -- use apply skin so panel contents are visible
			end
			-- check to see if any children are dropdowns or buttons
			local kids = {subPanel.frame:GetChildren()}
			for _, child in _G.ipairs(kids) do
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
					aObj:skinButton{obj=child, as=true} -- make sure text is above button skin
				end
			end
			kids = _G.null
			titleText = _G[subPanel.framename .. "Title"]:GetText()
			-- (BUGFIX) reparent sliders
			if titleText == DBM_GUI_Translations.AreaTitle_BarSetup then
				barSetup = subPanel.frame
			elseif titleText == DBM_GUI_Translations.AreaTitle_BarSetupSmall then
				if barSetup then
					-- reparent the sliders
					-- work backwards as the reparenting shortens the table
					for i = barSetup:GetNumChildren(), 1, -1 do
						local child = _G.select(i, barSetup:GetChildren())
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
					aObj:skinEditBox(_G["DBM_GUI_Option_" .. i], {9})
				end
			-- (BUGFIX) reparent 3D Model DD
			elseif titleText == DBM_GUI_Translations.ModelOptions then
				modelDD:SetParent(subPanel.frame)
			end
		end

	end

-->>--	Options Frame
	-- skin toggle buttons
	local frame, btn
	for _, v in pairs{"BossMods", "DBMOptions"} do
		frame = _G["DBM_GUI_OptionsFrame" .. v]
		for i = 1, #frame.buttons do
			btn = _G["DBM_GUI_OptionsFrame" .. v .. "Button" .. i .. "Toggle"]
			self:skinButton{obj=btn, mp2=true, plus=i==1 and true or nil}
		end
	end

	self:skinSlider{obj=_G.DBM_GUI_OptionsFrameBossModsListScrollBar}
	self:addSkinFrame{obj=_G.DBM_GUI_OptionsFrameBossMods, kfs=true}
	self:addSkinFrame{obj=_G.DBM_GUI_OptionsFrameDBMOptions, kfs=true}
	self:skinScrollBar{obj=_G.DBM_GUI_OptionsFramePanelContainerFOV}
	self:addSkinFrame{obj=_G.DBM_GUI_OptionsFramePanelContainer, bas=true}
	-- don't skin buttons as this also skins tab buttons
	self:addSkinFrame{obj=_G.DBM_GUI_OptionsFrame, kfs=true, hdr=true, nb=true}
	self:skinButton{obj=_G.DBM_GUI_OptionsFrameOkay}
	self:skinButton{obj=_G.DBM_GUI_OptionsFrameWebsiteButton}
	-- Tabs
	_G.DBM_GUI_OptionsFrame.numTabs = 2
	self:skinTabs{obj=_G.DBM_GUI_OptionsFrame, ignore=true, up=true, lod=true, y2=-3}
	-- hook this to manage tabs
	self:SecureHook(_G.DBM_GUI_OptionsFrame, "ShowTab", function(this, tab)
		_G.PanelTemplates_SetTab(this, tab)
	end)
	-- skin dropdown
	self:addSkinFrame{obj=_G.DBM_GUI_DropDown}

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

	-- hook this to skin BossMod sub panels button in TRHC
	self:SecureHook(DBM_GUI, "CreateBossModPanel", function(this, mod)
		self:skinButton{obj=self:getChild(mod.panel.frame, 1), as=true}
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
		self:addSkinFrame{obj=_G.DBMRangeCheck}
		self:Unhook(DBM.RangeCheck, "Show")
	end)
	-- hook this to skin the InfoFrame frame (actually a tooltip)
	self:SecureHook(DBM.InfoFrame, "Show", function(this, ...)
		self:addSkinFrame{obj=_G.DBMInfoFrame}
		self:Unhook(DBM.InfoFrame, "Show")
	end)
	-- hook these to skin the BossHealth Bars
	local bhFrame
	self:SecureHook(DBM.BossHealth, "Show", function(this, ...)
		bhFrame = _G.DBMBossHealthDropdown:GetParent()
		self:Unhook(DBM.BossHealth, "Show")
	end)
	self:SecureHook(DBM.BossHealth, "AddBoss", function(this, ...)
		if not bhFrame then return end
		local kids = {bhFrame:GetChildren()}
		for _, child in _G.ipairs(kids) do
			local cName = child:GetName().."Bar"
			if cName:find("DBM_BossHealth_Bar_")
			and	not self.sbGlazed[_G[cName]]
			then
				_G[cName .. "Border"]:SetAlpha(0) -- hide border
				self:glazeStatusBar(_G[cName], 0, _G[cName .. "Background"])
			end
		end
		kids = _G.null
	end)
	-- hook this to skin UpdateReminder frame
	self:SecureHook(DBM, "ShowUpdateReminder", function(this, ...)
		self.RegisterCallback("DBM-ShowUpdateReminder", "UIParent_GetChildren", function(this, child)
			local height, width = self:getInt(child:GetHeight()), self:getInt(child:GetWidth())
			if height == 140
			and width == 430
			then
				self:skinEditBox{obj=self:getChild(child, 1), regs={9}}
				self:skinButton{obj=self:getChild(child, 2)}
				self:addSkinFrame{obj=child, nb=true}
				self.UnregisterCallback("DBM-ShowUpdateReminder", "UIParent_GetChildren")
			end
		end)
		self:scanUIParentsChildren()
		self:Unhook(DBM, "ShowUpdateReminder")
	end)

	-- set default Timer bar texture
	_G.DBT_PersistentOptions.Texture = self.db.profile.StatusBar.texture
	-- apply the change
	_G.DBM.Bars:SetOption("Texture", self.sbTexture)

	-- minimap button
	if self.db.profile.MinimapButtons.skin then
		_G.DBMMinimapButton:GetNormalTexture():SetTexCoord(.3, .7, .3, .7)
		_G.DBMMinimapButton:GetPushedTexture():SetTexCoord(.3, .7, .3, .7)
		_G.DBMMinimapButton:SetWidth(22)
		_G.DBMMinimapButton:SetHeight(22)
		self:addSkinButton{obj=_G.DBMMinimapButton, parent=_G.DBMMinimapButton}
	end

end
