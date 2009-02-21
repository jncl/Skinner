
function Skinner:ArkInventory()
	if not self.db.profile.ContainerFrames then return end

	local aiFrames = {"Title", "Search", "Container", "Changer", "Status"}
	self:SecureHook(ArkInventory, "Frame_Main_Draw", function(frame)
--		self:Debug("ArkInventory.Frame_Main_Draw: [%s]", frame)
		local af = frame:GetName()
		if not self.skinned[frame] then
			for _, v in pairs(aiFrames) do
				self:keepFontStrings(_G[af..v])
				self:applySkin(_G[af..v])
				self:RawHook(_G[af..v], "SetBackdrop", function() end, true)
				self:RawHook(_G[af..v], "SetBackdropBorderColor", function() end, true)
			end
			self:skinEditBox(_G[af.."SearchFilter"], {9})
			if _G[af.."StatusText"] then _G[af.."StatusText"]:SetAlpha(1) end
		end
	end)

-->>--	Rules Frame
	self:applySkin(ARKINV_RulesTitle)
	self:applySkin(ARKINV_RulesFrame)
	self:applySkin(ARKINV_RulesFrameViewTitle)
	self:applySkin(ARKINV_RulesFrameViewSearch)
	self:skinEditBox(ARKINV_RulesFrameViewSearchFilter, {9})
	self:applySkin(ARKINV_RulesFrameViewSort)
	self:applySkin(ARKINV_RulesFrameViewTable)
	self:keepFontStrings(ARKINV_RulesFrameViewTableScroll)
	self:skinScrollBar(ARKINV_RulesFrameViewTableScroll)
	self:applySkin(ARKINV_RulesFrameViewMenu)
	self:RawHook(ARKINV_RulesTitle, "SetBackdrop", function() end, true)
	self:RawHook(ARKINV_RulesTitle, "SetBackdropBorderColor", function() end, true)
	self:RawHook(ARKINV_RulesFrame, "SetBackdrop", function() end, true)
	self:RawHook(ARKINV_RulesFrame, "SetBackdropBorderColor", function() end, true)
-->>--	RF Add
	self:applySkin(ARKINV_RulesFrameModifyTitle)
	self:applySkin(ARKINV_RulesFrameModifyMenu)
	self:applySkin(ARKINV_RulesFrameModifyData)
	self:skinEditBox(ARKINV_RulesFrameModifyDataOrder, {9})
	self:skinEditBox(ARKINV_RulesFrameModifyDataDescription, {9})
	self:keepFontStrings(ARKINV_RulesFrameModifyDataScroll)
	self:skinScrollBar(ARKINV_RulesFrameModifyDataScroll)

-->>--	Search Frame
	self:applySkin(ARKINV_SearchTitle)
	self:applySkin(ARKINV_SearchFrame)
	self:applySkin(ARKINV_SearchFrameViewSearch)
	self:skinEditBox(ARKINV_SearchFrameViewSearchFilter, {9})
	self:applySkin(ARKINV_SearchFrameViewTable)
	self:keepFontStrings(ARKINV_SearchFrameViewTableScroll)
	self:skinScrollBar(ARKINV_SearchFrameViewTableScroll)
	self:RawHook(ARKINV_SearchTitle, "SetBackdrop", function() end, true)
	self:RawHook(ARKINV_SearchTitle, "SetBackdropBorderColor", function() end, true)
	self:RawHook(ARKINV_SearchFrame, "SetBackdrop", function() end, true)
	self:RawHook(ARKINV_SearchFrame, "SetBackdropBorderColor", function() end, true)

end
