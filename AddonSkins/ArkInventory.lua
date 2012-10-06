local aName, aObj = ...
if not aObj:isAddonEnabled("ArkInventory") then return end

function aObj:ArkInventory()
	if not self.db.profile.ContainerFrames.skin then return end

	local function skinAIFrames(frame)
		local frameName = frame:GetName()
		local fID = tonumber(frameName:match("%d+$"))
		if not aObj.skinned[frame] then
			for _, v in pairs{"Title", "Search", "Container", "Changer", "Status"} do
				aObj:addSkinFrame{obj=_G[frameName..v], kfs=v~= "Status" and true or nil, y1=v == "Container" and -1 or 0, nb=true}
				if v == "Changer"
				and (fID == 1 or fID == 3 or fID == 4)
				then
					-- Changer frame bag buttons
					for i = 1, fID == 1 and 5 or fID == 3 and 8 or 9 do
						self:addButtonBorder{obj=_G[frameName.."ChangerWindowBag"..i]}
					end
					-- only on Bank changer
					if fID == 3 then
						self:skinButton{obj=_G[frameName.."ChangerWindowPurchaseInfoPurchaseButton"]}
					-- only on Guild Bank Changer
					elseif fID == 4 then
						self:skinButton{obj=_G[frameName.."ChangerWindowWithdrawButton"]}
						self:skinButton{obj=_G[frameName.."ChangerWindowDepositButton"]}
					end
				end
			end
			aObj:skinButton{obj=_G[frameName.."TitleClose"], cb2=true}
			aObj:skinEditBox(_G[frameName.."SearchFilter"], {9})
			if _G[frameName.."StatusText"] then _G[frameName.."StatusText"]:SetAlpha(1) end
		end

	end

	-- stop frames being painted
	ArkInventory.Frame_Main_Paint = function() end
	-- hook this to manage the frame borders
	self:RawHook(ArkInventory, "Frame_Border_Paint", function(border, slot, file, size, offset, scale, r, g, b, a)
		-- ignore Item frames
		if not self:hasTextInName(border, "Item") then return end
		self.hooks[ArkInventory].Frame_Border_Paint(border, slot, file, size, offset, scale, r, g, b, a)
	end, true)
	-- hook this to skin the frames
	self:SecureHook(ArkInventory, "Frame_Main_Draw", function(frame)
		skinAIFrames(frame)
	end)

-->>--	Search Frame
	ArkInventory.db.profile.option.ui.search.border.colour = CopyTable(self.db.profile.BackdropBorder)
	self:addSkinFrame{obj=ARKINV_SearchTitle}
	self:addSkinFrame{obj=ARKINV_SearchFrameViewSearch, nb=true}
	self:skinEditBox(ARKINV_SearchFrameViewSearchFilter, {9})
	self:applySkin(ARKINV_SearchFrameViewTable)
	self:skinScrollBar{obj=ARKINV_SearchFrameViewTableScroll}
	self:addSkinFrame{obj=ARKINV_SearchFrame, nb=true}

-->>-- GuildBank Log Frame
	self:applySkin{obj=ARKINV_Frame4Log}
	self:addButtonBorder{obj=ARKINV_Frame4LogScrollUp, ofs=-2}
	self:addButtonBorder{obj=ARKINV_Frame4LogScrollDown, ofs=-2}
	self:skinScrollBar{obj=ARKINV_Frame4InfoScroll}
	self:applySkin{obj=ARKINV_Frame4Info, nb=true}
	self:skinButton{obj=ARKINV_Frame4InfoSave}

end

function aObj:ArkInventoryRules()

-->>--	Rules Frame
	ArkInventory.db.profile.option.ui.rules.border.colour = CopyTable(self.db.profile.BackdropBorder)
	self:addSkinFrame{obj=ARKINV_RulesTitle}
	self:addSkinFrame{obj=ARKINV_RulesFrame, nb=true}
	-- View
	self:addSkinFrame{obj=ARKINV_RulesFrameViewTitle}
	self:addSkinFrame{obj=ARKINV_RulesFrameViewSearch, nb=true}
	self:skinEditBox(ARKINV_RulesFrameViewSearchFilter, {9})
	self:addSkinFrame{obj=ARKINV_RulesFrameViewSort}
	self:addSkinFrame{obj=ARKINV_RulesFrameViewTable}
	self:skinScrollBar{obj=ARKINV_RulesFrameViewTableScroll}
	self:addSkinFrame{obj=ARKINV_RulesFrameViewMenu, nb=true}
	self:skinButton{obj=ARKINV_RulesFrameViewMenuEdit}
	self:skinButton{obj=ARKINV_RulesFrameViewMenuAdd}
	self:skinButton{obj=ARKINV_RulesFrameViewMenuRemove}
	-- Modify
	self:addSkinFrame{obj=ARKINV_RulesFrameModifyTitle}
	self:addSkinFrame{obj=ARKINV_RulesFrameModifyMenu, nb=true}
	self:skinButton{obj=ARKINV_RulesFrameModifyMenuOk}
	self:skinButton{obj=ARKINV_RulesFrameModifyMenuCancel}
	self:addSkinFrame{obj=ARKINV_RulesFrameModifyData}
	self:skinEditBox(ARKINV_RulesFrameModifyDataOrder, {9})
	self:skinEditBox(ARKINV_RulesFrameModifyDataDescription, {9})
	self:skinScrollBar{obj=ARKINV_RulesFrameModifyDataScroll}
	self:addSkinFrame{obj=ARKINV_RulesFrameModifyDataScrollTextBorder}

end
