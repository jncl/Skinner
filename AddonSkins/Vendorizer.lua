
function Skinner:Vendorizer()

	local sr, sg, sb, sa = unpack(Skinner.bbColour)
	-- hook this to manage skin alpha changes
	self:RawHook(VendorizerFrame, "SetBackdropBorderColor", function(this, r, g, b, a)
		Skinner.skinFrame[this]:SetBackdropBorderColor(sr, sg, sb, a == 0 and a or sa)
	end, true)
	
	VendorizerFrameBuyTab:DisableDrawLayer("BACKGROUND")
	VendorizerFrameSellTab:DisableDrawLayer("BACKGROUND")
	VendorizerFrameSaveTab:DisableDrawLayer("BACKGROUND")
	self:skinScrollBar{obj=VendorizerFrameContainerScrollFrame}
	self:skinEditBox{obj=VendorizerFrameContainerAdjQtyInputBox, regs={9}, noHeight=true, x=-5}
	self:skinAllButtons{obj=VendorizerFrame}
	self:addSkinFrame{obj=VendorizerFrame, aso={bba=0}} -- turn off border alpha

end
