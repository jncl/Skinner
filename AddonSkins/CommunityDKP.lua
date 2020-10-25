local _, aObj = ...
if not aObj:isAddonEnabled("CommunityDKP") then return end
local _G = _G

local function skinFrame(frame, y2Ofs)
	frame.closeContainer:SetBackdrop(nil)
	aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, ofs=0, y2=y2Ofs}
	if aObj.modBtns then
		aObj:skinCloseButton{obj=frame.closeBtn}
	end
end
local function skinDropDown(frame)
	aObj:skinDropDown{obj=frame, noBB=true, y1=-2, x2=-17, y2=6}
	aObj.modUIBtns:addButtonBorder{obj=frame.Button, es=12, ofs=-3, x1=0, y2=1}
end
local function skinEditBox(eBox)
	aObj:skinEditBox{obj=eBox, regs={12, 13, 14}}
end
local function skinSliderAndEditBox(obj, name)
	aObj:skinSlider{obj=obj[name .. "Slider"], hgt=4}
	skinEditBox(obj[name])
end
local function skinHdr(opts)
	aObj:addSkinFrame{obj=opts.obj, ft="a", nb=true, ofs=4}
	if opts.aw then
		aObj:adjWidth{obj=opts.obj, adj=opts.aw}
	end
	if opts.mo then
		aObj:moveObject{obj=opts.obj, x=opts.mo}
	end
end
local function skinBidderWindow()
	if _G.CommDKP_BidderWindow then
		local bw = _G.CommDKP_BidderWindow
		aObj:addFrameBorder{obj=bw.bidTable, ft="a"}
		aObj:skinSlider{obj=bw.bidTable.ScrollBar}
		bw.BidTable_Headers:SetBackdrop(nil)
		skinHdr{obj=bw.headerButtons.player}
		skinHdr{obj=bw.headerButtons.bid}
		skinHdr{obj=bw.headerButtons.dkp}
		skinFrame(bw)
		for i = 1, 10 do
			bw.LootTableIcons[i]:SetAlpha(1) -- make Loot Icons apeear
		end
		if aObj.modBtns then
			aObj:skinStdButton{obj=bw.BidPlusOne}
			aObj:skinStdButton{obj=bw.BidPlusFive}
			aObj:skinStdButton{obj=bw.BidMax}
			aObj:skinStdButton{obj=bw.BidHalf}
			aObj:skinStdButton{obj=bw.SubmitBid}
			aObj:skinStdButton{obj=bw.CancelBid}
			aObj:skinStdButton{obj=bw.Pass}
		end
		if aObj.modChkBtns then
			aObj:skinCheckButton{obj=bw.AutoOpenCheckbox}
		end

		bw = nil
		skinBidderWindow = nil
	end
end
local function skinBiddingWindow()
	if _G.CommDKP_BiddingWindow then
		local bw = _G.CommDKP_BiddingWindow
		if bw.boss then
			skinEditBox(bw.boss)
			if bw.minBid then
				skinEditBox(bw.minBid)
				skinEditBox(bw.maxBid)
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=bw.CustomMinBid}
				aObj:skinCheckButton{obj=bw.CustomMaxBid}
			end
		end
		skinEditBox(bw.bidTimer)
		aObj:addFrameBorder{obj=bw.bidTable, ft="a"}
		aObj:skinSlider{obj=bw.bidTable.ScrollBar}
		bw.BidTable_Headers:SetBackdrop(nil)
		skinHdr{obj=_G.CommDKPDKPTableHeadersButtonPlayer, aw=-4, mo=2}
		skinHdr{obj=_G.CommDKPDKPTableHeadersButtonBid, aw=-5, mo=4}
		skinHdr{obj=_G.CommDKPDKPTableHeadersSuttonDkp, aw=-4, mo=-3}
		skinEditBox(bw.cost)
		skinFrame(bw)
		if bw.itemIcon then bw.itemIcon:SetAlpha(1) end -- show item Icon if required
		if aObj.modBtns then
			aObj:skinStdButton{obj=_G.CommDKPBiddingStartBiddingButton} -- labelled Start Bidding
			aObj:skinStdButton{obj=bw.ClearBidWindow}
			aObj:skinStdButton{obj=bw.StartBidding} -- labelled Award Item
			aObj:skinStdButton{obj=bw.ItemDE}
		end

		-- hook this to skin the BidderWindow
		aObj:SecureHookScript(_G.CommDKPBiddingStartBiddingButton, "OnClick", function(this)
			if skinBidderWindow then
				skinBidderWindow()
			end

			aObj:Unhook(this, "OnClick")
		end)

		bw =nil
		skinBiddingWindow = nil
	end
end
local function skinZeroSumBankFrame()
	if _G.CommDKP_DKPZeroSumBankFrame then
		zsb = _G.CommDKP_DKPZeroSumBankFrame
		skinEditBox(zsb.Balance)
		aObj:addFrameBorder{obj=zsb.LootFrame, ft="a"}
		skinFrame(zsb)
		if aObj.modBtns then
			aObj:skinStdButton{obj=zsb.Distribute}
		end
		if aObj.modChkBtns then
			aObj:skinCheckButton{obj=zsb.IncludeStandby}
		end

		zsb = nil
		skinZeroSumBankFrame = nil
	end
end
local function skinAwardWindowConfirm()
	if _G.CommDKP_AwardWindowConfirm then
		local aw = _G.CommDKP_AwardWindowConfirm
		skinDropDown(aw.team)
		skinDropDown(aw.player)
		skinEditBox(aw.cost)
		skinDropDown(aw.bossDropDown)
		skinDropDown(aw.zoneDropDown)
		aObj:addSkinFrame{obj=aw, ft="a", kfs=true, nb=true, ofs=0}
		if aObj.modBtns then
			aObj:skinStdButton{obj=aw.yesButton}
			aObj:skinStdButton{obj=aw.setPriceButton}
			aObj:skinStdButton{obj=aw.noButton}
		end

		aw = nil
		skinAwardWindowConfirm = nil
	end
end
local function skinExportWindow()
	if _G.CommDKPExportBox then
		local ew = _G.CommDKPExportBox
		aObj:skinSlider{obj=_G.CommDKPExportBoxScrollFrame.ScrollBar}
		skinDropDown(ew.FormatDropDown)
		skinFrame(ew)
		if aObj.modBtns then
			aObj:skinStdButton{obj=ew.GenerateDKPButton}
			aObj:skinStdButton{obj=ew.GenerateDKPHistoryButton}
			aObj:skinStdButton{obj=ew.GenerateDKPLootButton}
			aObj:skinStdButton{obj=ew.SelectAllButton}
		end

		ew = nil
		skinExportWindow = nil
	end
end
local function skinDKPModesWindow()
	if _G.CommDKP_DKPModesFrame then
		local mw = _G.CommDKP_DKPModesFrame
		mw.BG:SetTexture(nil)
		-- .ScrollFrame
		aObj:skinSlider{obj=mw.ScrollFrame.ScrollBar}
		-- .DKPModesMain
		skinDropDown(mw.DKPModesMain.ModesDropDown)
		skinDropDown(mw.DKPModesMain.RoundDropDown)
		skinDropDown(mw.DKPModesMain.MaxBidBehaviorDropDown)
		skinEditBox(mw.DKPModesMain.AntiSnipe)
		skinDropDown(mw.DKPModesMain.ChannelsDropDown)
		skinDropDown(mw.DKPModesMain.CostSelection)
		skinEditBox(mw.DKPModesMain.Inflation)
		skinDropDown(mw.DKPModesMain.ZeroSumType)
		skinDropDown(mw.DKPModesMain.ItemCostDropDown)
		aObj:addFrameBorder{obj=mw.DKPModesMain.RollContainer, ft= "a"}
		skinEditBox(mw.DKPModesMain.RollContainer.rollMin)
		skinEditBox(mw.DKPModesMain.RollContainer.rollMax)
		skinEditBox(mw.DKPModesMain.RollContainer.AddMax)
		-- .DKPModesMisc
		aObj:addFrameBorder{obj=mw.DKPModesMisc.AutoAwardContainer, ft="a"}
		aObj:addFrameBorder{obj=mw.DKPModesMisc.AnnounceBidContainer, ft="a"}
		aObj:addFrameBorder{obj=mw.DKPModesMisc.MiscContainer, ft="a"}
		aObj:addFrameBorder{obj=mw.DKPModesMisc.DKPAwardContainer, ft="a"}
		skinFrame(mw, -3)
		if aObj.modBtns then
			aObj:skinStdButton{obj=mw.DKPModesMain.BroadcastSettings}
		end
		if aObj.modChkBtns then
			aObj:skinCheckButton{obj=mw.DKPModesMain.SubZeroBidding}
			aObj:skinCheckButton{obj=mw.DKPModesMain.AllowNegativeBidders}
			aObj:skinCheckButton{obj=mw.DKPModesMain.RollContainer.UsePerc}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.AutoAwardContainer.AutoAward}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.AutoAwardContainer.IncStandby}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.AnnounceBidContainer.AnnounceBid}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.AnnounceBidContainer.AnnounceBidName}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.AnnounceBidContainer.AnnounceRaidWarning}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.AnnounceBidContainer.DeclineLowerBids}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.MiscContainer.Standby}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.MiscContainer.AnnounceAward}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.MiscContainer.BroadcastBids}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.MiscContainer.StoreBids}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.DKPAwardContainer.OnlineOnly}
			aObj:skinCheckButton{obj=mw.DKPModesMisc.DKPAwardContainer.SameZoneOnly}
		end

		mw = nil
		skinDKPModesWindow = nil
	end
end

local tDelay = 5
aObj.addonsToSkin.CommunityDKP = function(self) -- v 3.2.3-r60

	-- wait until Config frame has been created
	if not _G.CommDKPConfig then
		_G.C_Timer.After(tDelay, function()
			tDelay = 0.1
			self.addonsToSkin.CommunityDKP(self)
		end)
		return
	end

	local bwmfIdx, cfIdx
	self.RegisterCallback("CommunityDKP", "UIParent_GetChildren", function(this, child, idx)
		if child == _G.CommDKPBidWindowMenuFrame then
			bwmfIdx = idx
		elseif child == _G.CommDKPConfig then
			cfIdx = idx
			self.UnregisterCallback("CommunityDKP", this)
		end
	end)
	self:scanUIParentsChildren()
	local bidTimer = self:getChild(_G.UIParent, cfIdx - 1)
	local lhtooltip = self:getChild(_G.UIParent, bwmfIdx + 2)
	local lhTimer = self:getChild(_G.UIParent, bwmfIdx + 3)
	bwmfIdx,cfIdx = nil, nil

	-- RaidTimerPopout
	self:SecureHookScript(_G.CommDKP_RaidTimerPopout, "OnShow", function(this)
		skinFrame(this)

		self:Unhook(this, "OnShow")
	end)

	-- BidTimer
	self:SecureHookScript(bidTimer, "OnShow", function(this)
		this:SetBackdrop(nil)
		self:skinStatusBar{obj=this, fi=0}
		this.border:SetBackdrop(nil)
		if self.modBtns then
			self:skinStdButton{obj=this.OpenBid}
		end

		self:Unhook(this, "OnShow")
	end)

	-- hook this to skin the BidderWindow
	self:SecureHookScript(bidTimer.OpenBid, "OnClick", function(this)
		if skinBidderWindow then
			skinBidderWindow()
		end

		self:Unhook(this, "OnClick")
	end)

	-- LootHistory Timer
	self:SecureHookScript(lhTimer, "OnShow", function(this)
		self:skinStatusBar{obj=this, fi=0}

		self:Unhook(this, "OnShow")
	end)

	-- LootHistory tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, lhtooltip)
	end)

	local cld = _G.CommDKP_ChangeLogDisplay
	-- skin the ChangeLogDisplay if it exists
	if cld then
		skinFrame(cld)
		if self.modChkBtns then
			self:skinCheckButton{obj=cld.DontShowCheck}
		end
	end
	cld = nil

	self:SecureHookScript(_G.CommDKPConfig, "OnShow", function(this)
		_G.CommDKPDKPTableHeaders:SetBackdrop(nil)
		skinHdr{obj=_G.CommDKPDKPTableHeadersSortButtonPlayer, aw=-4, mo=-4}
		skinHdr{obj=_G.CommDKPDKPTableHeadersSortButtonClass}
		skinHdr{obj=_G.CommDKPDKPTableHeadersSortButtonDkp, aw=-4, mo=4}
		self:moveObject{obj=_G.CommDKPDKPTableHeadersSortButtonClass.t, y=1}
		self.modUIBtns:addButtonBorder{obj=_G.CommDKPDKPTableHeadersSortButtonClass.t.Button, es=12, ofs=-3, x1=0, y2=1}
		self:addSkinFrame{obj=_G.CommDKPDisplayScrollFrame, ft="a", kfs=true, nb=true}
		self:skinSlider{obj=_G.CommDKPDisplayScrollFrame.ScrollBar}
		_G.CommDKPDisplayScrollFrame.SeedVerifyIcon:SetAlpha(1) -- make the texture visible
		skinEditBox(this.search)
		skinDropDown(this.TeamViewChangerDropDown)
		self:moveObject{obj=this.expand, x=-2}
		skinFrame(this)

		-- these appear when the expand button is pressed
		self:addFrameBorder{obj=this.TabMenu, ft="a", ofs=3}
		this.TabMenuBG:SetTexture(nil)
		self:skinSlider{obj=this.TabMenu.ScrollFrame.ScrollBar}
		local tm = "CommDKPCommDKP.ConfigTabMenu"
		-- Menu Tab 1 Filters
		self:SecureHookScript(_G[tm .. "Tab1"].content, "OnShow", function(this)
			if self.modChkBtns then
				for _, cBtn in _G.ipairs(this.checkBtn) do
					self:skinCheckButton{obj=cBtn}
				end
			end

			self:Unhook(this, "OnShow")
		end)
		-- Menu Tab 2 AdjustDKP
		self:SecureHookScript(_G[tm .. "Tab2"].content, "OnShow", function(this)
			skinDropDown(this.reasonDropDown)
			skinEditBox(this.otherReason)
			skinDropDown(this.BossKilledDropdown)
			skinEditBox(this.addDKP)
			skinEditBox(this.decayDKP)
			if self.modBtns then
				self:skinStdButton{obj=this.adjustButton}
				self:skinStdButton{obj=this.decayButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.RaidOnlyCheck}
				self:skinCheckButton{obj=this.selectAll}
				self:skinCheckButton{obj=this.SelectedOnlyCheck}
				self:skinCheckButton{obj=this.AddNegative}
			end
			local rtc = this.RaidTimerContainer
			-- RaidTimerContainer
			skinEditBox(rtc.interval)
			skinEditBox(rtc.bonusvalue)
			self:addFrameBorder{obj=rtc, ft="a"}
			if self.modBtns then
				self:skinStdButton{obj=rtc.PopOut}
				self:skinStdButton{obj=rtc.StartTimer}
				self:skinStdButton{obj=rtc.PauseTimer}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=rtc.StartBonus}
				self:skinCheckButton{obj=rtc.EndRaidBonus}
				self:skinCheckButton{obj=rtc.StandbyInclude}
			end
			rtc = nil

			self:Unhook(this, "OnShow")
		end)
		-- Menu Tab 3 Manage
		self:SecureHookScript(_G[tm .. "Tab3"].content, "OnShow", function(this)
			skinDropDown(this.GuildRankDropDown)
			skinDropDown(this.TeamListDropDown)
			skinEditBox(this.TeamNameInput)
			if self.modBtns then
				self:skinStdButton{obj=this.add_raid_to_table}
				self:skinStdButton{obj=this.remove_entries}
				self:skinStdButton{obj=this.reset_previous_dkp}
				self:skinStdButton{obj=this.AddGuildToDKP}
				self:skinStdButton{obj=this.AddTargetToDKP}
				self:skinStdButton{obj=this.CleanList}
				self:skinStdButton{obj=this.TeamRename}
				self:skinStdButton{obj=this.TeamAdd}
			end
			local wlc = this.WhitelistContainer
			self:addSkinFrame{obj=wlc, ft="a", kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=wlc.AddWhitelistButton}
				self:skinStdButton{obj=wlc.ViewWhitelistButton}
				self:skinStdButton{obj=wlc.SendWhitelistButton}
			end
			wlc = nil

			self:Unhook(this, "OnShow")
		end)
		-- Menu Tab 4 Options
		self:SecureHookScript(_G[tm .. "Tab4"].content, "OnShow", function(this)
			for i = 1, 6 do
				skinEditBox(this.default[i])
			end
			for i = 1, 17 do
				skinEditBox(this.DefaultMinBids.SlotBox[i])
			end
			if this.DefaultMaxBids then
				for i = 1, 17 do
					skinEditBox(this.DefaultMaxBids.SlotBox[i])
				end
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.BroadcastMaxBids}
				end
			end
			skinSliderAndEditBox(this, "bidTimer")
			skinSliderAndEditBox(this, "TooltipHistory")
			skinSliderAndEditBox(this, "history")
			skinSliderAndEditBox(this, "DKPHistory")
			skinSliderAndEditBox(this, "TimerSize")
			self:skinSlider{obj=this.CommDKPScaleSize}
			skinEditBox(this.UIScaleSize)
			skinDropDown(this.ChatFrame)
			if self.modBtns then
				self:skinStdButton{obj=this.ModesButton}
				self:skinStdButton{obj=this.BroadcastMinBids}
				self:skinStdButton{obj=this.submitSettings}
				self:skinStdButton{obj=this.moveTimer}
				self:skinStdButton{obj=this.WipeTables}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.SuppressNotifications}
				self:skinCheckButton{obj=this.CombatLogging}
				self:skinCheckButton{obj=this.AutoOpenCheckbox}
				if this.SuppressTells then
					self:skinCheckButton{obj=this.SuppressTells}
					self:skinCheckButton{obj=this.DecreaseDisenchantCheckbox}
				end
			end

			self:SecureHookScript(this.ModesButton, "OnClick", function(this)
				if skinDKPModesWindow then
					skinDKPModesWindow()
				end

				self:Unhook(this, "OnClick")
			end)

			self:Unhook(this, "OnShow")
		end)
		-- Menu Tab 5 LootHistory
		self:SecureHookScript(_G[tm .. "Tab5"].content, "OnShow", function(this)
			skinDropDown(_G.CommDKPDeleteLootMenuFrame)
			skinDropDown(_G.CommDKPConfigFilterNameDropDown)
			this.inst:SetTextColor(self.BT:GetRGB())

			self:Unhook(this, "OnShow")
		end)
		-- Menu Tab 6 DKPHistory
		self:SecureHookScript(_G[tm .. "Tab6"].content, "OnShow", function(this)
			skinDropDown(_G.CommDKPDKPHistoryFilterNameDropDown)
			if self.modBtns then
				for i = 1, #this.history do
					if this.history[i].b then
						self:skinStdButton{obj=this.history[i].b}
					end
				end
				if this.loadMoreBtn then
					self:skinStdButton{obj=this.loadMoreBtn}
				end
			end

			self:Unhook(this, "OnShow")
		end)
		-- Menu Tab 7 Price
		self:SecureHookScript(_G[tm .. "Tab7"].content, "OnShow", function(this)
			this.PriceTable:SetBackdrop(nil)
			this.PriceTable.Headers:SetBackdrop(nil)
			skinHdr{obj=_G.CommDKPPriceTableHeadersPriceSortButtonItem, aw=-28, mo=-4}
			skinHdr{obj=_G.CommDKPPriceTableHeadersPriceSortButtonDkp}
			skinHdr{obj=_G.CommDKPPriceTableHeadersPriceSortButtonDisenchants, aw=10, mo=4}
			self:skinSlider{obj=this.PriceTable.ScrollBar}

			self:Unhook(this, "OnShow")
		end)
		tm = nil

		self:Unhook(this, "OnShow")
	end)

	skinDropDown(_G.CommDKPDKPTableMenuFrame)
	skinDropDown(_G.CommDKPDeleteDKPMenuFrame)
	skinDropDown(_G.CommDKPDeleteLootMenuFrame)
	skinDropDown(_G.CommDKPBidWindowMenuFrame)

	-- hook this to skin the CommDKP_FullBroadcastWindow
	self:SecureHookScript(_G.CommDKPDisplayScrollFrame.SeedVerify, "OnMouseDown", function(this)
		if _G.CommDKP_FullBroadcastWindow then
			local fbw = _G.CommDKP_FullBroadcastWindow
			self:addFrameBorder{obj=fbw.tocontainer, ft="a"}
			self:skinDropDown{obj=fbw.player}
			self:addFrameBorder{obj=fbw.datacontainer, ft="a"}
			skinFrame(fbw)
			if self.modBtns then
				self:skinStdButton{obj=fbw.confirmButton}
				self:skinStdButton{obj=fbw.cancelButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fbw.playerCheckbox}
				self:skinCheckButton{obj=fbw.guildCheckbox}
				self:skinCheckButton{obj=fbw.mergeCheckbox}
				self:skinCheckButton{obj=fbw.fullCheckbox}
			end
			-- hook this to skin the CommDKP_FullBroadcastStatus frame
			self:SecureHookScript(fbw.confirmButton, "OnClick", function(this)
				local myTicker
				local function skinFBS()
					if _G.CommDKP_FullBroadcastStatus then
						local fbs = _G.CommDKP_FullBroadcastStatus
						aObj:skinStatusBar{obj=fbs.status, fi=0}
						fbs.status.border:SetBackdrop(nil)
						aObj:addSkinFrame{obj=fbs, ft="a", kfs=true, nb=true, ofs=0}
						myTicker:Cancel()
						fbs = nil
						skinFBS = nil
					end
				end
				myTicker = _G.C_Timer.NewTicker(0.1, skinFBS)

				self:Unhook(this, "OnClick")
			end)
			fbw = nil

			self:Unhook(this, "OnClick")
		end
	end)

	self:SecureHook(_G.SlashCmdList, "CommunityDKP", function(arg1, ...)
		-- self:Debug("SCL CommunityDKP: [%s, %s, %s, %s]", arg1, ...)
		if arg1:lower() == "bid" then
			if skinBidderWindow then
				skinBidderWindow()
			end
			if skinBiddingWindow then
				skinBiddingWindow()
			end
			if skinZeroSumBankFrame then
				skinZeroSumBankFrame()
			end
		elseif arg1:lower() == "repairtables" then
			local vTmr = self:getLastChild(_G.UIParent)
			if vTmr
			and vTmr:IsObjectType("StatusBar")
			then
				self:skinStatusBar{obj=vTmr, fi=0}
				vTmr = nil
			end
		elseif arg1:lower():find("award") then
			if skinAwardWindowConfirm then
				skinAwardWindowConfirm()
			end
		elseif arg1:lower() == "export" then
			if skinExportWindow then
				skinExportWindow()
			end
		elseif arg1:lower() == "modes" then
			if skinDKPModesWindow then
				skinDKPModesWindow()
			end
		end
	end)

end
