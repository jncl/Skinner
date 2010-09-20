if not Skinner:isAddonEnabled("WowLua") then return end

function Skinner:WowLua()

	self:skinScrollBar{obj=WowLuaFrameEditScrollFrame}
	WowLuaFrameResizeBarLeftNub:SetTexture(nil)
	WowLuaFrameResizeBarRightNub:SetTexture(nil)
	self:addSkinFrame{obj=WowLuaFrame, kfs=true, x1=12, y1=-13, x2=2, y2=-1}

end
