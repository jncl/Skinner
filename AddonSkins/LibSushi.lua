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

	local function skinPopup(pop)
		self:keepFontStrings(pop.Border)
		self:addSkinFrame{obj=pop, ft="a", kfs=true, nb=true}
		if self.modBtns then
			local name = pop:GetName()
			self:skinStdButton{obj=_G[name..'Button1']}
			self:skinStdButton{obj=_G[name..'Button2']}
			self:skinStdButton{obj=_G[name..'Button3']}
			self:skinStdButton{obj=_G[name..'Button4']}
		end
		if pop.info.hasEditBox then
			self:skinEditBox{obj=pop.editBox, regs={6}} -- 6 is text
		end
		if pop.info.hasMoneyFrame then
		end
		if pop.info.hasItemFrame then
		end
		if pop.info.extraButton then
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
