local aName, aObj = ...
if not aObj:isAddonEnabled("Collectinator") then return end

function aObj:Collectinator() -- v 2

	local COL = LibStub("AceAddon-3.0"):GetAddon("Collectinator", true)
	if not COL then return end

	local function skinCOL(frame)

		-- skin frame
		aObj:addSkinFrame{obj=frame, kfs=true, x1=10, y1=-11, x2=-33, y2=73}
		-- search editbox
		aObj:skinEditBox{obj=frame.search_editbox, regs={9}, noHeight=true, mi=true}
		frame.search_editbox:SetHeight(18)
		-- button in TLHC
		aObj:moveObject{obj=frame.collectable_type_button, x=6, y=-9}
		aObj:moveObject{obj=frame.collection_texture, x=6, y=-9}
		frame.collection_texture:SetAlpha(1)
		-- expand button frame
		local ebF = aObj:getChild(frame, 3)
		aObj:keepRegions(ebF, {})
		aObj:moveObject{obj=ebF, y=6}
		aObj:skinButton{obj=frame.expand_button, mp=true, plus=true}
		aObj:SecureHookScript(frame.expand_button, "OnClick", function(this)
			aObj:checkTex(this)
		end)
		-- sort button (don't add button border as highlight texture is hidden)
		-- self:addButtonBorder{obj=frame.sort_button, x1=0, y1=-1, x2=-1, y2=0}
		-- scroll frame
		local sF = frame.list_frame
		aObj:adjWidth{obj=sF.scroll_bar, adj=-6}
		aObj:skinSlider{obj=sF.scroll_bar}
		sF:SetBackdrop(nil)
		--	minus/plus buttons
		for _, btn in pairs(sF.state_buttons) do
			aObj:skinButton{obj=btn, mp2=true, plus=true}
		end
		-- progress bar
		aObj:glazeStatusBar(frame.progress_bar, 0)
		frame.progress_bar:SetBackdrop(nil)
		aObj:removeRegions(frame.progress_bar, {2})

		-- Tabs
		for i = 1, #frame.tabs do
			local tabObj = frame.tabs[i]
			aObj:keepRegions(tabObj, {4, 5}) -- N.B. region 4 is highlight, 5 is text
			aObj:addSkinFrame{obj=tabObj, noBdr=aObj.isTT, x1=8, y1=-1, x2=-8, y2=0}
			if i == frame.current_tab then
				if aObj.isTT then aObj:setActiveTab(tabObj.sf) end
			else
				if aObj.isTT then aObj:setInactiveTab(tabObj.sf) end
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

		-- Filter Menu
		-- hook this to handle frame size change when filter button is clicked
		aObj:SecureHook(frame, "ToggleState", function(this)
			aObj:Debug("COL ToggleState: [%s, %s]", this, this.is_expanded)
			local xOfs, yOfs = -33, 73
			if this.is_expanded then xOfs = -87 end
			frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", xOfs, yOfs)
			-- Reset button
			if not frame.filter_reset.sb then
				aObj:skinButton{obj=frame.filter_reset}
			end
		end)
		local function changeTextColour(frame)

			for _, child in ipairs{frame:GetChildren()} do
				if child:IsObjectType("CheckButton") then -- checkboxes
					if child.text then child.text:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb) end
				elseif child:IsObjectType("Button") then -- heading toggle
					child:SetNormalFontObject("QuestTitleFontBlackShadow")
				elseif child:IsObjectType("Frame") then
					changeTextColour(child)
				end
			end

		end
		-- hook this the change text colour
		aObj:SecureHookScript(frame.filter_toggle, "OnClick", function(this)
			changeTextColour(frame.filter_menu)
			aObj:Unhook(frame.filter_toggle, "OnClick")
		end)

	end

	-- hook this to skin the frame
	self:SecureHook(COL, "Scan", function(this, textdump, is_refresh)
		self:Debug("COL Scan: [%s, %s, %s]", this, textdump, is_refresh)
		skinCOL(COL.Frame)
		self:Unhook(COL, "Scan")
	end)
	
end
