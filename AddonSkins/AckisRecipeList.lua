local aName, aObj = ...
if not aObj:isAddonEnabled("AckisRecipeList") then return end
local _G = _G
local pairs, ipairs = _G.pairs, _G.ipairs

aObj.addonsToSkin.AckisRecipeList = function(self) -- v7.3.0.1
	if not self.db.profile.TradeSkillUI then return end

	local ARL = _G.LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true)
	if not ARL then return end

	local function skinARL(frame)

		-- button in TLHC
		aObj:moveObject{obj=frame.prof_button, x=6, y=-9}
		aObj:moveObject{obj=frame.profession_texture, x=6, y=-9}
		aObj:skinEditBox{obj=frame.search_editbox, regs={6}, noHeight=true, mi=true}
		frame.search_editbox:SetHeight(18)
		-- expand button frame
		aObj:getChild(frame, 3):DisableDrawLayer("BACKGROUND")
		aObj:moveObject{obj=aObj:getChild(frame, 3), y=6}
		aObj:skinButton{obj=frame.expand_button, mp=true, plus=true}
		aObj:SecureHookScript(frame.expand_button, "OnClick", function(this)
			aObj:checkTex(this)
		end)
		aObj:adjWidth{obj=frame.list_frame.scroll_bar, adj=-6}
		aObj:skinSlider{obj=frame.list_frame.scroll_bar}
		frame.list_frame:SetBackdrop(nil)
		for _, btn in pairs(frame.list_frame.ListEntryButtons) do
			btn.titleBackgroundTexture:SetTexture(nil)
			aObj:skinButton{obj=btn.stateButton, mp2=true, plus=true}
		end
		-- progress bar
		aObj:skinStatusBar{obj=frame.progress_bar, fi=0}
		frame.progress_bar:SetBackdrop(nil)
		aObj:removeRegions(frame.progress_bar, {2})
		-- skin the frame
		aObj:addSkinFrame{obj=frame, kfs=true, x1=10, y1=-11, x2=-33, y2=74}
		-- show profession texture
		frame.profession_texture:SetAlpha(1)

		--  display exclusions checkbox size
		aObj:getChild(frame, 5):SetSize(20, 20)

-->>-- Tabs
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

-->>-- Filter Menu
		-- hook this to handle frame size change when filter button is clicked
		aObj:SecureHook(frame, "ToggleState", function(this)
--			self:Debug("ARL_TS: [%s, %s]", this, this.is_expanded)
			frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", this.is_expanded and -87 or -33, 74)
			-- Reset button
			aObj:skinButton{obj=frame.filter_reset}
		end)

		local function changeTextColour(frame)

			local kids, child = {frame:GetChildren()}
			for i = 1, #kids do
				child = kids[i]
				if child:IsObjectType("CheckButton") then
					if child.text then child.text:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb) end
				elseif child:IsObjectType("Frame") then
					changeTextColour(child)
				end
			end
			kids, child = nil, nil

		end
		aObj:SecureHookScript(frame.filter_toggle, "OnClick", function(this)
			changeTextColour(frame.filter_menu)
			-- aObj:getRegion(frame.filter_menu.misc, 1):SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
			aObj:Unhook(frame.filter_toggle, "OnClick")
		end)

		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.sort_button, ofs=-2, x1=1}
			aObj:addButtonBorder{obj=frame.filter_toggle, ofs=-2, x1=1}
		end

	end

	self:SecureHook(ARL, "Scan", function(this)
		skinARL(this.Frame)
		self:Unhook(this, "Scan")
	end)

	-- tooltip
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "AckisRecipeList_SpellTooltip")
	end

end
