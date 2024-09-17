local _, aObj = ...
if not aObj:isAddonEnabled("BuyEmAll")
and not aObj:isAddonEnabled("BuyEmAllClassic")
then
	return
end
local _G = _G

local function skinFrame()
		aObj:SecureHookScript(_G.BuyEmAllFrame, "OnShow", function(this)
		aObj:skinObject("frame", {obj=this, kfs=true, ofs=-8})
		if aObj.modBtns then
			aObj:skinStdButton{obj=_G.BuyEmAllOkayButton}
			aObj:skinStdButton{obj=_G.BuyEmAllCancelButton}
			aObj:skinStdButton{obj=_G.BuyEmAllStackButton, schk=true}
			aObj:skinStdButton{obj=_G.BuyEmAllMaxButton, schk=true}
		end

		aObj:Unhook(this, "OnShow")
	end)
end
aObj.addonsToSkin.BuyEmAll = function(self) -- v 4.1.0

	skinFrame()

end

aObj.addonsToSkin.BuyEmAllClassic = function(self) -- v 1.0.4

	skinFrame()

end
