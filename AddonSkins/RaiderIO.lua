local aName, aObj = ...
if not aObj:isAddonEnabled("RaiderIO") then return end
local _G = _G

aObj.addonsToSkin.RaiderIO = function(self) -- v 8.1.0 (v202006100600)

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
		if self.modBtns then
			-- buttons are children of configButtonFrame which is 3rd child of cPF
			-- N.B. NOT really buttons
			local function skinBtn(id)
				local btn = aObj:getChild(aObj:getChild(cPF, 3), id)
				if btn then
					aObj:addSkinButton{obj=btn, parent=btn, hook=btn, hide=true, ofs=0}
					btn.sb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
					btn:SetScript("OnEnter", function(this) this.sb:SetBackdropBorderColor(aObj.bbClr:GetRGBA()) end)
					btn:SetScript("OnLeave",  function(this) this.sb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1) end)
					btn = nil
				end
			end
			if self:getChild(cPF, 3) then
				skinBtn(2)
				skinBtn(3)
			end
		end
		if self.modChkBtns then
			for _, opt in ipairs{cPF.scrollframe.content:GetChildren()} do
				if opt.text then
					self:skinCheckButton{obj=opt.checkButton}
					self:skinCheckButton{obj=opt.checkButton2}
				end
			end
		end
	end
    cPF = nil

	-- _CustomDropDownList
	_G.RaiderIO_CustomDropDownListBackdrop:SetBackdrop(nil)
	_G.RaiderIO_CustomDropDownListMenuBackdrop:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.RaiderIO_CustomDropDownList, ft="a", kfs=true, nb=true}

	-- _ProfileTooltip
	_G.RaiderIO_ProfileTooltip:SetScript("OnShow", nil)
	self:add2Table(self.ttList, _G.RaiderIO_ProfileTooltip)

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
			aObj:add2Table(aObj.ttList, _G.RaiderIO_SearchTooltip)
			_G.SlashCmdList["RaiderIO"] = orig_sCLH
			orig_sCLH = nil
		end
		sUI = nil
	end

end
