
function Skinner:ArkInventory()
	if not self.db.profile.ContainerFrames then return end

	if ArkInventory and ArkInventory.Const.Program.Version then self:ArkInventory2plus() return end

	if ARKINV_G and ARKINV_G.PROGRAM_VERSION > 2 then self:ArkInventory2() return end

	self:ArkInventory1()

end

function Skinner:ArkInventory1()

	self:SecureHook(ARKINV, "ContainerGenerateActual", function(loc_id)
--		self:Debug("ARKINV-ContainerGenerateActual")
		self:keepFontStrings(ARKINV_MainFrame1Title)
		self:applySkin(ARKINV_MainFrame1Title)
		self:keepFontStrings(ARKINV_MainFrame1Container)
		self:applySkin(ARKINV_MainFrame1Container)
		self:keepFontStrings(ARKINV_MainFrame1BagChanger)
		self:applySkin(ARKINV_MainFrame1BagChanger)
		self:keepFontStrings(ARKINV_MainFrame1Status)
		if ARKINV_MainFrame1StatusText then ARKINV_MainFrame1StatusText:SetAlpha(1) end
		self:applySkin(ARKINV_MainFrame1Status)
		self:keepFontStrings(ARKINV_MainFrame2Title)
		self:applySkin(ARKINV_MainFrame2Title)
		self:keepFontStrings(ARKINV_MainFrame2Container)
		self:applySkin(ARKINV_MainFrame2Container)
		self:keepFontStrings(ARKINV_MainFrame2BagChanger)
		self:applySkin(ARKINV_MainFrame2BagChanger)
		self:keepFontStrings(ARKINV_MainFrame2Status)
		if ARKINV_MainFrame2StatusText then ARKINV_MainFrame2StatusText:SetAlpha(1) end
		self:applySkin(ARKINV_MainFrame2Status)
		self:keepFontStrings(ARKINV_MainFrame3Title)
		self:applySkin(ARKINV_MainFrame3Title)
		self:keepFontStrings(ARKINV_MainFrame3Container)
		self:applySkin(ARKINV_MainFrame3Container)
		self:keepFontStrings(ARKINV_MainFrame3BagChanger)
		self:applySkin(ARKINV_MainFrame3BagChanger)
		self:keepFontStrings(ARKINV_MainFrame3Status)
		if ARKINV_MainFrame3StatusText then ARKINV_MainFrame3StatusText:SetAlpha(1) end
		self:applySkin(ARKINV_MainFrame3Status)
	end)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ARKINV_Tooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(ARKINV_Tooltip, "OnShow", function(this)
			self:skinTooltip(ARKINV_Tooltip)
		end)
	end

end

function Skinner:ArkInventory2()

	self:SecureHook(ARKINV, "ContainerGenerate", function(AI, loc_id)
--		self:Debug("ARKINV-ContainerGenerate: [%s]", loc_id)
		local af = ARKINV_G.GUI_NAME..loc_id
		self:keepFontStrings(_G[af.."Title"])
		self:applySkin(_G[af.."Title"])
		self:keepFontStrings(_G[af.."Container"])
		self:applySkin(_G[af.."Container"])
		self:keepFontStrings(_G[af.."BagChanger"])
		self:applySkin(_G[af.."BagChanger"])
		self:keepFontStrings(_G[af.."Status"])
		self:applySkin(_G[af.."Status"])
		if _G[af.."StatusText"] then _G[af.."StatusText"]:SetAlpha(1) end
	end)

	if not self.db.profile.Tooltips.skin then return end

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			ARKINV_Tooltip:SetBackdrop(self.backdrop)
			ARKINV_StealthTooltip:SetBackdrop(self.backdrop)
		end
		self:skinTooltip(ARKINV_Tooltip)
		self:skinTooltip(ARKINV_StealthTooltip)
		self:SecureHook(ARKINV, "Tooltip", function(this, txt)
			self:skinTooltip(ARKINV_Tooltip)
		end)
	end

end

function Skinner:ArkInventory2plus()

	local aiFrames = {"Title", "Search", "Container", "Changer", "Status"}
	self:SecureHook(ArkInventory, "Frame_Main_Draw", function(frame)
--		self:Debug("ArkInventory.Frame_Main_Draw: [%s]", frame)
		local af = frame:GetName()
		if not frame.skinned then
			for _, v in pairs(aiFrames) do
				self:keepFontStrings(_G[af..v])
				self:applySkin(_G[af..v])
				self:RawHook(_G[af..v], "SetBackdrop", function() end, true)
			end
			self:skinEditBox(_G[af.."SearchFilter"], {9})
			if _G[af.."StatusText"] then _G[af.."StatusText"]:SetAlpha(1) end
			frame.skinned = true
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
