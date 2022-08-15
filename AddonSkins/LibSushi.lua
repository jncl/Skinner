local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["Sushi-3.1"] = function(self) -- v Sushi-3.1, 4
	if self.initialized.LibSushi then return end
	self.initialized.LibSushi = true

	local sushi = _G.LibStub:GetLibrary("Sushi-3.1", true)

	-- hook this to manage the Sushi Dropdowns
	self:RawHook(sushi.Dropdown, "Toggle", function(this, obj)
		local drop = self.hooks[this].Toggle(this, obj)
		if drop then
			self:skinObject("frame", {obj=drop.Bg, kfs=true})
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

	local function skinPopup(pop)
		if pop.Border then
			aObj:removeNineSlice(pop.Border)
		end
		pop.Separator:SetTexture(nil)
		aObj:skinObject("frame", {obj=pop, kfs=true})
		if aObj.modBtns then
			local name = pop:GetName()
			aObj:skinStdButton{obj=_G[name..'Button1']}
			aObj:skinStdButton{obj=_G[name..'Button2']}
			aObj:skinStdButton{obj=_G[name..'Button3']}
			aObj:skinStdButton{obj=_G[name..'Button4']}
		end
		if pop.info.hasEditBox then
			aObj:skinObject("editbox", {obj=pop.editbox})
		end
		if pop.info.hasMoneyFrame then
		end
		if pop.info.hasItemFrame then
		end
		if pop.info.extraButton then
			if aObj.modBtns then
				aObj:skinStdButton{obj=pop.info.extraButton}
			end
		end
	end
	-- hook this to skin new Popups
	self:RawHook(sushi.Popup, "New", function(this, input)
		local obj = self.hooks[this].New(this, input)
		if obj then
			skinPopup(obj)
			return obj
		end
	end, true)
	-- skin any existing Popups
	for obj, _ in pairs(sushi.Popup.__frames) do
		skinPopup(obj)
	end

end
