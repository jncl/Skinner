local aName, aObj = ...
if not aObj:isAddonEnabled("ArkInventory") then return end
local _G = _G

function aObj:ArkInventory()
	if not self.db.profile.ContainerFrames.skin then return end

	local function skinAIFrames(frame)

		local frameName = frame:GetName()
		local fID = _G.tonumber(frameName:match("%d+$"))

		if not frame.sf then
			for _, v in _G.pairs{"Title", "Search", "ScrollContainer", "Changer", "Status"} do
				aObj:addSkinFrame{obj=_G[frameName .. v], kfs=v~= "Status" and true or nil, nb=true, y1=-1}
			end
			aObj:skinEditBox{obj=_G[frameName .. "SearchFilter"], regs={6}} -- 6 is text
			if _G[frameName .. "StatusText"] then _G[frameName .. "StatusText"]:SetAlpha(1) end
		end

	end

	-- stop frames being painted
	_G.ArkInventory.Frame_Main_Paint = function() end
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

	-- GuildBank Log Frame
	self:applySkin{obj=_G.ARKINV_Frame4Log}
	self:skinSlider{obj=_G.ARKINV_Frame4InfoScroll.ScrollBar}
	self:skinButton{obj=_G.ARKINV_Frame4InfoSave}
	self:applySkin{obj=_G.ARKINV_Frame4Info, nb=true}
	self:addButtonBorder{obj=_G.ARKINV_Frame4ChangerWindowAction, ofs=0}

end

function aObj:ArkInventoryRules()

	--	Rules Frame
	_G.ArkInventory.db.option.ui.rules.border.colour = _G.CopyTable(self.db.profile.BackdropBorder)
	self:skinButton{obj=_G.ARKINV_RulesTitleClose, cb2=true}
	self:addSkinFrame{obj=_G.ARKINV_RulesTitle, nb=true}
	self:addSkinFrame{obj=_G.ARKINV_RulesFrame, nb=true}

	-- View
	self:skinEditBox(_G.ARKINV_RulesFrameViewSearchFilter, {6})
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameViewTable}
	self:skinSlider{obj=_G.ARKINV_RulesFrameViewTableScroll.ScrollBar}
	self:skinButton{obj=_G.ARKINV_RulesFrameViewMenuAdd, as=true}
	self:skinButton{obj=_G.ARKINV_RulesFrameViewMenuEdit, as=true}
	self:skinButton{obj=_G.ARKINV_RulesFrameViewMenuRemove, as=true}

	-- Modify (Add/Edit/Remove)
	self:skinEditBox(_G.ARKINV_RulesFrameModifyDataOrder, {6})
	self:skinEditBox(_G.ARKINV_RulesFrameModifyDataDescription, {6})
	_G.ARKINV_RulesFrameModifyDataScrollTextBorder:SetBackdrop(aObj.Backdrop[10]) -- no background
	_G.ARKINV_RulesFrameModifyDataScrollTextBorder:SetBackdropBorderColor(_G.unpack(aObj.bbColour))
	self:skinSlider{obj=_G.ARKINV_RulesFrameModifyDataScroll.ScrollBar}
	self:skinButton{obj=_G.ARKINV_RulesFrameModifyMenuOk, as=true}
	self:skinButton{obj=_G.ARKINV_RulesFrameModifyMenuCancel, as=true}

end

function aObj:ArkInventorySearch()

	_G.ArkInventory.db.option.ui.search.border.colour = _G.CopyTable(self.db.profile.BackdropBorder)
	self:skinButton{obj=_G.ARKINV_SearchTitleClose, cb2=true}
	self:addSkinFrame{obj=_G.ARKINV_SearchTitle, nb=true}
	self:skinEditBox(_G.ARKINV_SearchFrameViewSearchFilter, {6})
	self:skinSlider{obj=_G.ARKINV_SearchFrameViewTableScroll.ScrollBar}
	self:addSkinFrame{obj=_G.ARKINV_SearchFrame, nb=true}

end
