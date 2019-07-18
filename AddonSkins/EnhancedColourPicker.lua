local aName, aObj = ...
if not aObj:isAddonEnabled("EnhancedColourPicker") then return end
local _G = _G

aObj.addonsToSkin.EnhancedColourPicker = function(self) -- v 4

	local eb
	for _, v in _G.pairs{"R", "G", "B", "A"} do
		eb = _G["CPF" .. v]
		self:skinEditBox{obj=eb, regs={6 ,7}}
		eb.text:SetPoint("LEFT", eb, "LEFT", 5, 0)
		eb.label:SetPoint("RIGHT", eb, "LEFT")
	end
	eb = nil

	if self.modBtns then
		self:skinStdButton{obj=self:getChild(_G.ColorPickerFrame, 5)}
		self:skinStdButton{obj=self:getChild(_G.ColorPickerFrame, 6)}
	end

end
