local aName, aObj = ...
if not aObj:isAddonEnabled("TradeSkillMaster") then return end
local _G = _G

local function adjustSkinFrame(tab)

	-- handle Skin Frame not existing yet
	if not _G.AuctionFrame.sf then
		_G.C_Timer.After(0.2, function() adjustSkinFrame(tab) end)
		return
	end

	_G.AuctionFrame.sf:ClearAllPoints()
	if tab:GetID() > 3 then
		-- increase size of AuctionFrame skin frame
		_G.AuctionFrame.sf:SetPoint("TOPLEFT", _G.AuctionFrame, "TOPLEFT", -4, 4)
		_G.AuctionFrame.sf:SetPoint("BOTTOMRIGHT", _G.AuctionFrame, "BOTTOMRIGHT", 4, -6)
	else
		-- revert size of AuctionFrame skin frame
		_G.AuctionFrame.sf:SetPoint("TOPLEFT", _G.AuctionFrame, "TOPLEFT", 10, -11)
		_G.AuctionFrame.sf:SetPoint("BOTTOMRIGHT", _G.AuctionFrame, "BOTTOMRIGHT", 0, 5)
	end

end
function aObj:TSM_AuctionFrameHook()

	-- hook these to resize AuctionFrame.sf if required
	local idx
	for i = 1, 6 do
		if _G["AuctionFrameTab" .. i] then
			self:HookScript(_G["AuctionFrameTab" .. i], "OnClick", function(this, button, down)
				adjustSkinFrame(this)
			end)
			idx = i -- save current index value
		end
	end

	adjustSkinFrame(_G["AuctionFrameTab" .. idx])
	idx = nil

end

function aObj:TSM_AuctionHouse()

	if _G.IsAddOnLoaded("TradeSkillMaster_AuctionDB") then
	end
	if _G.IsAddOnLoaded("TradeSkillMaster_Auctioning") then
	end
	if _G.IsAddOnLoaded("TradeSkillMaster_Shopping") then
	end

end

-- loaded when TRADE_SKILL_SHOW event is triggered
function aObj:TradeSkillMaster_Crafting() -- v 3.2.5

	-- use NewTicker to manage different creation times on different hardware
	self.TSMC_Timer = _G.C_Timer.NewTicker(0.18, function()
		if _G.TSMCraftingTradeSkillFrame then
			self:addSkinFrame{obj=_G.TSMCraftingTradeSkillFrame, ft="a", nb=true, ofs=3}
			self:addSkinFrame{obj=_G.TSMCraftingTradeSkillFrame.queue, ft="a", nb=true, ofs=3}
			local pf = _G.TSMCraftingTradeSkillFrame.professionsTab
			self:addButtonBorder{obj=pf.craftInfoFrame.infoFrame.icon, relTo=pf.craftInfoFrame.infoFrame.icon.icon}
			self:addButtonBorder{obj=pf.craftInfoFrame.buttonsFrame.lessBtn, ofs=-2, x1=1}
			self:addButtonBorder{obj=pf.craftInfoFrame.buttonsFrame.moreBtn, ofs=-2, x1=1}
			pf.helpBtn.Ring:SetTexture(nil)
			pf = nil
			self.TSMC_Timer:Cancel()
			self.TSMC_Timer = nil
		end
	end)

end

-- Ore dProspecting
aObj.addonsToSkin.TradeSkillMaster_Destroying = function(self) -- v 3.1.7

	_G.C_Timer.After(0.1, function()
		self:addSkinFrame{obj=_G.TSMDestroyingFrame, ft="a", nb=true, ofs=3}
		self:getPenultimateChild(_G.TSMDestroyingFrame).Ring:SetTexture(nil)
	end)

end

aObj.addonsToSkin.TradeSkillMaster_Mailing = function(self) -- v 3.0.18

	self:RegisterEvent("MAIL_SHOW", function()
		local frame
		-- get TSM frame and skin it
		_G.C_Timer.After(0.1, function()
			frame = self:getPenultimateChild(_G.MailFrame)
			self:addSkinFrame{obj=frame, ft="a", nb=true, ofs=2, y2=-5}
			frame.content.inboxTab.helpBtn.Ring:SetTexture(nil)
		end)
		if self.prdb.MailFrame then
			-- prevent errors as not all tabs have been skinned yet
			self.tabFrames[_G.MailFrame] = nil
			_G.MailFrame.sf:Hide() -- hide to start with as mailframe opens to TSM frame initially
			_G.C_Timer.After(0.15, function() -- wait for TSM frame to be created
				self:keepRegions(_G.MailFrameTab3, {7, 8})
				self:addSkinFrame{obj=_G.MailFrameTab3, ft="a", nb=true, noBdr=self.isTT, x1=6, y1=0, x2=6, y2=2}
				self.tabFrames[_G.MailFrame] = true
				_G.PanelTemplates_UpdateTabs(_G.MailFrame)
				self:SecureHook(frame, "Show", function(this)
					_G.MailFrame.sf:Hide()
				end)
				self:SecureHook(frame, "Hide", function(this)
					_G.MailFrame.sf:Show()
				end)
			end)
		end
		frame = nil
		self:UnregisterEvent("MAIL_SHOW")
	end)

end

aObj.addonsToSkin.TradeSkillMaster_Vendoring = function(self) -- v 3.0.7

	self:RegisterEvent("MERCHANT_SHOW", function()
		-- prevent errors as not all tabs have been skinned yet
		aObj.tabFrames[_G.MerchantFrame] = nil
		_G.C_Timer.After(0.1, function()
			local frame = self:getPenultimateChild(_G.MerchantFrame)
			self:addSkinFrame{obj=frame, ft="a", nb=true, ofs=2, y2=-5}
			self:SecureHookScript(frame, "OnShow", function(this)
				_G.C_Timer.After(0.025, function()
					this.content.buyTab.helpBtn.Ring:SetTexture(nil)
				end)
				self:Unhook(this, "OnShow")
			end)
			frame = nil
			-- Tab
			self:keepRegions(_G.MerchantFrameTab3, {7, 8})
			self:addSkinFrame{obj=_G.MerchantFrameTab3, ft="a", nb=true, noBdr=self.isTT, x1=6, y1=0, x2=6, y2=2}
			if aObj.isTT then aObj:setInactiveTab(_G.MerchantFrameTab3.sf) end
			aObj.tabFrames[_G.MerchantFrame] = true
			_G.PanelTemplates_UpdateTabs(_G.MerchantFrame)
		end)
		self:UnregisterEvent("MERCHANT_SHOW")
	end)

end

aObj.addonsToSkin.TradeSkillMaster_Warehousing = function(self) -- v 3.0.8

	local function skinBankUI()

		_G.C_Timer.After(0.2, function()
			aObj.RegisterCallback("TSM_Warehousing", "UIParent_GetChildren", function(this, child)
				if child:IsObjectType("Frame")
				and child:GetName() == nil
				and _G.Round(child:GetWidth()) == 305
				and _G.Round(child:GetHeight()) == 490
				then
					aObj:addSkinFrame{obj=child, ft="a", nb=true, ofs=2}
					aObj:getLastChild(aObj:getChild(aObj:getChild(child, 3), 1)).Ring:SetTexture(nil)
					aObj:UnregisterEvent("GUILDBANKFRAME_OPENED")
					aObj:UnregisterEvent("BANKFRAME_OPENED")
				end
			end)
			aObj:scanUIParentsChildren()
		end)

	end

	self:RegisterEvent("GUILDBANKFRAME_OPENED", skinBankUI)
	self:RegisterEvent("BANKFRAME_OPENED", skinBankUI)

end
