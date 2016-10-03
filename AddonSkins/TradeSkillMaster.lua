local aName, aObj = ...
if not aObj:isAddonEnabled("TradeSkillMaster") then return end
local _G = _G

local function adjustSkinFrame(adjust)

	-- handle Skin Frame not existing yet
	if not _G.AuctionFrame.sf then
		aObj:ScheduleTimer(adjustSkinFrame, 0.2, adjust)
		return
	end
	_G.AuctionFrame.sf:ClearAllPoints()
	if adjust then
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

	self:SecureHook("AuctionFrameTab_OnClick", function(this, button, down, index)
		if this:GetID() < 4 then
			adjustSkinFrame()
		else
			adjustSkinFrame(true)
		end
	end)

end

function aObj:TradeSkillMaster() -- 3.6.1

	-- skin modules
	-- N.B. "Crafting" is handled by TRADE_SKILL_SHOW event code in AddonFrames.lua
	-- N.B. "Auctioning", "AuctionDB" & , "Shopping" are done in TSM_AuctionHouse
	for _, module in _G.pairs{"Accounting", "Destroying", "Mailing", "Vendoring", "Warehousing"} do
		if _G.IsAddOnLoaded("TradeSkillMaster_" .. module) then
			self:checkAndRunAddOn("TradeSkillMaster_" .. module)
		end
	end

end

function aObj:TradeSkillMaster_Accounting()

end

function aObj:TSM_AuctionHouse()

	if _G.IsAddOnLoaded("TradeSkillMaster_AuctionDB") then
	end
	if _G.IsAddOnLoaded("TradeSkillMaster_Auctioning") then
	end
	if _G.IsAddOnLoaded("TradeSkillMaster_Shopping") then
	end

end

function aObj:TradeSkillMaster_Crafting()

	_G.C_Timer.After(0.5, function()
		self:addSkinFrame{obj=_G.TSMCraftingTradeSkillFrame, ofs=3}
	end)

end

function aObj:TradeSkillMaster_Destroying()

	_G.C_Timer.After(0.2, function()
		self:addSkinFrame{obj=_G.TSMDestroyingFrame, ofs=3}
		self:UnregisterEvent("BAG_UPDATE")
	end)

end

function aObj:TradeSkillMaster_Mailing()

	-- prevent errors as not all tabs have been skinned
	aObj.tabFrames[_G.MailFrame] = nil

	self:RegisterEvent("MAIL_SHOW", function()
		_G.C_Timer.After(0.2, function()
			local frame = self:getChild(_G.MailFrame, _G.MailFrame:GetNumChildren() - 1) -- get penultimate child
			self:addSkinFrame{obj=frame, ofs=2, y2=-5}
			_G.MailFrame.sf:Hide() -- hide to start with as mailframe opens to TSM frame initiially
			self:SecureHook(frame, "Show", function(this)
				_G.MailFrame.sf:Hide()
			end)
			self:SecureHook(frame, "Hide", function(this)
				_G.MailFrame.sf:Show()
			end)
			-- Tab
			self:keepRegions(_G.MailFrameTab3, {7, 8})
			self:addSkinFrame{obj=_G.MailFrameTab3, noBdr=self.isTT, x1=6, y1=0, x2=6, y2=2}
			aObj.tabFrames[_G.MailFrame] = true
			_G.PanelTemplates_UpdateTabs(_G.MailFrame)
		end)
		self:UnregisterEvent("MAIL_SHOW")
	end)

end

function aObj:TradeSkillMaster_Vendoring()

	-- prevent errors as not all tabs have been skinned
	aObj.tabFrames[_G.MerchantFrame] = nil

	self:RegisterEvent("MERCHANT_SHOW", function()
		_G.C_Timer.After(0.2, function()
			aObj:Debug("MERCHANT_SHOW: [%s, %s, %s, %s]", _G.MerchantFrame, _G.MerchantFrame.sknd, _G.MerchantFrame.numTabs, _G.PanelTemplates_GetSelectedTab(_G.MerchantFrame))
			local frame = self:getChild(_G.MerchantFrame, _G.MerchantFrame:GetNumChildren() - 1) -- get penultimate child
			self:addSkinFrame{obj=frame, ofs=2, y2=-5}
			-- Tab
			self:keepRegions(_G.MerchantFrameTab3, {7, 8})
			self:addSkinFrame{obj=_G.MerchantFrameTab3, noBdr=self.isTT, x1=6, y1=0, x2=6, y2=2}
			if aObj.isTT then aObj:setInactiveTab(_G.MerchantFrameTab3.sf) end
			aObj.tabFrames[_G.MerchantFrame] = true
			_G.PanelTemplates_UpdateTabs(_G.MerchantFrame)
		end)
		self:UnregisterEvent("MERCHANT_SHOW")
	end)

end

function aObj:TradeSkillMaster_Warehousing()

	local function skinBankUI()

		_G.C_Timer.After(0.2, function()
			aObj.RegisterCallback("TSM_Warehousing", "UIParent_GetChildren", function(this, child)
				if child:IsObjectType("Frame")
				and child:GetName() == nil
				and aObj:getInt(child:GetWidth()) == 305
				and aObj:getInt(child:GetHeight()) == 490
				then
					aObj:addSkinFrame{obj=child, ofs=2}
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
