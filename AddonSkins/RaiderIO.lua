local _, aObj = ...
if not aObj:isAddonEnabled("RaiderIO") then return end
local _G = _G

aObj.addonsToSkin.RaiderIO = function(self) -- v 9.2.0 (v202205060600)

	-- Config & SearchUI
	local cPF, sUI -- configParentFrame, SearchUI
	self.RegisterCallback("RaiderIO", "UIParent_GetChildren", function(_, child)
		if child.scrollframe
		and child.scrollbar
		then
			cPF = child
		elseif child.header
		and child.copyUrl
		then
			sUI = child
		end
		if cPF
		and sUI
		then
			self.UnregisterCallback("RaiderIO", "UIParent_GetChildren")
		end
	end)
	self:scanUIParentsChildren()

	if cPF then
		self:skinObject("slider", {obj=cPF.scrollbar})
		self:skinObject("frame", {obj=cPF, kfs=true, ofs=0})
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
				end
			end
			if self:getChild(cPF, 3) then
				skinBtn(2)
				skinBtn(3)
			end
		end
		if self.modChkBtns then
			for _, opt in _G.ipairs{cPF.scrollframe.content:GetChildren()} do
				if opt.text then
					self:skinCheckButton{obj=opt.checkButton}
					self:skinCheckButton{obj=opt.checkButton2}
				end
			end
		end
	end

	if sUI then
		aObj:skinObject("editbox", {obj=aObj:getChild(sUI, 3), regions={3, 4, 5, 6, 7, 8}, ofs=-5, x1=-5, x2=5, chginset=false})
		aObj:skinObject("editbox", {obj=aObj:getChild(sUI, 4), regions={3, 4, 5, 6, 7, 8}, ofs=-5, x1=-5, x2=5, chginset=false})
		aObj:skinObject("frame", {obj=sUI, kfs=true, cb=true, ofs=0})
	end

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.RaiderIO_SearchTooltip)
		self:add2Table(self.ttList, _G.RaiderIO_ProfileTooltip)
	end)

end
