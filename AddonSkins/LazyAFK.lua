if not Skinner:isAddonEnabled("LazyAFK") then return end

function Skinner:LazyAFK()

  self:addSkinFrame{obj=self:findFrame(160, 350, {"FontString", "FontString", "Button", "Button"}), x1=8, y1=-11, x2=-11, y2=4}

end
