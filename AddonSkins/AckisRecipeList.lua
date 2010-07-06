if not Skinner:isAddonEnabled("AckisRecipeList") then return end

function Skinner:AckisRecipeList() -- RC2
	if not self.db.profile.TradeSkillUI then return end

	local ARL = LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true)
	if not ARL then return end

	self:SecureHookScript(ARL_MainPanel, "OnShow", function(ARL_MP)
		--	minus/plus buttons
		for _, btn in pairs(ARL_MP.scroll_frame.state_buttons) do
			self:skinButton{obj=btn, mp2=true, plus=true}
			btn.text:SetJustifyH("CENTER")
		end
		self:glazeStatusBar(ARL_MP.progress_bar, 0)
		ARL_MP.progress_bar:SetBackdrop(nil)
		self:removeRegions(ARL_MP.progress_bar, {2})
		self:moveObject{obj=ARL_MP.prof_button, x=6, y=-9} -- button in TLHC
		self:skinEditBox{obj=ARL_MP.search_editbox, regs={9}, noHeight=true}
		ARL_MP.search_editbox:SetHeight(18)
		local ebf = self:getChild(ARL_MP, 7) -- expand button frame
		self:keepRegions(ebf, {})
		self:moveObject{obj=ebf, y=6}
		self:skinButton{obj=ARL_MP.expand_all_button, mp=true, plus=true}
		self:SecureHookScript(ARL_MP.expand_all_button, "OnClick", function(this)
			self:checkTex(this)
		end)
		self:skinSlider{obj=ARL_MP.scroll_frame.scroll_bar}
		ARL_MP.scroll_frame:SetBackdrop(nil)
		self:getRegion(ARL_MP.filter_menu.misc, 1):SetTextColor(self.BTr, self.BTg, self.BTb) -- filter text
		self:addSkinFrame{obj=ARL_MP, kfs=true, x1=10, y1=-11, x2=-33, y2=74}
		-- tabs
		for i = 1, #ARL_MP.tabs do
			local tabObj = ARL_MP.tabs[i]
			self:keepRegions(tabObj, {4, 5}) -- N.B. region 4 is highlight, 5 is text
			local tabSF = self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
			if i == 3 then
				if self.isTT then self:setActiveTab(tabSF) end
			else
				if self.isTT then self:setInactiveTab(tabSF) end
			end
			if self.isTT then
				self:SecureHookScript(tabObj, "OnClick", function(this)
					for i, tab in ipairs(ARL_MP.tabs) do
						local tabSF = self.skinFrame[tab]
						if tab == this then self:setActiveTab(tabSF)
						else self:setInactiveTab(tabSF) end
					end
				end)
			end
		end
		-- hook this to handle frame size change when filter button is clicked
		self:SecureHook(ARL_MP, "ToggleState", function(this)
			if this.is_expanded then
				self.skinFrame[ARL_MP]:SetPoint("BOTTOMRIGHT", ARL_MP, "BOTTOMRIGHT", -87, 74)
			else
				self.skinFrame[ARL_MP]:SetPoint("BOTTOMRIGHT", ARL_MP, "BOTTOMRIGHT", -33, 74)
			end
		end)
		local function changeTextColour(frame)
		
			for _, child in ipairs{frame:GetChildren()} do
				Skinner:Debug("cTC: [%s, %s, %s]", frame, child, child:GetObjectType())
				if child:IsObjectType("CheckButton") then
					if child.text then child.text:SetTextColor(self.BTr, self.BTg, self.BTb) end
				elseif child:IsObjectType("Frame") then
					changeTextColour(child)
				end
			end
			
		end
		-- change the text colour of the filter text
		changeTextColour(ARL_MP.filter_menu)
		self:Unhook(ARL_MP, "OnShow")
	end)

	-- TextDump frame
	self:skinScrollBar{obj=ARLCopyScroll}
	self:addSkinFrame{obj=ARLCopyFrame}

	-- button on Tradeskill frame
	self:skinButton{obj=ARL.scan_button}

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then arlSpellTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(arlSpellTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
