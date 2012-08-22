if not Skinner:isAddonEnabled("EnhancedColourPicker") then return end

function Skinner:EnhancedColourPicker()

	self:skinEditBox{obj=CPFR, regs={9, 10}}
	CPFR.text:SetPoint("LEFT", CPFR, "LEFT", 5, 0)
	self:skinEditBox{obj=CPFG, regs={9, 10}}
	CPFG.text:SetPoint("LEFT", CPFG, "LEFT", 5, 0)
	self:skinEditBox{obj=CPFB, regs={9, 10}}
	CPFB.text:SetPoint("LEFT", CPFB, "LEFT", 5, 0)
	self:skinEditBox{obj=CPFA, regs={9, 10}}
	CPFA.text:SetPoint("LEFT", CPFA, "LEFT", 5, 0)

end
