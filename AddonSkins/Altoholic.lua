if not Skinner:isAddonEnabled("Altoholic") then return end

function Skinner:Altoholic()

-->>-- Main Frame
	self:skinEditBox{obj=AltoholicFrame_SearchEditBox, regs={9}}
	self:addSkinFrame{obj=AltoholicFrame, kfs=true, y1=-11, y2=3}
	-- Tabs
	for i = 1, AltoholicFrame.numTabs do
		local tabObj = _G["AltoholicFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[AltoholicFrame] = true

-->>-- Message Box
	self:addSkinFrame{obj=AltoMsgBox, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

-->>--	Other Frames
	-- skin minus/plus buttons
	for i = 1, 14 do
		self:skinButton{obj=_G["AltoholicFrameSummaryEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameActivityEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameBagUsageEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameGuildBankTabsEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameGuildBankTabsEntry"..i.."UpdateTab"]}
		self:skinButton{obj=_G["AltoholicFrameGuildMembersEntry"..i.."Collapse"], mp2=true}
		self:skinButton{obj=_G["AltoholicFrameSkillsEntry"..i.."Collapse"], mp2=true}
	end

	local obj
-->>-- Summary tab
	for i = 1, 7 do -- menu items
		obj = _G["AltoholicTabSummaryMenuItem"..i]
		self:keepRegions(obj, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	for i = 1, 8 do -- sort headers
		obj = _G["AltoholicTabSummary_Sort"..i]
		if i == 1 then self:moveObject(obj, nil, nil, "+", 6) end
		self:adjHeight{obj=obj, adj=3}
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		self:applySkin(obj)
	end
	self:skinButton{obj=AltoholicTabSummaryToggleView, mp2=true, plus=true}
	self:skinDropDown{obj=AltoholicTabSummary_SelectLocation}
-->>-- Characters tab, now a separate addon (r92)
-->>-- Search Tab, now a separate addon (r92)
-->>-- GuildBank tab
	self:skinDropDown{obj=AltoholicTabGuildBank_SelectGuild}
	for i = 1, 6 do
		obj = _G["AltoholicTabGuildBankMenuItem"..i]
		self:keepRegions(obj , {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
-->>-- Achievements tab, now a separate addon (r83)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AltoTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(AltoTooltip, "OnShow", function(this)
			self:skinTooltip(AltoTooltip)
		end)
	end

-->>-- Account Sharing option menu panel (buttons and panels)
	-- make sure icons are visible by changing their draw layer
	AltoholicAccountSharingOptionsIconNever:SetDrawLayer("OVERLAY")
	AltoholicAccountSharingOptionsIconAsk:SetDrawLayer("OVERLAY")
	AltoholicAccountSharingOptionsIconAuto:SetDrawLayer("OVERLAY")
	self:skinScrollBar{obj=AltoholicFrameSharingClientsScrollFrame}
	self:addSkinFrame{obj=AltoholicFrameSharingClients}
	self:skinScrollBar{obj=AltoholicFrameSharedContentScrollFrame}
-->>-- SharedContent option menu panel
	self:skinButton{obj=AltoholicSharedContent_ToggleAll, mp2=true}
	self:addSkinFrame{obj=AltoholicFrameSharedContent}
	for i = 1, 10 do
		self:skinButton{obj=_G["AltoholicFrameSharedContentEntry"..i.."Collapse"], mp2=true}
	end

-->>-- Account Sharing frame
	self:skinEditBox{obj=AltoAccountSharing_AccNameEditBox, regs={9}}
	self:skinButton{obj=AltoAccountSharing_ToggleAll, mp2=true}
	self:skinEditBox{obj=AltoAccountSharing_AccTargetEditBox, regs={9}}
	self:skinScrollBar{obj=AltoholicFrameAvailableContentScrollFrame}
	for i = 1, 10 do
		self:skinButton{obj=_G["AltoholicFrameAvailableContentEntry"..i.."Collapse"], mp2=true}
	end
	self:addSkinFrame{obj=AltoholicFrameAvailableContent}
	self:addSkinFrame{obj=AltoAccountSharing}

end

function Skinner:Altoholic_Characters()

-->>-- Characters tab
	self:skinDropDown{obj=AltoholicTabCharacters_SelectRealm}
	self:skinDropDown{obj=AltoholicTabCharacters_SelectChar}
	for i = 1, 4 do -- sort headers
		obj = _G["AltoholicTabCharacters_Sort"..i]
		if i == 1 then self:moveObject(obj, nil, nil, "+", 6) end
		self:adjHeight{obj=obj, adj=3}
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		self:applySkin(obj)
	end
	-- Bags View
	self:skinDropDown{obj=AltoholicFrameContainers_SelectContainerView}
	self:skinDropDown{obj=AltoholicFrameContainers_SelectRarity}
	self:skinScrollBar{obj=AltoholicFrameContainersScrollFrame}
	-- Equipment View
	self:skinScrollBar{obj=AltoholicFrameEquipmentScrollFrame}
	-- Quests View
	self:skinScrollBar{obj=AltoholicFrameQuestsScrollFrame}
	-- Talents View
	self:skinScrollBar{obj=AltoholicFrameTalents_ScrollFrame}
	-- Auctions/Bids View
	self:skinDropDown{obj=AltoholicFrameAuctionsRightClickMenu}
	self:skinScrollBar{obj=AltoholicFrameAuctionsScrollFrame}
	-- Mails View
	self:skinScrollBar{obj=AltoholicFrameMailScrollFrame}
	-- Pets/Mounts View
	self:skinDropDown{obj=AltoholicFramePets_SelectPetView}
	self:makeMFRotatable(AltoholicFramePetsNormal_ModelFrame)
	self:skinScrollBar{obj=AltoholicFramePetsAllInOneScrollFrame}
	-- Factions View
	self:skinDropDown{obj=AltoholicFrameReputations_SelectFaction}
	self:skinScrollBar{obj=AltoholicFrameReputationsScrollFrame}
	-- Tokens View
	self:skinDropDown{obj=AltoholicFrameCurrencies_SelectCurrencies}
	self:skinScrollBar{obj=AltoholicFrameCurrenciesScrollFrame}
	-- Cooking/FirstAid/Prof1/Prof2 View
	self:skinButton{obj=AltoholicFrameRecipesInfo_ToggleAll, mp2=true}
	self:skinDropDown{obj=AltoholicFrameRecipesInfo_SelectColor}
	self:skinDropDown{obj=AltoholicFrameRecipesInfo_SelectSubclass}
	self:skinDropDown{obj=AltoholicFrameRecipesInfo_SelectInvSlot}
	self:skinScrollBar{obj=AltoholicFrameRecipesScrollFrame}
	
end

function Skinner:Altoholic_Search()

	self:skinScrollBar{obj=AltoholicSearchMenuScrollFrame}
	self:skinEditBox{obj=AltoholicTabSearch_MinLevel, regs={9}}
	self:skinEditBox{obj=AltoholicTabSearch_MaxLevel, regs={9}}
	self:skinDropDown{obj=AltoholicTabSearch_SelectRarity}
	self:skinDropDown{obj=AltoholicTabSearch_SelectSlot}
	self:skinDropDown{obj=AltoholicTabSearch_SelectLocation}
	for i = 1, 15 do
		obj = _G["AltoholicTabSearchMenuItem"..i]
		self:keepRegions(obj, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	for i = 1, 8 do
		obj = _G["AltoholicTabSearch_Sort"..i]
		if i == 1 then self:moveObject(obj, nil, nil, "+", 4) end
		self:adjHeight{obj=obj, adj=2}
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		self:applySkin(obj)
	end
	self:skinScrollBar{obj=AltoholicFrameSearchScrollFrame}

end


function Skinner:Altoholic_Achievements()

	self:skinScrollBar{obj=AltoholicAchievementsMenuScrollFrame}
	for i = 1, 15 do
		obj = _G["AltoholicTabAchievementsMenuItem"..i]
		self:keepRegions(obj , {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	self:skinScrollBar{obj=AltoholicFrameAchievementsScrollFrame}

end
