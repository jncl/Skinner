local aName, aObj = ...
if not aObj:isAddonEnabled("DBM-Core") then return end
local _G = _G
local pairs, ipairs = _G.pairs, _G.ipairs

aObj.addonsToSkin["DBM-Core"] = function(self) -- v 8.0.1

	-- hook this to skin the InfoFrame frame (actually a tooltip)
	self:SecureHook(_G.DBM.InfoFrame, "Show", function(this, _, event, ...)
		if _G.DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end
		self:addSkinFrame{obj=_G.DBMInfoFrame, ft="a", nb=true}
		self:Unhook(_G.DBM.InfoFrame, "Show")
	end)

	-- hook this to skin UpdateReminder frame
	self:SecureHook(_G.DBM, "ShowUpdateReminder", function(this, ...)
		self:skinEditBox{obj=self:getChild(_G.DBMUpdateReminder, 1), regs={6}}
		self:skinStdButton{obj=self:getChild(_G.DBMUpdateReminder, 2)}
		self:addSkinFrame{obj=_G.DBMUpdateReminder, ft="a", nb=true}
		self:Unhook(_G.DBM, "ShowUpdateReminder")
	end)

	-- hook this to skin DBMNotesEditor frame
	self:SecureHook(_G.DBM, "ShowNoteEditor", function(this, ...)
		self:skinEditBox{obj=self:getChild(this.Noteframe, 1), regs={6}} -- 6 is text
		self:skinStdButton{obj=self:getChild(this.Noteframe, 2)}
		self:skinStdButton{obj=self:getChild(this.Noteframe, 3)}
		self:skinStdButton{obj=self:getChild(this.Noteframe, 4)}
		self:addSkinFrame{obj=this.Noteframe, ft="a", nb=true}
		self:Unhook(this, "ShowNoteEditor")
	end)

	-- set default Timer bar texture
	_G.DBT_PersistentOptions.Texture = self.db.profile.StatusBar.texture
	-- apply the change
	_G.DBM.Bars:SetOption("Texture", self.sbTexture)

	-- minimap button
	if _G.DBMMinimapButton -- from 17687 alpha uses lib DBIcon for minimap button
	and self.db.profile.MinimapButtons.skin
	then
		_G.DBMMinimapButton:GetNormalTexture():SetTexCoord(.3, .7, .3, .7)
		_G.DBMMinimapButton:GetPushedTexture():SetTexCoord(.3, .7, .3, .7)
		_G.DBMMinimapButton:SetSize(22, 22)
		self:addSkinButton{obj=_G.DBMMinimapButton, parent=_G.DBMMinimapButton}
	end

end

aObj.lodAddons["DBM-GUI"] = function(self) -- v 8.0.1

	--	Options Frame
	self:SecureHookScript(_G.DBM_GUI_OptionsFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.DBM_GUI_OptionsFrameBossModsListScrollBar}
		self:addSkinFrame{obj=_G.DBM_GUI_OptionsFrameBossMods, ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=_G.DBM_GUI_OptionsFrameDBMOptions, ft="a", kfs=true, nb=true}
		self:skinSlider{obj=_G.DBM_GUI_OptionsFramePanelContainerFOVScrollBar}
		self:addSkinFrame{obj=_G.DBM_GUI_OptionsFramePanelContainer, ft="a", nb=true}
		self:addSkinFrame{obj=_G.DBM_GUI_OptionsFrame, ft="a", kfs=true, hdr=true, nb=true}
		self:skinStdButton{obj=_G.DBM_GUI_OptionsFrameOkay}
		self:skinStdButton{obj=_G.DBM_GUI_OptionsFrameWebsiteButton}
		-- Tabs
		_G.DBM_GUI_OptionsFrame.numTabs = 2
		self:skinTabs{obj=_G.DBM_GUI_OptionsFrame, ignore=true, up=true, lod=true, y2=-3}
		-- hook this to manage tabs
		self:SecureHook(_G.DBM_GUI_OptionsFrame, "ShowTab", function(this, tab)
			_G.PanelTemplates_SetTab(this, tab)
		end)
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
				self:skinExpandButton{obj=_G["DBM_GUI_OptionsFrame" .. v .. "Button" .. i .. "Toggle"], sap=true, plus=plus}
			end
		end
		-- skin the Bosses LoadAddOn buttons
		for k, addon in ipairs(_G.DBM.AddOns) do
			if addon.panel.frame:GetNumChildren() == 1 then
				self:skinStdButton{obj=self:getChild(addon.panel.frame, 1)}
			end
		end
		-- skin dropdown menu
		self:addSkinFrame{obj=_G.DBM_GUI_DropDown, ft="a", nb=true}
		self:Unhook(this, "OnShow")
	end)

	local function skinSubPanels(panel)

		for _, subPanel in pairs(panel.areas) do
			if not subPanel.frame.sf then
				aObj:addSkinFrame{obj=subPanel.frame, ft="a", nb=true}
			end
			-- check to see if any children are dropdowns or buttons
			for _, child in ipairs{subPanel.frame:GetChildren()} do
				if aObj:isDropDown(child) then
					aObj:skinDropDown{obj=child, rp=true, x2=34}
                elseif child:IsObjectType("CheckButton") then -- NewSpecialWarning object
					aObj:skinCheckButton{obj=child}
                    for _, child2 in ipairs{child:GetChildren()} do
                        if aObj:isDropDown(child2) then
        					aObj:skinDropDown{obj=child2, rp=true, x1=16, x2=34, y2=-1}
                        end
                    end
				elseif child:IsObjectType("Button")
				and not child.sb
				then
					-- handle expand button (Spell/Skill Cooldowns)
					if _G.Round(child:GetHeight()) == 15
					and _G.Round(child:GetWidth()) == 15
					then
						child:SetSize(8, 8)
						aObj:skinExpandButton{obj=child}
					else
						-- increase high of short, narrow buttons
						if _G.Round(child:GetHeight()) < 15 then
							child:SetHeight(15)
						end
						aObj:skinStdButton{obj=child}
					end
                elseif child:IsObjectType("EditBox") then
                    aObj:skinEditBox{obj=child, regs={6}}
				elseif child:IsObjectType("Slider") then
					aObj:skinSlider{obj=child}
				end
			end
		end

	end

	-- hook this to skin sub panels
	self:SecureHook(_G.DBM_GUI, "CreateNewPanel", function(this, ...)
		for _, panel in pairs(_G.DBM_GUI.panels) do
			self:secureHook(panel, "CreateArea", function(this, ...)
				_G.C_Timer.After(0.25, function() -- wait for it to be populated
					skinSubPanels(this)
				end)
			end)
		end
	end)

	-- hook this to skin BossMod sub panels button in TRHC
	self:SecureHook(_G.DBM_GUI, "CreateBossModPanel", function(this, mod)
		self:skinStdButton{obj=self:getChild(mod.panel.frame, 1)}
		self:skinCheckButton{obj=self:getChild(mod.panel.frame, 2)}
	end)

end
