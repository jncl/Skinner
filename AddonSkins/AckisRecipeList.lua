local aName, aObj = ...
if not aObj:isAddonEnabled("AckisRecipeList") then return end
local _G = _G
local pairs, ipairs = _G.pairs, _G.ipairs

function aObj:AckisRecipeList() -- v7.0.3.8
	if not self.db.profile.TradeSkillUI then return end

	local ARL = _G.LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true)
	if not ARL then return end

	-- check version
	local vTab = {
		["1.0 2817"] = 1, -- release
		["1.0 @project-revision@"] = 2, -- beta
		["v1.1.0-beta2"] = 3, -- beta
		["2.0-rc1"] = 4, -- beta
		["2.0-rc2"] = 5, -- beta
		["v2.0"] = 6, -- release
		["v2.01"] = 7, -- release
		["2.0.4"] = 8, -- release
		["2.0.5"] = 9, -- release
		["2.1.0"] = 10, -- release
		["2.2.8"] = 11, -- release
		["2.4.1"] = 12, -- release
		["7.0.3.8"] = 70, -- release
	}
	local aVer = _G.GetAddOnMetadata("AckisRecipeList", "Version")
	local ver = vTab[aVer] or 99

	local function skinARL(frame)

		if ver < 4 then
			frame.backdrop:SetAlpha(0)
		end
		-- button in TLHC
		aObj:moveObject{obj=ver > 4 and frame.prof_button or frame.mode_button, x=6, y=-9}
		aObj:moveObject{obj=ver > 11 and frame.profession_texture, x=6, y=-9}
		if ver < 3 then
			aObj:skinDropDown{obj=_G.ARL_DD_Sort}
		end
		if ver == 1 then
			aObj:skinEditBox{obj=_G.ARL_SearchText, regs={6}}
		else
			aObj:skinEditBox{obj=frame.search_editbox, regs={6}, noHeight=true, mi=true}
			frame.search_editbox:SetHeight(18)
		end
		if ver > 2 then
			-- expand button frame
			local ebF = aObj:getChild(frame, ver < 6 and 7 or 3)
			aObj:keepRegions(ebF, {ver == 1 and 6})
			aObj:moveObject{obj=ebF, y=6}
			local eBtn = ver > 5 and frame.expand_button or frame.expand_all_button
			aObj:skinButton{obj=eBtn, mp=true, plus=true}
			aObj:SecureHookScript(eBtn, "OnClick", function(this)
				aObj:checkTex(this)
			end)
		end
		local sF = ver > 5 and frame.list_frame or frame.scroll_frame
		if ver == 1 then
			aObj:skinScrollBar{obj=sF}
		else
			aObj:adjWidth{obj=sF.scroll_bar, adj=-6}
			aObj:skinSlider{obj=sF.scroll_bar}
			sF:SetBackdrop(nil)
		end
		--	minus/plus buttons
		if ver < 70 then
			for _, btn in pairs(sF.state_buttons) do
				aObj:skinButton{obj=btn, mp2=true, plus=true}
				if ver < 6 then btn.text:SetJustifyH("CENTER") end
			end
		else
			for _, btn in pairs(sF.ListEntryButtons) do
				btn.titleBackgroundTexture:SetTexture(nil)
				aObj:skinButton{obj=btn.stateButton, mp2=true, plus=true}
			end
		end
		-- progress bar
		aObj:glazeStatusBar(frame.progress_bar, 0)
		frame.progress_bar:SetBackdrop(nil)
		aObj:removeRegions(frame.progress_bar, {ver > 3 and 2 or 6})
		-- skin the frame
		local x1, y1, x2, y2 = 6, -9, 2, -3
		if ver > 3 then
			x1, y1, x2, y2 = 10, -11, -33, 74
		end
		aObj:addSkinFrame{obj=frame, kfs=true, x1=x1, y1=y1, x2=x2, y2=y2}
		-- show profession texture
		if ver > 11 then
			frame.profession_texture:SetAlpha(1)
		end

-->>-- Tabs
		if ver > 2 then
			for i = 1, #frame.tabs do
				local tabObj = frame.tabs[i]
				aObj:keepRegions(tabObj, {4, 5}) -- N.B. region 4 is highlight, 5 is text
				local tabSF = self:addSkinFrame{obj=tabObj, noBdr=aObj.isTT, x1=6, y1=0, x2=-6, y2=2}
				if i == 3 then
					if aObj.isTT then self:setActiveTab(tabSF) end
				else
					if aObj.isTT then self:setInactiveTab(tabSF) end
				end
				if aObj.isTT then
					aObj:SecureHookScript(tabObj, "OnClick", function(this)
						for i, tab in ipairs(frame.tabs) do
							if tab == this then aObj:setActiveTab(tab.sf)
							else aObj:setInactiveTab(tab.sf) end
						end
					end)
				end
			end
		end

-->>-- Filter Menu
		-- hook this to handle frame size change when filter button is clicked
		aObj:SecureHook(frame, "ToggleState", function(this)
--			self:Debug("ARL_TS: [%s, %s]", this, this.is_expanded)
			local xOfs, yOfs = 2, -3
			if ver > 3 then
				yOfs = 74
				if this.is_expanded then xOfs = -87
				else xOfs = -33 end
			end
			frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", xOfs, yOfs)
			-- Reset button
			if not aObj.sBtn[frame.filter_reset] then
				aObj:skinButton{obj=frame.filter_reset}
			end
		end)
		if ver < 4 then
			aObj:addSkinFrame{obj=frame.filter_menu, kfs=true, bg=true} -- separate Flyaway panel
		elseif ver < 6 then
			aObj:getRegion(frame.filter_menu.misc, 1):SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb) -- filter text
		end
		local function changeTextColour(frame)

			for _, child in ipairs{frame:GetChildren()} do
				if child:IsObjectType("CheckButton") then
					if child.text then child.text:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb) end
				elseif child:IsObjectType("Frame") then
					changeTextColour(child)
				end
			end

		end
		if ver < 6 then
			changeTextColour(frame.filter_menu)
		else
			aObj:SecureHookScript(frame.filter_toggle, "OnClick", function(this)
				changeTextColour(frame.filter_menu)
				aObj:getRegion(frame.filter_menu.misc, 1):SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
				aObj:Unhook(frame.filter_toggle, "OnClick")
			end)
		end

		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.sort_button, ofs=-2, x1=1}
			aObj:addButtonBorder{obj=frame.filter_toggle, ofs=-2, x1=1}
		end

	end

	if ver > 2 and ver < 6 then
		self:SecureHookScript(_G.ARL_MainPanel, "OnShow", function(this)
			skinARL(this)
			self:Unhook(_G.ARL_MainPanel, "OnShow")
		end)
	else
		local hookFunc = ARL.Scan and "Scan" or ARL.DisplayFrame and "DisplayFrame" or "CreateFrame"
		self:SecureHook(ARL, hookFunc, function(this)
			skinARL(ARL.Frame)
			self:Unhook(ARL, hookFunc)
		end)
	end

	if ver < 12 then
		-- TextDump frame
		self:skinScrollBar{obj=_G.ARLCopyScroll}
		self:addSkinFrame{obj=_G.ARLCopyFrame}
	end

	-- button on Tradeskill frame
	if ver < 11 then
		self:skinButton{obj=ARL.scan_button}
	else
		if ver < 70 then
			if ARL.CreateScanButton then
				self:SecureHook(ARL, "CreateScanButton", function()
					self:skinButton{obj=ARL.scan_button}
					self:Unhook(ARL, "CreateScanButton")
				end)
			else
				self:skinButton{obj=ARL.scan_button}
			end
		end
	end

-->>-- Tooltip
	local tTip = ver > 5 and _G.AckisRecipeList_SpellTooltip or _G.arlSpellTooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then tTip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(tTip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
