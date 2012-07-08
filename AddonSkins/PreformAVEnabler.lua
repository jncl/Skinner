local aName, aObj = ...
if not aObj:isAddonEnabled("PreformAVEnabler") then return end

function aObj:PreformAVEnabler()

	for i = 1, 9 do
		local btn = _G["PreformAVEnablerHideButton"..i]
		self:skinButton{obj=btn, mp2=true}
	end
	self:skinScrollBar{obj=PreformAVEnablerMembersScrollFrame}
	self:skinDropDown{obj=PreformAVEnablerDropDown}
	self:addSkinFrame{obj=PreformAVEnablerFrame, kfs=true, hdr=true}

end
