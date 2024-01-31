local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["Sushi-3.2"] = function(self) -- v Sushi-3.2, 1
	if self.initialized.LibSushi then return end
	self.initialized.LibSushi = true

	local sushi = _G.LibStub:GetLibrary("Sushi-3.2", true)

	-- hook this to manage the Sushi Dropdowns
	self:RawHook(sushi.Dropdown, "Toggle", function(this, obj)
		local drop = self.hooks[this].Toggle(this, obj)
		if drop then
			self:skinObject("frame", {obj=drop.bg, kfs=true})
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

	-- hook this to skin clickable buttons
	if self.modBtns then
		self:RawHook(sushi.Clickable, "Construct", function(this)
			local cObj = self.hooks[sushi.Clickable].Construct(this)
			if cObj:IsObjectType("Button")
			and cObj.__type == "Button"
			and cObj.__name
			and cObj.__name:find("^Sushi")
			then
				self:skinStdButton{obj=cObj}
			end
			return cObj
		end, true)
	end

	local function skinPopup(pop)
		aObj:skinObject("frame", {obj=pop.bg, kfs=true})
		if pop.textInput then
			aObj:skinObject("editbox", {obj=pop.textInput, y1=-6, y2=4})
		end
		-- pop.moneyInput
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
	for _, obj in pairs(sushi.Popup.Active) do
		skinPopup(obj)
	end

end
