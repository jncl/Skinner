
function Skinner:EasyUnlock()

	if select(2, UnitClass('player')) ~= "ROGUE" then return end

	local funcName = "EasyUnlock_OnLoad"
	if EasyUnlock_DoFrameCheck then funcName = "EasyUnlock_DoFrameCheck" end

	self:SecureHook(funcName, function()
		if not EasyUnlock.skinned then
			self:moveObject(TradeFrameTradeButton, "+", 20, "-", 45)
			EasyUnlock.skinned = true
		end
	end)

end
