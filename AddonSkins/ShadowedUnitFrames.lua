local _, aObj = ...
if not aObj:isAddonEnabled("ShadowedUnitFrames") then return end
local _G = _G

aObj.addonsToSkin.ShadowedUnitFrames = function(self) -- v4.4.11/

	local function skinInfoFrame(frame)
		aObj:moveObject{obj=frame.title, y=-6}
		aObj:skinObject("frame", {obj=frame, kfs=true, ofs=0})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.lock}
			aObj:skinStdButton{obj=frame.unlink}
		end
	end
	if _G.ShadowUF.modules.movers.infoFrame then
		skinInfoFrame(_G.ShadowUF.modules.movers.infoFrame)
	else
		self:SecureHook(_G.ShadowUF.modules.movers, "CreateInfoFrame", function(this)
			skinInfoFrame(this.infoFrame)
			self:Unhook(this, "CreateInfoFrame")
		end)
	end

end
