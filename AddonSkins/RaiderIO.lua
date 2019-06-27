local aName, aObj = ...
if not aObj:isAddonEnabled("RaiderIO") then return end
local _G = _G

aObj.addonsToSkin.RaiderIO = function(self) -- v 8.1.0 (v201901160600)

	-- Config
	local cPF -- configParentFrame
	self.RegisterCallback("RaiderIO", "UIParent_GetChildren", function(this, child)
		if child.scrollframe
		and child.scrollbar
		then
			cPF = child
			self.UnregisterCallback("RaiderIO", "UIParent_GetChildren")
		end
	end)
	self:scanUIParentsChildren()

	if cPF then
		self:skinSlider{obj=cPF.scrollbar}
		self:addSkinFrame{obj=cPF, ft="a", kfs=true, nb=true}
		if self.modChkBtns then
			local cF = cPF.scrollframe.content
			for _, opt in ipairs{cF:GetChildren()} do
				if opt.text then
					self:skinCheckButton{obj=opt.checkButton}
					self:skinCheckButton{obj=opt.checkButton2}
				end
			end
			cF = nil
		end
		if self.modBtns then
			-- buttons are children of configButtonFrame which is 3rd child of cPF
			-- N.B. NOT really buttons
			local function skinBtn(btn)
				aObj:addSkinButton{obj=btn, parent=btn, hook=btn, hide=true, ofs=0}
				btn.sb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
				btn:SetScript("OnEnter", function(this) this.sb:SetBackdropBorderColor(aObj.bbClr:GetRGBA()) end)
				btn:SetScript("OnLeave",  function(this) this.sb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1) end)
			end
			local cBF = self:getChild(cPF, 3)
			if cBF then
				skinBtn(self:getChild(cBF, 2))
				skinBtn(self:getChild(cBF, 3))
			end
			cBF = nil
		end
		cPF = nil
	end

	-- _CustomDropDownList
	_G.RaiderIO_CustomDropDownListBackdrop:SetBackdrop(nil)
	_G.RaiderIO_CustomDropDownListMenuBackdrop:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.RaiderIO_CustomDropDownList, ft="a", kfs=true, nb=true}

	-- _ProfileTooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.RaiderIO_ProfileTooltip)
		_G.RaiderIO_ProfileTooltip:SetScript("OnShow", nil)
	end)

	-- SearchUI
	-- hook original function to skin searchUI
	local orig_sCLH = _G.SlashCmdList["RaiderIO"]
	_G.SlashCmdList["RaiderIO"] = function(text)
		orig_sCLH(text)
		local sUI -- SearchUI
		aObj.RegisterCallback("RaiderIO", "UIParent_GetChildren", function(this, child)
			if child.header
			and child.Search
			then
				sUI = child
				aObj.UnregisterCallback("RaiderIO", "UIParent_GetChildren")
			end
		end)
		aObj:scanUIParentsChildren()
		if sUI then
			local btn = aObj:getChild(sUI, 1)
			btn:DisableDrawLayer("BORDER") -- remove border textures
			aObj:skinEditBox{obj=btn, regs={6}} -- 6 is text
			btn = aObj:getChild(sUI, 2)
			btn:DisableDrawLayer("BORDER") -- remove border textures
			aObj:skinEditBox{obj=btn, regs={6}} -- 6 is text
			btn:ClearAllPoints()
			btn:SetPoint("TOP", aObj:getChild(sUI, 1), "BOTTOM", 0, 0)
			aObj:addSkinFrame{obj=sUI, ft="a", kfs=true, nb=true}
			sUI, btn = nil, nil
			-- _SearchTooltip
			_G.C_Timer.After(0.1, function()
				aObj:add2Table(aObj.ttList, _G.RaiderIO_SearchTooltip)
			end)
			_G.SlashCmdList["RaiderIO"] = orig_sCLH
			orig_sCLH = nil
		end
	end

end
