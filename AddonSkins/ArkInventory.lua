
function Skinner:ArkInventory()
	if not self.db.profile.ContainerFrames.skin then return end

	-- stop frames being painted
	ArkInventory.Frame_Main_Paint = function() end

	self:SecureHook(ArkInventory, "Frame_Main_Draw", function(frame)
--		self:Debug("ArkInventory.Frame_Main_Draw: [%s]", frame)
		local af = frame:GetName()
		if not self.skinned[frame] then
			for _, v in pairs{"Title", "Search", "Container", "Changer", "Status"} do
				y1 = v == "Container" and -1 or 0
				self:addSkinFrame{obj=_G[af..v], kfs=true, y1=y1}
				if v == "Title" then
					self:skinButton{obj=_G[af..v.."Close"], cb2=true, x1=-2, y1=2, x2=2, y2=-2}
				end
			end
			self:skinEditBox(_G[af.."SearchFilter"], {9})
			if _G[af.."StatusText"] then _G[af.."StatusText"]:SetAlpha(1) end
		end
	end)

-->>--	Rules Frame
	ArkInventory.db.profile.option.ui.rules.border.colour = CopyTable(self.db.profile.BackdropBorder)
	self:applySkin(ARKINV_RulesTitle)
	self:skinButton{obj=ARKINV_RulesTitleClose, cb2=true, tx=-1, x1=-1, y1=1, x2=1, y2=-1}
	self:applySkin(ARKINV_RulesFrame)
	self:applySkin(ARKINV_RulesFrameViewTitle)
	self:applySkin(ARKINV_RulesFrameViewSearch)
	self:skinEditBox(ARKINV_RulesFrameViewSearchFilter, {9})
	self:applySkin(ARKINV_RulesFrameViewSort)
	self:applySkin(ARKINV_RulesFrameViewTable)
	self:skinScrollBar{obj=ARKINV_RulesFrameViewTableScroll}
	self:applySkin(ARKINV_RulesFrameViewMenu)
	self:skinButton{obj=ARKINV_RulesFrameViewMenuAdd, y2=1}
	self:skinButton{obj=ARKINV_RulesFrameViewMenuEdit, y2=1}
	self:skinButton{obj=ARKINV_RulesFrameViewMenuRemove, y2=1}
-->>--	RF Add
	self:applySkin(ARKINV_RulesFrameModifyTitle)
	self:applySkin(ARKINV_RulesFrameModifyMenu)
	self:skinButton{obj=ARKINV_RulesFrameModifyMenuOk, y2=1}
	self:skinButton{obj=ARKINV_RulesFrameModifyMenuCancel, y2=1}
	self:applySkin(ARKINV_RulesFrameModifyData)
	self:skinEditBox(ARKINV_RulesFrameModifyDataOrder, {9})
	self:skinEditBox(ARKINV_RulesFrameModifyDataDescription, {9})
	self:skinScrollBar{obj=ARKINV_RulesFrameModifyDataScroll}
	self:addSkinFrame{obj=ARKINV_RulesFrameModifyDataScrollTextBackground}
	ARKINV_RulesFrameModifyDataScrollBarBackground:SetAlpha(0)
-->>--	Search Frame
	ArkInventory.db.profile.option.ui.search.border.colour = CopyTable(self.db.profile.BackdropBorder)
	self:applySkin(ARKINV_SearchTitle)
	self:skinButton{obj=ARKINV_SearchTitleClose, cb2=true, tx=-1, x1=-1, y1=1, x2=1, y2=-1}
	self:applySkin(ARKINV_SearchFrame)
	self:applySkin(ARKINV_SearchFrameViewSearch)
	self:skinEditBox(ARKINV_SearchFrameViewSearchFilter, {9})
	self:applySkin(ARKINV_SearchFrameViewTable)
	self:skinScrollBar{obj=ARKINV_SearchFrameViewTableScroll}
-->>-- GuildBank Log Frame
	self:applySkin{obj=ARKINV_Frame4Log}
-->>-- GuildBank buttons
	self:skinButton{obj=ARKINV_Frame4ChangerWindowPurchaseInfoPurchaseButton}
	self:skinButton{obj=ARKINV_Frame4ChangerWindowDepositButton}
	self:skinButton{obj=ARKINV_Frame4ChangerWindowWithdrawButton}
-->>-- Bank button
	self:skinButton{obj=ARKINV_Frame3ChangerWindowPurchaseInfoPurchaseButton}

end
