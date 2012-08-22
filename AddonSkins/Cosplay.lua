local aName, aObj = ...
if not aObj:isAddonEnabled("Cosplay") then return end

function aObj:Cosplay()

	if self.modBtns then
		if not DUFUndressButton then
			self:SecureHook(Cosplay, "CreateMainButtons", function(this)
				self:skinButton{obj=DUFUndressButton}
				self:skinButton{obj=DUFDressTargetButton}
				self:Unhook(Cosplay, "CreateMainButtons")
			end)
		else
			self:skinButton{obj=DUFUndressButton}
			self:skinButton{obj=DUFDressTargetButton}
		end
		if not ADUFUndressButton then
			self:SecureHook(Cosplay, "CreateAHButtons", function(this)
				self:skinButton{obj=ADUFUndressButton}
				self:Unhook(Cosplay, "CreateAHButtons")
			end)
		else
			self:skinButton{obj=ADUFUndressButton}
		end
	end
	
	-- disable rotate function
	Cosplay.ToggleRotatable = function() end

end
