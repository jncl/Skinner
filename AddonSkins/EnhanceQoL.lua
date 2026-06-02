local _, aObj = ...
if not aObj:isAddonEnabled("EnhanceQoL") then return end
local _G = _G

local addon = _G.EnhanceQoL

local frame
local function ActionTracker(self)
	local aAT = addon.ActionTracker
	local function skinActionTracker()
		frame = aAT.frame
		if self.modBtnBs then
			for _, btn in _G.pairs(frame.icons) do
				self:addButtonBorder{obj=btn}
			end
		end
	end
	if aAT.frame then
		skinActionTracker()
	else
		self:SecureHook(aAT, "EnsureFrame", function(_)
			skinActionTracker()
			self:Unhook(aAT, "EnsureFrame")
		end)
	end
end
local function Aura(self)
	local aA = addon.Aura

	local CastBar = aA.Castbar
	local function skinCastFrame()
		frame = CastBar._state.castBar
		self:skinObject("statusbar", {obj=frame, fi=0})
	end
	if CastBar._state.frame then
		skinCastFrame()
	else
		self:add2Table(self.createFrames, {func = function(_)
			_G.RunNextFrame(function()
				skinCastFrame()
			end)
		end}, "EQOLPlayerCastFrame")
	end

	local ufBossContainer = _G.EQOLUFBossContainer
	local function skinBossContainer(panel)
		frame = ufBossContainer or panel
		self:skinObject("frame", {obj=frame, kfs=true})
	end
	if ufBossContainer then
		skinBossContainer()
	else
		self:add2Table(self.createFrames, {func = function(fObj)
			_G.RunNextFrame(function()
				skinBossContainer(fObj)
			end)
		end}, "EQOLUFBossContainer")
	end

	local UF = aA.UF
	local gaiEditor = _G.EQOL_UF_GlobalAuraIgnoreEditor
	local function skinGAIEditor()
		frame = gaiEditor
		self:skinObject("slider", {obj=frame.ScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=frame, kfs=true})
		if self.modBtns then
			self:skinCloseButton{obj=frame.CloseButton}
			for _, btn in _G.pairs(frame.ContextButtons) do
				self:skinStdButton{obj=btn}
			end
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=frame.EnabledCheck}
			for _, cBtn in _G.pairs(frame.SpecialChecks) do
				self:skinCheckButton{obj=cBtn}
			end
			local function skinFRChecks()
				for _, cBtn in _G.pairs(frame.FamilyRows) do
					self:skinCheckButton{obj=cBtn}
				end
			end
			self:SecureHook(UF.GlobalAuraIgnore, "ResetFamilyCache", function(_)
				skinFRChecks()
			end)
			skinFRChecks()
		end
	end
	if gaiEditor then
		skinGAIEditor()
	else
		self:SecureHook(UF.GlobalAuraIgnore, "ToggleEditor", function(_)
			skinGAIEditor()
			self:Unhook(UF.GlobalAuraIgnore, "ToggleEditor")
		end)
	end

	local gfhbEditor = UF.GroupFramesHealerBuffEditor
	local function skinGFHBEditor()
		frame = gfhbEditor.frame
		self:moveObject{obj=frame.CloseButton, x=-20, y=-12}
		self:skinObject("frame", {obj=frame.GroupPanel, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame.RulePanel, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame.PreviewPanel, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame.PreviewPanel.Frame, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame.PreviewPanel.UnitFrame, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame.SettingsPanel, kfs=true, fb=true})
		self:skinObject("frame", {obj=self:getChild(frame.SettingsPanel, 1), kfs=true, fb=true}) -- groupControlCard
		-- .GroupControlViewport
		self:skinObject("frame", {obj=frame.SettingsPanel.GroupControlContent, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame, kfs=true, cbns=true})
		local controls = frame.Controls
		self:skinObject("editbox", {obj=controls.GroupName})
		self:skinObject("dropdown", {obj=controls.GroupAnchor})
		self:skinObject("dropdown", {obj=controls.GroupGrowth})
		self:skinObject("dropdown", {obj=controls.GroupBarOrientation})
		self:skinObject("dropdown", {obj=controls.BorderStrata})
		self:skinObject("dropdown", {obj=controls.IndicatorBorderTexture})
		self:skinObject("dropdown", {obj=controls.RuleIconMode})
		self:skinObject("dropdown", {obj=controls.RuleMatch})
		for _, type in _G.pairs{"PerRow", "Max", "Spacing", "Size", "CooldownTextSize", "ChargeTextSize", "X", "Y", "BarWidth", "BarHeight", "BarAlpha", "Inset", "BorderSize", "IndicatorBorderSize", "IndicatorBorderOffset"} do
			self:skinObject("slider", {obj=controls[type == "Max" and type .. "Count" or (type == "X" or type == "Y") and type .. "Offset" or type]})
			self:skinObject("editbox", {obj=controls[type .. "Value"], y1=-2, y2=2})
		end
		if self.modBtns then
			for _, pType in _G.pairs{"Group", "Rule"} do
				self:skinStdButton{obj=frame[pType .. "Panel"].AddButton}
				self:skinStdButton{obj=frame[pType .. "Panel"].UpButton}
				self:skinStdButton{obj=frame[pType .. "Panel"].DownButton}
				self:skinStdButton{obj=frame[pType .. "Panel"].DeleteButton}
				for _, row in _G.pairs(frame[pType .. "Panel"].Rows) do
					self:skinStdButton{obj=row.DeleteButton, ofs=0}
				end
			end
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=frame.EnabledCheck, size=26}
			self:skinCheckButton{obj=frame.PreviewPanel.LoopCheck, size=26}
			self:skinCheckButton{obj=controls.IndicatorBorder, size=26}
			self:skinCheckButton{obj=controls.BarFillFrame, size=26}
			self:skinCheckButton{obj=controls.BarDrainAnimation, size=26}
			self:skinCheckButton{obj=controls.BarReverseFill, size=26}
			self:skinCheckButton{obj=controls.CooldownSwipe, size=26}
			self:skinCheckButton{obj=controls.CooldownEdge, size=26}
			self:skinCheckButton{obj=controls.CooldownBling, size=26}
			self:skinCheckButton{obj=controls.HideCooldownText, size=26}
			self:skinCheckButton{obj=controls.HideChargeText, size=26}
			self:skinCheckButton{obj=controls.RuleEnabled, size=26}
			self:skinCheckButton{obj=controls.RuleNot, size=26}
			self:skinCheckButton{obj=controls.RuleMissingDesaturate, size=26}
			self:skinCheckButton{obj=controls.RuleAppliesParty, size=26}
			self:skinCheckButton{obj=controls.RuleAppliesRaid, size=26}
		end
	end
	if gfhbEditor.frame then
		skinGFHBEditor()
	else
		self:SecureHook(gfhbEditor, "EnsureFrame", function(_)
			skinGFHBEditor()
			self:Unhook(gfhbEditor, "EnsureFrame")
		end)
	end

	local GF = UF.GroupFrames
	local function skinGroupBorderFrame()
		frame = _G.EQOLUFPartyGroupBorder
		self:skinObject("frame", {obj=frame, kfs=true, ofs=0})
	end
	if _G.EQOLUFPartyGroupBorder then
		skinGroupBorderFrame()
	else
		self:SecureHook(GF, "EnsureGroupBorderFrame", function(_, _)
			skinGroupBorderFrame()
			self:Unhook(GF, "EnsureGroupBorderFrame")
		end)
	end

	local function skinGroupDropdown()
		frame = GF._dropdown
		self:skinObject("dropdown", {obj=frame})
	end
	if GF._dropdown then
		skinGroupDropdown()
	else
		self:SecureHook(GF, "OpenUnitMenu", function(_)
			skinGroupDropdown()
			self:Unhook(GF, "OpenUnitMenu")
		end)
	end

	if self.modChkBtns then
		self:SecureHook(GF, "_ensureGroupCopySectionCheckbox", function(_, dialog, index)
			self:skinCheckButton{obj=dialog.eqolGroupCopySectionRows[index]}
			self:Unhook(GF, "_ensureGroupCopySectionCheckbox")
		end)
		self:SecureHook(GF, "_ensureGroupCopyAllCheckbox", function(_, dialog)
			self:skinCheckButton{obj=dialog.eqolGroupCopyAllRow}
			self:Unhook(GF, "_ensureGroupCopyAllCheckbox")
		end)
	end

	if self.modBtnBs then
		local fiTracker = aA.FocusInterruptTracker
		local function skinFITrackerFrame()
			frame = fiTracker._state.frame
			self:addButtonBorder{obj=frame.border, relTo=frame.icon}
		end
		if fiTracker._state.frame then
			skinFITrackerFrame()
		else
			self:SecureHook(fiTracker, "EnsureFrame", function(_)
				skinFITrackerFrame()
				self:Unhook(fiTracker, "EnsureFrame")
			end)
		end
		local taTracker = aA.TotalAbsorbTracker
		local taTrackerFrame = _G.EQOLTotalAbsorbTracker
		local function skinTATrackerFrame()
			frame = taTrackerFrame
			self:addButtonBorder{obj=frame.border, relTo=frame.icon}
		end
		if taTrackerFrame then
			skinTATrackerFrame()
		else
			self:SecureHook(taTracker, "EnsureFrame", function(_)
				skinTATrackerFrame()
				self:Unhook(taTracker, "EnsureFrame")
			end)
		end
	end
end
local function Bags(self)
	local aB = addon.Bags

	local function skinBagsFrame()
		frame = aB.variables.state.frame
		self:skinObject("editbox", {obj=frame.SearchBox, si=true})
		self:skinObject("slider", {obj=frame.ScrollFrame.ScrollBar})
		-- .Content
		self:skinObject("frame", {obj=frame, kfs=true, cb=true})
		-- TODO: skin item buttons
		-- aB.variables.state.buttons
	end
	if aB.variables.state.frame then
		skinBagsFrame()
	else
		self:SecureHook(aB.functions, "EnableMain", function(_)
			skinBagsFrame()
			self:Unhook(aB.functions, "EnableMain")
		end)
	end

	local function skinWarbandBankFrame()
		frame = aB.variables.warbandBankState.frame
		self:skinObject("editbox", {obj=frame.SearchBox, si=true})
		self:skinObject("tabs", {obj=frame, tabs=frame.Tabs, ignoreSize=true, lod=self.isTT and true, upwards=true, regions={10}, offsets={x1=2, y1=-4, x2=-2, y2=-2}})
		if self.modBtns then
			self:skinStdButton{obj=frame.ActionBar.DepositButton}
			self:skinStdButton{obj=frame.ActionBar.PurchaseTabButton}
			self:skinStdButton{obj=frame.ActionBar.DepositMoneyButton}
			self:skinStdButton{obj=frame.ActionBar.WithdrawMoneyButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=frame.ActionBar.IncludeReagentsCheckbox}
		end
		self:skinObject("slider", {obj=frame.ScrollFrame.ScrollBar})
		-- .Content
		self:skinObject("frame", {obj=frame, kfs=true, cb=true})
		-- TODO: skin item buttons
		-- aBv.warbandBankState.buttons
	end
	if aB.variables.warbandBankState.frame then
		skinWarbandBankFrame()
	else
		self:add2Table(self.createFrames, {func = function(_)
			_G.RunNextFrame(function()
				skinWarbandBankFrame()
			end)
		end}, "BagsWarbandBankFrame")
	end

	local function skinBagSettingsFrame()
		frame = aB.variables.settingsState.frame
		self:keepFontStrings(frame.BorderFrame)
		for _, tab in _G.pairs(frame.PageButtons) do
			tab.Background:SetTexture(nil)
			self:skinObject("button", {obj=tab, ofs=-1, x1=-1, y2=2})
		end
		self:skinObject("frame", {obj=frame.ModeCard, kfs=true, fb=true})
		if self.modBtns then
			self:skinStdButton{obj=frame.ModeCard.SwitchButton}
			self:skinStdButton{obj=frame.ModeCard.CopyButton}
		end
		self:skinObject("frame", {obj=frame, kfs=true, cb=true, ofs=1})

		local layout = frame.Pages.layout
		self:skinObject("slider", {obj=layout.ScrollFrame.ScrollBar})
		if self.modBtns then
			self:skinStdButton{obj=layout.CompactCategoryGapControl.DownButton}
			self:skinStdButton{obj=layout.CompactCategoryGapControl.UpButton}
			self:skinStdButton{obj=layout.CategoryTreeIndentControl.DownButton}
			self:skinStdButton{obj=layout.CategoryTreeIndentControl.UpButton}
			self:skinStdButton{obj=layout.ResetButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=layout.OneBagMode}
			self:skinCheckButton{obj=layout.ShowCategories}
			self:skinCheckButton{obj=layout.OneBagFreeSlotsAtEnd}
			self:skinCheckButton{obj=layout.CombineFreeSlots}
			self:skinCheckButton{obj=layout.ShowFreeSlots}
			self:skinCheckButton{obj=layout.CombineDuplicateItems}
			self:skinCheckButton{obj=layout.ClearNewItemsOnHeaderClick}
			self:skinCheckButton{obj=layout.CompactCategoryLayout}
			self:skinCheckButton{obj=layout.CategoryTreeView}
			self:skinCheckButton{obj=layout.ShowCloseButton}
			self:skinCheckButton{obj=layout.RememberLastBankTab}
		end
		self:skinObject("frame", {obj=layout.PaddingCard, kfs=true, fb=true})
		if self.modBtns then
			self:skinStdButton{obj=layout.OutsideHeaderPaddingControl.UpButton}
			self:skinStdButton{obj=layout.OutsideHeaderPaddingControl.DownButton}
			self:skinStdButton{obj=layout.OutsideFooterPaddingControl.UpButton}
			self:skinStdButton{obj=layout.OutsideFooterPaddingControl.DownButton}
			self:skinStdButton{obj=layout.InsideHorizontalPaddingControl.UpButton}
			self:skinStdButton{obj=layout.InsideHorizontalPaddingControl.DownButton}
			self:skinStdButton{obj=layout.InsideTopPaddingControl.UpButton}
			self:skinStdButton{obj=layout.InsideTopPaddingControl.DownButton}
			self:skinStdButton{obj=layout.InsideBottomPaddingControl.UpButton}
			self:skinStdButton{obj=layout.InsideBottomPaddingControl.DownButton}
			self:skinStdButton{obj=layout.ItemScaleControl.UpButton}
			self:skinStdButton{obj=layout.ItemScaleControl.DownButton}
			self:skinStdButton{obj=layout.MaxColumnsControl.UpButton}
			self:skinStdButton{obj=layout.MaxColumnsControl.DownButton}
		end
		self:skinObject("frame", {obj=layout.TextAppearanceCard, kfs=true, fb=true})
		if self.modBtns then
			self:skinStdButton{obj=layout.SkinPresetButton}
			self:skinStdButton{obj=layout.IconShapeButton}
			self:skinStdButton{obj=layout.FreeSlotDisplayButton}
			self:skinStdButton{obj=layout.FrameBackgroundButton}
			self:skinStdButton{obj=layout.FrameBackgroundOpacityDownButton}
			self:skinStdButton{obj=layout.FrameBackgroundOpacityUpButton}
			self:skinStdButton{obj=layout.FrameBorderTextureButton}
			self:skinStdButton{obj=layout.FrameBorderSizeDownButton}
			self:skinStdButton{obj=layout.FrameBorderSizeUpButton}
			self:skinStdButton{obj=layout.FrameBorderOffsetDownButton}
			self:skinStdButton{obj=layout.FrameBorderOffsetUpButton}
			self:skinStdButton{obj=layout.TextFontButton}
			self:skinStdButton{obj=layout.TextSizeDownButton}
			self:skinStdButton{obj=layout.TextSizeUpButton}
			self:skinStdButton{obj=layout.TextOverlaySizeDownButton}
			self:skinStdButton{obj=layout.TextOverlaySizeUpButton}
			self:skinStdButton{obj=layout.TextOutlineButton}
		end
		for _, row in _G.pairs(layout.TextStyleRows) do
			if self.modBtns then
				self:skinStdButton{obj=row.OutlineButton}
				self:skinStdButton{obj=row.StackAnchorButton}
				self:skinStdButton{obj=row.CaseButton}
				self:skinStdButton{obj=row.SizeDownButton}
				self:skinStdButton{obj=row.SizeUpButton}
				self:skinStdButton{obj=row.FontButton}
			end
		end

		local categories = frame.Pages.categories
		self:skinObject("frame", {obj=categories.BuiltInCard, kfs=true, fb=true})
		self:skinObject("slider", {obj=categories.ListScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=categories.ListCard, kfs=true, fb=true})
		if self.modBtns then
			self:skinStdButton{obj=categories.AddGroupButton}
			self:skinStdButton{obj=categories.AddCategoryButton}
		end
		self:skinObject("slider", {obj=categories.DetailScrollFrame.ScrollBar})
		self:skinObject("editbox", {obj=categories.NameBox})
		if self.modBtns then
			self:skinStdButton{obj=categories.DeleteCategoryButton}
			self:skinStdButton{obj=categories.GroupButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=categories.HideInBags}
			self:skinCheckButton{obj=categories.DesaturateItems}
		end
		self:skinObject("editbox", {obj=categories.PriorityValue})
		if self.modBtns then
			self:skinStdButton{obj=categories.PriorityDownButton}
			self:skinStdButton{obj=categories.PriorityUpButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=categories.GroupSpacerBefore}
			self:skinCheckButton{obj=categories.GroupCombineSubcategories}
		end
		self:skinObject("editbox", {obj=categories.MatchPriorityValue})
		if self.modBtns then
			self:skinStdButton{obj=categories.MatchPriorityDownButton}
			self:skinStdButton{obj=categories.MatchPriorityUpButton}
			self:skinStdButton{obj=categories.SortButton}
		end
		self:skinObject("frame", {obj=categories.ItemsCard, kfs=true, fb=true})
		self:skinObject("editbox", {obj=categories.ItemInput})
		if self.modBtns then
			self:skinStdButton{obj=categories.AddItemButton}
		end
		self:skinObject("slider", {obj=categories.ItemsListScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=categories.RulesCard, kfs=true, fb=true})
		for _, rnFrame in _G.pairs(categories.RuleNodeFrames) do
			self:skinObject("editbox", {obj=rnFrame.ValueBox})
		end

		local overlays = frame.Pages.overlays
		self:skinObject("slider", {obj=overlays.ScrollFrame.ScrollBar})
		for _, card in _G.pairs(overlays.Cards) do
			self:skinObject("frame", {obj=card, kfs=true, fb=true})
			if self.modBtns then
				self:skinStdButton{obj=card.DisplayModeButton}
				self:skinStdButton{obj=card.ColorModeButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=card.EnabledCheck}
				for _, tBtn in _G.pairs(card.TrackButtons) do
					self:skinCheckButton{obj=tBtn}
				end
			end
		end

		local footer = frame.Pages.footer
		if self.modBtns then
			self:skinStdButton{obj=footer.MoneyFormatButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=footer.ShowGold}
			self:skinCheckButton{obj=footer.ShowCurrencies}
			self:skinCheckButton{obj=footer.ShowFooterSlotSummary}
		end
		self:skinObject("slider", {obj=footer.CharacterListScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=footer.TrackedCharactersCard, kfs=true, fb=true})

		local tracking = frame.Pages.tracking
		self:skinObject("slider", {obj=tracking.ScrollFrame.ScrollBar})
		if self.modChkBtns then
			self:skinCheckButton{obj=tracking.ShowWatchedCurrencies}
			self:skinCheckButton{obj=tracking.ShowTrackedCurrencyCharacterBreakdown}
		end
		self:skinObject("frame", {obj=tracking.TrackedCurrencyTooltipCard, kfs=true, fb=true})
		if self.modBtns then
			self:skinStdButton{obj=tracking.TrackedCurrencyTooltipTotalPositionButton}
			self:skinStdButton{obj=tracking.TrackedCurrencyTooltipNameColorButton}
			self:skinStdButton{obj=tracking.TrackedCurrencyTooltipCountColorButton}
		end
		self:skinObject("editbox", {obj=tracking.TrackedCurrencyAddBox})
		self:skinObject("slider", {obj=tracking.TrackedCurrencyScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=tracking.TrackedCurrencyCard, kfs=true, fb=true})
		if self.modBtns then
			self:skinStdButton{obj=tracking.TrackedCurrencyAddButton}
		end

		self:SecureHook(addon, "RefreshSettingsFrame", function(_, _, _)
			if self.modBtns then
				for _, row in _G.pairs(categories.AssignedItemRows) do
					self:skinStdButton{obj=row.RemoveButton}
				end
				for _, rnFrame in _G.pairs(categories.RuleNodeFrames) do
					self:skinStdButton{obj=rnFrame.ActionButton}
					self:skinStdButton{obj=rnFrame.AddButton}
					self:skinStdButton{obj=rnFrame.FieldButton}
					self:skinStdButton{obj=rnFrame.OperatorButton}
					self:skinStdButton{obj=rnFrame.ValueButton}
					self:skinStdButton{obj=rnFrame.RemoveButton}
				end
				for _, row in _G.pairs(footer.CharacterRows) do
					self:skinStdButton{obj=row.DeleteButton}
				end
				for _, row in _G.pairs(tracking.TrackedCurrencyRows) do
					self:skinStdButton{obj=row.RemoveButton}
					self:skinStdButton{obj=row.DownButton}
					self:skinStdButton{obj=row.UpButton}
				end
			end
			if self.modChkBtns then
				for _, cBtn in _G.pairs(categories.BuiltInCategoryButtons) do
					self:skinCheckButton{obj=cBtn}
				end
			end
		end)
	end
	if aB.variables.settingsState.frame then
		skinBagSettingsFrame()
	else
		self:SecureHook(addon, "OpenSettings", function(_, _)
			skinBagSettingsFrame()
			self:Unhook(addon, "OpenSettings")
		end)
	end

	local function skinOnboardingFrame()
		-- WIP:
		frame = aB.variables.settingsState.onboardingFrame
		self:skinObject("frame", {obj=frame, kfs=true, cb=true})
	end
	if aB.variables.settingsState.onboardingFrame then
		skinOnboardingFrame()
	else
		self:SecureHook(addon, "OpenCategoryModeOnboarding", function(_)
			skinOnboardingFrame()
			self:Unhook(addon, "OpenCategoryModeOnboarding")
		end)
	end
end
local function ButtonSink(self)
	local bsFrame = addon.variables.buttonSink
	local function skinButtonSink()
		frame = addon.variables.buttonSink
		self:skinObject("frame", {obj=frame, kfs=true, cb=true, ofs=0})
	end
	if bsFrame then
		skinButtonSink()
	end
	self:SecureHook(addon.functions, "toggleButtonSink", function(_, _)
		frame = addon.variables.buttonSink
		if addon.db["enableMinimapButtonBin"]
		or bsFrame
		then
			if bsFrame then
				bsFrame.sf = nil
			end
		end
		skinButtonSink()
	end)
end
local function ChannelHistory(self)
	local channelHist = addon.ChatIM.ChannelHistory
	local ui = channelHist.ui

	if self.modBtnBs then
		local function skinToggleButton()
			self:addButtonBorder{obj=channelHist.toggleButton, ofs=0}
		end
		if channelHist.toggleButton then
			skinToggleButton()
		else
			self:SecureHook(channelHist, "EnsureToggleButton", function(_, _)
				skinToggleButton()
				self:Unhook(channelHist, "EnsureToggleButton")
			end)
		end
	end

	local function skinCopyPopupFrame()
		frame = ui.copyPopup

		self:skinObject("frame", {obj=frame, kfs=true, ofs=3})
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(frame, 1)}
		end
	end
	local function skinDebugFrame()
		frame = channelHist.debugFrame

		self:moveObject{obj=ui.closeButton, x=-17, y=-9}
		self:moveObject{obj=ui.clearHelpButton, x=8, y=-8}

		self:skinObject("frame", {obj=frame.left, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame.middle, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame.right, kfs=true, fb=true})

		self:skinObject("editbox", {obj=ui.leftSearch, si=true})
		self:skinObject("editbox", {obj=ui.rightSearch, si=true})

		if self.modBtns then
			self:skinStdButton{obj=ui.filterTopBar.allBtn, ofs=3}
			self:skinStdButton{obj=ui.filterTopBar.noneBtn, ofs=3}
			self:skinStdButton{obj=ui.filterTopBar.invertBtn, ofs=3}
		end
		if self.modChkBtns then
			for _, cBtn in _G.pairs(ui.filterChecksByKey) do
				self:skinCheckButton{obj=cBtn, size=22}
			end
		end

		self:skinObject("frame", {obj=frame, kfs=true})
		if self.modBtns then
			self:skinCloseButton{obj=ui.closeButton}
		end

		if ui.copyPopup then
			skinCopyPopupFrame()
		else
			self:SecureHookScript(ui.copyButton, "OnClick", function(_)
				skinCopyPopupFrame()
				self:Unhook(ui.copyButton, "OnClick")
			end)
		end
	end
	if channelHist.debugFrame then
		skinDebugFrame()
	else
		self:SecureHook(channelHist, "CreateDebugFrame", function(_, _)
			skinDebugFrame()
			self:Unhook(channelHist, "CreateDebugFrame")
		end)
	end
end
local function CooldownPanels(self)
	local aACP = addon.Aura.CooldownPanels
	local rEditor = aACP.runtime.editor

	local function skinEditor()
		frame = aACP.runtime.editor.frame
		self:moveObject{obj=frame.close, x=-17, y=-10}
		frame.cdmAuraHelp.ring:SetTexture(nil)
		self:moveObject{obj=frame.cdmAuraHelp, x=8, y=-8}

		self:skinObject("frame", {obj=frame.left, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame.right, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame.middle, kfs=true, fb=true})
		self:skinObject("frame", {obj=rEditor.previewFrame, kfs=true, fb=true})
		self:skinObject("frame", {obj=frame, kfs=true, cb=true})

		self:skinObject("slider", {obj=rEditor.panelList.scroll.ScrollBar})
		self:skinObject("slider", {obj=rEditor.inspector.scroll.ScrollBar})
		self:skinObject("slider", {obj=rEditor.entryList.scroll.ScrollBar})

		self:skinObject("editbox", {obj=rEditor.addIdBox})
		self:skinObject("editbox", {obj=rEditor.inspector.panelName})
		self:skinObject("editbox", {obj=rEditor.inspector.entryId})
		self:skinObject("editbox", {obj=rEditor.inspector.customDurationBox})
		self:skinObject("editbox", {obj=rEditor.inspector.staticTextBox})

		if self.modBtns then
			self:skinStdButton{obj=rEditor.addGroup}
			self:skinStdButton{obj=rEditor.importPanel}
			self:skinStdButton{obj=rEditor.addPanel}
			self:skinStdButton{obj=rEditor.deletePanel, schk=true}
			self:skinStdButton{obj=rEditor.panelSpecButton, schk=true}
			self:skinStdButton{obj=rEditor.addSpellButton, schk=true}
			self:skinStdButton{obj=rEditor.addItemButton, schk=true}
			self:skinStdButton{obj=rEditor.layoutEditButton, schk=true}
			self:skinStdButton{obj=rEditor.slotButton, schk=true}
			self:skinStdButton{obj=rEditor.importCDMButton, schk=true}
			self:skinStdButton{obj=rEditor.inspector.racialExclusionsButton, schk=true}
			self:skinStdButton{obj=rEditor.inspector.soundButton, schk=true}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=rEditor.panelEnabled}
			self:skinCheckButton{obj=rEditor.inspector.cbCooldownText}
			self:skinCheckButton{obj=rEditor.inspector.cbTrackPassiveSpell}
			self:skinCheckButton{obj=rEditor.inspector.cbAlwaysShow}
			self:skinCheckButton{obj=rEditor.inspector.cbCharges}
			self:skinCheckButton{obj=rEditor.inspector.cbStacks}
			self:skinCheckButton{obj=rEditor.inspector.cbItemCount}
			self:skinCheckButton{obj=rEditor.inspector.cbItemUses}
			self:skinCheckButton{obj=rEditor.inspector.cbUseHighestRank}
			self:skinCheckButton{obj=rEditor.inspector.cbShowWhenEmpty}
			self:skinCheckButton{obj=rEditor.inspector.cbShowWhenNoCooldown}
			self:skinCheckButton{obj=rEditor.inspector.cbCDMAuraOverlay}
			self:skinCheckButton{obj=rEditor.inspector.cbCDMAuraOverlayReverse}
			self:skinCheckButton{obj=rEditor.inspector.cbActivationOverlayOnly}
			self:skinCheckButton{obj=rEditor.inspector.cbActivationOverlayGlow}
			self:skinCheckButton{obj=rEditor.inspector.cbAutoDuration}
			self:skinCheckButton{obj=rEditor.inspector.cbCustomDuration}
			self:skinCheckButton{obj=rEditor.inspector.cbStaticTextDuringCD}
			self:skinCheckButton{obj=rEditor.inspector.cbGlow}
			self:skinCheckButton{obj=rEditor.inspector.cbPandemicGlow}
			self:skinCheckButton{obj=rEditor.inspector.cbSound}
		end
	end
	if rEditor then
		skinEditor()
	else
		self:SecureHook(aACP, "OpenEditor", function(_)
			skinEditor()
			self:Unhook(aACP, "OpenEditor")
		end)
	end
end
local function DamageMeter(self)
	local aDM = addon.DamageMeter
	local function skinDamageMeterWindow(window)
		-- .windowBackground
		-- .contentBackground
		-- .windowBorder
		window.headerBackground:SetTexture(nil)
		-- .header
		-- .headerButtons
		-- .resetButton
		-- .reportButton
		-- .rowsViewport
		-- .rowsContainer
		-- .footerBackground
		-- .status
		-- .rows
	end
	self:RawHook(aDM, "EnsureWindow", function(this, index)
		local window = self.hooks[this].EnsureWindow(this, index)
		skinDamageMeterWindow(window)
		return window
	end, true)
	for _, window in _G.pairs(aDM.windows) do
		skinDamageMeterWindow(window)
	end

	local function skinContextMenu()
		frame = aDM.contextMenu
		self:skinObject("frame", {obj=frame, kfs=true})
		-- .buttons
	end
	if aDM.contextMenu then
		skinContextMenu()
	else
		self:SecureHook(aDM, "EnsureContextMenu", function(_)
			skinContextMenu()
			self:Unhook(aDM, "EnsureContextMenu")
		end)
	end

	local function skinSourceTooltip()
		frame = aDM.sourceTooltip
		frame.border:SetBackdrop(nil)
		frame.border.SetBackdrop = _G.nop
		self:skinObject("frame", {obj=frame, kfs=true, clr="gold"})
	end
	if aDM.sourceTooltip then
		skinSourceTooltip()
	else
		self:SecureHook(aDM, "EnsureSourceTooltip", function(_)
			skinSourceTooltip()
			self:Unhook(aDM, "EnsureSourceTooltip")
		end)
	end

	local function skinReportDialog()
		frame = aDM.reportDialog
		self:skinObject("editbox", {obj=frame.linesBox})
		self:skinObject("editbox", {obj=frame.targetBox})
		self:skinObject("frame", {obj=frame, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=frame.channelButton}
			self:skinStdButton{obj=frame.send}
			self:skinStdButton{obj=frame.cancel}
		end
	end
	if aDM.reportDialog then
		skinReportDialog()
	else
		self:SecureHook(aDM, "EnsureReportDialog", function(_)
			skinReportDialog()
			self:Unhook(aDM, "EnsureReportDialog")
		end)
	end
end
local function DataPanels(self)
	local aDP = addon.DataPanel
	local function skinDataPanel(panel)
		self:skinObject("frame", {obj=panel, kfs=true})
	end

	self:RawHook(aDP, "Create", function(...)
		local panel = self.hooks[aDP].Create(...)
		skinDataPanel(panel.frame)
		return panel
	end, true)

	-- skin existing panels
	for id in _G.pairs(addon.db.dataPanels) do
		aDP.Create(id, nil, true)
	end
end
local function EditModeLib(self)
	local aEML = addon.EditModeLib
	local function skinDialog()
		frame = aEML.internal.dialog

		self:removeNineSlice(frame.Border)
		frame.Border.Bg:SetTexture(nil)
		-- .HideLabelButton [child3] (LFG_EYE_TEXTURE)
		self:skinObject("slider", {obj=frame.SettingsScroll.ScrollBar})
		frame.Settings.Divider:SetTexture(nil)
		self:skinObject("frame", {obj=frame, kfs=true, cb=true, ofs=-1})
		if self.modBtns then
			self:skinStdButton{obj=frame.Settings.ResetButton, ofs=0}
		end

		local oType
		self:SecureHook(frame, "Update", function(this, _)
			for _, child in _G.ipairs{this.Settings:GetChildren()} do
				if child.collapsed ~=nil then
					if self.modBtns then
						self:skinStdButton{obj=child, sechk=true, ofs=0}
						-- TODO: handle .CollapseIcon texture changes
					end
				end
				if child.Button
				or child.Check
				then
					oType = (child.Check or child.Button):GetObjectType()
					if oType == "CheckButton"
					and self.modChkBtns
					then
						self:skinCheckButton{obj=child.Check or child.Button, size=28}
					end
				end
				if child.Dropdown
				and self.modBtns
				then
					self:skinStdButton{obj=child.Dropdown, ofs=0}
				end
				if child.OldDropdown then
					self:skinObject("ddbutton", {obj=child.OldDropdown})
				end
				if child.Slider then
					self:skinObject("slider", {obj=child.Slider.Slider, y1=-10, y2=10})
				end
				if child.Input then
					self:skinObject("editbox", {obj=child.Input})
				end
			end
			if self.modBtns then
				for _, child in _G.ipairs{this.Buttons.Primary:GetChildren()} do
					self:skinStdButton{obj=child, ofs=0}
				end
				for _, child in _G.ipairs{this.Buttons.Compact:GetChildren()} do
					self:skinStdButton{obj=child, ofs=0}
				end
				for _, child in _G.ipairs{this.Buttons.Reset:GetChildren()} do
					self:skinStdButton{obj=child, ofs=0}
				end
			end
		end)
	end
	if aEML.internal.dialog then
		skinDialog()
	else
		self:SecureHook(aEML.internal, "EnsureDialog", function(_)
			skinDialog()
			self:Unhook(aEML.internal, "EnsureDialog")
		end)
	end
end
local function GemHelper(self)
	local function skinGemHelper()
		frame = _G.EnhanceQoLGemHelper
		self:skinObject("frame", {obj=frame, kfs=true})
	end
	if _G.EnhanceQoLGemHelper then
		skinGemHelper()
	else
		_G.EventUtil.RegisterOnceFrameEventAndCallback("SOCKET_INFO_UPDATE", skinGemHelper)
	end
end
local function Ignore(self)
	local aI = addon.Ignore
	local function skinIgnoreFrame()
		frame = aI.frame
		self:skinObject("editbox", {obj=aI.searchBox})
		for _, header in _G.ipairs_reverse{aI.header:GetChildren()} do
			header:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=header})
		end
		self:skinObject("slider", {obj=aI.scrollFrame.scrollBar})
		self:skinObject("frame", {obj=frame, kfs=true, ri=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=aI.removeBtn}
			-- TODO: skin .rows
			-- hook aI:UpdateRows
		end
	end
	if aI.frame then
		skinIgnoreFrame()
	end
end
local function InstantCatalyst(self)
	local icButton = _G.EnhanceQoLInstantCatalyst
	_G.EventUtil.ContinueOnAddOnLoaded("Blizzard_ItemInteractionUI", function()
		_G.RunNextFrame(function()
			if icButton then
				self:addButtonBorder{obj=icButton}
			end
		end)
	end)
end
local function InventoryFilterPanel(self)
	local function skinInventoryFilterPanel()
		frame = addon.filterFrame
		self:skinObject("frame", {obj=frame, kfs=true, ofs=0})
	end
	if addon.filterFrame then
		skinInventoryFilterPanel()
	else
		self:SecureHook(addon.functions, "updateBags", function(_)
			if addon.db["showBagFilterMenu"] then
				skinInventoryFilterPanel()
				self:Unhook(addon.functions, "updateBags")
			end
		end)
	end
end
local function ItemInventory(self)
	local aDW = addon.DurabilityWarning
	local function skinDurabilityWarning()
		self:skinObject("frame", {obj=aDW.frame, kfs=true})
	end
	if aDW.frame then
		skinDurabilityWarning()
	else
		self:SecureHook(aDW, "EnsureFrame", function(_)
			skinDurabilityWarning()
			self:Unhook(aDW, "EnsureFrame")
		end)
	end
end
local function LootspecFrame(self)
	local lsFrame = addon.variables.lootSpec
	local function skinLootSpecFrame()
		frame = addon.variables.lootSpec
		self:skinObject("frame", {obj=frame, kfs=true, ofs=0})
	end
	if lsFrame then
		skinLootSpecFrame()
	end
	self:SecureHook(addon.functions, "createLootspecFrame", function(_)
		skinLootSpecFrame()
	end)
	self:RawHook(addon.functions, "removeLootspecframe", function()
		frame = addon.variables.lootSpec
		frame.sf = nil
		self.hooks[addon.functions].removeLootspecframe()
	end)
end
local function Mailbox(self)
	local aM = addon.Mailbox
	local function skinMailboxFrame()
		frame = aM.frame
		self:skinObject("editbox", {obj=aM.searchBox})
		for _, header in _G.ipairs_reverse{aM.header:GetChildren()} do
			header:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=header, x2=-2})
		end
		self:skinObject("slider", {obj=aM.scrollFrame.scrollBar})
		self:skinObject("frame", {obj=frame, kfs=true, cb=true})
	end
	if aM.frame then
		skinMailboxFrame()
	end
end
local function MountActions(self)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.EQOLRandomMountButton, sabt=true}
		self:addButtonBorder{obj=_G.EQOLRepairMountButton, sabt=true}
		self:addButtonBorder{obj=_G.EQOLAuctionMountButton, sabt=true}
	end
end
local function MythicPlus(self)
	local aMP = addon.MythicPlus

	local function skinDungeonTeleportFrame()
		frame = aMP.portalFrame
		self:skinObject("frame", {obj=frame, kfs=true})
	end
	if aMP.portalFrame then
		skinDungeonTeleportFrame()
	end

	local function skinDungeonScoreFrame()
		frame = _G.EQOLDungeonScoreFrame
		self:skinObject("frame", {obj=frame, kfs=true, cb=true})
	end
	if _G.EQOLDungeonScoreFrame then
		skinDungeonScoreFrame()
	else
		self:SecureHook(aMP.functions, "toggleFrame", function(_)
			skinDungeonScoreFrame()
			self:Unhook(aMP.functions, "toggleFrame")
		end)
	end

	local popup = _G.ChangeTalentUIPopup
	local function skinChangeTalentUIPopup()
		frame = popup
		self:skinObject("frame", {obj=frame, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(frame, 1)} -- reloadButton
			self:skinStdButton{obj=self:getChild(frame, 2)} -- cancelButton
		end
	end
	if popup then
		skinChangeTalentUIPopup()
	else
		self:SecureHook(aMP.functions, "checkLoadout", function(_)
			if popup then
				skinChangeTalentUIPopup()
			end
		end)
	end

	local warning = _G.ChangeTalentUIWarning
	local function skinChangeTalentUIWarning()
		frame = popup
		self:skinObject("frame", {obj=frame, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(frame, 1)} -- cancelButton
		end
	end
	if warning then
		skinChangeTalentUIWarning()
	else
		self:SecureHook(aMP.functions, "checkRemovedLoadout", function(_)
			if warning then
				skinChangeTalentUIWarning()
			end
		end)
	end

	local wmdpPanel = _G.EQOLWorldMapDungeonPortalsPanel
	local function skinWMDungeonPortalsPanel(panel)
		frame = wmdpPanel or panel
		frame.Scroll.Background:SetTexture(nil)
		self:skinObject("scrollbar", {obj=frame.Scroll.ScrollBar})
		-- .Blocker
		self:keepFontStrings(frame.BorderFrame)
		self:skinObject("frame", {obj=frame, kfs=true, ofs=5, y1=34, y2=-12}) -- include Title
	end
	if wmdpPanel then
		skinWMDungeonPortalsPanel()
	else
		self:add2Table(self.createFrames, {func = function(fObj)
			_G.RunNextFrame(function()
				skinWMDungeonPortalsPanel(fObj)
			end)
		end}, "EQOLWorldMapDungeonPortalsPanel")
	end

	-- EQOLRandomHearthstoneButton
end
local function ReloadFrame(self)
	local rlFrame = _G.ReloadUIPopup
	local function skinReloadFrame(panel)
		frame = rlFrame or panel
		self:skinObject("frame", {obj=frame, kfs=true, cb=true, ofs=0})
		if self.modBtns then
			 self:skinStdButton{obj=self:getChild(frame, 2)} -- reloadButton
			 self:skinStdButton{obj=self:getChild(frame, 3)} -- cancelButton
		end
	end
	if rlFrame then
		skinReloadFrame()
	else
		self:SecureHook(addon.functions, "checkReloadFrame", function(_, _)
			if addon.variables.requireReload then
				skinReloadFrame(_G.ReloadUIPopup)
				self:Unhook(addon.functions, "checkReloadFrame")
			end
		end)
	end
end
local function Reminder(self)
	local aCBR = addon.ClassBuffReminder

	local function skinReminderFrame()
		frame = aCBR.frame
		self:skinObject("frame", {obj=frame, kfs=true})
		if self.modBtnBs then
			self:SecureHook(aCBR, "Render", function(_)
				for _, btn in _G.pairs(frame.missingIcons) do
					btn.border:SetTexture(nil)
					self:addButtonBorder{obj=btn, relTo=btn.icon}
					-- TODO: colour button border from border
				end
				self:Unhook(aCBR, "Render")
			end)
			for _, btn in _G.pairs(frame.sampleIcons) do
				self:addButtonBorder{obj=btn, relTo=btn.icon}
			end
		end
	end
	if aCBR.frame then
		skinReminderFrame()
	else
		self:SecureHook(aCBR, "EnsureFrame", function(_)
			skinReminderFrame()
			self:Unhook(aCBR, "EnsureFrame")
		end)
	end
end
local function TradeMailLog(self)
	local aTML = addon.TradeMailLog
	local function skinMailPreviewFrame()
		frame = aTML.mailPreview
		frame.ScrollFrame:DisableDrawLayer("BACKGROUND")
		self:skinObject("slider", {obj=frame.ScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=frame, kfs=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=frame.CloseButtonBottom}
		end
		if self.modBtnBs then
			for _, btn in _G.pairs(frame.attachmentButtons) do
				self:addButtonBorder{obj=btn, ibt=true}
			end
		end
	end
	if aTML.mailPreview then
		self:SecureHook(aTML, "ShowMailPreview", function(_)
			skinMailPreviewFrame()
			self:Unhook(aTML, "ShowMailPreview")
		end)
	end

	local function skinTradePreviewFrame()
		frame = aTML.tradePreview
		self:removeInset(frame.RecipientItemsInset)
		for _, tItem in _G.pairs(frame.targetItemFrames) do
			tItem.SlotTexture:SetTexture(nil)
			tItem.NameFrame:SetTexture(nil)
		end
		self:removeInset(frame.RecipientEnchantInset)
		self:removeInset(frame.PlayerItemsInset)
		for _, pItem in _G.pairs(frame.playerItemFrames) do
			pItem.SlotTexture:SetTexture(nil)
			pItem.NameFrame:SetTexture(nil)
		end
		self:removeInset(frame.PlayerEnchantInset)
		self:removeInset(frame.PlayerInputMoneyInset)
		self:removeInset(frame.RecipientMoneyInset)
		frame.RecipientMoneyBg:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=frame, kfs=true, cb=true})
		if self.modBtnBs then
			for _, btn in _G.pairs(frame.playerButtons) do
				self:addButtonBorder{obj=btn, ibt=true}
			end
			for _, btn in _G.pairs(frame.targetButtons) do
				self:addButtonBorder{obj=btn, ibt=true}
			end
		end

	end
	if aTML.tradePreview then
		self:SecureHook(aTML, "ShowTradePreview", function(_)
			skinTradePreviewFrame()
			self:Unhook(aTML, "ShowTradePreview")
		end)
	end
end
local function TrainAllButton(self)
	local taButton = addon.variables.trainAllButton
	_G.EventUtil.ContinueOnAddOnLoaded("Blizzard_TrainerUI", function()
		_G.RunNextFrame(function()
			if taButton then
				self:skinStdButton{obj=taButton, sechk=true}
			end
		end)
	end)
end
local function Vendor(self)
	local fCMF = _G.EQOLCrafterMultiply
	local function skinCrafterMultiply(panel)
		frame = fCMF or panel
		self:skinObject("editbox", {obj=frame.editBox})
		if self.modBtns then
			self:skinStdButton{obj=frame.ok}
		end
	end
	if fCMF then
		skinCrafterMultiply()
	else
		self:add2Table(self.createFrames, {func = function(fObj)
			_G.RunNextFrame(function()
				skinCrafterMultiply(fObj)
			end)
		end}, "EQOLCrafterMultiply")
	end
end
local function WorldMarkerCycler(self)
	local wmcButton = _G.EQOLWorldMarkerCycler
	if wmcButton then
		self:addButtonBorder{obj=wmcButton, sabt=true}
	end
end
aObj.addonsToSkin.EnhanceQoL = function(self) -- v 10.24.0

	ActionTracker(self)
	Aura(self) -- WIP:
	Bags(self) -- WIP:
	ButtonSink(self)
	ChannelHistory(self)
	CooldownPanels(self)
	DamageMeter(self)
	DataPanels(self)
	EditModeLib(self)
	GemHelper(self)
	Ignore(self)
	InventoryFilterPanel(self)
	ItemInventory(self)
	LootspecFrame(self)
	Mailbox(self)
	MountActions(self)
	MythicPlus(self)
	ReloadFrame(self)
	Reminder(self) -- WIP:
	TradeMailLog(self)
	Vendor(self)

	if self.modBtns then
		TrainAllButton(self)
	end
	if self.modBtnBs then
		InstantCatalyst(self)
		WorldMarkerCycler(self)
	end

	-- add custom Settings entries
	self:add2Table(self.customSettings, {key = "soundDropdown", type = "DropdownWithButtons", template="_SoundDropdownTemplate"})
	self:add2Table(self.customSettings, {key = "Input", type = "EditBox", template="_InputControlTemplate"})

end

-- EQOLUFDebugCopyFrame (according to the code this is a temporary frame)
