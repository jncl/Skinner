local aName, aObj = ...
if not aObj:isAddonEnabled("PreformAVEnabler") then return end

function aObj:PreformAVEnabler()

	for i = 1, #PreformAVEnabler.BG_NAME do
		local btn = _G["PreformAVEnablerHideButton"..i]
		self:skinButton{obj=btn, mp2=true}
	end
	self:skinButton{obj=PreformAVEnablerInfoHideButton, mp=true}
	self:skinSlider{obj=PreformAVEnablerMembersScrollFrame.ScrollBar}
	self:skinDropDown{obj=PreformAVEnablerDropDown}
	self:addSkinFrame{obj=PreformAVEnablerFrame, kfs=true, hdr=true, y1=2}

end
