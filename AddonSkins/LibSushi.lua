local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["Sushi-3.1"] = function(self) -- v Sushi-3.1, 3
	if self.initialized.LibSushi then return end
	self.initialized.LibSushi = true

	local sushi = _G.LibStub:GetLibrary("Sushi-3.1", true)

	-- hook this to manage the Sushi Dropdowns
	self:RawHook(sushi.Dropdown, "Toggle", function(this, obj)
		local drop = self.hooks[this].Toggle(this, obj)
		if drop then
			self:addSkinFrame{obj=drop.Bg, ft="a", kfs=true, nb=true}
			drop.Bg.SetBackdrop = _G.nop
			return drop
		end
	end, true)

	-- hook this to manage width of check boxes
	if self.modChkBtns then
		self:RawHook(sushi.Check, "Construct", function(this)
			local cBtn = self.hooks[sushi.Check].Construct(this)
			self:skinCheckButton{obj=cBtn}
			cBtn.sb:SetPoint("BOTTOMRIGHT", cBtn, "BOTTOMLEFT", 22, 5)
			return cBtn
		end, true)
	end

end
