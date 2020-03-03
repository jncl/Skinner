local _, aObj = ...
if not aObj:isAddonEnabled("Cosplay") then return end
local _G = _G

aObj.addonsToSkin.Cosplay = function(self) -- v 80300-1

	if self.modBtns then
		if not _G.DUFUndressButton then
			self:SecureHook(_G.Cosplay, "CreateMainButtons", function(this)
				self:skinStdButton{obj=_G.DUFUndressButton}
				self:skinStdButton{obj=_G.DUFDressTargetButton}
				self:Unhook(this, "CreateMainButtons")
			end)
		else
			self:skinStdButton{obj=_G.DUFUndressButton}
			self:skinStdButton{obj=_G.DUFDressTargetButton}
		end
		if not _G.ADUFUndressButton then
			self:SecureHook(_G.Cosplay, "CreateAHButtons", function(this)
				self:skinStdButton{obj=_G.ADUFUndressButton}
				self:Unhook(this, "CreateAHButtons")
			end)
		else
			self:skinStdButton{obj=_G.ADUFUndressButton}
		end
	end

end
