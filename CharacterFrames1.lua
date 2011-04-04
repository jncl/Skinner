local aName, aObj = ...
local _G = _G
local ftype = "c"
local obj, objName, tex, texName, btn, btnName, tab, tabSF

function aObj:CharacterFrames()
	if not self.db.profile.CharacterFrames or self.initialized.CharacterFrames then return end
	self.initialized.CharacterFrames = true

	self:add2Table(self.charKeys1, "CharacterFrames")

	-- skin each sub frame
	self:checkAndRun("CharacterFrame")
	for _, v in pairs{"PaperDollFrame", "PetPaperDollFrame", "ReputationFrame", "TokenFrame"} do
		self:checkAndRun(v)
	end

end

function aObj:CharacterFrame()

	CharacterFrameInsetRight:DisableDrawLayer("BACKGROUND")
	CharacterFrameInsetRight:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=CharacterFrame, ft=ftype, kfs=true, ri=true, bgen=2, y1=2, x2=1, y2=-6}

-->>-- Tabs
	for i = 1, CharacterFrame.numTabs do
		tab = _G["CharacterFrameTab"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
	end
	self.tabFrames[CharacterFrame] = true

end

function aObj:PaperDollFrame()

	self:keepFontStrings(PaperDollFrame)
	if not self.isPTR then
		self:skinDropDown{obj=PlayerTitleFrame}
		self:moveObject{obj=PlayerTitleFrameButton, y=1}
		self:skinScrollBar{obj=PlayerTitlePickerScrollFrame}
		self:addSkinFrame{obj=PlayerTitlePickerFrame, kfs=true, ft=ftype}
	end
	self:makeMFRotatable(CharacterModelFrame)
	-- skin slots
	for _, child in ipairs{PaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			if child:IsObjectType("Button") and child:GetName():find("Slot") then
				self:addButtonBorder{obj=child}
			end
		end
	end
	CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	CharacterModelFrame:DisableDrawLayer("BORDER")
	CharacterModelFrame:DisableDrawLayer("OVERLAY")
	CharacterStatsPane:DisableDrawLayer("ARTWORK")
	self:skinSlider{obj=CharacterStatsPaneScrollBar, size=3}
	-- hide ItemFlyout background textures
	local btnFrame = PaperDollFrameItemFlyout.buttonFrame
	self:addSkinFrame{obj=btnFrame, ft=ftype, x1=-3, y1=2, x2=5, y2=-3}
	self:SecureHook("PaperDollFrameItemFlyout_Show", function(...)
		for i = 1, btnFrame["numBGs"] do
			btnFrame["bg" .. i]:SetAlpha(0)
		end
		if self.modBtnBs then
			for i = 1, #PaperDollFrameItemFlyout.buttons do
				btn = PaperDollFrameItemFlyout.buttons[i]
				if not btn.sknrBdr then self:addButtonBorder{obj=btn, ibt=true} end
			end
		end
	end)
	if not self.isPTR then
		self:addButtonBorder{obj=GearManagerToggleButton, x1=1, x2=-1}
	end
	if self.isPTR then
		-- Sidebar Tabs
		PaperDollSidebarTabs.DecorLeft:SetAlpha(0)
		PaperDollSidebarTabs.DecorRight:SetAlpha(0)
		for i = 1, #PAPERDOLL_SIDEBARS do
			tab = _G["PaperDollSidebarTab"..i]
			tab.TabBg:SetAlpha(0)
			tab.Hider:SetAlpha(0)
			-- use a button border to indicate the active tab
			self:addButtonBorder{obj=tab, relTo=tab.Icon}
			tab.sknrBdr:SetBackdropBorderColor(1, 0.6, 0, 1)
		end
		-- hook this to manage the active tab
		self:SecureHook("PaperDollFrame_UpdateSidebarTabs", function()
			for i = 1, #PAPERDOLL_SIDEBARS do
				local tab = _G["PaperDollSidebarTab"..i]
				if (_G[PAPERDOLL_SIDEBARS[i].frame]:IsShown()) then
					tab.sknrBdr:Show()
				else
					tab.sknrBdr:Hide()
				end
			end
		end)
		-- Titles
		self:SecureHookScript(PaperDollTitlesPane, "OnShow", function(this)
			for i = 1, #this.buttons do
				btn = this.buttons[i]
				btn:DisableDrawLayer("BACKGROUND")
			end
			self:Unhook(PaperDollTitlesPane, "OnShow")
		end)
		self:skinSlider{obj=PaperDollTitlesPane.scrollBar, size=3}
		-- Equipment Manager
		self:SecureHookScript(PaperDollEquipmentManagerPane, "OnShow", function(this)
			for i = 1, #this.buttons do
				btn = this.buttons[i]
				btn:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=btn, relTo=btn.icon}
			end
			self:Unhook(PaperDollEquipmentManagerPane, "OnShow")
		end)
		self:skinSlider{obj=PaperDollEquipmentManagerPane.scrollBar, size=3}
	end
	-- GearManagerDialog Popup Frame
	self:skinScrollBar{obj=GearManagerDialogPopupScrollFrame}
	self:skinEditBox{obj=GearManagerDialogPopupEditBox, regs={9}}
	self:addSkinFrame{obj=GearManagerDialogPopup, ft=ftype, kfs=true, x1=4, y1=-2, x2=-1, y2=3}

end

function aObj:PetPaperDollFrame()

-->>-- Pet Frame
	PetPaperDollPetModelBg:SetAlpha(0) -- changed in blizzard code
	PetModelFrameShadowOverlay:Hide()
	self:removeRegions(PetPaperDollFrameExpBar, {1, 2})
	self:glazeStatusBar(PetPaperDollFrameExpBar, 0)
	self:makeMFRotatable(PetModelFrame)
	-- up the Frame level otherwise the tooltip doesn't work
	RaiseFrameLevel(PetPaperDollPetInfo)

-->>-- Tabs
	-- self:skinFFToggleTabs("PetPaperDollFrameTab") -- no longer used ??

end

function aObj:ReputationFrame()

	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ReputationFrame_Update", function()
			for i = 1, NUM_FACTIONS_DISPLAYED do
				self:checkTex(_G["ReputationBar"..i.."ExpandOrCollapseButton"])
			end
		end)
	end

	self:keepFontStrings(ReputationFrame)
	self:skinScrollBar{obj=ReputationListScrollFrame}

	for i = 1, NUM_FACTIONS_DISPLAYED do
		obj = "ReputationBar"..i
		self:skinButton{obj=_G[obj.."ExpandOrCollapseButton"], mp=true} -- treat as just a texture
		_G[obj.."Background"]:SetAlpha(0)
		_G[obj.."ReputationBarLeftTexture"]:SetAlpha(0)
		_G[obj.."ReputationBarRightTexture"]:SetAlpha(0)
		self:glazeStatusBar(_G[obj.."ReputationBar"], 0)
	end

-->>-- Reputation Detail Frame
	self:addSkinFrame{obj=ReputationDetailFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

end

function aObj:TokenFrame() -- a.k.a. Currency Frame

	if self.db.profile.ContainerFrames.skin then
		BACKPACK_TOKENFRAME_HEIGHT = BACKPACK_TOKENFRAME_HEIGHT - 6
		BackpackTokenFrame:DisableDrawLayer("BACKGROUND")
	end

	self:keepFontStrings(TokenFrame)
	self:skinAllButtons{obj=TokenFrame}
	self:skinScrollBar{obj=TokenFrameContainer}

	self:SecureHookScript(TokenFrame, "OnShow", function(this)
		-- remove header textures
		for i = 1, #TokenFrameContainer.buttons do
			self:removeRegions(TokenFrameContainer.buttons[i], {6, 7, 8})
		end
		self:Unhook(TokenFrame, "OnShow")
	end)
-->>-- Popup Frame
	self:addSkinFrame{obj=TokenFramePopup,ft=ftype, kfs=true, y1=-6, x2=-6, y2=6}

end

function aObj:PVPFrame()
	if not self.db.profile.PVPFrame or self.initialized.PVPFrame then return end
	self.initialized.PVPFrame = true

	PVPFrame.topInset:DisableDrawLayer("BACKGROUND")
	PVPFrame.topInset:DisableDrawLayer("BORDER")
	self:glazeStatusBar(PVPFrameConquestBar, 0,	 PVPFrameConquestBarBG)
	PVPFrameConquestBarBorder:Hide()
	self:addSkinFrame{obj=PVPFrame, ft=ftype, kfs=true, ri=true, x1=-2, y1=2, x2=1, y2=-8}
	self:removeMagicBtnTex(PVPFrameLeftButton)
	self:removeMagicBtnTex(PVPFrameRightButton)
-->>-- Honor frame
	self:keepFontStrings(PVPFrame.panel1)
	self:skinScrollBar{obj=PVPFrame.panel1.bgTypeScrollFrame}
	self:skinSlider{obj=PVPHonorFrameInfoScrollFrameScrollBar}
	PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.description:SetTextColor(self.BTr, self.BTg, self.BTb)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.winReward:DisableDrawLayer("BACKGROUND")
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.lossReward:DisableDrawLayer("BACKGROUND")
	self:removeMagicBtnTex(PVPHonorFrameWarGameButton)
-->>-- Conquest frame
	self:keepFontStrings(PVPFrame.panel2)
	PVPFrame.panel2.winReward:DisableDrawLayer("BACKGROUND")
	PVPFrame.panel2.infoButton:DisableDrawLayer("BORDER")
-->>-- Team Management frame
	self:keepFontStrings(PVPFrame.panel3)
	self:keepFontStrings(PVPTeamManagementFrameWeeklyDisplay)
	self:skinUsingBD{obj=PVPTeamManagementFrameWeeklyDisplay}
	PVPFrame.panel3.flag2.NormalHeader:SetTexture(nil)
	PVPFrame.panel3.flag2.GlowHeader:SetTexture(nil)
	PVPFrame.panel3.flag3.NormalHeader:SetTexture(nil)
	PVPFrame.panel3.flag3.GlowHeader:SetTexture(nil)
	PVPFrame.panel3.flag5.NormalHeader:SetTexture(nil)
	PVPFrame.panel3.flag5.GlowHeader:SetTexture(nil)
	self:skinFFColHeads("PVPTeamManagementFrameHeader", 4)
	self:skinScrollBar{obj=PVPFrame.panel3.teamMemberScrollFrame}
	self:skinDropDown{obj=PVPTeamManagementFrameTeamDropDown}
	-- Glow boxes
	self:addSkinFrame{obj=PVPFrame.panel3.noTeams, ft=ftype, kfs=true}
	self:addSkinFrame{obj=PVPFrame.panel3.invalidTeam, ft=ftype, kfs=true}
	self:addSkinFrame{obj=PVPFrame.lowLevelFrame, ft=ftype, kfs=true}

-->>-- Tabs
	for i = 1, PVPFrame.numTabs do
		tab = _G["PVPFrameTab"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
	end
	self.tabFrames[PVPFrame] = true

-->>-- Static Popup Special frame
	self:addSkinFrame{obj=PVPFramePopup, ft=ftype, kfs=true, x1=9, y1=-9, x2=-7, y2=9}

	-- Hook this to suppress the PVP Banner Header from being displayed when new team created
	self:SecureHook("CreateArenaTeam", function(size, name, ...)
		self:Debug("CreateArenaTeam: [%s, %s]", size,name)
		if size == 2 then
			PVPFrame.panel3.flag2.NormalHeader:SetTexture(nil)
			PVPFrame.panel3.flag2.GlowHeader:SetTexture(nil)
		elseif size == 3 then
			PVPFrame.panel3.flag3.NormalHeader:SetTexture(nil)
			PVPFrame.panel3.flag3.GlowHeader:SetTexture(nil)
		elseif size == 5 then
			PVPFrame.panel3.flag5.NormalHeader:SetTexture(nil)
			PVPFrame.panel3.flag5.GlowHeader:SetTexture(nil)
		end
	end)

end

function aObj:PetStableFrame()
	if not self.db.profile.PetStableFrame or self.initialized.PetStableFrame then return end
	self.initialized.PetStableFrame = true

	self:add2Table(self.charKeys1, "PetStableFrame")

	self:makeMFRotatable(PetStableModel)

	PetStableFrameModelBg:Hide()
	PetStableModelShadow:Hide()
	PetStableFrame.LeftInset:DisableDrawLayer("BORDER")
	PetStableActiveBg:Hide()
	self:addButtonBorder{obj=PetStablePetInfo, relTo=PetStableSelectedPetIcon}
	for i = 1, NUM_PET_ACTIVE_SLOTS do
		btn = _G["PetStableActivePet"..i]
		btn.Border:Hide()
		if not self.modBtnBs then
			self:resizeEmptyTexture(btn.Background)
		else
			btn.Background:Hide()
			self:addButtonBorder{obj=btn}
		end
	end
	for i = 1, NUM_PET_STABLE_SLOTS do
		btn = _G["PetStableStabledPet"..i]
		if not self.modBtnBs then
			self:resizeEmptyTexture(btn.Background)
		else
			btn.Background:Hide()
			self:addButtonBorder{obj=btn}
		end
	end
	PetStableFrame.BottomInset:DisableDrawLayer("BORDER")
	PetStableFrameStableBg:Hide()
	self:addSkinFrame{obj=PetStableFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1}

end

function aObj:SpellBookFrame()
	if not self.db.profile.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	self:add2Table(self.charKeys1, "SpellBookFrame")

	SpellBookFrame.numTabs = 5
	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ToggleSpellBook", function(bookType)
			local tab, tabSF
			for i = 1, SpellBookFrame.numTabs do
				tab = _G["SpellBookFrameTabButton"..i]
				tabSF = self.skinFrame[tab]
				if tab.bookType == bookType then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	self:addSkinFrame{obj=SpellBookFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}
-->>- Spellbook Panel
	SpellBookPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- hook this to change text colour as required
	self:SecureHook("SpellButton_UpdateButton", function(this)
		if this.UnlearnedFrame and this.UnlearnedFrame:IsShown() then -- level too low
			this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
			this.RequiredLevelString:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		if this.TrainFrame and this.TrainFrame:IsShown() then -- see Trainer
			this.SpellName:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			this.SpellSubName:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		end
		if this.SpellName then
			this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
			this.SpellSubName:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end)
-->>-- Professions Panel
	local function skinProf(type, times)

		local obj, objName
		for i = 1, times do
			objName = type.."Profession"..i
			obj =_G[objName]
			if type == "Primary" then
				_G[objName.."IconBorder"]:Hide()
				if not obj.missingHeader:IsShown() then
					obj.icon:SetDesaturated(nil) -- show in colour
				end
			else
				obj.missingHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
			end
			obj.missingText:SetTextColor(self.BTr, self.BTg, self.BTb)
			obj.button1:DisableDrawLayer("BACKGROUND")
			obj.button1.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
			self:addButtonBorder{obj=obj.button1, sec=true}
			obj.button2:DisableDrawLayer("BACKGROUND")
			obj.button2.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
			self:addButtonBorder{obj=obj.button2, sec=true}
			_G[objName.."StatusBar"]:DisableDrawLayer("BACKGROUND")
		end

	end
	-- Primary professions
	skinProf("Primary", 2)
	-- Secondary professions
	skinProf("Secondary", 4)
-->>-- Companions/Mounts Panel
	SpellBookCompanionsModelFrame:Hide()
	SpellBookCompanionModelFrameShadowOverlay:Hide()
	self:makeMFRotatable(SpellBookCompanionModelFrame)
	for i = 1, NUM_COMPANIONS_PER_PAGE do
		btn = _G["SpellBookCompanionButton"..i]
		btn.Background:Hide()
		btn.TextBackground:Hide()
		btn.IconTextureBg:Hide()
		self:addButtonBorder{obj=btn, sec=true}
	end
	-- colour the spell name text
	for i = 1, SPELLS_PER_PAGE do
		btnName = "SpellButton"..i
		btn = _G[btnName]
		btn:DisableDrawLayer("BACKGROUND")
		btn:DisableDrawLayer("BORDER")
		_G[btnName.."SlotFrame"]:SetAlpha(0)
		btn.UnlearnedFrame:SetAlpha(0)
		btn.TrainFrame:SetAlpha(0)
		self:addButtonBorder{obj=_G[btnName], sec=true}
	end
-->>-- Tabs (side)
	for i = 1, MAX_SKILLLINE_TABS do
		obj = _G["SpellBookSkillLineTab"..i]
		self:removeRegions(obj, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=obj}
	end
-->>-- Tabs (bottom)
	local x1, y1, x2, y2
	if self.isPTR then
		x1, y1, x2, y2 = 8, 1, -8, 2
	else
		x1, y1, x2, y2 = 6, 1, -6, 2
	end
	for i = 1, SpellBookFrame.numTabs do
		tab = _G["SpellBookFrameTabButton"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 1 is the Text, 3 is the highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=x1, y1=y1, x2=x2, y2=y2}
	end

end

function aObj:GlyphUI() -- LoD
	if not self.db.profile.TalentUI or self.initialized.GlyphUI then return end
	self.initialized.GlyphUI = true

	GlyphFrame:DisableDrawLayer("BACKGROUND")
--[=[
	-- Removing the ring texture also removes the empty slots
	for i = 1, NUM_GLYPH_SLOTS do
		_G["GlyphFrameGlyph"..i].ring:SetAlpha(0)
	end
--]=]
	GlyphFrame.sideInset:DisableDrawLayer("BACKGROUND")
	GlyphFrame.sideInset:DisableDrawLayer("BORDER")
	self:skinEditBox{obj=GlyphFrameSearchBox, regs={9}}
	self:moveObject{obj=GlyphFrameSearchBox.searchIcon, x=3}
	self:skinDropDown{obj=GlyphFrameFilterDropDown}
	-- Headers
	for i = 1, #GLYPH_STRING do
		self:removeRegions(_G["GlyphFrameHeader"..i], {1, 2, 3})
		self:applySkin{obj=_G["GlyphFrameHeader"..i], ft=ftype, nb=true} -- use applySkin so text is seen
	end
	-- remove Glyph item textures
	for i = 1, #GlyphFrame.scrollFrame.buttons do
		btn = GlyphFrame.scrollFrame.buttons[i]
		btn:GetNormalTexture():SetAlpha(0)
		btn.selectedTex:SetAlpha(0)
		btn.disabledBG:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	self:skinSlider{obj=GlyphFrameScrollFrameScrollBar, size=2}
	self:addButtonBorder{obj=GlyphFrameClearInfoFrame}

end

function aObj:TalentUI() -- LoD
	if not self.db.profile.TalentUI or self.initialized.TalentUI then return end
	self.initialized.TalentUI = true

	self:addSkinFrame{obj=PlayerTalentFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}
-->>-- Talents Frame
	for i = 1, 3 do
		objName = "PlayerTalentFramePanel"..i
		obj = _G[objName]
		-- Summary panel(s)
		obj.Summary.IconBorder:SetAlpha(0) -- so linked item is still positioned properly
		local sAB1 = objName.."SummaryActiveBonus1"
		_G[sAB1].IconBorder:Hide()
		self:addButtonBorder{obj=_G[sAB1], relTo=_G[sAB1].Icon}
		local sB
		for j = 1, 5 do
			sB = objName.."SummaryBonus"..j
			_G[sB].IconBorder:Hide()
			self:addButtonBorder{obj=_G[sB], es=12, relTo=_G[sB].Icon}
		end
		self:skinScrollBar{obj=obj.Summary.Description}
		-- talent info panel(s)
		obj:DisableDrawLayer("BORDER")
		obj.HeaderBackground:SetAlpha(0)
		obj.HeaderBorder:SetAlpha(0)
		obj.HeaderIcon:DisableDrawLayer("ARTWORK")
		obj.HeaderIcon.PointsSpentBgGold:SetAlpha(0)
		obj.HeaderIcon.PointsSpentBgSilver:SetAlpha(0)
		if self.modBtnBs then
			self:addButtonBorder{obj=obj.HeaderIcon, relTo=obj.HeaderIcon.Icon, reParent={obj.HeaderIcon.PointsSpent, obj.HeaderIcon.LockIcon}}
			-- add button borders
			for i = 1, MAX_NUM_TALENTS do
				self:addButtonBorder{obj=_G[objName.."Talent"..i], tibt=true}
			end
			RaiseFrameLevel(_G[objName.."Arrow"]) -- so arrows appear above border
			RaiseFrameLevel(obj.InactiveShadow) -- so arrows appear below the InactiveShadow
			RaiseFrameLevel(obj.Summary) -- so summary panel appears above the InactiveShadow
			RaiseFrameLevel(obj.SelectTreeButton) -- so button can be clicked
		end
	end
	self:removeMagicBtnTex(PlayerTalentFrameResetButton)
	self:removeMagicBtnTex(PlayerTalentFrameLearnButton)
	self:removeMagicBtnTex(PlayerTalentFrameToggleSummariesButton)
-->>-- Pet Talents Panel
	PlayerTalentFramePetPanel:DisableDrawLayer("BORDER")
	PlayerTalentFramePetModelBg:Hide()
	PlayerTalentFramePetShadowOverlay:Hide()
	self:makeMFRotatable(PlayerTalentFramePetModel)
	PlayerTalentFramePetIconBorder:Hide()
	PlayerTalentFramePetPanel.HeaderBackground:Hide()
	PlayerTalentFramePetPanel.HeaderBorder:Hide()
	PlayerTalentFramePetPanel.HeaderIcon.Border:Hide()
	PlayerTalentFramePetPanel.HeaderIcon.PointsSpentBgGold:Hide()
	self:moveObject{obj=PlayerTalentFramePetPanel.HeaderIcon.PointsSpent, x=8}
	if self.modBtnBs then
		self:addButtonBorder{obj=PlayerTalentFramePetInfo, relTo=PlayerTalentFramePetIcon}
		self:addButtonBorder{obj=PlayerTalentFramePetPanel.HeaderIcon}
		for i = 1, 24 do
			btnName = "PlayerTalentFramePetPanelTalent"..i
			btn = _G[btnName]
			self:addButtonBorder{obj=btn, tibt=true}
		end
	end
-->>-- Glyph Panel
-- see GlyphUI above
-->>-- Glow boxes
	self:addSkinFrame{obj=PlayerTalentFrameHeaderHelpBox, ft=ftype, kfs=true}
	self:addSkinFrame{obj=PlayerTalentFrameLearnButtonTutorial, ft=ftype, kfs=true, y1=3, x2=3}

-->>-- Tabs (side)
	for i = 1, 2 do
		obj = _G["PlayerSpecTab"..i]
		self:removeRegions(obj, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=obj}
	end
-->>-- Tabs (bottom)
	for i = 1, PlayerTalentFrame.numTabs do
		tab = _G["PlayerTalentFrameTab"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		-- set textures here first time thru as it's LoD
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[PlayerTalentFrame] = true

end

function aObj:DressUpFrame()
	if not self.db.profile.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	self:add2Table(self.charKeys1, "DressUpFrame")

	self:removeRegions(DressUpFrame, {1, 2, 3, 4, 5}) -- N.B. regions 6 & 7 are text, 8-11 are the background picture
	self:makeMFRotatable(DressUpModel)
	self:addSkinFrame{obj=DressUpFrame, ft=ftype, x1=10, y1=-12, x2=-33, y2=73}

end

function aObj:AchievementUI() -- LoD
	if not self.db.profile.AchievementUI.skin or self.initialized.AchievementUI then return end
	self.initialized.AchievementUI = true

	local prdbA = self.db.profile.AchievementUI

	if prdbA.style == 2 then
		ACHIEVEMENTUI_REDBORDER_R = self.bbColour[1]
		ACHIEVEMENTUI_REDBORDER_G = self.bbColour[2]
		ACHIEVEMENTUI_REDBORDER_B = self.bbColour[3]
		ACHIEVEMENTUI_REDBORDER_A = self.bbColour[4]
	end

	local function skinSB(statusBar, type)

		aObj:moveObject{obj=_G[statusBar..type], y=-3}
		aObj:moveObject{obj=_G[statusBar.."Text"], y=-3}
		_G[statusBar.."Left"]:SetAlpha(0)
		_G[statusBar.."Right"]:SetAlpha(0)
		_G[statusBar.."Middle"]:SetAlpha(0)
		self:glazeStatusBar(_G[statusBar], 0, _G[statusBar.."FillBar"])

	end
	local function skinStats()

		local btn
		for i = 1, #AchievementFrameStatsContainer.buttons do
			btn = _G["AchievementFrameStatsContainerButton"..i]
			btn.background:SetTexture(nil)
			btn.left:SetAlpha(0)
			btn.middle:SetAlpha(0)
			btn.right:SetAlpha(0)
		end

	end
	local function glazeProgressBar(pBar)

		if not aObj.sbGlazed[pBaro] then
			_G[pBar.."BorderLeft"]:SetAlpha(0)
			_G[pBar.."BorderRight"]:SetAlpha(0)
			_G[pBar.."BorderCenter"]:SetAlpha(0)
			aObj:glazeStatusBar(_G[pBar], 0, _G[pBar.."BG"])
		end

	end
	local function skinCategories()

		for i = 1, #AchievementFrameCategoriesContainer.buttons do
			_G["AchievementFrameCategoriesContainerButton"..i.."Background"]:SetAlpha(0)
		end

	end
	local function skinComparisonStats()

		local btnName
		for i = 1, #AchievementFrameComparisonStatsContainer.buttons do
			btnName = "AchievementFrameComparisonStatsContainerButton"..i
			if _G[btnName].isHeader then _G[btnName.."BG"]:SetAlpha(0) end
			_G[btnName.."HeaderLeft"]:SetAlpha(0)
			_G[btnName.."HeaderLeft2"]:SetAlpha(0)
			_G[btnName.."HeaderMiddle"]:SetAlpha(0)
			_G[btnName.."HeaderMiddle2"]:SetAlpha(0)
			_G[btnName.."HeaderRight"]:SetAlpha(0)
			_G[btnName.."HeaderRight2"]:SetAlpha(0)
		end

	end
	local function cleanButtons(frame, type)

		if prdbA.style == 1 then return end -- don't remove textures if option not chosen

		local btn, btnName
		-- remove textures etc from buttons
		for i = 1, #frame.buttons do
			btnName = frame.buttons[i]:GetName()..(type == "Comparison" and "Player" or "")
			btn = _G[btnName]
			btn:DisableDrawLayer("BACKGROUND")
			-- don't DisableDrawLayer("BORDER") as the button border won't show if skinned
			btn:DisableDrawLayer("ARTWORK")
			if btn.plusMinus then btn.plusMinus:SetAlpha(0) end
			btn.icon:DisableDrawLayer("BACKGROUND")
			btn.icon:DisableDrawLayer("BORDER")
			btn.icon:DisableDrawLayer("OVERLAY")
			self:addButtonBorder{obj=btn.icon, x1=4, y1=-1, x2=-4, y2=6}
			-- hook this to handle description text colour changes
			self:SecureHook(btn, "Saturate", function(this)
				this.description:SetTextColor(self.BTr, self.BTg, self.BTb)
			end)
			if type == "Achievements" then
				-- set textures to nil and prevent them from being changed as guildview changes the textures
				_G[btnName.."TopTsunami1"]:SetTexture(nil)
				_G[btnName.."TopTsunami1"].SetTexture = function() end
				_G[btnName.."BottomTsunami1"]:SetTexture(nil)
				_G[btnName.."BottomTsunami1"].SetTexture = function() end
				btn.hiddenDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
			elseif type == "Summary" then
				if not btn.tooltipTitle then btn:Saturate() end
			elseif type == "Comparison" then
				-- force update to colour the button
				if btn.completed then btn:Saturate() end
				-- Friend
				btn = _G[btnName:gsub("Player", "Friend")]
				btn:DisableDrawLayer("BACKGROUND")
				-- don't DisableDrawLayer("BORDER") as the button border won't show if skinned
				btn:DisableDrawLayer("ARTWORK")
				btn.icon:DisableDrawLayer("BACKGROUND")
				btn.icon:DisableDrawLayer("BORDER")
				btn.icon:DisableDrawLayer("OVERLAY")
				self:addButtonBorder{obj=btn.icon, x1=4, y1=-1, x2=-4, y2=6}
				-- force update to colour the button
				if btn.completed then btn:Saturate() end
			end
		end

	end

	self:moveObject{obj=AchievementFrameFilterDropDown, y=-10}
	if self.db.profile.TexturedDD then
		tex = AchievementFrameFilterDropDown:CreateTexture(nil, "BORDER")
		tex:SetTexture(self.itTex)
		tex:SetWidth(110)
		tex:SetHeight(19)
		tex:SetPoint("RIGHT", AchievementFrameFilterDropDown, "RIGHT", -3, 4)
	end
	self:addSkinFrame{obj=AchievementFrame, ft=ftype, kfs=true, y1=1, y2=-3}

-->>-- move Header info
	self:keepFontStrings(AchievementFrameHeader)
	self:moveObject{obj=AchievementFrameHeaderTitle, x=-60, y=-29}
	self:moveObject{obj=AchievementFrameHeaderPoints, x=40, y=-9}
	AchievementFrameHeaderShield:SetAlpha(1)

-->>-- Categories Panel (on the Left)
	self:skinSlider(AchievementFrameCategoriesContainerScrollBar)
	self:addSkinFrame{obj=AchievementFrameCategories, ft=ftype, y2=-2}
	self:SecureHook("AchievementFrameCategories_Update", function()
		skinCategories()
	end)
	skinCategories()

	local bbR, bbG, bbB, bbA = unpack(self.bbColour)

-->>-- Achievements Panel (on the right)
	self:keepFontStrings(AchievementFrameAchievements)
	self:getChild(AchievementFrameAchievements, 2):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	self:skinSlider(AchievementFrameAchievementsContainerScrollBar)
	if prdbA.style == 2 then
		-- remove textures etc from buttons
		cleanButtons(AchievementFrameAchievementsContainer, "Achievements")
		-- hook this to handle objectives text colour changes
		self:SecureHookScript(AchievementFrameAchievementsObjectives, "OnShow", function(this)
			if this.completed then
				for _, child in ipairs{this:GetChildren()} do
					for _, reg in ipairs{child:GetRegions()} do
						if reg:IsObjectType("FontString") then
							reg:SetTextColor(self.BTr, self.BTg, self.BTb)
						end
					end
				end
			end
		end)
		-- hook this to remove icon border used by the Objectives mini panels
		self:RawHook("AchievementButton_GetMeta", function(...)
			local obj = self.hooks.AchievementButton_GetMeta(...)
			obj:DisableDrawLayer("BORDER")
			self:addButtonBorder{obj=obj, es=12, relTo=obj.icon}
			return obj
		end, true)
	end
	-- glaze any existing progress bars
	for i = 1, 10 do
		objName = "AchievementFrameProgressBar"..i
		if _G[objName] then glazeProgressBar(objName) end
	end
	-- hook this to skin StatusBars used by the Objectives mini panels
	self:RawHook("AchievementButton_GetProgressBar", function(...)
		local obj = self.hooks.AchievementButton_GetProgressBar(...)
		glazeProgressBar(obj:GetName())
		return obj
	end, true)

-->>-- Stats
	self:keepFontStrings(AchievementFrameStats)
	self:skinSlider(AchievementFrameStatsContainerScrollBar)
	AchievementFrameStatsBG:SetAlpha(0)
	self:getChild(AchievementFrameStats, 3):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	-- hook this to skin buttons
	self:SecureHook("AchievementFrameStats_Update", function()
		skinStats()
	end)
	skinStats()

-->>-- Summary Panel
	self:keepFontStrings(AchievementFrameSummary)
	AchievementFrameSummaryBackground:SetAlpha(0)
	AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0)
	self:skinSlider(AchievementFrameAchievementsContainerScrollBar)
	-- remove textures etc from buttons
	if not AchievementFrameSummary:IsShown() and prdbA.style == 2 then
		self:SecureHookScript(AchievementFrameSummary, "OnShow", function()
			cleanButtons(AchievementFrameSummaryAchievements, "Summary")
			self:Unhook(AchievementFrameSummary, "OnShow")
		end)
	else
		cleanButtons(AchievementFrameSummaryAchievements, "Summary")
	end
	-- Categories SubPanel
	self:keepFontStrings(AchievementFrameSummaryCategoriesHeader)
	for i = 1, 8 do
		skinSB("AchievementFrameSummaryCategoriesCategory"..i, "Label")
	end
	self:getChild(AchievementFrameSummary, 1):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	skinSB("AchievementFrameSummaryCategoriesStatusBar", "Title")

-->>-- Comparison Panel
	AchievementFrameComparisonBackground:SetAlpha(0)
	AchievementFrameComparisonDark:SetAlpha(0)
	AchievementFrameComparisonWatermark:SetAlpha(0)
	-- Header
	self:keepFontStrings(AchievementFrameComparisonHeader)
	AchievementFrameComparisonHeaderShield:SetAlpha(1)
	-- move header info
	AchievementFrameComparisonHeaderShield:ClearAllPoints()
	AchievementFrameComparisonHeaderShield:SetPoint("RIGHT", AchievementFrameCloseButton, "LEFT", -10, -1)
	AchievementFrameComparisonHeaderPoints:ClearAllPoints()
	AchievementFrameComparisonHeaderPoints:SetPoint("RIGHT", AchievementFrameComparisonHeaderShield, "LEFT", -10, 1)
	AchievementFrameComparisonHeaderName:ClearAllPoints()
	AchievementFrameComparisonHeaderName:SetPoint("RIGHT", AchievementFrameComparisonHeaderPoints, "LEFT", -10, 0)
	-- Container
	self:skinSlider(AchievementFrameComparisonContainerScrollBar)
	-- Summary Panel
	self:getChild(AchievementFrameComparison, 5):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	for _, type in pairs{"Player", "Friend"} do
		_G["AchievementFrameComparisonSummary"..type]:SetBackdrop(nil)
		_G["AchievementFrameComparisonSummary"..type.."Background"]:SetAlpha(0)
		skinSB("AchievementFrameComparisonSummary"..type.."StatusBar", "Title")
	end
	-- remove textures etc from buttons
	if not AchievementFrameComparison:IsShown() and prdbA.style == 2 then
		self:SecureHookScript(AchievementFrameComparison, "OnShow", function()
			cleanButtons(AchievementFrameComparisonContainer, "Comparison")
			self:Unhook(AchievementFrameSummary, "OnShow")
		end)
	else
		cleanButtons(AchievementFrameComparisonContainer, "Comparison")
	end
	-- Stats Panel
	self:skinSlider(AchievementFrameComparisonStatsContainerScrollBar)
	self:SecureHook("AchievementFrameComparison_UpdateStats", function()
		skinComparisonStats()
	end)
	self:SecureHook(AchievementFrameComparisonStatsContainer, "Show", function()
		skinComparisonStats()
	end)
	if achievementFunctions == COMPARISON_STAT_FUNCTIONS then skinComparisonStats() end

-->>-- Tabs
	for i = 1, AchievementFrame.numTabs do
		tab = _G["AchievementFrameTab"..i]
		self:keepRegions(tab, {7, 8, 9, 10}) -- N.B. region 10 is text, 7-9 are highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=9, y1=2, x2=-9, y2=-10}
		tabSF.ignore = true -- ignore size changes
		-- set textures here first time thru as it's LoD
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[AchievementFrame] = true

end

function aObj:AlertFrames()
	if not self.db.profile.AlertFrames or self.initialized.AlertFrames then return end
	self.initialized.AlertFrames = true

	self:add2Table(self.charKeys1, "AlertFrames")

	local aafName = "AchievementAlertFrame"

	local function skinAlertFrames()

		local obj, icon
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			obj = _G[aafName..i]
			if obj and not aObj.skinFrame[obj] then
				_G[aafName..i.."Background"]:SetTexture(nil)
				_G[aafName..i.."Background"].SetTexture = function() end
				_G[aafName..i.."Unlocked"]:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
				icon = _G[aafName..i.."Icon"]
				icon:DisableDrawLayer("BORDER")
				icon:DisableDrawLayer("OVERLAY")
				aObj:addButtonBorder{obj=icon, relTo=_G[aafName..i.."IconTexture"]}
				aObj:addSkinFrame{obj=obj, ft=ftype, anim=true, x1=5, y1=-10, x2=-5, y2=12}
			end
		end

	end
	-- check for both Achievement Alert frames now, (3.1.2) as the Bliz code changed
	if not AchievementAlertFrame1 or AchievementAlertFrame2 then
		self:RawHook("AchievementAlertFrame_GetAlertFrame", function(...)
			local frame = self.hooks.AchievementAlertFrame_GetAlertFrame(...)
			skinAlertFrames()
			if AchievementAlertFrame2 then
				self:Unhook("AchievementAlertFrame_GetAlertFrame")
			end
			return frame
		end, true)
	end
	-- skin any existing Achievement Alert Frames
	skinAlertFrames()

	-- adjust frame size for guild achievements
	self:SecureHook("AchievementAlertFrame_ShowAlert", function(...)
		local obj, y1, y2
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			obj = _G[aafName..i]
			if obj then
				y1, y2 = -10, 12
	 				if obj.guildDisplay then
					y1, y2 = -8, 8
				end
				self.skinFrame[obj]:SetPoint("TOPLEFT", obj, "TOPLEFT", 5, y1)
				self.skinFrame[obj]:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", 5, y2)
			end
		end
	end)

	-- hook dungeon rewards function
	self:SecureHook("DungeonCompletionAlertFrameReward_SetReward", function(frame, ...)
		frame:DisableDrawLayer("OVERLAY") -- border texture
	end)

	-- dungeon completion alert frame will already exist, only 1 atm (0.3.0.10772)
	DungeonCompletionAlertFrame1:DisableDrawLayer("BORDER") -- border textures
	_G["DungeonCompletionAlertFrame1Reward1"]:DisableDrawLayer("OVERLAY") -- border texture
	self:addSkinFrame{obj=DungeonCompletionAlertFrame1, ft=ftype, anim=true, x1=5, y1=-13, x2=-5, y2=4}

end
