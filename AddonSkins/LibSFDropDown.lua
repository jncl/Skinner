local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibSFDropDown-1.5"] = function(self) -- v LibSFDropDown-1.5, 17
	if self.initialized.LibSFDropDown then return end
	self.initialized.LibSFDropDown = true

	local lSFdd = _G.LibStub:GetLibrary("LibSFDropDown-1.5", true)

	if lSFdd then
		for _, menu in lSFdd:IterateMenus() do
			for _, style in _G.pairs(menu.styles) do
				-- aObj:Debug("IterateMenus: [%s, %s]", style)
				self:skinObject("frame", {obj=style, kfs=true, rns=true})
				style:SetScript("OnUpdate", nil) -- Bugfix for MountsJournal
			end
		end
		for name, _ in _G.pairs(lSFdd._v.menuStyles) do
			-- aObj:Debug("menuStyles: [%s, %s]", name, func)
			lSFdd._v.menuStyles[name] = function(parent)
				-- aObj:Debug("menuStyles style: [%s, %s]", parent)
				local frame = _G.CreateFrame("FRAME", nil, parent, "BackdropTemplate")
				aObj:skinObject("frame", {obj=frame, kfs=true, rns=true})
				frame:SetScript("OnUpdate", nil) -- Bugfix for MountsJournal
				return frame
			end
		end

		local function skinSearchFrame(frame)
			-- aObj:Debug("searchFrame: [%s, %s]", frame)
			aObj:skinObject("editbox", {obj=frame.searchBox, si=true})
			aObj:skinObject("slider", {obj=frame.listScroll.scrollBar, rpTex="background"})
		end
		for _, frame in lSFdd:IterateSearchFrames() do
			skinSearchFrame(frame)
		end
		_G.setmetatable(lSFdd._v.dropDownSearchFrames, {__newindex = function(tab, key, frame)
			_G.rawset(tab, key, frame)
			skinSearchFrame(frame)
		end})

		local function skinDD(btn)
			aObj:Debug("skinDD: [%s, %s]", btn)
			aObj:skinObject("dropdown", {obj=btn, initState=not btn.Button:IsEnabled() ,x1=1, y1=2, x2=-1, y2=0})
			aObj:SecureHook(btn.Button, "SetEnabled", function(this, enabled)
				aObj:clrBBC(this:GetParent().sf, not enabled and "disabled")
				aObj:clrBtnBdr(this)
			end)
		end
		for _, btn in lSFdd:IterateCreatedButtons() do
			skinDD(btn)
		end
		self:RawHook(lSFdd, "CreateButton", function(this, ...)
			local btn = self.hooks[this].CreateButton(this, ...)
			skinDD(btn)
			return btn
		end, true)
		for _, btn in lSFdd:IterateCreatedModernButtons() do
			skinDD(btn)
		end
		self:RawHook(lSFdd, "CreateModernButton", function(this, ...)
			local btn = self.hooks[this].CreateModernButton(this, ...)
			skinDD(btn)
			return btn
		end, true)

		if self.modBtns then
			local function skinStretchBtn(btn)
				aObj:skinStdButton{obj=btn}
			end
			for _, btn in lSFdd:IterateCreatedStretchButtons() do
				skinStretchBtn(btn)
			end
			self:RawHook(lSFdd, "CreateStretchButton", function(this, ...)
				local btn = self.hooks[this].CreateStretchButton(this, ...)
				skinStretchBtn(btn)
				return btn
			end, true)
		end

	end

end
