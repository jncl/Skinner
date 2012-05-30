local aName, aObj = ...
if not aObj:isAddonEnabled("oGlow") then return end

function aObj:oGlow()
	if not aObj.modBtnBs then
		self.oGlow = nil
		return
	end
	
	-- skin the option panels ??
	
	local r, g, b, a = unpack(self.bbColour)
	local function btnUpd(obj, oGB)
		oGB = oGB or obj
		if obj.sknrBdr then
			if oGB.oGlowBorder
			and oGB.oGlowBorder:IsVisible()
			then
				obj.sknrBdr:SetBackdropBorderColor(oGB.oGlowBorder:GetVertexColor())
				oGB.oGlowBorder:SetTexture()
			else
				obj.sknrBdr:SetBackdropBorderColor(r, g, b, a)
			end
		end
	end
	local function merchant(...) -- √
		local function merchUpd()
			for i = 1, max(MERCHANT_ITEMS_PER_PAGE, BUYBACK_ITEMS_PER_PAGE) do
				btnUpd(_G["MerchantItem"..i.."ItemButton"])
			end
		end
		aObj:SecureHook("MerchantFrame_Update", function() aObj:ScheduleTimer(merchUpd, 0.1) end)
	end
	local function bags(...) -- √
		local function bagUpd(bagId)
			for j = 1, MAX_CONTAINER_ITEMS do
				btnUpd(_G["ContainerFrame"..(bagId + 1).."Item"..j])
			end
		end
		aObj:SecureHook("ContainerFrame_Update", function(bag) aObj:ScheduleTimer(bagUpd, 0.1, bag:GetID()) end)
	end
	local function char(...) -- √
		local function charUpd()
			for _, child in ipairs{PaperDollItemsFrame:GetChildren()} do
				btnUpd(child)
			end
		end
		local evtRef
		aObj:SecureHook(CharacterFrame, "Show", function(this)
			aObj:ScheduleTimer(charUpd, 0.1)
			evtRef = aObj:RegisterEvent("UNIT_INVENTORY_CHANGED", function() aObj:ScheduleTimer(charUpd, 0.1) end)
		end)
		aObj:SecureHook(CharacterFrame, "Hide", function(this)
			aObj:UnregisterEvent("UNIT_INVENTORY_CHANGED", evtRef)
		end)
	end
	local function voidstore(...) -- √
		local function voidstoreUpd()
			for i = 1, 9 do
				btnUpd(_G["VoidStorageDepositButton"..i])
				btnUpd(_G["VoidStorageWithdrawButton"..i])
			end
			for i = 1, 80 do
				btnUpd(_G["VoidStorageStorageButton"..i])
			end
		end
		aObj:RegisterEvent("VOID_STORAGE_OPEN", function() aObj:ScheduleTimer(voidstoreUpd, 0.1) end)
		aObj:RegisterEvent("VOID_STORAGE_DEPOSIT_UPDATE", function() aObj:ScheduleTimer(voidstoreUpd, 0.1) end)
		aObj:RegisterEvent("VOID_STORAGE_CONTENTS_UPDATE", function() aObj:ScheduleTimer(voidstoreUpd, 0.1) end)
		aObj:RegisterEvent("VOID_TRANSFER_DONE", function() aObj:ScheduleTimer(voidstoreUpd, 0.1) end)
	end
	local function gbank(...) -- √
		local function gbankUpd()
			for i = 1, NUM_GUILDBANK_COLUMNS do
				for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
					btnUpd(_G["GuildBankColumn"..i.."Button"..j])
				end
			end
		end
		aObj:RegisterEvent("GUILDBANKFRAME_OPENED", function() aObj:ScheduleTimer(gbankUpd, 0.1) end)
		aObj:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED", function() aObj:ScheduleTimer(gbankUpd, 0.1) end)
	end
	local function charflyout(...) -- √
		local function charflyoutUpd(btn)
			btnUpd(btn)
		end
		aObj:SecureHook("EquipmentFlyout_DisplayButton", function(btn, pDIS) aObj:ScheduleTimer(charflyoutUpd, 0.1, btn) end)
	end
	local function loot(...) --√
		local function lootUpd()
			if LootFrame:IsShown() then
				for i = 1, LOOTFRAME_NUMBUTTONS do
					btnUpd(_G["LootButton"..i])
				end
			end
		end
		aObj:RegisterEvent("LOOT_OPENED", function() aObj:ScheduleTimer(lootUpd, 0.1) end)
		aObj:RegisterEvent("LOOT_SLOT_CHANGED", function() aObj:ScheduleTimer(lootUpd, 0.1) end)
		aObj:RegisterEvent("LOOT_SLOT_CLEARED", function() aObj:ScheduleTimer(lootUpd, 0.1) end)
	end
	local function trade(...)
		local function tradeUpd()
			for i = 1, MAX_TRADE_ITEMS do
				for _, v in pairs{"Player", "Recipient"} do
					btnUpd(_G["Trade"..v.."Item"..i.."ItemButton"])
				end
			end
		end
		aObj:RegisterEvent("TRADE_SHOW", function() aObj:ScheduleTimer(tradeUpd, 0.1) end)
		aObj:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED", function() aObj:ScheduleTimer(tradeUpd, 0.1) end)
		aObj:RegisterEvent("TRADE_TARGET_ITEM_CHANGED", function() aObj:ScheduleTimer(tradeUpd, 0.1) end)
		aObj:RegisterEvent("TRADE_UPDATE", function() aObj:ScheduleTimer(tradeUpd, 0.1) end)
	end
	local function mail(...) -- √
		local function mailUpd()
			for i = 1, INBOXITEMS_TO_DISPLAY do
				btnUpd(_G["MailItem"..i.."Button"])
			end
			for i = 1, ATTACHMENTS_MAX_SEND do
				btnUpd(_G["SendMailAttachment"..i])
			end
			for i = 1, ATTACHMENTS_MAX_RECEIVE do
				btnUpd(_G["OpenMailAttachmentButton"..i])
			end
		end
		aObj:RegisterEvent("MAIL_SHOW", function() aObj:ScheduleTimer(mailUpd, 0.1) end)
		aObj:SecureHook("InboxFrame_Update", function()	aObj:ScheduleTimer(mailUpd, 0.1) end)
		aObj:SecureHook("OpenMail_Update", function() aObj:ScheduleTimer(mailUpd, 0.1) end)
		aObj:RegisterEvent("MAIL_SEND_INFO_UPDATE", function() aObj:ScheduleTimer(mailUpd, 0.1) end)
		aObj:RegisterEvent("MAIL_SEND_SUCCESS", function() aObj:ScheduleTimer(mailUpd, 0.1) end)
	end
	local function inspect(...) -- √
		local function inspectUpd()
			for _, child in ipairs{InspectPaperDollItemsFrame:GetChildren()} do
				btnUpd(child)
			end
		end
		aObj:RegisterEvent("INSPECT_READY", function() aObj:ScheduleTimer(inspectUpd, 0.1) end)
		local evtRef1, evtRef2, evtRef3
		evtRef1 = aObj:RegisterEvent("ADDON_LOADED", function(this, event, addon)
			if addon == "Blizzard_InspectUI" then
				self:SecureHook(InspectFrame, "Show", function(this)
					evtRef2 = aObj:RegisterEvent("PLAYER_TARGET_CHANGED", function() aObj:ScheduleTimer(inspectUpd, 0.1) end)
					evtRef3 = aObj:RegisterEvent("UNIT_INVENTORY_CHANGED", function(this, event, unit)
						if InspectFrame.unit == unit then aObj:ScheduleTimer(inspectUpd, 0.1) end
					end)
					aObj:ScheduleTimer(inspectUpd, 0.1)
				end)
				self:SecureHook(InspectFrame, "Hide", function(this)
					aObj:UnregisterEvent("PLAYER_TARGET_CHANGED", evtRef2)
					aObj:UnregisterEvent("UNIT_INVENTORY_CHANGED", evtRef3)
				end)
				aObj:UnregisterEvent(event, evtRef1)
			end
		end)
	end
	local function tradeskill(...) -- √
		local function tradeskillUpd()
			btnUpd(TradeSkillSkillIcon)
			for i = 1, MAX_TRADE_SKILL_REAGENTS do
				btnUpd(_G["TradeSkillReagent"..i], _G["TradeSkillReagent"..i.."IconTexture"])
			end
		end
		local evtRef
		evtRef = aObj:RegisterEvent("TRADE_SKILL_SHOW", function(this, event)
			aObj:SecureHook("TradeSkillFrame_SetSelection", function()
				aObj:ScheduleTimer(tradeskillUpd, 0.1)
			end)
			aObj:ScheduleTimer(tradeskillUpd, 0.1)
			aObj:UnregisterEvent(event, evtRef)
		end)
	end
	local function bank(...) -- √
		local function bankUpd()
			for i = 1, NUM_BANKGENERIC_SLOTS do
				btnUpd(_G["BankFrameItem"..i])
			end
		end
		aObj:RegisterEvent("BANKFRAME_OPENED", function() aObj:ScheduleTimer(bankUpd, 0.1) end)
		aObj:RegisterEvent("PLAYERBANKSLOTS_CHANGED", function() aObj:ScheduleTimer(bankUpd, 0.1) end)
	end
		
	-- enable active modules
	local pipesTable = {
		["bags"]        = bags,
		["char"]        = char,
		["inspect"]     = inspect,
		["bank"]        = bank,
		["gbank"]       = gbank,
		["trade"]       = trade,
		["tradeskill"]  = tradeskill,
		["merchant"]    = merchant,
		["mail"]        = mail,
		["char-flyout"] = charflyout,
		["voidstore"] 	= voidstore,
		["loot"]        = loot,
	}
	for pipe, isActive, name, desc in oGlow.IteratePipes() do
		if isActive then
			pipesTable[pipe]()
		end
	end

end
