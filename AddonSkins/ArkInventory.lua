local aName, aObj = ...
if not aObj:isAddonEnabled("ArkInventory") then return end
local _G = _G

aObj.addonsToSkin.ArkInventory = function(self) -- v 30735
	if not self.db.profile.ContainerFrames.skin then return end

	local function skinAIFrames(frame)

		local frameName = frame:GetName()
		local fID = _G.tonumber(frameName:match("%d+$"))

		if not frame.sf then
			for _, type in _G.pairs{"Title", "Search", "ScrollContainer", "Changer", "Status"} do
				aObj:addSkinFrame{obj=_G[frameName .. type], ft="a", kfs=true, nb=true, y1=-1}
				if _G[frameName .. type .. "ArkBorder"] then
					_G[frameName .. type .. "ArkBorder"]:SetBackdrop(nil)
				end
			end
			_G[frameName .. "ScrollArkBorder"]:SetBackdrop(nil)
			_G[frameName .. "SearchFilter"]:SetPoint("TOP", _G[frameName .. "Search"], "TOP", 0, -5)
			_G[frameName .. "SearchFilter"]:SetPoint("BOTTOM", _G[frameName .. "Search"], "BOTTOM", 0, 3)
			aObj:skinEditBox{obj=_G[frameName .. "SearchFilter"], regs={6}} -- 6 is text
			-- reparent the text so it appears above the skinFrame
			_G[frameName .. "StatusEmptyText"]:SetParent(_G[frameName .. "Status"].sf)
		end

	end

	-- stop frames being painted
	_G.ArkInventory.Frame_Main_Paint = _G.nop
	-- hook this to manage the frame borders
	self:RawHook(_G.ArkInventory, "Frame_Border_Paint", function(border, slot, file, size, offset, scale, r, g, b, a)
		-- ignore Item frames
		if not self:hasTextInName(border, "Item") then return end
		self.hooks[_G.ArkInventory].Frame_Border_Paint(border, slot, file, size, offset, scale, r, g, b, a)
	end, true)
	-- hook this to skin the frames
	self:SecureHook(_G.ArkInventory, "Frame_Main_Draw", function(frame)
		skinAIFrames(frame)
	end)

	-- GuildBank Frame a.k.a. Vault
	self:addSkinFrame{obj=_G.ARKINV_Frame4Log, ft="a", nb=true}
	self:skinSlider{obj=_G.ARKINV_Frame4InfoScroll.ScrollBar}
	self:skinStdButton{obj=_G.ARKINV_Frame4InfoSave, as=true} -- use as=true to make text appear above button
	self:addButtonBorder{obj=_G.ARKINV_Frame4ChangerWindowAction, ofs=-2, x1=0}
	_G.ARKINV_Frame4ChangerWindowAction:DisableDrawLayer("BACKGROUND") -- remove button border texture
	self:addSkinFrame{obj=_G.ARKINV_Frame4Info, ft="a", nb=true}

end

aObj.addonsToSkin.ArkInventoryRules = function(self) -- v 10003

	--	Rules Frame
	_G.ArkInventory.db.option.ui.rules.border.colour = _G.CopyTable(self.db.profile.BackdropBorder)
	self:skinCloseButton{obj=_G.ARKINV_RulesTitleClose, onSB=true, sap=true}
	self:addSkinFrame{obj=_G.ARKINV_RulesTitle, ft="a", nb=true}
	self:addSkinFrame{obj=_G.ARKINV_RulesFrame, ft="a", nb=true}

	-- View
	self:skinEditBox(_G.ARKINV_RulesFrameViewSearchFilter, {6})
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameViewTable, ft="a", nb=true}
	self:skinSlider{obj=_G.ARKINV_RulesFrameViewTableScroll.ScrollBar}
	self:skinStdButton{obj=_G.ARKINV_RulesFrameViewMenuAdd, as=true}
	self:skinStdButton{obj=_G.ARKINV_RulesFrameViewMenuEdit, as=true}
	self:skinStdButton{obj=_G.ARKINV_RulesFrameViewMenuRemove, as=true}

	-- Modify (Add/Edit/Remove)
	self:skinEditBox(_G.ARKINV_RulesFrameModifyDataOrder, {6})
	self:skinEditBox(_G.ARKINV_RulesFrameModifyDataDescription, {6})
	_G.ARKINV_RulesFrameModifyDataScrollTextBorder:SetBackdrop(aObj.Backdrop[10]) -- no background
	_G.ARKINV_RulesFrameModifyDataScrollTextBorder:SetBackdropBorderColor(_G.unpack(aObj.bbColour))
	self:skinSlider{obj=_G.ARKINV_RulesFrameModifyDataScroll.ScrollBar}
	self:skinStdButton{obj=_G.ARKINV_RulesFrameModifyMenuOk, as=true}
	self:skinStdButton{obj=_G.ARKINV_RulesFrameModifyMenuCancel, as=true}

end

aObj.lodAddons.ArkInventorySearch = function(self) -- v 10002

	_G.ArkInventory.db.option.ui.search.border.colour = _G.CopyTable(self.db.profile.BackdropBorder)
	self:skinCloseButton{obj=_G.ARKINV_SearchTitleClose, onSB=true, sap=true}
	self:addSkinFrame{obj=_G.ARKINV_SearchTitle, ft="a", nb=true}
	self:skinEditBox(_G.ARKINV_SearchFrameViewSearchFilter, {6})
	self:skinSlider{obj=_G.ARKINV_SearchFrameViewTableScroll.ScrollBar}
	self:addSkinFrame{obj=_G.ARKINV_SearchFrame, ft="a", nb=true}

end
