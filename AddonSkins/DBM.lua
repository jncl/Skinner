local aName, aObj = ...
if not aObj:isAddonEnabled("DBM-Core") then return end
local _G = _G
local pairs, ipairs = _G.pairs, _G.ipairs

function aObj:DBMGUI() -- LoD

	local function skinSubPanels(panel)

		for _, subPanel in pairs(panel.areas) do
			if not subPanel.sknd then
				aObj:applySkin(subPanel.frame) -- use apply skin so panel contents are visible
			end
			-- check to see if any children are dropdowns or buttons
			local kids = {subPanel.frame:GetChildren()}
			for _, child in ipairs(kids) do
				if aObj:isDropDown(child) then
					aObj:skinDropDown{obj=child, rp=true, x2=35}
				elseif child:IsObjectType("Button")
				and not child.GetChecked
				then
					aObj:skinButton{obj=child, as=true} -- make sure text is above button skin
                elseif child:IsObjectType("EditBox") then
                    aObj:skinEditBox{obj=child, regs={9}}
                elseif child:IsObjectType("CheckButton") then -- NewSpecialWarning object
                    local kids2 = {child:GetChildren()}
                    for _, child2 in _G.ipairs(kids2) do
                        if aObj:isDropDown(child2) then
        					aObj:skinDropDown{obj=child2, rp=true, x1=16, x2=35, y2=-1}
                        end
                    end
                    kids2 = nil
				end
			end
		end

	end

-->>--	Options Frame
	-- skin toggle buttons
	local frame, plus
	for _, v in pairs{"BossMods", "DBMOptions"} do
		frame = _G["DBM_GUI_OptionsFrame" .. v]
		for i = 1, #frame.buttons do
            plus = false
            if frame.buttons[i].element
            and frame.buttons[i].element.haschilds
            and not frame.buttons[i].element.showsub
            then
                plus = true
            end
			self:skinButton{obj=_G["DBM_GUI_OptionsFrame" .. v .. "Button" .. i .. "Toggle"], mp2=true, plus=plus}
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
	self:SecureHook(_G.DBM_GUI, "CreateNewPanel", function(this, ...)
		for _, panel in pairs(_G.DBM_GUI.panels) do
			if not panel.hooked then
				self:SecureHook(panel, "CreateArea", function(this, ...)
					skinSubPanels(this)
				end)
				panel.hooked = true
			end
		end
	end)

	-- hook this to skin BossMod sub panels button in TRHC
	self:SecureHook(_G.DBM_GUI, "CreateBossModPanel", function(this, mod)
		self:skinButton{obj=self:getChild(mod.panel.frame, 1), as=true}
	end)

	-- loop through all the existing panels
	for _, panel in pairs(_G.DBM_GUI.panels) do
		if panel.areas then
			skinSubPanels(panel)
		else
			if not panel.hooked then
				self:SecureHook(panel, "CreateArea", function(this, ...)
					skinSubPanels(this)
				end)
				panel.hooked = true
			end
		end
	end

	-- skin the Bosses LoadAddOn buttons
	for k, addon in ipairs(_G.DBM.AddOns) do
		if addon.panel.frame:GetNumChildren() == 1 then
			self:skinButton{obj=self:getChild(addon.panel.frame, 1)}
		end
	end

end

function aObj:DBMCore()

	-- hook this to skin the RangeCheck frame (actually a tooltip)
	self:SecureHook(_G.DBM.RangeCheck, "Show", function(this, ...)
		self:addSkinFrame{obj=this}
		self:Unhook(_G.DBM.RangeCheck, "Show")
	end)
	-- hook this to skin the InfoFrame frame (actually a tooltip)
	self:SecureHook(_G.DBM.InfoFrame, "Show", function(this, ...)
		self:addSkinFrame{obj=this}
		self:Unhook(_G.DBM.InfoFrame, "Show")
	end)
	-- hook these to skin the BossHealth Bars
	local bhFrame
	self:SecureHook(_G.DBM.BossHealth, "Show", function(this, ...)
		bhFrame = _G.DBMBossHealthDropdown:GetParent()
		self:Unhook(_G.DBM.BossHealth, "Show")
	end)
	self:SecureHook(_G.DBM.BossHealth, "AddBoss", function(this, ...)
		if not bhFrame then return end
		local kids = {bhFrame:GetChildren()}
		for _, child in ipairs(kids) do
			local cName = child:GetName() .. "Bar"
			if cName:find("DBM_BossHealth_Bar_")
			and	not self.sbGlazed[_G[cName]]
			then
				_G[cName .. "Border"]:SetAlpha(0) -- hide border
				self:glazeStatusBar(_G[cName], 0, _G[cName .. "Background"])
			end
		end
		kids = nil
	end)
	-- hook this to skin UpdateReminder frame
	self:SecureHook(_G.DBM, "ShowUpdateReminder", function(this, ...)
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
		self:Unhook(_G.DBM, "ShowUpdateReminder")
	end)

	-- set default Timer bar texture
	_G.DBT_PersistentOptions.Texture = self.db.profile.StatusBar.texture
	-- apply the change
	_G.DBM.Bars:SetOption("Texture", self.sbTexture)

	-- minimap button
	if self.db.profile.MinimapButtons.skin then
		_G.DBMMinimapButton:GetNormalTexture():SetTexCoord(.3, .7, .3, .7)
		_G.DBMMinimapButton:GetPushedTexture():SetTexCoord(.3, .7, .3, .7)
		_G.DBMMinimapButton:SetSize(22, 22)
		self:addSkinButton{obj=_G.DBMMinimapButton, parent=_G.DBMMinimapButton}
	end

end
