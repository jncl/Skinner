local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibInit"] = function(self) -- v 47
	if self.initialized["LibInit"] then return end
	self.initialized["LibInit"] = true

	local liF = _G.LibStub:GetLibrary("LibInit-Factory", true)
	if liF then
		self:RawHook(liF, "Slider", function(this, ...)
			local frame = self.hooks[this].Slider(this, ...)
			self:skinSlider{obj=self:getChild(frame, 1), hgt=-3}
			return frame
		end, true)
		if self.modChkBtns then
			self:RawHook(liF, "Checkbox", function(this, ...)
				local frame = self.hooks[this].Checkbox(this, ...)
				self:skinCheckButton{obj=frame.child}
				return frame
			end, true)
		end
		if self.modBtns then
			self:RawHook(liF, "Button", function(this, ...)
				local btn = self.hooks[this].Button(this, ...)
				self:skinStdButton{obj=btn, aso={sabt=true}}
				return btn
			end, true)
		end
		self:RawHook(liF, "DropDown", function(this, ...)
			local frame = self.hooks[this].DropDown(this, ...)
			self:skinDropDown{obj=frame.child, x1=2, x2=4}
			return frame
		end, true)
	end

end
