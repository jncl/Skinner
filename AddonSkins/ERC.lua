local aName, aObj = ...
if not aObj:isAddonEnabled("ERC") then return end
local _G = _G

aObj.addonsToSkin.ERC = function(self) -- v r46

	local btn
	for i = 1, #_G.ERC.frame.scrollFrame.buttons do
		btn = _G.ERC.frame.scrollFrame.buttons[i]
		self:skinButton{obj=btn.header.key1}
		self:skinButton{obj=btn.header.key2}
		self:skinButton{obj=btn.detail.key1}
		self:skinButton{obj=btn.detail.key2}
	end
	btn = nil
	self:skinSlider{obj=_G.ERC.frame.scrollFrame.scrollBar}
	self:addSkinFrame{obj=_G.ERC.frame, nb=true}

	self:addSkinFrame{obj=_G.ERC.frame.statusFrame}

end
