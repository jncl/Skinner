if not Skinner:isAddonEnabled("AckisRecipeList") then return end

function Skinner:AckisRecipeList()
	if not self.db.profile.TradeSkillUI then return end

	local ARL = LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true)
	if not ARL then return end

	local isDevel = ARL.version == "Devel" and true or false
	self:Debug("ARL isDevel: [%s]", isDevel)
	
	self:SecureHookScript(ARL_MainPanel, "OnShow", function(this)
		--	minus/plus buttons
		for _, btn in pairs(ARL.Frame.scroll_frame.state_buttons) do
			self:skinButton{obj=btn, mp2=true, plus=true}
			btn.text:SetJustifyH("CENTER")
		end
		self:glazeStatusBar(ARL.Frame.progress_bar, 0)
		if isDevel then
			self:moveObject{obj=ARL.Frame.mode_button, x=6, y=-9} -- button in TLHC
			self:skinEditBox{obj=ARL.Frame.search_editbox, regs={9}, noHeight=true}
			ARL.Frame.search_editbox:SetHeight(18)
			local ebf = self:getChild(ARL.Frame, 8) -- expand button frame
			self:keepRegions(ebf, {})
			self:moveObject{obj=ebf, y=6}
			self:skinButton{obj=ARL.Frame.expand_all_button, mp=true, plus=true}
			self:SecureHookScript(ARL.Frame.expand_all_button, "OnClick", function(this)
				self:checkTex(this)
			end)
			self:skinSlider{obj=ARL.Frame.scroll_frame.scroll_bar}
			self:addSkinFrame{obj=ARL.Frame, kfs=true, x1=10, y1=-11, x2=-33, y2=74}
			-- tabs
			for i = 1, #ARL.Frame.tabs do
				local tabObj = ARL.Frame.tabs[i]
				self:keepRegions(tabObj, {4, 5}) -- N.B. region 4 is highlight, 5 is text
				local tabSF = self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
				if i == 3 then
					if self.isTT then self:setActiveTab(tabSF) end
				else
					if self.isTT then self:setInactiveTab(tabSF) end
				end
				if self.isTT then
					self:SecureHookScript(tabObj, "OnClick", function(this)
						for i, tab in ipairs(ARL.Frame.tabs) do
							local tabSF = self.skinFrame[tab]
							if tab == this then self:setActiveTab(tabSF)
							else self:setInactiveTab(tabSF) end
						end
					end)
				end
			end
			-- hook this to handle frame size change when filter button is clicked
			self:SecureHook(ARL.Frame, "ToggleState", function(this)
				if this.is_expanded then
					self.skinFrame[ARL.Frame]:SetPoint("BOTTOMRIGHT", ARL.Frame, "BOTTOMRIGHT", -87, 74)
				else
					self.skinFrame[ARL.Frame]:SetPoint("BOTTOMRIGHT", ARL.Frame, "BOTTOMRIGHT", -33, 74)
				end
			end)
			local function changeTextColour(frame)
			
				for _, child in ipairs{frame:GetChildren()} do
					if child:IsObjectType("CheckButton") then
						if child.text then child.text:SetTextColor(self.BTr, self.BTg, self.BTb) end
					elseif child:IsObjectType("Frame") then
						changeTextColour(child)
					end
				end
				
			end
			-- change the text colour of the filter text
			changeTextColour(ARL.Frame.filter_menu)
		else
			self:moveObject{obj=ARL.Frame.mode_button, y=-9}
			ARL.Frame.backdrop:SetAlpha(0)
			self:skinDropDown{obj=ARL_DD_Sort}
			self:skinEditBox{obj=ARL_SearchText, regs={9}}
			-- Flyaway frame (used when Filters button is clicked)
			self:addSkinFrame{obj=ARL.Frame.filter_menu, kfs=true, bg=true, x2=2}
			self:skinScrollBar{obj=ARL.Frame.scroll_frame}
			self:addSkinFrame{obj=ARL.Frame, y1=-9, x2=2, y2=-4}
		end
		self:Unhook(ARL_MainPanel, "OnShow")
	end)

	-- TextDump frame
	self:skinScrollBar{obj=ARLCopyScroll}
	self:addSkinFrame{obj=ARLCopyFrame}

	-- button on Tradeskill frame
	self:skinButton{obj=ARL_ScanButton or ARL.scan_button} -- ARL.scan_button is the new name of the old ARL_ScanButton in an arl alpha

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then arlSpellTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(arlSpellTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
