local aName, aObj = ...
if not aObj:isAddonEnabled("EnhancedColourPicker") then return end
local _G = _G

function aObj:EnhancedColourPicker()

	for _, v in _G.pairs{"R", "G", "B", "A"} do
		local eb = _G["CPF" .. v]
		self:skinEditBox{obj=eb, regs={9, 10}}
		eb.text:SetPoint("LEFT", eb, "LEFT", 5, 0)
		eb.label:SetPoint("RIGHT", eb, "LEFT")
	end

end
