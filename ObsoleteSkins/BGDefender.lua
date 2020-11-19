local aName, aObj = ...
if not aObj:isAddonEnabled("BGDefender") then return end
local _G = _G

function aObj:BGDefender()

	local btn
	for i = 1, 11 do
		btn = _G["Button" .. i]
		self:skinButton{obj=btn}
		if self:getInt(btn:GetHeight()) == 8 then
			btn:SetSize(18, 12)
		end
	end
	btn = nil

end
