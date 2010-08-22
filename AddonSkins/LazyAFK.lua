if not Skinner:isAddonEnabled("LazyAFK") then return end
local count = 0
function Skinner:LazyAFK()

    local frame = self:findFrame(160, 350, {"FontString", "FontString", "Button", "Button"})

    if not frame then
        count = count + 1
        if count < 10 then -- wait for a maximum of 2 seconds
		    self:ScheduleTimer("LazyAFK", 0.2) -- wait for 2/10th second for frame to be created
		end
	else
        self:addSkinFrame{obj=frame, x1=8, y1=-11, x2=-11, y2=4}
	end

end
