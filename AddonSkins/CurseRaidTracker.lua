local aName, aObj = ...
if not aObj:isAddonEnabled("CurseRaidTracker") then return end

function aObj:CurseRaidTracker()

	-- about panel
	local ap = self:getChild(CurseRaidTrackerFrame, 3)
	-- print(aboutPanel, aboutPanel:GetHeight(), aboutPanel:GetWidth())
	self:addSkinFrame{obj=ap}
	ap.SetBackdrop = function() end
	ap.SetBackdropColor = function() end

-->>-- Main Panel
	self:moveObject{obj=CurseRaidTrackerFrame.logo, x=6, y=-8}
	self:addSkinFrame{obj=CurseRaidTrackerFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=71}

-->>-- Pool Frame
	local PF = CurseRaidTrackerPoolFrame
	-- general panel
	self:skinDropDown{obj=CurseRaidTrackerPoolSelector}
	self:skinEditBox{obj=PF.name_editbox, regs={9}}
	self:skinEditBox{obj=PF.currency_editbox, regs={9}}
	self:skinDropDown{obj=PF.loot_selector}
	self:skinDropDown{obj=PF.income_selector}
	self:skinEditBox{obj=PF.boss_worth_editbox, regs={9}}
	-- attendance panel
	self:skinEditBox{obj=PF.attendance_panel.fee_editbox, regs={9}}
	-- bidding panel
	CurseRaidTrackerPoolFrameBiddingScrollFrameScrollBarTrack:Hide()
	self:skinScrollBar{obj=PF.bidding_scrollframe}
	self:skinDropDown{obj=PF.bidding_panel.tie_selector}
	self:skinEditBox{obj=PF.bidding_panel.debt_editbox, regs={9}}
	self:addSkinFrame{obj=PF.bidding_panel.starting_bid_editbox.scrollBG}
	self:skinScrollBar{obj=PF.bidding_panel.starting_bid_editbox.scrollFrame}
	self:skinButton{obj=PF.bidding_panel.starting_bid_editbox.button, as=true}
	self:addSkinFrame{obj=PF.bidding_panel.bid_limit_editbox.scrollBG}
	self:skinScrollBar{obj=PF.bidding_panel.bid_limit_editbox.scrollFrame}
	self:skinButton{obj=PF.bidding_panel.bid_limit_editbox.button, as=true}
	self:skinButton{obj=PF.action_button}

-->>-- Situation Frame
	local SF = CurseRaidTrackerSituationFrame
	SF:SetBackdrop(nil)
	for i = 1, #SF.column_buttons do
		local btn = SF.column_buttons[i]
		self:removeRegions(btn, {1, 2, 3})
		self:addSkinFrame{obj=btn}
	end
	self:skinSlider{obj=SF.scroll_bar, size=3}
	self:skinDropDown{obj=CurseRaidTrackerSituationSelector}
	--[=[
		TODO skin statusbars ?
	--]=]
	self:keepFontStrings(SF.footer:GetParent())
	self:skinButton{obj=SF.delete_button}

-->>-- Tabs
	for k, v in pairs{"Pool", "Situation"} do
		local tab = _G["CurseRaidTrackerTab"..v]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if k == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
		if self.isTT then
			self:SecureHookScript(tab, "OnClick", function(this)
				self:setInactiveTab(self.skinFrame[CurseRaidTrackerTabPool])
				self:setInactiveTab(self.skinFrame[CurseRaidTrackerTabSituation])
				self:setActiveTab(self.skinFrame[this])
			end)
		end
	end
	
end
