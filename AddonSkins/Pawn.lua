local aName, aObj = ...
if not aObj:isAddonEnabled("Pawn") then return end
local _G = _G

function aObj:Pawn()

	local aVer = GetAddOnMetadata("Pawn", "Version")

	-- don't skin IOF Pawn button
	self.ignoreIOF[_G.PawnInterfaceOptionsFrame] = true
	-- remove button textures from behind buttons
	_G.PawnUI_InventoryPawnButton:DisableDrawLayer("BACKGROUND")
	_G.PawnInterfaceOptionsFrame_PawnButton:DisableDrawLayer("BACKGROUND")

	-- skin the UI
	self:addSkinFrame{obj=_G.PawnUIFrame}

-->>-- Scale Selector Frame
	self:keepFontStrings(_G.PawnUIScaleSelector)
	self:skinScrollBar{obj=_G.PawnUIScaleSelectorScrollFrame}
-->>-- Scales Tab
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.PawnUIFrame_ScaleColorSwatch, ofs=-4}
	end
-->>-- Values Tab
	self:skinEditBox{obj=_G.PawnUIFrame_StatValueBox, regs={9}}
	self:addSkinFrame{obj=self:getChild(_G.PawnUIValuesTabPage, 1)}
	self:skinScrollBar{obj=_G.PawnUIFrame_StatsList}
-->>-- Compare Tab
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.PawnUICompareItemIcon1}
		self:addButtonBorder{obj=_G.PawnUICompareItemIcon2}
		self:addButtonBorder{obj=_G.PawnUIFrame_ClearItemsButton}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut1}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut2}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut3}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut4}
	end
	self:skinScrollBar{obj=_G.PawnUICompareScrollFrame}
-->>-- Gems Tab
	self:keepFontStrings(_G.PawnUIGemsTabPage)
	self:skinEditBox{obj=_G.PawnUIFrame_GemQualityLevelBox, regs={9}}
	self:skinScrollBar{obj=_G.PawnUIGemScrollFrame}

-->>-- Dialog Frame
	self:skinEditBox(_G.PawnUIStringDialog_TextBox, {9})
	self:addSkinFrame{obj=_G.PawnUIStringDialog}

-->>-- Tabs
	self:skinTabs{obj=_G.PawnUIFrame, lod=true, x1=6, y1=0, x2=-6, y2=2}

-->>-- Tooltips
	_G.PawnCommon.ColorTooltipBorder = false -- disable tooltip border color change
	if self.db.profile.Tooltips.skin then
		self:SecureHook("PawnUI_OnSocketUpdate", function()
			if _G.PawnSocketingTooltip then
				self:add2Table(self.ttList, "PawnSocketingTooltip")
				self:Unhook("PawnUI_OnSocketUpdate")
			end
		end)
	end

end
