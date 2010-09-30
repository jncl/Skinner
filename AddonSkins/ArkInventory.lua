if not Skinner:isAddonEnabled("ArkInventory") then return end

function Skinner:ArkInventory()
	if not self.db.profile.ContainerFrames.skin then return end

	-- stop frames being painted
	ArkInventory.Frame_Main_Paint = function() end
	-- hook this to manage the frame borders
	self:RawHook(ArkInventory, "Frame_Border_Paint", function(border, slot, file, size, offset, scale, r, g, b, a)
		-- ignore Item frames
		if not border:GetName():find("Item") then
			file = self.Backdrop[1].edgeFile
			local c = self.db.profile.BackdropBorder
			r, g, b, a = c.r, c.g, c.b, c.a
		end
		self.hooks[ArkInventory].Frame_Border_Paint(border, slot, file, size, offset, scale, r, g, b, a)
	end, true)
	self:SecureHook(ArkInventory, "Frame_Main_Draw", function(frame)
		self:Debug("ArkInventory.Frame_Main_Draw: [%s]", frame)
		local af = frame:GetName()
		if not self.skinned[frame] then
			for _, v in pairs{"Title", "Search", "Container", "Changer", "Status"} do
				y1 = v == "Container" and -1 or 0
				self:addSkinFrame{obj=_G[af..v], kfs=v~= "Status" and true or nil, y1=y1} -- show currency icons
			end
			self:skinEditBox(_G[af.."SearchFilter"], {9})
			if _G[af.."StatusText"] then _G[af.."StatusText"]:SetAlpha(1) end
		end
	end)

-->>--	Search Frame
	ArkInventory.db.profile.option.ui.search.border.colour = CopyTable(self.db.profile.BackdropBorder)
	self:addSkinFrame{obj=ARKINV_SearchTitle}
	self:applySkin(ARKINV_SearchFrameViewSearch)
	self:skinEditBox(ARKINV_SearchFrameViewSearchFilter, {9})
	self:applySkin(ARKINV_SearchFrameViewTable)
	self:skinScrollBar{obj=ARKINV_SearchFrameViewTableScroll}
	self:addSkinFrame{obj=ARKINV_SearchFrame}
-->>-- GuildBank Log Frame
	self:applySkin{obj=ARKINV_Frame4Log}

-->>--	Rules Frame
	ArkInventory.db.profile.option.ui.rules.border.colour = CopyTable(self.db.profile.BackdropBorder)
	self:addSkinFrame{obj=ARKINV_RulesTitle}
	self:applySkin(ARKINV_RulesFrameViewTitle)
	self:applySkin(ARKINV_RulesFrameViewSearch)
	self:skinEditBox(ARKINV_RulesFrameViewSearchFilter, {9})
	self:applySkin(ARKINV_RulesFrameViewSort)
	self:applySkin(ARKINV_RulesFrameViewTable)
	self:skinScrollBar{obj=ARKINV_RulesFrameViewTableScroll}
	self:applySkin(ARKINV_RulesFrameViewMenu)
	self:addSkinFrame{obj=ARKINV_RulesFrame}
-->>--	RF Add
	self:applySkin(ARKINV_RulesFrameModifyTitle)
	self:applySkin(ARKINV_RulesFrameModifyMenu)
	self:applySkin(ARKINV_RulesFrameModifyData)
	self:skinEditBox(ARKINV_RulesFrameModifyDataOrder, {9})
	self:skinEditBox(ARKINV_RulesFrameModifyDataDescription, {9})
	self:skinScrollBar{obj=ARKINV_RulesFrameModifyDataScroll}
	self:addSkinFrame{obj=ARKINV_RulesFrameModifyDataScrollTextBorder}

end
