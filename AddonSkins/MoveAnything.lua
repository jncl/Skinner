-- thanks to sixthepaladin
local _G = _G

function Skinner:MoveAnything()

	self:skinButton{obj=GameMenuButtonMoveAnything}
-->>-- Options frame
	self:skinScrollBar{obj=MAScrollFrame}
	MAScrollBorder:SetAlpha(0)
	self:skinAllButtons{obj=MAOptions}
	self:addSkinFrame{obj=MAOptions, kfs=true, hdr=true}
	-- category buttons
	for i = 1, 17 do
		self:skinButton{obj=_G["MAMove"..i.."Reset"]}
	end
-->>-- Nudger frame
	self:skinAllButtons{obj=MANudger, x1=-1, x2=1}
	self:addSkinFrame{obj=MANudger}

end