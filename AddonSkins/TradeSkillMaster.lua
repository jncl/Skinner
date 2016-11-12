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

function aObj:TradeSkillMaster_Crafting()

	_G.C_Timer.After(0.5, function()
		self:addSkinFrame{obj=_G.TSMCraftingTradeSkillFrame, ofs=3}
		self:addSkinFrame{obj=_G.TSMCraftingTradeSkillFrame.queue, ofs=3}
		local pf = _G.TSMCraftingTradeSkillFrame.professionsTab
		pf.helpBtn.Ring:SetTexture(nil)
		self:addButtonBorder{obj=pf.craftInfoFrame.infoFrame.icon, relTo=pf.craftInfoFrame.infoFrame.icon.icon}
		self:addButtonBorder{obj=pf.craftInfoFrame.buttonsFrame.lessBtn, ofs=-2, x1=1}
		self:addButtonBorder{obj=pf.craftInfoFrame.buttonsFrame.moreBtn, ofs=-2, x1=1}
		pf = nil
	end)

end

function aObj:TradeSkillMaster_Destroying()

	_G.C_Timer.After(0.2, function()
		self:addSkinFrame{obj=_G.TSMDestroyingFrame, ofs=3}
	end)

end

function aObj:TradeSkillMaster_Mailing()

	-- prevent errors as not all tabs have been skinned
	aObj.tabFrames[_G.MailFrame] = nil

	self:RegisterEvent("MAIL_SHOW", function()
		_G.C_Timer.After(0.2, function()
			local frame = self:getChild(_G.MailFrame, _G.MailFrame:GetNumChildren() - 1) -- get penultimate child
			self:addSkinFrame{obj=frame, ofs=2, y2=-5}
			_G.MailFrame.sf:Hide() -- hide to start with as mailframe opens to TSM frame initially
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
			-- aObj:Debug("MERCHANT_SHOW: [%s, %s, %s, %s]", _G.MerchantFrame, _G.MerchantFrame.sknd, _G.MerchantFrame.numTabs, _G.PanelTemplates_GetSelectedTab(_G.MerchantFrame))
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
