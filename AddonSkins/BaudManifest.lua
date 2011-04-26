local aName, aObj = ...
if not aObj:isAddonEnabled("BaudManifest") then return end

function aObj:BaudManifest()

	local function skinDisplay(dispNo)

		aObj:skinDropDown(_G["BaudManifestDisplay"..dispNo].SortDrop)
		aObj:skinDropDown(_G["BaudManifestDisplay"..dispNo].FilterDrop)
		aObj:skinEditBox(_G["BaudManifestDisplay"..dispNo].FilterEdit, {9})
		self:skinScrollBar{obj=_G["BaudManifestDisplay"..dispNo].ScrollBar}
		aObj:addSkinFrame{obj=_G["BaudManifestDisplay"..dispNo], kfs=true}

	end

-->>--	Bags
	skinDisplay(1)
	self:addSkinFrame{obj=BaudManifestDisplay1BagsFrame}
-->>-- Properties
	self:skinEditBox{obj=BaudManifestPropertiesEditBox1, regs={9}}
	self:skinEditBox{obj=BaudManifestPropertiesEditBox2, regs={9}}
	self:addSkinFrame{obj=BaudManifestPropertiesRestock}
	BaudManifestPropertiesRestock.SetBackdropBorderColor = function() end
	self:addSkinFrame{obj=BaudManifestProperties, hdr=true}
	self:addButtonBorder{obj=BaudManifestProperties, relTo=BaudManifestPropertiesIcon}
-->>--	Bank
	skinDisplay(2)
	self:addSkinFrame{obj=BaudManifestDisplay2BagsFrame}
-->>--	Characters
	skinDisplay(3)
	skinDisplay(4)
	self:addSkinFrame{obj=BaudManifestCharactersScrollBox}
	self:addSkinFrame{obj=BaudManifestCharacters, hdr=true}
-->>-- Tooltip Icon
	self:addButtonBorder{obj=BaudManifestTooltipIcon}

	-- stop the background texture being changed
	BaudManifestUpdateBGTexture = function() end

end
