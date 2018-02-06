local aName, aObj = ...
if not aObj:isAddonEnabled("Collectinator") then return end
local _G = _G

aObj.lodAddons.Collectinator = function(self) -- v 7.2.5.1

	local COL = _G.LibStub("AceAddon-3.0"):GetAddon("Collectinator", true)
	if not COL then return end

	self:skinStdButton{obj=self:getLastChild(_G.CollectionsJournal)}

	local function skinCOL(frame)

		aObj:skinStdButton{obj=frame.close_button}
		aObj:skinCloseButton{obj=frame.xclose_button}
		aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, x1=10, y1=-11, x2=-33, y2=73}
		aObj:skinEditBox{obj=frame.search_editbox, regs={6}, noHeight=true, mi=true}
		frame.search_editbox:SetHeight(18)
		-- button in TLHC
		aObj:moveObject{obj=frame.collectable_type_button, x=6, y=-9}
		aObj:moveObject{obj=frame.collection_texture, x=6, y=-9}
		frame.collection_texture:SetAlpha(1)
		-- expand button frame
		aObj:getChild(frame, 3):DisableDrawLayer("BACKGROUND")
		aObj:skinExpandButton{obj=frame.expand_button, onSB=true, sap=true, plus=true}
		aObj:SecureHookScript(frame.expand_button, "OnClick", function(this)
			local is_expanded = frame.current_tab["expand_button_" .. frame.current_collectable_type]
			if is_expanded then
				this.sb:SetText("-")
			else
				this.sb:SetText("+")
			end
			is_expanded = nil
		end)
		self:addButtonBorder{obj=frame.sort_button, x1=0, y1=-1, x2=-1, y2=0}
		self:addButtonBorder{obj=frame.filter_toggle, x1=0, y1=-1, x2=-1, y2=0}
		-- scroll frame
		local sF = frame.list_frame
		aObj:adjWidth{obj=sF.scroll_bar, adj=-6}
		aObj:skinSlider{obj=sF.scroll_bar}
		sF:SetBackdrop(nil)
		if aObj.modBtns then
			--	minus/plus buttons
			for _, btn in _G.ipairs(sF.state_buttons) do
				aObj:skinExpandButton{obj=btn, sap=true, plus=true}
			end
		end
		aObj:skinStatusBar{obj=frame.progress_bar, fi=0}
		frame.progress_bar:SetBackdrop(nil)
		aObj:removeRegions(frame.progress_bar, {2})

		-- Tabs
		for i = 1, #frame.tabs do
			local tabObj = frame.tabs[i]
			aObj:keepRegions(tabObj, {4, 5}) -- N.B. region 4 is highlight, 5 is text
			aObj:addSkinFrame{obj=tabObj, ft="a", nb=true, noBdr=aObj.isTT, x1=8, y1=-1, x2=-8, y2=0}
			if tabObj == frame.current_tab then
				if aObj.isTT then aObj:setActiveTab(tabObj.sf) end
			else
				if aObj.isTT then aObj:setInactiveTab(tabObj.sf) end
			end
			if aObj.isTT then
				aObj:SecureHookScript(tabObj, "OnClick", function(this)
					for i, tab in _G.ipairs(frame.tabs) do
						if tab == this then aObj:setActiveTab(tab.sf)
						else aObj:setInactiveTab(tab.sf) end
					end
				end)
			end
		end

		-- Filter Menu
		-- hook this to handle frame size change when filter button is clicked
		aObj:SecureHook(frame, "ToggleState", function(this)
			local xOfs = -33
			if this.is_expanded then xOfs = -87 end
			frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", xOfs, 73)
			-- Reset button
			if not frame.filter_reset.sb then
				aObj:skinStdButton{obj=frame.filter_reset}
			end
		end)
		local function changeTextColour(frame)

			for _, child in _G.ipairs{frame:GetChildren()} do
				if child:IsObjectType("CheckButton") then -- checkboxes
					if child.text then child.text:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb) end
					if self.modChkBtns then
						self:skinCheckButton{obj=child}
					end
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
		skinCOL(COL.Frame)
		self:Unhook(COL, "Scan")
	end)

end
