if not Skinner:isAddonEnabled("AtlasLoot") then return end

function Skinner:AtlasLoot()

-->>--	Default Frame
	AtlasLootDefaultFrame_LootBackground:SetBackdrop(nil)
	self:keepFontStrings(AtlasLootDefaultFrame_LootBackground)
	self:skinEditBox{obj=AtlasLootDefaultFrameSearchBox, regs={9}}
	self:addSkinFrame{obj=AtlasLootDefaultFrame, kfs=true, y1=3}
	-- prevent style being changed
	AtlasLoot_SetNewStyle = function() end
	-- disable button textures
	AtlasLootDefaultFrameWishListButton:DisableDrawLayer("BACKGROUND")
	AtlasLootDefaultFrameSearchButton:DisableDrawLayer("BACKGROUND")
	AtlasLootDefaultFrameSearchClearButton:DisableDrawLayer("BACKGROUND")
	AtlasLootDefaultFrameLastResultButton:DisableDrawLayer("BACKGROUND")

-->>--	Items Frame
	AtlasLootItemsFrame_PREV:DisableDrawLayer("BACKGROUND")
	AtlasLootItemsFrame_NEXT:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=AtlasLootItemsFrame, kfs=true}

-->>--	Loot Panel
	self:skinEditBox(AtlasLootSearchBox, {9})
	self:addSkinFrame{obj=AtlasLootPanel, kfs=true}

-->>-- Filter Options panel
	if self.modBtns then
		-- fix for buttons on filter page
		for _, child in pairs{AtlasLootFilterOptionsScrollInhalt:GetChildren()} do
--			self:Debug("ALFOSI: [%s, %s]", child, self:isButton(child))
			if self:isButton(child) then
				self:skinButton{obj=child, as=true}
			end
		end
	end
	AtlasLootFilterOptionsScrollFrame:SetBackdrop(nil)
	self:addSkinFrame{obj=AtlasLootFilterOptionsScrollFrame:GetParent(), kfs=true, nb=true}
	self:skinScrollBar{obj=AtlasLootFilterOptionsScrollFrame}
-->>-- Wishlist Options panel
	AtlasLootWishlistOwnOptionsScrollFrame:SetBackdrop(nil)
	self:skinScrollBar{obj=AtlasLootWishlistOwnOptionsScrollFrame}
-->>-- Help Options panel
	self:SecureHook("AtlasLoot_DisplayHelp", function()
		AtlasLootHelpFrame_HelpTextFrameScroll:SetBackdrop(nil)
		self:skinScrollBar{obj=AtlasLootHelpFrame_HelpTextFrameScroll}
		self:Unhook("AtlasLoot_DisplayHelp")
	end)

-->>-- WishList Add frame
	self:addSkinFrame{obj=AtlasLootWishList_AddFrame, kfs=true}
	self:skinEditBox{obj=AtlasLootWishListNewName, regs={9}}
	self:skinScrollBar{obj=AtlasLootWishlistAddFrameIconList}

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AtlasLootTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(AtlasLootTooltip, "OnShow", function(this)
			self:skinTooltip(AtlasLootTooltip)
		end)
	end

end
