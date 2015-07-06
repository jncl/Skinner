local aName, aObj = ...
if not aObj:isAddonEnabled("ArkInventory") then return end
local _G = _G

function aObj:ArkInventory()
	if not self.db.profile.ContainerFrames.skin then return end

	local function skinAIFrames(frame)
		local frameName = frame:GetName()
		local fID = _G.tonumber(frameName:match("%d+$"))
		if not frame.sknd then
			for _, v in _G.pairs{"Title", "Search", "ScrollContainer", "Changer", "Status"} do
				aObj:addSkinFrame{obj=_G[frameName .. v], kfs=v~= "Status" and true or nil, y1=v == "Container" and -1 or 0, nb=true}
				if v == "Changer" then
					-- GuildBank frame
					if fID == 4 then
						aObj:addButtonBorder{obj=_G[frameName .. "ChangerWindowAction"], ofs=0}
					end
				end
			end
			aObj:skinButton{obj=_G[frameName .. "TitleClose"], cb2=true}
			aObj:skinEditBox(_G[frameName .. "SearchFilter"], {9})
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

-->>--	Search Frame
	_G.ArkInventory.db.profile.option.ui.search.border.colour = _G.CopyTable(self.db.profile.BackdropBorder)
	self:skinButton{obj=_G.ARKINV_SearchTitleClose, cb2=true}
	self:addSkinFrame{obj=_G.ARKINV_SearchTitle, nb=true}
	self:addSkinFrame{obj=_G.ARKINV_SearchFrameViewSearch, nb=true}
	self:skinEditBox(_G.ARKINV_SearchFrameViewSearchFilter, {9})
	self:applySkin(_G.ARKINV_SearchFrameViewTable)
	self:skinScrollBar{obj=_G.ARKINV_SearchFrameViewTableScroll}
	self:addSkinFrame{obj=_G.ARKINV_SearchFrame, nb=true}

-->>-- GuildBank Log Frame
	self:applySkin{obj=_G.ARKINV_Frame4Log}
	self:skinScrollBar{obj=_G.ARKINV_Frame4InfoScroll}
	self:skinButton{obj=_G.ARKINV_Frame4InfoSave}
	self:applySkin{obj=_G.ARKINV_Frame4Info, nb=true}

end

function aObj:ArkInventoryRules()

-->>--	Rules Frame
	_G.ArkInventory.db.profile.option.ui.rules.border.colour = _G.CopyTable(self.db.profile.BackdropBorder)
	self:skinButton{obj=_G.ARKINV_RulesTitleClose, cb2=true}
	self:addSkinFrame{obj=_G.ARKINV_RulesTitle, nb=true}
	self:addSkinFrame{obj=_G.ARKINV_RulesFrame, nb=true}
	-- View
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameViewTitle}
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameViewSearch, nb=true}
	self:skinEditBox(_G.ARKINV_RulesFrameViewSearchFilter, {9})
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameViewSort}
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameViewTable}
	self:skinScrollBar{obj=_G.ARKINV_RulesFrameViewTableScroll}
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameViewMenu, nb=true}
	self:skinButton{obj=_G.ARKINV_RulesFrameViewMenuEdit}
	self:skinButton{obj=_G.ARKINV_RulesFrameViewMenuAdd}
	self:skinButton{obj=_G.ARKINV_RulesFrameViewMenuRemove}
	-- Modify
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameModifyTitle}
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameModifyMenu, nb=true}
	self:skinButton{obj=_G.ARKINV_RulesFrameModifyMenuOk}
	self:skinButton{obj=_G.ARKINV_RulesFrameModifyMenuCancel}
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameModifyData}
	self:skinEditBox(_G.ARKINV_RulesFrameModifyDataOrder, {9})
	self:skinEditBox(_G.ARKINV_RulesFrameModifyDataDescription, {9})
	self:skinScrollBar{obj=_G.ARKINV_RulesFrameModifyDataScroll}
	self:addSkinFrame{obj=_G.ARKINV_RulesFrameModifyDataScrollTextBorder}

end
