if not Skinner:isAddonEnabled("AtlasLoot") then return end

function Skinner:AtlasLoot()

-->>--	Items Frame
	self:keepFontStrings(AtlasLootInfo)
	self:moveObject(AtlasLootInfo_Text1, nil, nil, "+", 10)
	self:moveObject(AtlasLootInfoHidePanel, nil, nil, "+", 10)
	self:keepFontStrings(AtlasLootItemsFrame)
	self:applySkin(AtlasLootItemsFrame)
-->>--	Panel
	self:keepFontStrings(AtlasLootPanel)
	self:moveObject(AtlasLootPanel_Title, nil, nil, "-", 6)
	self:skinEditBox(AtlasLootSearchBox, {9})
	self:applySkin(AtlasLootPanel)
-->>--	Default Frame
	-- Hook this to move the title
	self:SecureHook("AtlasLootDefaultFrame_OnShow", function()
		self:moveObject(self:getRegion(AtlasLootDefaultFrame, 2), nil, nil, "-", 6)
		self:Unhook("AtlasLootDefaultFrame_OnShow")
	end)
	self:keepFontStrings(AtlasLootDefaultFrame)
	self:moveObject(self:getRegion(AtlasLootDefaultFrame, 2), nil, nil, "-", 6)
	self:moveObject(AtlasLootDefaultFrame_CloseButton, "+", 10, "+", 10)
	self:keepFontStrings(AtlasLootDefaultFrame_LootBackground)
	self:skinEditBox(AtlasLootDefaultFrameSearchBox, {9})
	self:applySkin(AtlasLootDefaultFrame)
-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AtlasLootTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(AtlasLootTooltip, "OnShow", function(this)
			self:skinTooltip(AtlasLootTooltip)
		end)
	end

end
