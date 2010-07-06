if not Skinner:isAddonEnabled("LazyAFK") then return end

function Skinner:LazyAFK()

	self:addSkinFrame{obj=AFKButton:GetParent(), x1=8, y1=-11, x2=-11, y2=4}

end
