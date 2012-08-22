local aName, aObj = ...
if not aObj:isAddonEnabled("Vendomatic") then return end

function aObj:Vendomatic()

	-- header frame
	self:addSkinFrame{obj=VendomaticFrame}
	-- options frame
	self:addSkinFrame{obj=VendomaticOptionsFrame}
	-- repair
	self:skinEditBox{obj=Vendomatic_OptionsRepairFrame_EditBox, regs={9}}
	self:addSkinFrame{obj=Vendomatic_OptionsRepairFrame}
	-- sell
	Vendomatic_OptionsSellFrame_DropBox_DropBackground:SetTexture(nil)
	self:addButtonBorder{obj=Vendomatic_OptionsSellFrame_DropBox}
	self:addSkinFrame{obj=SellItemFauxFrame}
	self:addSkinFrame{obj=Vendomatic_OptionsSellFrame}
	-- restock
	Vendomatic_OptionsStockFrame_DropBox_DropBackground:SetTexture(nil)
	self:addButtonBorder{obj=Vendomatic_OptionsStockFrame_DropBox}
	self:skinEditBox{obj=Vendomatic_OptionsStockFrame_EditBox, regs={9}}
	self:addSkinFrame{obj=StockItemFauxFrame}
	self:addSkinFrame{obj=Vendomatic_OptionsStockFrame}
	-- repair confirmation frame
	self:addSkinFrame{obj=Vendomatic_RepairConfirmation}

end
